import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';

class StudentTemplate {
  static String generate(ResumeModel resume) {
    String profileImageHtml = '';
    if (resume.personalInfo.profileImagePath != null) {
      final imageFile = File(resume.personalInfo.profileImagePath!);
      if (imageFile.existsSync()) {
        final fileUri = Uri.file(imageFile.path).toString();
        profileImageHtml = '''
          <img src="$fileUri" 
               class="profile-pic" />
        ''';
      } else {
        profileImageHtml = '<div class="profile-pic-placeholder"></div>';
      }
    } else {
      profileImageHtml = '<div class="profile-pic-placeholder"></div>';
    }

    final String fullName = resume.personalInfo.fullName;
    final String jobTitle = resume.personalInfo.targetJobTitle;
    final String email = resume.personalInfo.email;
    final String phone = resume.personalInfo.phone;
    final String location = resume.personalInfo.address ?? '';
    final String linkedin = resume.personalInfo.linkedinUrl ?? '';
    
    // Build contact info string
    List<String> contactParts = [];
    if (location.isNotEmpty) contactParts.add(location);
    contactParts.add(email);
    contactParts.add(phone);
    if (linkedin.isNotEmpty) contactParts.add(linkedin);
    
    String contactInfoStr = contactParts.join(' • ');

    final String aboutSection = (resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty) ? '''
      <div class="card">
        <h2 class="card-title">About</h2>
        <div class="card-content">
          <p>${resume.professionalSummary!.replaceAll('\\n', '<br>')}</p>
        </div>
      </div>
    ''' : '';

    final String experienceSection = resume.experience.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Experience</h2>
        <div class="card-content">
          ${resume.experience.map((e) {
            String dates = '${DateFormat.yMMM().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : "Present")}';
            return '''
              <div class="list-item">
                <div class="list-item-icon">
                  <div class="company-logo-placeholder"></div>
                </div>
                <div class="list-item-details">
                  <div class="item-title">${e.jobTitle}</div>
                  <div class="item-subtitle">${e.companyName}</div>
                  <div class="item-meta">$dates</div>
                  ${e.description.isNotEmpty ? '<div class="item-desc">${e.description.replaceAll('\\n', '<br>')}</div>' : ''}
                  ${e.bulletPoints.isNotEmpty ? '''
                    <ul class="bullet-list">
                      ${e.bulletPoints.map((b) => '<li>$b</li>').join('')}
                    </ul>
                  ''' : ''}

                </div>
              </div>
            ''';
          }).join('')}
        </div>
      </div>
    ''' : '';

    final String educationSection = resume.education.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Education</h2>
        <div class="card-content">
          ${resume.education.map((e) {
            String dates = '${DateFormat.y().format(e.startDate)} - ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.y().format(e.endDate!) : "Present")}';
            return '''
              <div class="list-item">
                <div class="list-item-icon">
                  <div class="school-logo-placeholder"></div>
                </div>
                <div class="list-item-details">
                  <div class="item-title">${e.institutionName}</div>
                  <div class="item-subtitle">${e.degree}, ${e.fieldOfStudy}</div>
                  <div class="item-meta">$dates</div>
                </div>
              </div>
            ''';
          }).join('')}
        </div>
      </div>
    ''' : '';

    final String skillsSection = resume.skills.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Skills</h2>
        <div class="card-content skills-list">
          ${resume.skills.map((s) => '<span class="skill-badge">$s</span>').join('')}
        </div>
      </div>
    ''' : '';

    final String languagesSection = resume.languages.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Languages</h2>
        <div class="card-content">
          <ul style="padding-left: 20px; margin: 0; color: #000000; font-size: 14px;">
            ${resume.languages.map((l) => '<li style="margin-bottom: 4px;"><strong>${l.languageName}</strong> <span style="color: #666666; font-size: 13px;">(${l.level})</span></li>').join('')}
          </ul>
        </div>
      </div>
    ''' : '';

    final String certsSection = resume.certificates.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Licenses & Certifications</h2>
        <div class="card-content">
          ${resume.certificates.map((c) => '''
              <div class="list-item">
                <div class="list-item-icon">
                  <div class="cert-logo-placeholder"></div>
                </div>
                <div class="list-item-details">
                  <div class="item-title">${c.title}</div>
                  <div class="item-subtitle">${c.issuer}</div>
                </div>
              </div>
            ''').join('')}
        </div>
      </div>
    ''' : '';

    final String referencesSection = resume.references.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">References</h2>
        <div class="card-content">
          ${resume.references.map((r) => '''
              <div class="list-item">
                <div class="list-item-details">
                  <div class="item-title">${r.fullName}</div>
                  <div class="item-subtitle">${r.company}</div>
                  <div class="item-meta">${r.email ?? ''} ${r.phone ?? ''}</div>
                </div>
              </div>
            ''').join('')}
        </div>
      </div>
    ''' : '';

    final String activitiesSection = resume.activities.isNotEmpty ? '''
      <div class="card">
        <h2 class="card-title">Activities & Projects</h2>
        <div class="card-content">
          ${resume.activities.map((a) => '''
              <div class="list-item">
                <div class="list-item-details">
                  <div class="item-title">${a.title}</div>
                  ${a.description.isNotEmpty ? '<div class="item-desc">${a.description.replaceAll('\\n', '<br>')}</div>' : ''}
                </div>
              </div>
            ''').join('')}
        </div>
      </div>
    ''' : '';


    final String htmlContent = '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    @page { margin: 0; size: A4; }
    * { box-sizing: border-box; }
    body {
      font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", "Fira Sans", Ubuntu, Oxygen, "Oxygen Sans", Cantarell, "Droid Sans", "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Lucida Grande", Helvetica, Arial, sans-serif;
      margin: 0;
      padding: 0;
      background-color: #F3F2EF;
      color: #000000;
    }
    .container {
      width: 100%;
      max-width: 800px;
      margin: 0 auto;
      padding: 20px;
    }
    .main-wrapper {
      background-color: #FFFFFF;
      border-radius: 12px;
      box-shadow: 0 4px 12px rgba(0,0,0,0.05);
      overflow: hidden;
      border: 1px solid #D0D7DE;
    }
    .card {
      background-color: #FFFFFF;
      border-bottom: 1px solid #D0D7DE;
      padding: 0;
      margin-bottom: 0;
    }
    .card:last-child {
      border-bottom: none;
    }
    /* Intro Card */
    .intro-section {
      position: relative;
    }
    .banner {
      height: 140px;
      background-color: #A0B4C7;
      width: 100%;
      border-top-left-radius: 12px;
      border-top-right-radius: 12px;
    }
    .profile-info-wrapper {
      padding: 0 24px 24px 24px;
      position: relative;
    }
    .profile-pic-container {
      position: relative;
      margin-top: -100px;
      margin-bottom: 12px;
      width: 152px;
      height: 152px;
    }
    .profile-pic {
      width: 152px;
      height: 152px;
      border-radius: 50%;
      border: 4px solid #FFFFFF;
      object-fit: cover;
      background-color: #E9E5DF;
    }
    .profile-pic-placeholder {
      width: 152px;
      height: 152px;
      border-radius: 50%;
      border: 4px solid #FFFFFF;
      background-color: #E9E5DF;
    }
    .name {
      font-size: 24px;
      font-weight: 600;
      color: rgba(0,0,0,0.9);
      margin-bottom: 4px;
      letter-spacing: -0.5px;
    }
    .headline {
      font-size: 16px;
      font-weight: 400;
      color: rgba(0,0,0,0.9);
      margin-bottom: 6px;
    }
    .contact-info {
      font-size: 14px;
      font-weight: 400;
      color: #666666;
      line-height: 1.4;
      margin-bottom: 8px;
    }
    /* Generic Card Sections */
    .section-title {
      font-size: 20px;
      font-weight: 600;
      color: rgba(0,0,0,0.9);
      padding: 24px 24px 12px 24px;
      margin: 0;
    }
    .card-content {
      padding: 0 24px 24px 24px;
      font-size: 14px;
      line-height: 1.5;
      color: rgba(0,0,0,0.9);
    }
    /* List Items (Experience, Education) */
    .list-item {
      display: flex;
      margin-bottom: 24px;
    }
    .list-item:last-child {
      margin-bottom: 0;
    }
    .list-item-icon {
      flex-shrink: 0;
      width: 56px;
      margin-right: 16px;
    }
    .company-logo-placeholder, .school-logo-placeholder, .cert-logo-placeholder {
      width: 56px;
      height: 56px;
      background-color: #F0F2F5;
      border-radius: 4px;
      border: 1px solid #E0E0E0;
    }
    .list-item-details {
      flex-grow: 1;
    }
    .item-title {
      font-size: 17px;
      font-weight: 600;
      color: rgba(0,0,0,0.9);
      line-height: 1.3;
    }
    .item-subtitle {
      font-size: 15px;
      font-weight: 400;
      color: rgba(0,0,0,0.9);
      margin-top: 2px;
    }
    .item-meta {
      font-size: 14px;
      color: #666666;
      margin-top: 2px;
    }
    .item-desc {
      margin-top: 10px;
      font-size: 15px;
      color: rgba(0,0,0,0.8);
    }
    .bullet-list {
      margin-top: 8px;
      padding-left: 20px;
      margin-bottom: 0;
    }
    .bullet-list li {
      margin-bottom: 5px;
      color: rgba(0,0,0,0.8);
    }
    /* Skills */
    .skills-list {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
    }
    .skill-badge {
      display: inline-block;
      padding: 8px 16px;
      border-radius: 20px;
      border: 1px solid #666666;
      color: #666666;
      font-size: 14px;
      font-weight: 600;
    }
    .footer-button {
      text-align: center;
      padding: 24px 0;
      border-top: 1px solid #D0D7DE;
    }
    .btn-outline {
      display: inline-block;
      padding: 10px 24px;
      border: 1px solid #0077B5;
      border-radius: 24px;
      color: #0077B5;
      font-weight: 600;
      text-decoration: none;
      font-size: 15px;
    }
  </style>
</head>
<body>
  <div class="container">
    <div class="main-wrapper">
      <!-- Header -->
      <div class="card intro-section">
        <div class="banner"></div>
        <div class="profile-info-wrapper">
          <div class="profile-pic-container">
            $profileImageHtml
          </div>
          <div class="name">$fullName</div>
          <div class="headline">$jobTitle</div>
          <div class="contact-info">$contactInfoStr</div>
        </div>
      </div>
      
      $aboutSection
      $experienceSection
      $educationSection
      $skillsSection
      $certsSection
      $languagesSection
      $activitiesSection
      $referencesSection

      <div class="footer-button">
        <div class="btn-outline">View Full Profile</div>
      </div>
    </div>
  </div>
</body>
</html>
    ''';
    return htmlContent;
  }
}
