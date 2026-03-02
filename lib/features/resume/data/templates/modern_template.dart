import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class ModernTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      final imageFile = File(resume.personalInfo.profileImagePath!);
      if (imageFile.existsSync()) {
        final fileUri = Uri.file(imageFile.path).toString();
        profileImageHtml = '''
          <div style="text-align:center; margin-bottom:18px;">
            <img src="$fileUri" 
                 style="width:100px; height:100px; border-radius:50%; object-fit:cover; border:3px solid #0D9488;" />
          </div>
        ''';
      }
    }

    final experiences = resume.experience.map((e) => '''
      <div style="margin-bottom:14px;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="font-weight:700; font-size:13px; color:#0F172A; border:none;">${e.jobTitle}</td>
            <td style="text-align:right; font-size:10px; color:#94A3B8; white-space:nowrap; border:none;">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
        <div style="font-size:12px; color:#0D9488; font-weight:500; margin-bottom:3px;">${e.companyName}</div>
        ${e.description.isNotEmpty ? '<div style="font-size:11px; color:#64748B; margin-bottom:3px;">${e.description}</div>' : ''}
        ${e.bulletPoints.isNotEmpty ? '<ul style="padding-left:14px; margin:2px 0 0;">${e.bulletPoints.map((b) => '<li style="font-size:11px; color:#475569; margin-bottom:2px;">$b</li>').join('')}</ul>' : ''}
      </div>
    ''').join('');

    final education = resume.education.map((e) => '''
      <div style="margin-bottom:10px;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="font-weight:700; font-size:12px; color:#0F172A; border:none;">${e.degree} in ${e.fieldOfStudy}</td>
            <td style="text-align:right; font-size:10px; color:#94A3B8; white-space:nowrap; border:none;">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
        <div style="font-size:11px; color:#0D9488; font-weight:500;">${e.institutionName}</div>
      </div>
    ''').join('');

    final skills = resume.skills.map((s) => '''
      <span style="display:inline-block; font-size:10px; padding:3px 10px; background-color:#fff; border:1px solid #0D9488; border-radius:4px; color:#0D9488; margin:0 4px 6px 0; font-weight:500;">$s</span>
    ''').join('');

    final languages = resume.languages.map((l) => '''
      <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:4px; border:none;">
        <tr>
          <td style="font-size:11px; color:#334155; border:none;">${l.languageName}</td>
          <td style="font-size:10px; color:#94A3B8; text-align:right; border:none;">${l.level}</td>
        </tr>
      </table>
    ''').join('');

    final certificates = resume.certificates.map((c) => '''
      <div style="margin-bottom:6px;">
        <div style="font-weight:600; font-size:11px; color:#334155;">${c.title}</div>
        <div style="font-size:10px; color:#94A3B8;">${c.issuer}</div>
      </div>
    ''').join('');

    final references = resume.references.map((r) => '''
      <div style="margin-bottom:8px;">
        <div style="font-weight:600; font-size:11px; color:#334155;">${r.fullName}</div>
        <div style="font-size:10px; color:#64748B;">${r.company}</div>
        <div style="font-size:10px; color:#94A3B8;">${r.email ?? ''} · ${r.phone ?? ''}</div>
      </div>
    ''').join('');

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        @page { margin: 0; size: A4; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: 'Helvetica Neue', 'Arial', sans-serif;
          margin: 0;
          padding: 0;
          font-size: 12px;
          line-height: 1.4;
          background-color: #fff;
          color: #334155;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        table { border-collapse: collapse; }
        td { vertical-align: top; }
      </style>
    </head>
    <body>
      <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
        <tr>
          <!-- ═══ SIDEBAR ═══ -->
          <td width="34%" style="background-color:#F1F5F9; padding:16px 14px; vertical-align:top; border-right:3px solid #0D9488; border-top:none; border-bottom:none; border-left:none;">
            
            $profileImageHtml

            <!-- Contact -->
            <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0D9488; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid #CBD5E1;">Contact</div>
            <div style="font-size:11px; color:#475569; margin-bottom:5px;">📧 ${resume.personalInfo.email}</div>
            <div style="font-size:11px; color:#475569; margin-bottom:5px;">📱 ${resume.personalInfo.phone}</div>
            ${resume.personalInfo.address != null && resume.personalInfo.address!.isNotEmpty ? '<div style="font-size:11px; color:#475569; margin-bottom:5px;">📍 ${resume.personalInfo.address}</div>' : ''}
            ${resume.personalInfo.linkedinUrl != null && resume.personalInfo.linkedinUrl!.isNotEmpty ? '<div style="font-size:11px; color:#475569; margin-bottom:5px;">🔗 ${resume.personalInfo.linkedinUrl}</div>' : ''}
            ${resume.personalInfo.websiteUrl != null && resume.personalInfo.websiteUrl!.isNotEmpty ? '<div style="font-size:11px; color:#475569; margin-bottom:5px;">🌐 ${resume.personalInfo.websiteUrl}</div>' : ''}

            <!-- Skills -->
            ${resume.skills.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0D9488; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid #CBD5E1;">Skills</div>
              <div>$skills</div>
            ''' : ''}

            <!-- Languages -->
            ${resume.languages.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0D9488; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid #CBD5E1;">Languages</div>
              $languages
            ''' : ''}

            <!-- Certificates -->
            ${resume.certificates.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0D9488; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid #CBD5E1;">Certificates</div>
              $certificates
            ''' : ''}

            <!-- References -->
            ${resume.references.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0D9488; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid #CBD5E1;">References</div>
              $references
            ''' : ''}
          </td>

          <!-- ═══ MAIN CONTENT ═══ -->
          <td width="66%" style="background-color:#fff; padding:16px 18px; vertical-align:top; border:none;">
            
            <!-- Name & Title -->
            <div style="font-size:24px; font-weight:700; color:#0F172A; letter-spacing:0.5px; margin-bottom:2px;">${resume.personalInfo.fullName}</div>
            <div style="font-size:13px; color:#0D9488; font-weight:500; text-transform:uppercase; letter-spacing:1px; margin-bottom:16px;">${resume.personalInfo.targetJobTitle}</div>

            <!-- Profile -->
            ${resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty ? '''
              <div style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0F172A; margin-bottom:8px; padding-bottom:4px; border-bottom:2px solid #0D9488;">Profile</div>
              <div style="font-size:11px; line-height:1.6; color:#475569; margin-bottom:16px;">${resume.professionalSummary}</div>
            ''' : ''}
            
            <!-- Experience -->
            ${resume.experience.isNotEmpty ? '''
              <div style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0F172A; margin-bottom:8px; margin-top:8px; padding-bottom:4px; border-bottom:2px solid #0D9488;">Experience</div>
              $experiences
            ''' : ''}
            
            <!-- Education -->
            ${resume.education.isNotEmpty ? '''
              <div style="font-size:11px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#0F172A; margin-bottom:8px; margin-top:8px; padding-bottom:4px; border-bottom:2px solid #0D9488;">Education</div>
              $education
            ''' : ''}
          </td>
        </tr>
      </table>
    </body>
    </html>
    ''';
  }
}
