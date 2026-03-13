import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';
import 'template_utils.dart';

class ExecutiveTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    // Executive templates often omit photos in some regions, but let's keep it optional/subtle
    final imgUri = getBase64ImageUri(resume.personalInfo.profileImagePath);
    if (imgUri != null) {
      profileImageHtml = '''
        <img src="$imgUri" 
             style="width:80px; height:80px; object-fit:cover; border-radius:4px;" />
      ''';
    }

    final experiences = resume.experience.where((e) => e.jobTitle.isNotEmpty || e.companyName.isNotEmpty || e.description.isNotEmpty).map((e) => '''
      <div style="margin-bottom:16px;">
        <div style="display:flex; justify-content:space-between; align-items:baseline;">
           <span style="font-weight:700; font-size:14px; color:#111827;">${e.companyName}</span>
           <span style="font-size:11px; color:#374151;">${DateFormat.yMMM().format(e.startDate)} – ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</span>
        </div>
        <div style="font-style:italic; font-size:13px; color:#4B5563; margin-bottom:6px;">${e.jobTitle}</div>
        ${e.description.isNotEmpty ? '<div style="font-size:11px; color:#374151; line-height:1.5;">${e.description}</div>' : ''}
        ${e.bulletPoints.isNotEmpty ? '<ul style="margin-top:4px; padding-left:16px; margin-bottom:0;">${e.bulletPoints.map((b) => '<li style="font-size:11px; color:#4B5563; margin-bottom:2px;">$b</li>').join('')}</ul>' : ''}
      </div>
    ''').join('');

    final education = resume.education.where((e) => e.institutionName.isNotEmpty || e.degree.isNotEmpty || e.fieldOfStudy.isNotEmpty).map((e) => '''
      <div style="margin-bottom:8px;">
        <div style="font-weight:700; font-size:12px; color:#1F2937;">${e.institutionName}</div>
        <div style="font-size:11px; color:#4B5563;">${e.degree}, ${e.fieldOfStudy} (${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.y().format(e.endDate!) : "Present")})</div>
      </div>
    ''').join('');

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        @page { margin: 40px; size: A4; }
        body { font-family: 'Georgia', serif; color: #111827; line-height: 1.5; font-size: 11px; }
        .header { border-bottom: 1px solid #000; padding-bottom: 20px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items:flex-end; }
        .name { font-family: 'Helvetica', sans-serif; font-size: 28px; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; line-height: 1.2; }
        .title { font-family: 'Helvetica', sans-serif; font-size: 14px; color: #6B7280; text-transform: uppercase; letter-spacing: 2px; margin-top: 4px; }
        .contact { font-size: 10px; color: #4B5563; text-align: right; line-height: 1.6; }
        
        .section-header {
           font-family: 'Helvetica', sans-serif;
           font-size: 12px; 
           font-weight: 700; 
           text-transform: uppercase; 
           border-bottom: 1px solid #E5E7EB; 
           padding-bottom: 4px; 
           margin-top: 24px; 
           margin-bottom: 12px; 
           color: #111827;
        }
        .container { display: flex; gap: 30px; }
        .main-col { flex: 1; }
      </style>
    </head>
    <body>
      <div class="header">
        <div>
           <div class="name">${resume.personalInfo.fullName}</div>
           <div class="title">${resume.personalInfo.targetJobTitle}</div>
        </div>
        <div class="contact">
           ${resume.personalInfo.email}<br>
           ${resume.personalInfo.phone}<br>
           ${resume.personalInfo.address ?? ''}<br>
           ${resume.personalInfo.linkedinUrl ?? ''}
        </div>
      </div>

      ${resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty ? '''
        <div class="section-header">Executive Profile</div>
        <div style="margin-bottom:20px;">${resume.professionalSummary}</div>
      ''' : ''}

      <div class="section-header">Professional Experience</div>
      <div style="margin-bottom:20px;">
         $experiences
      </div>

      <div class="section-header">Education</div>
      <div>
         $education
      </div>
      
      ${resume.skills.isNotEmpty ? '''
        <div class="section-header" style="page-break-before: auto;">Core Competencies</div>
        <div style="display:flex; flex-wrap:wrap; gap:8px;">
           ${resume.skills.map((s) => '<span style="background:#F3F4F6; padding:4px 8px; border-radius:4px;">$s</span>').join('')}
        </div>
      ''' : ''}
    </body>
    </html>
    ''';
  }
}
