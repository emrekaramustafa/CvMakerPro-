import 'dart:convert';
import 'dart:io';
import '../models/resume_model.dart';
import 'package:intl/intl.dart';
import 'template_utils.dart';

class StudentTemplate {
  static String generate(ResumeModel resume) {
    // ── Profile image ──
    String profileImageHtml = '';
    bool hasImage = false;
    final imgUri = getBase64ImageUri(resume.personalInfo.profileImagePath);
    if (imgUri != null) {
      hasImage = true;
      profileImageHtml = '<img src="$imgUri" class="profile-pic" />';
    }
    if (profileImageHtml.isEmpty) {
      final initials = resume.personalInfo.fullName
          .split(' ')
          .where((w) => w.isNotEmpty)
          .map((w) => w[0].toUpperCase())
          .take(2)
          .join();
      profileImageHtml = '<div class="profile-pic profile-pic-initials">$initials</div>';
    }

    final String fullName = resume.personalInfo.fullName;
    final String jobTitle = resume.personalInfo.targetJobTitle;
    final String email = resume.personalInfo.email;
    final String phone = resume.personalInfo.phone;
    final String location = resume.personalInfo.address ?? '';
    final String linkedin = resume.personalInfo.linkedinUrl ?? '';

    // ── Contact line ──
    List<String> contactParts = [];
    if (location.isNotEmpty) contactParts.add(location);
    contactParts.add(email);
    contactParts.add(phone);
    if (linkedin.isNotEmpty) contactParts.add(linkedin);
    String contactInfoStr = contactParts.join('  ·  ');

    // ── About ──
    final String aboutSection = (resume.professionalSummary != null && resume.professionalSummary!.isNotEmpty) ? '''
      <div class="card">
        <h2 class="section-title">About</h2>
        <div class="card-body">
          <p class="about-text">${resume.professionalSummary!.replaceAll('\\n', '<br>')}</p>
        </div>
      </div>
    ''' : '';

    // ── Experience ──
    final experienceItems = resume.experience.map((e) {
      final dates = '${DateFormat.yMMM().format(e.startDate)} – ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.yMMM().format(e.endDate!) : "Present")}';
      final iconLetter = e.companyName.isNotEmpty ? e.companyName[0].toUpperCase() : '?';
      final descHtml = e.description.isNotEmpty ? '<div class="entry-desc">${e.description.replaceAll('\\n', '<br>')}</div>' : '';
      final bulletHtml = e.bulletPoints.isNotEmpty ? '<ul class="bullet-list">${e.bulletPoints.map((b) => '<li>$b</li>').join('')}</ul>' : '';
      return '''
        <div class="entry">
          <div class="entry-icon">
            <div class="icon-box"><span class="icon-letter">$iconLetter</span></div>
          </div>
          <div class="entry-content">
            <div class="entry-title">${e.jobTitle}</div>
            <div class="entry-subtitle">${e.companyName}</div>
            <div class="entry-meta">$dates</div>
            $descHtml
            $bulletHtml
          </div>
        </div>
      ''';
    }).join('');

    final String experienceSection = resume.experience.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Experience</h2>
        <div class="card-body">$experienceItems</div>
      </div>
    ''' : '';

    // ── Education ──
    final educationItems = resume.education.map((e) {
      final dates = '${DateFormat.y().format(e.startDate)} – ${e.isCurrent ? "Present" : (e.endDate != null ? DateFormat.y().format(e.endDate!) : "Present")}';
      final iconLetter = e.institutionName.isNotEmpty ? e.institutionName[0].toUpperCase() : '?';
      return '''
        <div class="entry">
          <div class="entry-icon">
            <div class="icon-box edu"><span class="icon-letter">$iconLetter</span></div>
          </div>
          <div class="entry-content">
            <div class="entry-title">${e.institutionName}</div>
            <div class="entry-subtitle">${e.degree}, ${e.fieldOfStudy}</div>
            <div class="entry-meta">$dates</div>
          </div>
        </div>
      ''';
    }).join('');

    final String educationSection = resume.education.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Education</h2>
        <div class="card-body">$educationItems</div>
      </div>
    ''' : '';

    // ── Skills ──
    final skillItems = resume.skills.map((s) => '<span class="skill-pill">$s</span>').join('');
    final String skillsSection = resume.skills.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Skills</h2>
        <div class="card-body"><div class="skills-wrap">$skillItems</div></div>
      </div>
    ''' : '';

    // ── Languages ──
    final langItems = resume.languages.map((l) => '<div class="skill-row"><span class="skill-name">${l.languageName}</span><span class="skill-level">${l.level}</span></div>').join('');
    final String languagesSection = resume.languages.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Languages</h2>
        <div class="card-body">$langItems</div>
      </div>
    ''' : '';

    // ── Certifications ──
    final certItems = resume.certificates.map((c) {
      final iconLetter = c.issuer.isNotEmpty ? c.issuer[0].toUpperCase() : '?';
      return '''
        <div class="entry">
          <div class="entry-icon">
            <div class="icon-box cert"><span class="icon-letter">$iconLetter</span></div>
          </div>
          <div class="entry-content">
            <div class="entry-title">${c.title}</div>
            <div class="entry-subtitle">${c.issuer}</div>
          </div>
        </div>
      ''';
    }).join('');
    final String certsSection = resume.certificates.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Licenses & Certifications</h2>
        <div class="card-body">$certItems</div>
      </div>
    ''' : '';

    // ── References ──
    final refItems = resume.references.map((r) => '''
      <div class="entry">
        <div class="entry-content">
          <div class="entry-title">${r.fullName}</div>
          <div class="entry-subtitle">${r.company}</div>
          <div class="entry-meta">${r.email ?? ''} ${r.phone ?? ''}</div>
        </div>
      </div>
    ''').join('');
    final String referencesSection = resume.references.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">References</h2>
        <div class="card-body">$refItems</div>
      </div>
    ''' : '';

    // ── Activities ──
    final actItems = resume.activities.map((a) {
      final descHtml = a.description.isNotEmpty ? '<div class="entry-desc">${a.description.replaceAll('\\n', '<br>')}</div>' : '';
      return '''
        <div class="entry">
          <div class="entry-content">
            <div class="entry-title">${a.title}</div>
            $descHtml
          </div>
        </div>
      ''';
    }).join('');
    final String activitiesSection = resume.activities.isNotEmpty ? '''
      <div class="card">
        <h2 class="section-title">Activities & Projects</h2>
        <div class="card-body">$actItems</div>
      </div>
    ''' : '';

    return '''
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    @page { margin: 0; size: A4; }
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: -apple-system, system-ui, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
      background-color: #F4F2EE;
      color: rgba(0,0,0,0.9);
      -webkit-font-smoothing: antialiased;
    }
    .page { max-width: 780px; margin: 0 auto; padding: 0; }

    /* Card */
    .card {
      background: #FFFFFF;
      border: 1px solid #D4D2CD;
      border-radius: 8px;
      margin-bottom: 8px;
      overflow: hidden;
    }

    /* Header */
    .header-card {
      position: relative;
      background: #FFFFFF;
      border: 1px solid #D4D2CD;
      border-radius: 8px;
      margin-bottom: 8px;
      overflow: hidden;
    }
    .banner {
      height: 120px;
      background-color: #0077B5;
      width: 100%;
    }
    .header-body {
      padding: 0 24px 24px 24px;
      position: relative;
    }
    .profile-pic {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      border: 4px solid #FFFFFF;
      object-fit: cover;
      display: block;
      margin-top: -60px;
      margin-bottom: 12px;
      background-color: #0077B5;
    }
    .profile-pic-initials {
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 42px;
      font-weight: 600;
      color: #FFFFFF;
      background-color: #0077B5;
    }
    .header-name {
      font-size: 24px;
      font-weight: 600;
      color: rgba(0,0,0,0.9);
      line-height: 1.2;
    }
    .header-headline {
      font-size: 16px;
      font-weight: 400;
      color: rgba(0,0,0,0.9);
      margin-top: 4px;
      line-height: 1.3;
    }
    .header-contact {
      font-size: 13px;
      color: rgba(0,0,0,0.6);
      margin-top: 8px;
      line-height: 1.5;
      word-break: break-word;
    }

    /* Section Title */
    .section-title {
      font-size: 20px;
      font-weight: 600;
      color: rgba(0,0,0,0.9);
      padding: 20px 24px 4px 24px;
    }
    .card-body {
      padding: 12px 24px 20px 24px;
    }
    .about-text {
      font-size: 14px;
      line-height: 1.6;
      color: rgba(0,0,0,0.9);
    }

    /* Entries */
    .entry {
      display: flex;
      align-items: flex-start;
      padding: 12px 0;
      border-bottom: 1px solid #F0EDE8;
    }
    .entry:last-child { border-bottom: none; }
    .entry-icon { flex-shrink: 0; margin-right: 12px; }
    .icon-box {
      width: 48px; height: 48px; border-radius: 4px;
      background: #F3F6F8; border: 1px solid #E8E5DF;
      display: flex; align-items: center; justify-content: center;
    }
    .icon-box.edu { background: #FFF4E5; border-color: #F5DEB3; }
    .icon-box.cert { background: #E8F5E9; border-color: #C8E6C9; }
    .icon-letter { font-size: 20px; font-weight: 700; color: rgba(0,0,0,0.6); }
    .entry-content { flex: 1; min-width: 0; }
    .entry-title { font-size: 16px; font-weight: 600; color: rgba(0,0,0,0.9); line-height: 1.3; }
    .entry-subtitle { font-size: 14px; color: rgba(0,0,0,0.9); margin-top: 2px; }
    .entry-meta { font-size: 13px; color: rgba(0,0,0,0.6); margin-top: 2px; }
    .entry-desc { font-size: 14px; color: rgba(0,0,0,0.8); line-height: 1.5; margin-top: 8px; }
    .bullet-list { margin: 8px 0 0 18px; padding: 0; }
    .bullet-list li { font-size: 14px; color: rgba(0,0,0,0.8); margin-bottom: 4px; line-height: 1.4; }

    /* Skills inline pills */
    .skills-wrap { }
    .skill-pill {
      display: inline-block; font-size: 13px; font-weight: 600;
      padding: 6px 14px; background-color: #F3F6F8; border: 1px solid #E8E5DF;
      border-radius: 20px; color: rgba(0,0,0,0.9); white-space: nowrap;
      margin: 0 6px 8px 0;
    }

    /* Languages */
    .skill-row {
      display: flex; justify-content: space-between; align-items: center;
      padding: 10px 0; border-bottom: 1px solid #F0EDE8; font-size: 14px;
    }
    .skill-row:last-child { border-bottom: none; }
    .skill-name { font-weight: 600; color: rgba(0,0,0,0.9); }
    .skill-level { color: rgba(0,0,0,0.6); font-size: 13px; }
  </style>
</head>
<body>
  <div class="page">
    <div class="header-card">
      <div class="banner"></div>
      <div class="header-body">
        $profileImageHtml
        <div class="header-name">$fullName</div>
        <div class="header-headline">$jobTitle</div>
        <div class="header-contact">$contactInfoStr</div>
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
  </div>
</body>
</html>
    ''';
  }
}
