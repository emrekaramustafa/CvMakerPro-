import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../models/resume_model.dart';
import '../templates/modern_template.dart';
import '../templates/classic_template.dart';

class PdfGeneratorService {
  Future<File> generateResumePdf(ResumeModel resume) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String targetPath = directory.path;
    
    // Choose template
    String htmlContent;
    if (resume.templateId == 'classic') {
       htmlContent = ClassicTemplate.generate(resume);
    } else {
       htmlContent = ModernTemplate.generate(resume);
    }
    
    // Generate PDF
    // Note: flutter_html_to_pdf creates a file named {targetFileName}.pdf
    final String targetFileName = "Resume_${resume.id}";
    final File generatedPdfFile = await FlutterHtmlToPdf.convertFromHtmlContent(
      htmlContent,
      targetPath,
      targetFileName,
    );
    
    return generatedPdfFile;
  }
}
