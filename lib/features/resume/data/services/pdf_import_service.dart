import 'dart:io';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class PdfImportService {
  Future<String> extractTextFromPdf(File file) async {
    try {
      // Load the PDF document.
      final PdfDocument document = PdfDocument(inputBytes: await file.readAsBytes());

      // Extract text from all the pages.
      String text = PdfTextExtractor(document).extractText();

      // Dispose the document.
      document.dispose();

      return text;
    } catch (e) {
      throw Exception('Failed to extract text: $e');
    }
  }
}
