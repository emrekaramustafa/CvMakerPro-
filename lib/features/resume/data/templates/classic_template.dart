import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class ClassicTemplate {
  static String generate(ResumeModel resume) {
    // Profile image as base64 if available
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      try {
        final bytes = File(resume.personalInfo.profileImagePath!).readAsBytesSync();
        final base64Image = base64Encode(bytes);
        profileImageHtml = '''
          <img src="data:image/jpeg;base64,$base64Image" class="profile-photo" alt="Profile Photo"/>
        ''';
      } catch (e) {
        // If image can't be loaded, skip it
        profileImageHtml = '';
      }
    }
    
    final experiences = resume.experience.map((e) => '''
      <div class="section-item">
        <div class="item-header">
          <span class="item-title">${e.jobTitle}</span>, <span class="item-company">${e.companyName}</span>
          <span class="item-date">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</span>
        </div>
        <div class="item-desc">${e.description}</div>
        <ul>
          ${e.bulletPoints.map((b) => '<li>$b</li>').join('')}
        </ul>
      </div>
    ''').join('');

    final education = resume.education.map((e) => '''
      <div class="section-item">
        <div class="item-header">
          <span class="item-title">${e.institutionName}</span>
          <span class="item-date">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</span>
        </div>
        <div>${e.degree}, ${e.fieldOfStudy}</div>
      </div>
    ''').join('');

    final skills = resume.skills.join(" • ");

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: 'Times New Roman', serif; color: #000; padding: 40px; font-size: 14px; margin: 0; }
        .header { text-align: center; border-bottom: 1px solid #000; padding-bottom: 20px; margin-bottom: 20px; }
        h1 { font-size: 28px; margin: 0 0 10px 0; text-transform: uppercase; }
        .contact-info { font-size: 14px; }
        h2 { font-size: 16px; text-transform: uppercase; border-bottom: 1px solid #ccc; padding-bottom: 5px; margin-top: 20px; letter-spacing: 1px; }
        .section-item { margin-bottom: 15px; }
        .item-header { font-weight: bold; margin-bottom: 3px; }
        .item-date { float: right; font-weight: normal; }
        .item-title { font-style: italic; }
        ul { margin: 5px 0 0 0; padding-left: 20px; }
        li { margin-bottom: 2px; }
        .summary { margin-bottom: 20px; }
        .profile-photo { width: 80px; height: 80px; border-radius: 50%; object-fit: cover; margin-bottom: 10px; }
      </style>
    </head>
    <body>
      <div class="header">
        $profileImageHtml
        <h1>${resume.personalInfo.fullName}</h1>
        <div class="contact-info">
          ${resume.personalInfo.email} | ${resume.personalInfo.phone} <br>
          ${resume.personalInfo.address ?? ''} | ${resume.personalInfo.linkedinUrl ?? ''}
        </div>
      </div>
      
      <h2>Professional Summary</h2>
      <div class="summary">
        ${resume.professionalSummary ?? ''}
      </div>
      
      <h2>Experience</h2>
      $experiences
      
      <h2>Education</h2>
      $education
      
      <h2>Skills</h2>
      <div>$skills</div>
    </body>
    </html>
    ''';
  }
}
