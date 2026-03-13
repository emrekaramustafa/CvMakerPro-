import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';
import 'template_utils.dart';

class BritishGreenTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    final imgUri = getBase64ImageUri(resume.personalInfo.profileImagePath);
    if (imgUri != null) {
      profileImageHtml = '''
        <div style="text-align: center; margin-bottom: 20px;">
          <img src="$imgUri" style="width:140px; height:140px; border-radius:50%; object-fit:cover; border:6px solid #FFFFFF;" />
        </div>
      ''';
    }

    final experiences = resume.experience.where((e) => e.jobTitle.trim().isNotEmpty || e.companyName.trim().isNotEmpty || e.description.trim().isNotEmpty).map((e) => '''
      <div style="margin-bottom: 20px;">
        <div style="font-weight:700; font-size:16px; color:#374151;">${e.jobTitle}</div>
        <div style="color:#004225; font-weight:600; font-size:14px; margin-bottom:4px;">${e.companyName}</div>
        <div style="font-size:12px; color:#6B7280; margin-bottom:8px; font-style: italic;">
           ${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : "Present")}
        </div>
        ${e.description.trim().isNotEmpty ? '<div style="font-size:13px; color:#4B5563; line-height:1.6;">${e.description.replaceAll('\n', '<br>')}</div>' : ''}
        ${e.bulletPoints.isNotEmpty ? '''
          <ul style="margin: 8px 0 0 18px; padding: 0; font-size:13px; color:#4B5563;">
            ${e.bulletPoints.map((b) => '<li style="margin-bottom:4px;">$b</li>').join('')}
          </ul>
        ''' : ''}
      </div>
    ''').join('');

    final educations = resume.education.where((e) => e.institutionName.trim().isNotEmpty || e.degree.trim().isNotEmpty || e.fieldOfStudy.trim().isNotEmpty).map((e) => '''
      <div style="margin-bottom: 20px;">
        <div style="font-weight:700; font-size:16px; color:#374151;">${e.institutionName}</div>
        <div style="color:#004225; font-weight:600; font-size:14px; margin-bottom:4px;">${e.degree}, ${e.fieldOfStudy}</div>
        <div style="font-size:12px; color:#6B7280; font-style: italic;">
           ${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.y().format(e.endDate!) : "Present")}
        </div>
      </div>
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
        ? '''<div class="section-title ${resume.professionalSummary == null || resume.professionalSummary!.isEmpty ? 'first' : ''}">Experience</div>\n<div>\n$experiences\n</div>''' : '';

    final String educationSection = resume.education.isNotEmpty 
        ? '''<div class="section-title">Education</div>\n<div>\n$educations\n</div>''' : '';

    final String certHtml = resume.certificates.map((c) => '''
      <div style="margin-bottom: 15px;">
        <div style="font-weight:700; font-size:15px; color:#374151;">${c.title}</div>
        <div style="color:#004225; font-size:13px;">${c.issuer}</div>
      </div>
    ''').join('');

    final String certificationsSection = resume.certificates.isNotEmpty 
        ? '<div class="section-title">Certifications</div>\n<div>\n$certHtml\n</div>' : '';

    final String refHtml = resume.references.map((r) => '''
      <div style="margin-bottom: 15px;">
        <div style="font-weight:700; font-size:15px; color:#374151;">${r.fullName}</div>
        <div style="color:#004225; font-size:13px;">${r.company}</div>
        <div style="font-size:12px; color:#6B7280;">${r.email ?? ''} ${r.phone ?? ''}</div>
      </div>
    ''').join('');

    final String referencesSection = resume.references.isNotEmpty 
        ? '<div class="section-title">References</div>\n<div>\n$refHtml\n</div>' : '';

    final String actHtml = resume.activities.map((a) => '''
      <div style="margin-bottom: 15px;">
        <div style="font-weight:700; font-size:15px; color:#374151;">${a.title}</div>
        ${a.description.isNotEmpty ? '<div style="font-size:13px; color:#4B5563; line-height:1.5; margin-top:4px;">${a.description.replaceAll('\n', '<br>')}</div>' : ''}
      </div>
    ''').join('');

    final String activitiesSection = resume.activities.isNotEmpty 
        ? '<div class="section-title">Activities & Projects</div>\n<div>\n$actHtml\n</div>' : '';


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
           -webkit-print-color-adjust: exact;
           print-color-adjust: exact;
        }
        table.main-table {
           width: 100%;
           border-collapse: collapse;
           margin: 0;
           padding: 0;
        }
        td.sidebar {
           width: 35%;
           background-color: #004225;
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
           color: #004225;
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
              $profileImageHtml
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
