import 'dart:io';
import 'package:flutter_html_to_pdf/flutter_html_to_pdf.dart';
import 'package:path_provider/path_provider.dart';
import '../models/resume_model.dart';
import '../templates/modern_template.dart';
import '../templates/classic_template.dart';
import '../templates/creative_template.dart';
import '../templates/elegant_template.dart';
import '../templates/student_template.dart';
import '../templates/executive_template.dart';
import '../templates/startup_template.dart';

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
      case 'modern':
      default:
        htmlContent = ModernTemplate.generate(resume);
        break;
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
