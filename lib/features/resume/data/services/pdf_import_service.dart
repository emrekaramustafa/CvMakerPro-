import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart' hide PdfDocument; // Hide to avoid conflict with pdfx
import 'package:syncfusion_flutter_pdf/pdf.dart' as syncfusion; // Alias for text extraction logic if needed or just use hide
import 'package:pdfx/pdfx.dart'; // For image rendering
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class PdfImportService {
  Future<String> extractTextFromPdf(File file) async {
    try {
      if (!await file.exists()) {
        throw Exception('File does not exist');
      }

      final bytes = await file.readAsBytes();
      
      // Check for PDF magic bytes (%PDF-)
      if (bytes.length < 5) {
        throw Exception('File is too small to be a PDF');
      }
      
      // Basic header check (some PDFs might behave differently but standard ones start with %PDF-)
      final header = String.fromCharCodes(bytes.sublist(0, 5));
      if (header != '%PDF-') {
        throw Exception('Invalid PDF file format (Missing PDF header)');
      }

      // Load the PDF document.
      final syncfusion.PdfDocument document = syncfusion.PdfDocument(inputBytes: bytes);

      // Extract text from all the pages.
      String text = syncfusion.PdfTextExtractor(document).extractText();

      // Dispose the document.
      document.dispose();

      return text;
    } catch (e) {
      throw Exception('Failed to extract text: $e');
    }
  }

  Future<String?> extractProfileImage(File file) async {
    try {
      if (!await file.exists()) {
        print('[extractProfileImage] File does not exist: ${file.path}');
        return null;
      }
      print('[extractProfileImage] Starting image extraction from: ${file.path}');

      // 1. Render first page to image at high resolution for better face detection
      final document = await PdfDocument.openFile(file.path);
      final page = await document.getPage(1);
      final scale = 3.0; // render at 3x for ~200 DPI
      final renderWidth = page.width * scale;
      final renderHeight = page.height * scale;
      print('[extractProfileImage] Page size: ${page.width}x${page.height}, rendering at ${renderWidth.toInt()}x${renderHeight.toInt()}');
      final pageImage = await page.render(
        width: renderWidth,
        height: renderHeight,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await document.close();

      if (pageImage == null) {
        print('[extractProfileImage] Page render returned null');
        return null;
      }
      print('[extractProfileImage] Page rendered, raw bytes: ${pageImage.bytes.length}');

      // 2. Re-encode through image package to ensure proper format for ML Kit
      final tempDir = await getTemporaryDirectory();
      
      // Decode the raw rendered bytes and re-encode as proper JPEG
      final decodedImage = img.decodeImage(pageImage.bytes);
      if (decodedImage == null) {
        print('[extractProfileImage] Failed to decode rendered page image');
        return null;
      }
      print('[extractProfileImage] Decoded image: ${decodedImage.width}x${decodedImage.height}');
      
      // Re-encode as JPEG (ML Kit works better with JPEG)
      final jpegBytes = img.encodeJpg(decodedImage, quality: 95);
      final tempFile = File('${tempDir.path}/${const Uuid().v4()}.jpg');
      await tempFile.writeAsBytes(jpegBytes);
      print('[extractProfileImage] Re-encoded as JPEG: ${jpegBytes.length} bytes, saved to ${tempFile.path}');

      // 3. Detect Faces
      final inputImage = InputImage.fromFilePath(tempFile.path);
      final faceDetector = FaceDetector(options: FaceDetectorOptions(
        enableContours: false,
        enableClassification: false,
        minFaceSize: 0.01, // very small minimum to catch any face
        performanceMode: FaceDetectorMode.accurate,
      ));
      
      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();
      print('[extractProfileImage] Faces detected: ${faces.length}');

      if (faces.isEmpty) {
        print('[extractProfileImage] No faces found via ML Kit, trying image-based extraction fallback');
        // Fallback: Try to find and crop the upper-left region where profile photos usually are in CVs
        // Most CVs place the profile photo in the top-left or top-center area
        final cropWidth = (decodedImage.width * 0.35).toInt(); // left 35% of page
        final cropHeight = (decodedImage.height * 0.25).toInt(); // top 25% of page
        
        // Check if this region has significant non-white content (indicating an image)
        final croppedRegion = img.copyCrop(decodedImage, x: 0, y: 0, width: cropWidth, height: cropHeight);
        
        // Simple check: count non-white pixels to see if there's an image there
        int darkPixelCount = 0;
        final totalPixels = croppedRegion.width * croppedRegion.height;
        for (int py = 0; py < croppedRegion.height; py += 3) {
          for (int px = 0; px < croppedRegion.width; px += 3) {
            final pixel = croppedRegion.getPixel(px, py);
            final r = pixel.r.toInt();
            final g = pixel.g.toInt();
            final b = pixel.b.toInt();
            // If pixel is significantly dark (not white/light background)
            if (r < 200 || g < 200 || b < 200) {
              darkPixelCount++;
            }
          }
        }
        final darkRatio = darkPixelCount / (totalPixels / 9); // we sample every 3rd pixel
        print('[extractProfileImage] Dark pixel ratio in top-left region: $darkRatio');
        
        if (darkRatio > 0.15) {
          // There's likely an image there - save this cropped region
          final appDir = await getApplicationDocumentsDirectory();
          final fileName = 'profile_${const Uuid().v4()}.jpg';
          final savedImage = File('${appDir.path}/$fileName');
          await savedImage.writeAsBytes(img.encodeJpg(croppedRegion, quality: 90));
          print('[extractProfileImage] Fallback: saved top-left region as profile to: ${savedImage.path}');
          return savedImage.path;
        }
        
        print('[extractProfileImage] No profile image found in fallback region either');
        return null;
      }

      // 4. Find the largest face (most likely the profile picture)
      faces.sort((a, b) => (b.boundingBox.width * b.boundingBox.height).compareTo(a.boundingBox.width * a.boundingBox.height));
      final mainFace = faces.first;
      print('[extractProfileImage] Largest face bbox: ${mainFace.boundingBox}');

      // 5. Crop the face with some padding
      final bbox = mainFace.boundingBox;
      final paddingX = bbox.width * 0.3;
      final paddingY = bbox.height * 0.3;

      int x = (bbox.left - paddingX).toInt().clamp(0, decodedImage.width);
      int y = (bbox.top - paddingY).toInt().clamp(0, decodedImage.height);
      int w = (bbox.width + paddingX * 2).toInt().clamp(0, decodedImage.width - x);
      int h = (bbox.height + paddingY * 2).toInt().clamp(0, decodedImage.height - y);
      
      final croppedImage = img.copyCrop(decodedImage, x: x, y: y, width: w, height: h);
      
      // 6. Save the cropped image
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${const Uuid().v4()}.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(img.encodeJpg(croppedImage, quality: 90));
      print('[extractProfileImage] Saved cropped face to: ${savedImage.path}');
      
      return savedImage.path;

    } catch (e, stack) {
      print('[extractProfileImage] ERROR: $e');
      print('[extractProfileImage] Stack: $stack');
      return null;
    }
  }
}
