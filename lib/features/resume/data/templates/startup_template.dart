import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class StartupTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      final imageFile = File(resume.personalInfo.profileImagePath!);
      if (imageFile.existsSync()) {
        final fileUri = Uri.file(imageFile.path).toString();
        profileImageHtml = '''
          <img src="$fileUri" 
               style="width:140px; height:140px; border-radius:50%; object-fit:cover; border:6px solid #FFFFFF;" />
        ''';
      } else {
        profileImageHtml = '<div style="width:140px; height:140px; border-radius:50%; border:6px solid #FFFFFF; background-color: rgba(255,255,255,0.3);"></div>';
      }
    } else {
        profileImageHtml = '<div style="width:140px; height:140px; border-radius:50%; border:6px solid #FFFFFF; background-color: rgba(255,255,255,0.3);"></div>';
    }

    final experiences = resume.experience.map((e) => '''
      <tr>
        <td style="padding-bottom: 20px;">
          <div style="font-weight:700; font-size:16px; color:#374151;">${e.jobTitle}</div>
          <div style="color:#F48FB1; font-weight:600; font-size:14px; margin-bottom:4px;">${e.companyName}</div>
          <div style="font-size:12px; color:#9CA3AF; margin-bottom:8px; font-style: italic;">
             ${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : "Present")}
          </div>
          ${e.description.isNotEmpty ? '<div style="font-size:13px; color:#4B5563; line-height:1.6;">${e.description.replaceAll('\n', '<br>')}</div>' : ''}
          ${e.bulletPoints.isNotEmpty ? '''
            <ul style="margin: 8px 0 0 18px; padding: 0; font-size:13px; color:#4B5563;">
              ${e.bulletPoints.map((b) => '<li style="margin-bottom:4px;">$b</li>').join('')}
            </ul>
          ''' : ''}

        </td>
      </tr>
    ''').join('');

    final educations = resume.education.map((e) => '''
      <tr>
        <td style="padding-bottom: 20px;">
          <div style="font-weight:700; font-size:16px; color:#374151;">${e.institutionName}</div>
          <div style="color:#F48FB1; font-weight:600; font-size:14px; margin-bottom:4px;">${e.degree}, ${e.fieldOfStudy}</div>
          <div style="font-size:12px; color:#9CA3AF; font-style: italic;">
             ${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.y().format(e.endDate!) : "Present")}
          </div>
        </td>
      </tr>
    ''').join('');
    
    final skillsLeft = resume.skills.map((s) => '''
      <div style="margin-bottom:8px; color:#FFFFFF; font-size:14px; letter-spacing: 0.5px;">• $s</div>
    ''').join('');

    final languagesLeft = resume.languages.map((l) => '''
      <div style="margin-bottom:8px; color:#FFFFFF; font-size:14px; letter-spacing: 0.5px;"><strong style="font-weight:700;">${l.languageName}</strong> <span style="opacity: 0.8; font-size: 12px;">(${l.level})</span></div>
    ''').join('');

    final String contactAddress = resume.personalInfo.address != null && resume.personalInfo.address!.isNotEmpty 
        ? '<div class="contact-item"><strong>A:</strong> ${resume.personalInfo.address}</div>' : '';
    final String contactLinkedin = resume.personalInfo.linkedinUrl != null && resume.personalInfo.linkedinUrl!.isNotEmpty 
        ? '<div class="contact-item"><strong>L:</strong> ${resume.personalInfo.linkedinUrl}</div>' : '';

    final String skillsSection = resume.skills.isNotEmpty 
        ? '<div class="sidebar-head">Skills</div>\n<div>$skillsLeft</div>' : '';

    final String languagesSection = resume.languages.isNotEmpty 
        ? '<div class="sidebar-head">Languages</div>\n<div>$languagesLeft</div>' : '';

    final String summarySection = resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty 
        ? '''<div class="section-title first">Profile</div>\n<div class="summary-text">${resume.professionalSummary!.replaceAll('\n', '<br>')}</div>''' : '';

    final String experienceSection = resume.experience.isNotEmpty 
        ? '''<div class="section-title ${resume.professionalSummary == null || resume.professionalSummary!.isEmpty ? 'first' : ''}">Experience</div>\n<table class="list-table">\n$experiences\n</table>''' : '';

    final String educationSection = resume.education.isNotEmpty 
        ? '''<div class="section-title">Education</div>\n<table class="list-table">\n$educations\n</table>''' : '';

    final String certHtml = resume.certificates.map((c) => '''
      <tr>
        <td style="padding-bottom: 15px;">
          <div style="font-weight:700; font-size:15px; color:#374151;">${c.title}</div>
          <div style="color:#F48FB1; font-size:13px;">${c.issuer}</div>
        </td>
      </tr>
    ''').join('');

    final String certificationsSection = resume.certificates.isNotEmpty 
        ? '<div class="section-title">Certifications</div>\n<table class="list-table">\n$certHtml\n</table>' : '';

    final String refHtml = resume.references.map((r) => '''
      <tr>
        <td style="padding-bottom: 15px;">
          <div style="font-weight:700; font-size:15px; color:#374151;">${r.fullName}</div>
          <div style="color:#F48FB1; font-size:13px;">${r.company}</div>
          <div style="font-size:12px; color:#9CA3AF;">${r.email ?? ''} ${r.phone ?? ''}</div>
        </td>
      </tr>
    ''').join('');

    final String referencesSection = resume.references.isNotEmpty 
        ? '<div class="section-title">References</div>\n<table class="list-table">\n$refHtml\n</table>' : '';

    final String actHtml = resume.activities.map((a) => '''
      <tr>
        <td style="padding-bottom: 15px;">
          <div style="font-weight:700; font-size:15px; color:#374151;">${a.title}</div>
          ${a.description.isNotEmpty ? '<div style="font-size:13px; color:#4B5563; line-height:1.5; margin-top:4px;">${a.description.replaceAll('\n', '<br>')}</div>' : ''}
        </td>
      </tr>
    ''').join('');

    final String activitiesSection = resume.activities.isNotEmpty 
        ? '<div class="section-title">Activities & Projects</div>\n<table class="list-table">\n$actHtml\n</table>' : '';


    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        @page { margin: 0; size: A4; }
        body { 
           font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
           margin: 0; 
           padding: 0;
           background-color: #FFFFFF;
        }
        table.main-table {
           width: 100%;
           border-collapse: collapse;
           margin: 0;
           padding: 0;
        }
        td.sidebar {
           width: 35%;
           background-color: #F48FB1;
           color: #FFFFFF;
           vertical-align: top;
           padding: 30px 30px;
        }
        td.content {
           width: 65%;
           background-color: #FFFFFF;
           vertical-align: top;
           padding: 30px 36px;
        }
        
        .name-box { margin-top: 40px; margin-bottom: 10px; }
        .first-name { font-size: 38px; font-weight: 300; letter-spacing: 4px; line-height: 1.1; margin: 0; color: #FFFFFF; text-transform: uppercase; }
        .last-name { font-size: 38px; font-weight: 700; letter-spacing: 4px; line-height: 1.1; margin: 0; color: #FFFFFF; text-transform: uppercase; }
        
        .job-title {
           font-size: 14px;
           font-weight: 600;
           letter-spacing: 2px;
           text-transform: uppercase;
           color: #FFFFFF;
           opacity: 0.9;
           margin-top: 15px;
           margin-bottom: 40px;
           padding-bottom: 15px;
           border-bottom: 2px solid rgba(255,255,255,0.3);
        }
        
        .contact-box { margin-bottom: 40px; }
        .contact-item { margin-bottom: 12px; font-size: 13px; color: #FFFFFF; line-height: 1.4; word-break: break-word;}
        
        .sidebar-head {
           font-size: 18px;
           font-weight: 700;
           letter-spacing: 2px;
           text-transform: uppercase;
           color: #FFFFFF;
           margin-bottom: 15px;
           margin-top: 40px;
        }
        
        .section-title {
           font-size: 20px;
           font-weight: 700;
           letter-spacing: 3px;
           text-transform: uppercase;
           color: #F48FB1;
           margin-bottom: 25px;
           padding-bottom: 8px;
           border-bottom: 2px solid #F3F4F6;
           margin-top: 30px;
        }
        .section-title.first { margin-top: 0; }
        
        .summary-text {
           font-size: 14px;
           color: #4B5563;
           line-height: 1.7;
           margin-bottom: 30px;
        }
        
        table.list-table {
           width: 100%;
           border-collapse: collapse;
        }
      </style>
    </head>
    <body>
       <table class="main-table">
         <tr>
           <td class="sidebar">
              <div style="text-align: center; margin-bottom: 20px;">
                $profileImageHtml
              </div>
              <div class="name-box">
                <div class="last-name">${resume.personalInfo.fullName}</div>
              </div>
              <div class="job-title">${resume.personalInfo.targetJobTitle}</div>
              
              <div class="contact-box">
                <div class="contact-item"><strong>E:</strong> ${resume.personalInfo.email}</div>
                <div class="contact-item"><strong>P:</strong> ${resume.personalInfo.phone}</div>
                $contactAddress
                $contactLinkedin
              </div>
              
              $skillsSection
              $languagesSection
           </td>
           <td class="content">
              $summarySection
              $experienceSection
              $educationSection
              $certificationsSection
              $activitiesSection
              $referencesSection
           </td>
         </tr>
       </table>
    </body>
    </html>
    ''';
  }
}
