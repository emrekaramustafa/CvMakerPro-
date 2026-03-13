import 'dart:io';
import 'dart:ui';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import '../models/resume_model.dart';
import '../templates/modern_template.dart';
import '../templates/classic_template.dart';
import '../templates/creative_template.dart';
import '../templates/elegant_template.dart';
import '../templates/student_template.dart';
import '../templates/executive_template.dart';
import '../templates/startup_template.dart';
import '../templates/british_green_template.dart';

class PdfGeneratorService {
  Future<File> generateResumePdf(ResumeModel resume) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String targetPath = directory.path;
    
    // Choose template
    String htmlContent;
    switch (resume.templateId) {
      case 'classic':
        htmlContent = ClassicTemplate.generate(resume);
        break;
      case 'creative':
        htmlContent = CreativeTemplate.generate(resume);
        break;
      case 'elegant':
        htmlContent = ElegantTemplate.generate(resume);
        break;
      case 'student':
      case 'academic':
        htmlContent = StudentTemplate.generate(resume);
        break;
      case 'executive':
      case 'simple':
        htmlContent = ExecutiveTemplate.generate(resume);
        break;
      case 'startup':
        htmlContent = StartupTemplate.generate(resume);
        break;
      case 'british_green':
        htmlContent = BritishGreenTemplate.generate(resume);
        break;
      case 'modern':
      default:
        htmlContent = ModernTemplate.generate(resume);
        break;
    }
    
    // Generate PDF (may produce multiple A4 pages)
    final String targetFileName = "Resume_${resume.id}";
    final File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      targetPath,
      targetFileName,
    );
    
    // Post-process: merge all pages into a single tall page
    return await _mergeToSinglePage(generatedPdfFile);
  }

  /// Reads a multi-page PDF and merges all pages into a single tall page.
  Future<File> _mergeToSinglePage(File pdfFile) async {
    final bytes = await pdfFile.readAsBytes();
    final srcDoc = PdfDocument(inputBytes: bytes);
    final pageCount = srcDoc.pages.count;

    // Calculate total height from all pages
    double totalHeight = 0;
    final double pageWidth = srcDoc.pages[0].getClientSize().width;
    
    for (int i = 0; i < pageCount; i++) {
      totalHeight += srcDoc.pages[i].getClientSize().height;
    }

    // Add bottom padding (~5 lines of whitespace)
    totalHeight += 60;

    // Create new single-page document
    final newDoc = PdfDocument();
    newDoc.pageSettings.margins.all = 0;
    newDoc.pageSettings.size = Size(pageWidth, totalHeight);
    
    final newPage = newDoc.pages.add();
    
    // Draw each source page onto the new single page sequentially
    double yOffset = 0;
    for (int i = 0; i < pageCount; i++) {
      final template = srcDoc.pages[i].createTemplate();
      newPage.graphics.drawPdfTemplate(template, Offset(0, yOffset));
      yOffset += srcDoc.pages[i].getClientSize().height;
    }

    final outBytes = newDoc.saveSync();
    newDoc.dispose();
    srcDoc.dispose();

    await pdfFile.writeAsBytes(outBytes);
    return pdfFile;
  }
}
