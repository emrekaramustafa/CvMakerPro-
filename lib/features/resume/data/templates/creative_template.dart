import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';
import 'template_utils.dart';

class CreativeTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    final imgUri = getBase64ImageUri(resume.personalInfo.profileImagePath);
    if (imgUri != null) {
      profileImageHtml = '''
        <div style="text-align:center; margin-bottom:18px;">
          <img src="$imgUri" 
               style="width:100px; height:100px; border-radius:50%; object-fit:cover; border:3px solid #fff;" />
        </div>
      ''';
    }

    final experiences = resume.experience.where((e) => e.jobTitle.isNotEmpty || e.companyName.isNotEmpty || e.description.isNotEmpty).map((e) => '''
      <div style="margin-bottom:14px;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="vertical-align:top; width:8px; padding-top:6px; border:none;">
              <div style="width:8px; height:8px; background-color:#EC4899; border-radius:50%;"></div>
            </td>
            <td style="padding-left:10px; border:none;">
              <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
                <tr>
                  <td style="font-weight:700; font-size:13px; color:#fff; border:none;">${e.jobTitle}</td>
                  <td style="text-align:right; font-size:10px; color:#94A3B8; white-space:nowrap; border:none;">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</td>
                </tr>
              </table>
              <div style="font-size:12px; color:#EC4899; font-weight:500; margin-bottom:3px;">${e.companyName}</div>
              ${e.description.isNotEmpty ? '<div style="font-size:11px; color:#94A3B8; margin-bottom:3px;">${e.description}</div>' : ''}
              ${e.bulletPoints.isNotEmpty ? '<ul style="padding-left:14px; margin:2px 0 0;">${e.bulletPoints.map((b) => '<li style="font-size:11px; color:#CBD5E1; margin-bottom:2px;">$b</li>').join('')}</ul>' : ''}
            </td>
          </tr>
        </table>
      </div>
    ''').join('');

    final education = resume.education.where((e) => e.institutionName.isNotEmpty || e.degree.isNotEmpty || e.fieldOfStudy.isNotEmpty).map((e) => '''
      <div style="margin-bottom:10px;">
        <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
          <tr>
            <td style="vertical-align:top; width:8px; padding-top:6px; border:none;">
              <div style="width:8px; height:8px; background-color:#F97316; border-radius:50%;"></div>
            </td>
            <td style="padding-left:10px; border:none;">
              <table width="100%" cellpadding="0" cellspacing="0" style="border:none;">
                <tr>
                  <td style="font-weight:700; font-size:12px; color:#fff; border:none;">${e.degree}</td>
                  <td style="text-align:right; font-size:10px; color:#94A3B8; white-space:nowrap; border:none;">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</td>
                </tr>
              </table>
              <div style="font-size:11px; color:#EC4899; font-weight:500;">${e.institutionName}</div>
              ${e.fieldOfStudy.isNotEmpty ? '<div style="font-size:10px; color:#94A3B8;">${e.fieldOfStudy}</div>' : ''}
            </td>
          </tr>
        </table>
      </div>
    ''').join('');

    final skills = resume.skills.map((s) => '''
      <span style="display:inline-block; font-size:10px; padding:3px 10px; border:1px solid rgba(255,255,255,0.4); border-radius:12px; color:#fff; background-color:rgba(255,255,255,0.1); margin:0 4px 6px 0;">$s</span>
    ''').join('');

    final languages = resume.languages.map((l) => '''
      <table width="100%" cellpadding="0" cellspacing="0" style="margin-bottom:4px; border:none;">
        <tr>
          <td style="font-size:11px; color:#fff; border:none;">${l.languageName}</td>
          <td style="font-size:10px; color:rgba(255,255,255,0.6); text-align:right; border:none;">${l.level}</td>
        </tr>
      </table>
    ''').join('');

    final certificates = resume.certificates.map((c) => '''
      <div style="margin-bottom:6px;">
        <div style="font-weight:600; font-size:11px; color:#fff;">${c.title}</div>
        <div style="font-size:10px; color:rgba(255,255,255,0.6);">${c.issuer}</div>
      </div>
    ''').join('');

    final references = resume.references.map((r) => '''
      <div style="margin-bottom:8px;">
        <div style="font-weight:600; font-size:11px; color:#fff;">${r.fullName}</div>
        <div style="font-size:10px; color:rgba(255,255,255,0.7);">${r.company}</div>
        <div style="font-size:10px; color:rgba(255,255,255,0.5);">${r.email ?? ''} · ${r.phone ?? ''}</div>
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
          background-color: #1E1333;
          color: #E2E8F0;
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
          <td width="34%" style="background-color:#2D1B69; padding:16px 14px; vertical-align:top; border:none;">
            
            $profileImageHtml

            <!-- Name in sidebar -->
            <div style="text-align:center; margin-bottom:20px;">
              <div style="font-size:20px; font-weight:800; color:#fff; text-transform:uppercase; letter-spacing:1px;">
                ${resume.personalInfo.fullName}
              </div>
            </div>

            <!-- Contact -->
            <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#EC4899; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid rgba(255,255,255,0.2);">Contact</div>
            <div style="font-size:11px; color:rgba(255,255,255,0.85); margin-bottom:5px;">📧 ${resume.personalInfo.email}</div>
            <div style="font-size:11px; color:rgba(255,255,255,0.85); margin-bottom:5px;">📱 ${resume.personalInfo.phone}</div>
            ${resume.personalInfo.address != null && resume.personalInfo.address!.isNotEmpty ? '<div style="font-size:11px; color:rgba(255,255,255,0.85); margin-bottom:5px;">📍 ${resume.personalInfo.address}</div>' : ''}
            ${resume.personalInfo.linkedinUrl != null && resume.personalInfo.linkedinUrl!.isNotEmpty ? '<div style="font-size:11px; color:rgba(255,255,255,0.85); margin-bottom:5px;">🔗 ${resume.personalInfo.linkedinUrl}</div>' : ''}
            ${resume.personalInfo.websiteUrl != null && resume.personalInfo.websiteUrl!.isNotEmpty ? '<div style="font-size:11px; color:rgba(255,255,255,0.85); margin-bottom:5px;">🌐 ${resume.personalInfo.websiteUrl}</div>' : ''}

            <!-- Skills -->
            ${resume.skills.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#F97316; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid rgba(255,255,255,0.2);">Skills & Expertise</div>
              <div>$skills</div>
            ''' : ''}

            <!-- Languages -->
            ${resume.languages.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#F97316; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid rgba(255,255,255,0.2);">Languages</div>
              $languages
            ''' : ''}

            <!-- Certificates -->
            ${resume.certificates.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#F97316; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid rgba(255,255,255,0.2);">Certificates</div>
              $certificates
            ''' : ''}

            <!-- References -->
            ${resume.references.isNotEmpty ? '''
              <div style="font-size:10px; font-weight:700; text-transform:uppercase; letter-spacing:2px; color:#F97316; margin-top:18px; margin-bottom:8px; padding-bottom:4px; border-bottom:1px solid rgba(255,255,255,0.2);">References</div>
              $references
            ''' : ''}
          </td>

          <!-- ═══ MAIN CONTENT ═══ -->
          <td width="66%" style="background-color:#1E1333; padding:16px 18px; vertical-align:top; border:none;">
            
            <!-- Title -->
            <div style="font-size:14px; color:#EC4899; font-weight:600; text-transform:uppercase; letter-spacing:1px; margin-bottom:14px;">
              ${resume.personalInfo.targetJobTitle}
            </div>

            <!-- Profile / About Me -->
            ${resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty ? '''
              <div style="font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#F97316; margin-bottom:8px; padding-left:10px; border-left:3px solid #EC4899;">Profile</div>
              <div style="font-size:11px; line-height:1.6; color:#CBD5E1; font-style:italic; margin-bottom:16px;">${resume.professionalSummary}</div>
            ''' : ''}
            
            <!-- Work Experience -->
            ${resume.experience.isNotEmpty ? '''
              <div style="font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#F97316; margin-bottom:10px; margin-top:8px; padding-left:10px; border-left:3px solid #EC4899;">Work Experience</div>
              $experiences
            ''' : ''}
            
            <!-- Education & Awards -->
            ${resume.education.isNotEmpty ? '''
              <div style="font-size:13px; font-weight:700; text-transform:uppercase; letter-spacing:1px; color:#F97316; margin-bottom:10px; margin-top:8px; padding-left:10px; border-left:3px solid #EC4899;">Education & Awards</div>
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
