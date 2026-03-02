import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class ElegantTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      final imageFile = File(resume.personalInfo.profileImagePath!);
      if (imageFile.existsSync()) {
        final fileUri = Uri.file(imageFile.path).toString();
        profileImageHtml = '''
          <div style="text-align:center; margin-bottom:14px;">
            <img src="$fileUri" 
                 style="width:90px; height:90px; border-radius:50%; object-fit:cover; border:2px solid #C9A96E; padding:2px;" />
          </div>
        ''';
      }
    }

    final experiences = resume.experience.map((e) => '''
      <div style="margin-bottom:16px; padding-bottom:12px; border-bottom:1px solid #F3F4F6;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="border:none;">
              <div style="font-weight:700; font-size:13px; color:#1C1C1C;">${e.jobTitle}</div>
              <div style="color:#6B7280; font-style:italic; font-size:12px;">${e.companyName}</div>
            </td>
            <td style="text-align:right; font-size:10px; color:#9CA3AF; white-space:nowrap; vertical-align:top; border:none;">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
        ${e.description.isNotEmpty ? '<div style="font-size:11px; color:#4B5563; margin-top:4px; margin-bottom:3px; line-height:1.6;">${e.description}</div>' : ''}
        ${e.bulletPoints.isNotEmpty ? '<ul style="padding-left:16px; margin:3px 0 0;">${e.bulletPoints.map((b) => '<li style="font-size:11px; color:#4B5563; margin-bottom:2px;">$b</li>').join('')}</ul>' : ''}
      </div>
    ''').join('');

    final education = resume.education.map((e) => '''
      <div style="margin-bottom:12px; padding-bottom:8px; border-bottom:1px solid #F3F4F6;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="border:none;">
              <div style="font-weight:700; font-size:13px; color:#1C1C1C;">${e.degree} in ${e.fieldOfStudy}</div>
              <div style="color:#6B7280; font-size:12px;">${e.institutionName}</div>
            </td>
            <td style="text-align:right; font-size:10px; color:#9CA3AF; white-space:nowrap; vertical-align:top; border:none;">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
      </div>
    ''').join('');

    final skills = resume.skills.map((s) => '''
      <span style="display:inline-block; font-size:10px; padding:3px 12px; border:1px solid #C9A96E; border-radius:2px; color:#1C1C1C; background-color:#FEFCE8; margin:0 5px 6px 0; letter-spacing:0.5px;">$s</span>
    ''').join('');

    final languages = resume.languages.map((l) => '''
      <span style="font-size:12px; color:#374151; margin-right:8px;">${l.languageName} <span style="color:#9CA3AF; font-size:10px;">(${l.level})</span></span>
    ''').join('<span style="color:#C9A96E; margin:0 4px;">·</span>');

    final certificates = resume.certificates.map((c) => '''
      <div style="text-align:center; margin-bottom:6px;">
        <div style="font-weight:700; font-size:12px; color:#1C1C1C;">${c.title}</div>
        <div style="font-size:10px; color:#6B7280; font-style:italic;">${c.issuer}</div>
      </div>
    ''').join('');

    final references = resume.references.map((r) => '''
      <div style="display:inline-block; text-align:center; margin:0 14px 8px 0; vertical-align:top;">
        <div style="font-weight:700; font-size:12px; color:#1C1C1C;">${r.fullName}</div>
        <div style="font-size:10px; color:#6B7280;">${r.company}</div>
        <div style="font-size:10px; color:#9CA3AF;">${r.email ?? ''} · ${r.phone ?? ''}</div>
      </div>
    ''').join('');

    // Contact bar items
    final contactItems = <String>[
      resume.personalInfo.email,
      resume.personalInfo.phone,
    ];
    if (resume.personalInfo.address != null && resume.personalInfo.address!.isNotEmpty) {
      contactItems.add(resume.personalInfo.address!);
    }
    if (resume.personalInfo.linkedinUrl != null && resume.personalInfo.linkedinUrl!.isNotEmpty) {
      contactItems.add(resume.personalInfo.linkedinUrl!);
    }
    if (resume.personalInfo.websiteUrl != null && resume.personalInfo.websiteUrl!.isNotEmpty) {
      contactItems.add(resume.personalInfo.websiteUrl!);
    }
    final contactHtml = contactItems.map((item) => '<span style="font-size:11px;">$item</span>').join('<span style="color:#C9A96E; margin:0 6px;">·</span>');

    // Section title helper - centered with gold underline
    String sectionTitle(String title) => '''
      <div style="font-size:12px; font-weight:400; text-transform:uppercase; letter-spacing:3px; color:#1C1C1C; margin-top:24px; margin-bottom:6px; text-align:center;">
        $title
        <div style="width:40px; height:2px; background-color:#C9A96E; margin:6px auto 0;"></div>
      </div>
    ''';

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        @page { margin: 0; size: A4; }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
          font-family: 'Georgia', 'Times New Roman', serif;
          margin: 0;
          padding: 0;
          font-size: 12px;
          line-height: 1.6;
          background-color: #fff;
          color: #1C1C1C;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        table { border-collapse: collapse; }
        td { vertical-align: top; }
      </style>
    </head>
    <body>
      <!-- ═══ GOLD TOP ACCENT ═══ -->
      <div style="height:5px; background-color:#C9A96E;"></div>
      
      <!-- ═══ CONTENT ═══ -->
      <div style="padding:16px 36px;">
        
        <!-- Header -->
        <div style="text-align:center; margin-bottom:22px;">
          $profileImageHtml
          <div style="font-size:28px; font-weight:300; color:#1C1C1C; letter-spacing:4px; text-transform:uppercase; margin-bottom:4px;">
            ${resume.personalInfo.fullName}
          </div>
          <div style="font-size:13px; color:#C9A96E; letter-spacing:3px; text-transform:uppercase; font-weight:400; margin-bottom:14px;">
            ${resume.personalInfo.targetJobTitle}
          </div>
          <div style="border-top:1px solid #E5E7EB; border-bottom:1px solid #E5E7EB; padding:8px 0; text-align:center; color:#6B7280;">
            $contactHtml
          </div>
        </div>

        <!-- Profile -->
        ${resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty ? '''
          ${sectionTitle('Profile')}
          <div style="font-size:12px; line-height:1.8; text-align:center; color:#374151; max-width:480px; margin:0 auto 8px; font-style:italic;">${resume.professionalSummary}</div>
        ''' : ''}

        <!-- Experience -->
        ${resume.experience.isNotEmpty ? '''
          ${sectionTitle('Experience')}
          <div style="margin-top:10px;">$experiences</div>
        ''' : ''}

        <!-- Education -->
        ${resume.education.isNotEmpty ? '''
          ${sectionTitle('Education')}
          <div style="margin-top:10px;">$education</div>
        ''' : ''}

        <!-- Skills / Expertise -->
        ${resume.skills.isNotEmpty ? '''
          ${sectionTitle('Expertise')}
          <div style="text-align:center; margin-top:8px;">$skills</div>
        ''' : ''}

        <!-- Languages -->
        ${resume.languages.isNotEmpty ? '''
          ${sectionTitle('Languages')}
          <div style="text-align:center; margin-top:8px;">$languages</div>
        ''' : ''}

        <!-- Certificates -->
        ${resume.certificates.isNotEmpty ? '''
          ${sectionTitle('Certificates')}
          <div style="margin-top:8px;">$certificates</div>
        ''' : ''}

        <!-- References -->
        ${resume.references.isNotEmpty ? '''
          ${sectionTitle('References')}
          <div style="text-align:center; margin-top:8px;">$references</div>
        ''' : ''}
      </div>

      <!-- ═══ GOLD BOTTOM ACCENT ═══ -->
      <div style="height:5px; background-color:#C9A96E;"></div>
    </body>
    </html>
    ''';
  }
}
