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
      if (!await file.exists()) return null;

      // 1. Render first page to image
      final document = await PdfDocument.openFile(file.path);
      final page = await document.getPage(1);
      final pageImage = await page.render(
        width: page.width,
        height: page.height,
        format: PdfPageImageFormat.png,
      );
      await page.close();
      await document.close();

      if (pageImage == null) return null;

      // 2. Detect Faces
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${const Uuid().v4()}.png');
      await tempFile.writeAsBytes(pageImage.bytes);

      final inputImage = InputImage.fromFile(tempFile);
      final faceDetector = FaceDetector(options: FaceDetectorOptions(
        enableContours: true,
        enableClassification: true,
      ));
      
      final faces = await faceDetector.processImage(inputImage);
      await faceDetector.close();

      if (faces.isEmpty) {
        // No face found
        return null;
      }

      // 3. Find the largest face (most likely the profile picture)
      // Sort by bounding box area (width * height) descending
      faces.sort((a, b) => (b.boundingBox.width * b.boundingBox.height).compareTo(a.boundingBox.width * a.boundingBox.height));
      final mainFace = faces.first;

      // 4. Crop the face with some padding
      final bytes = await tempFile.readAsBytes();
      final originalImage = img.decodeImage(bytes);

      if (originalImage == null) return null;

      final bbox = mainFace.boundingBox;
      
      // Add generous padding (e.g. 50% more) to include hair/neck, but keep within bounds
      // Profile pictures in CVs are usually well-framed, so standard expansion is good.
      final paddingX = bbox.width * 0.3;
      final paddingY = bbox.height * 0.3;

      int x = (bbox.left - paddingX).toInt().clamp(0, originalImage.width).toInt();
      int y = (bbox.top - paddingY).toInt().clamp(0, originalImage.height).toInt();
      int w = (bbox.width + paddingX * 2).toInt().clamp(0, originalImage.width - x).toInt();
      int h = (bbox.height + paddingY * 2).toInt().clamp(0, originalImage.height - y).toInt();
      
      // Ensure square aspect ratio if possible for profile pic? 
      // User didn't specify, but square is standard. Let's make it roughly square.
      // Actually, let's keep original aspect but expanded.
      
      final croppedImage = img.copyCrop(originalImage, x: x, y: y, width: w, height: h);
      
      // 5. Save the cropped image
      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'profile_${const Uuid().v4()}.jpg';
      final savedImage = File('${appDir.path}/$fileName');
      await savedImage.writeAsBytes(img.encodeJpg(croppedImage));
      
      return savedImage.path;

    } catch (e) {
      print('Profile extraction failed: $e');
      return null;
    }
  }
}
