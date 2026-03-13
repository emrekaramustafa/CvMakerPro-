import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';
import 'template_utils.dart';

class ClassicTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    final imgUri = getBase64ImageUri(resume.personalInfo.profileImagePath);
    if (imgUri != null) {
      profileImageHtml = '''
        <div style="text-align:center; margin-bottom:12px;">
          <img src="$imgUri" 
               style="width:80px; height:80px; border-radius:50%; object-fit:cover; border:3px solid #C4975C;" />
        </div>
      ''';
    }

    final experiences = resume.experience.map((e) => '''
      <div style="margin-bottom:14px; padding-bottom:12px; border-bottom:1px solid #F3F4F6;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="border:none;">
              <div style="font-weight:700; font-size:13px; color:#1B2A4A;">${e.jobTitle}</div>
              <div style="color:#718096; font-style:italic; font-size:12px;">${e.companyName}</div>
            </td>
            <td style="text-align:right; font-size:10px; color:#A0AEC0; white-space:nowrap; vertical-align:top; border:none;">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
        ${e.description.isNotEmpty ? '<div style="font-size:11px; color:#4A5568; margin-top:4px; margin-bottom:3px;">${e.description}</div>' : ''}
        ${e.bulletPoints.isNotEmpty ? '<ul style="padding-left:16px; margin:3px 0 0;">${e.bulletPoints.map((b) => '<li style="font-size:11px; color:#4A5568; margin-bottom:2px;">$b</li>').join('')}</ul>' : ''}
      </div>
    ''').join('');

    final education = resume.education.map((e) => '''
      <div style="margin-bottom:10px; padding-bottom:8px; border-bottom:1px solid #F3F4F6;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="border:none;">
              <div style="font-weight:700; font-size:13px; color:#1B2A4A;">${e.institutionName}</div>
              <div style="color:#718096; font-size:12px;">${e.degree}, ${e.fieldOfStudy}</div>
            </td>
            <td style="text-align:right; font-size:10px; color:#A0AEC0; white-space:nowrap; vertical-align:top; border:none;">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</td>
          </tr>
        </table>
      </div>
    ''').join('');

    final skills = resume.skills.map((s) => '''
      <span style="display:inline-block; font-size:10px; padding:3px 11px; border:1px solid #1B2A4A; border-radius:14px; color:#1B2A4A; background-color:#F7FAFC; margin:0 4px 6px 0;">$s</span>
    ''').join('');

    final languages = resume.languages.map((l) => '''
      <span style="font-size:12px; color:#2D3748; margin-right:10px;">${l.languageName} <span style="color:#A0AEC0; font-size:10px;">(${l.level})</span></span>
    ''').join('');

    final certificates = resume.certificates.map((c) => '''
      <div style="margin-bottom:6px;">
        <div style="font-weight:700; font-size:12px; color:#1B2A4A;">${c.title}</div>
        <div style="font-size:10px; color:#718096;">${c.issuer}</div>
      </div>
    ''').join('');

    final references = resume.references.map((r) => '''
      <div style="margin-bottom:8px;">
        <div style="font-weight:700; font-size:12px; color:#1B2A4A;">${r.fullName}</div>
        <div style="font-size:10px; color:#718096;">${r.company}</div>
        <div style="font-size:10px; color:#A0AEC0;">${r.email ?? ''} · ${r.phone ?? ''}</div>
      </div>
    ''').join('');

    // Build contact items
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
    final contactHtml = contactItems.map((item) => '<span style="font-size:11px;">$item</span>').join('<span style="color:#C4975C; margin:0 6px;">·</span>');

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
          line-height: 1.5;
          background-color: #fff;
          color: #2D3748;
          -webkit-print-color-adjust: exact;
          print-color-adjust: exact;
        }
        table { border-collapse: collapse; }
        td { vertical-align: top; }
      </style>
    </head>
    <body>
      <!-- ═══ HEADER BAND ═══ -->
      <div style="background-color:#1B2A4A; color:#fff; padding:16px 36px 12px; text-align:center;">
        $profileImageHtml
        <div style="font-size:26px; font-weight:700; letter-spacing:3px; text-transform:uppercase; color:#fff; margin-bottom:4px;">
          ${resume.personalInfo.fullName}
        </div>
        <div style="font-size:13px; color:#C4975C; letter-spacing:2px; text-transform:uppercase; font-weight:400; margin-bottom:14px;">
          ${resume.personalInfo.targetJobTitle}
        </div>
        <div style="font-size:11px; color:#CBD5E0; word-spacing:2px;">
          $contactHtml
        </div>
      </div>

      <!-- ═══ CONTENT ═══ -->
      <div style="padding:12px 36px 24px;">
        
        <!-- Profile -->
        ${resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Profile</div>
          <div style="font-size:12px; line-height:1.7; color:#4A5568; font-style:italic; margin-bottom:10px;">${resume.professionalSummary}</div>
        ''' : ''}

        <!-- Experience -->
        ${resume.experience.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Experience</div>
          $experiences
        ''' : ''}

        <!-- Education -->
        ${resume.education.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Education</div>
          $education
        ''' : ''}

        <!-- Skills -->
        ${resume.skills.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Skills</div>
          <div style="margin-top:4px;">$skills</div>
        ''' : ''}

        <!-- Languages -->
        ${resume.languages.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Languages</div>
          <div style="margin-top:4px;">$languages</div>
        ''' : ''}

        <!-- Certificates -->
        ${resume.certificates.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">Certificates</div>
          $certificates
        ''' : ''}

        <!-- References -->
        ${resume.references.isNotEmpty ? '''
          <div style="font-size:12px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#1B2A4A; margin-top:16px; margin-bottom:8px; padding-bottom:5px; border-bottom:2px solid #C4975C;">References</div>
          $references
        ''' : ''}
      </div>
    </body>
    </html>
    ''';
  }
}
