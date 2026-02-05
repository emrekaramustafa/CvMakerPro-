import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class ModernTemplate {
  static String generate(ResumeModel resume) {
    // Profile image as base64 if available
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      try {
        final bytes = File(resume.personalInfo.profileImagePath!).readAsBytesSync();
        final base64Image = base64Encode(bytes);
        profileImageHtml = '''
          <div class="profile-photo">
            <img src="data:image/jpeg;base64,$base64Image" alt="Profile Photo"/>
          </div>
        ''';
      } catch (e) {
        // If image can't be loaded, skip it
        profileImageHtml = '';
      }
    }
    
    final experiences = resume.experience.map((e) => '''
      <div class="section-item">
        <div class="item-header">
          <span class="item-title">${e.jobTitle}</span>
          <span class="item-date">${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : 'Present')}</span>
        </div>
        <div class="item-subtitle">${e.companyName}</div>
        <div class="item-desc">${e.description}</div>
        <ul>
          ${e.bulletPoints.map((b) => '<li>$b</li>').join('')}
        </ul>
      </div>
    ''').join('');

    final education = resume.education.map((e) => '''
      <div class="section-item">
        <div class="item-header">
          <span class="item-title">${e.degree} in ${e.fieldOfStudy}</span>
          <span class="item-date">${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? 'Present' : (e.endDate != null ? DateFormat.y().format(e.endDate!) : 'Present')}</span>
        </div>
        <div class="item-subtitle">${e.institutionName}</div>
      </div>
    ''').join('');

    final skills = resume.skills.map((s) => '<span class="skill-tag">$s</span>').join('');

    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <style>
        body { font-family: 'Inter', sans-serif; display: flex; color: #333; margin: 0; padding: 0; }
        .sidebar { width: 30%; background-color: #f8fafc; padding: 20px; border-right: 1px solid #e2e8f0; }
        .main { width: 70%; padding: 20px; }
        h1 { color: #2563eb; font-size: 24px; margin-bottom: 5px; }
        h2 { font-size: 16px; color: #64748b; margin-top: 5px; text-transform: uppercase; border-bottom: 2px solid #2563eb; padding-bottom: 5px; margin-bottom: 15px;}
        h3 { font-size: 14px; margin-bottom: 5px; }
        .profile-photo { text-align: center; margin-bottom: 20px; }
        .profile-photo img { width: 100px; height: 100px; border-radius: 50%; object-fit: cover; border: 3px solid #2563eb; }
        .contact-info { font-size: 12px; margin-bottom: 20px; }
        .contact-item { margin-bottom: 5px; }
        .section-item { margin-bottom: 15px; }
        .item-header { display: flex; justify-content: space-between; font-weight: bold; font-size: 14px; }
        .item-subtitle { color: #475569; font-style: italic; font-size: 13px; margin-bottom: 5px; }
        .item-desc { font-size: 13px; margin-bottom: 5px; }
        ul { margin: 0; padding-left: 20px; font-size: 13px; }
        li { margin-bottom: 3px; }
        .skill-tag { display: inline-block; background: #e2e8f0; padding: 3px 8px; border-radius: 4px; font-size: 12px; margin: 0 5px 5px 0; }
        .summary { font-size: 13px; line-height: 1.5; margin-bottom: 20px; }
      </style>
    </head>
    <body>
      <div class="sidebar">
        $profileImageHtml
        <div class="contact-info">
          <h2>Contact</h2>
          <div class="contact-item">${resume.personalInfo.email}</div>
          <div class="contact-item">${resume.personalInfo.phone}</div>
          <div class="contact-item">${resume.personalInfo.address ?? ''}</div>
          <div class="contact-item">${resume.personalInfo.linkedinUrl ?? ''}</div>
          <div class="contact-item">${resume.personalInfo.websiteUrl ?? ''}</div>
        </div>
        
        <div class="skills">
          <h2>Skills</h2>
          $skills
        </div>
      </div>
      
      <div class="main">
        <h1>${resume.personalInfo.fullName}</h1>
        <h3>${resume.personalInfo.targetJobTitle}</h3>
        
        <div class="summary">
          ${resume.professionalSummary ?? ''}
        </div>
        
        <h2>Experience</h2>
        $experiences
        
        <h2>Education</h2>
        $education
      </div>
    </body>
    </html>
    ''';
  }
}
