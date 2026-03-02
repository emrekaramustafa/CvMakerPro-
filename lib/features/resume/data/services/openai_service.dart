import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/resume_model.dart';
import '../../../../core/constants/app_constants.dart';

class OpenAIService {
  static const String _baseUrl = 'https://api.openai.com/v1/chat/completions';
  
  // TODO: Secure this key! ideally use Env variables or backend proxy
  final String apiKey;

  OpenAIService({required this.apiKey});

  Future<Map<String, dynamic>> optimizeResume({
    required ResumeModel resume,
    required String targetJobTitle,
    required String targetLanguage,
  }) async {
    final prompt = _generatePrompt(resume, targetJobTitle, targetLanguage);
    
    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert CV writer. Your goal is to optimize resumes for ATS systems and professional impact. Return ONLY JSON.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
          'response_format': { "type": "json_object" }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('Failed to optimize resume: ${response.body}');
      }
    } catch (e) {
      throw Exception('AI Service Error: $e');
    }
  }

  String _generatePrompt(ResumeModel resume, String jobTitle, String language) {
    // Construct detailed prompt with ALL data
    final works = resume.experience.map((e) => 
      "Company: ${e.companyName}\nRole: ${e.jobTitle}\nDescription: ${e.description}\nBullet Points:\n${e.bulletPoints.map((b) => '- $b').join('\n')}"
    ).join("\n\n");
    
    final edus = resume.education.map((e) => 
      "School: ${e.institutionName}, Degree: ${e.degree}, Field: ${e.fieldOfStudy}"
    ).join("\n");

    String styleGuide = "";
    switch (resume.templateId) {
      case 'creative':
        styleGuide = "Use a bold, energetic, and creative tone. Highlight unique achievements and personality.";
        break;
      case 'elegant':
        styleGuide = "Use a sophisticated, minimalist, and executive tone. Focus on high-level impact and leadership.";
        break;
      case 'modern':
        styleGuide = "Use a sleek, professional, and forward-thinking tone. Focus on modern skills and efficiency.";
        break;
      case 'classic':
      default:
        styleGuide = "Use a traditional, formal, and authoritative tone. Focus on steady career growth and reliability.";
        break;
    }

    return '''
    The user is applying for the position of "$jobTitle".
    Target Language: "$language".
    Selected CV Style: "${resume.templateId}" ($styleGuide).
    
    Current Data:
    Name: ${resume.personalInfo.fullName}
    
    Experience:
    $works
    
    Education:
    $edus
    
    Skills: ${resume.skills.join(", ")}
    
    Task:
    1. Write a professional summary in $language that matches the $styleGuide.
    2. Rewrite experience bullet points to be achievement-oriented (Action Verbs) in $language, tailored to the $styleGuide.
    3. Suggest missing skills for "$jobTitle" in $language.
    
    CRITICAL RULES:
    - You MUST return the SAME NUMBER of experience entries as the input (${resume.experience.length} entries).
    - You MUST return AT LEAST as many bullet points per experience as the original. DO NOT reduce the number of bullet points.
    - Keep the ORIGINAL ORDER of experiences.
    - Improve wording but DO NOT remove any information.
    
    Output Format (JSON):
    {
      "summary": "...",
      "experience": [
        {
          "company": "Must match input company name",
          "role": "Must match input role",
          "description": "improved description",
          "bullet_points": ["improved bullet 1", "improved bullet 2", "...all bullets, same count or more"]
        }
      ],
      "skills": ["skill1", "skill2", ...]
    }
    ''';
  }

  /// Parse raw CV text (from PDF) into structured resume data using AI
  Future<Map<String, dynamic>> parseCVFromText(String rawText) async {
    final prompt = '''
You are a precise CV/Resume data extractor. Your ONLY job is to extract information EXACTLY as written in the CV text below.

CRITICAL RULES:
1. DO NOT summarize, rephrase, shorten, or rewrite ANY text. Extract VERBATIM (word-for-word).
2. DO NOT merge, combine, or skip ANY bullet points. Every single bullet point must be extracted.
3. PRESERVE the exact original order of experiences, education, skills, and bullet points.
4. Each experience entry's bullet points belong ONLY to that specific job. DO NOT mix bullet points between different jobs.
5. If there is a "description" paragraph before bullet points, extract it as "description". The bullet points go in "bulletPoints" array.
6. If there is no separate description paragraph, set "description" to empty string and put everything in "bulletPoints".
7. For dates, use ISO 8601 format (YYYY-MM-DD). If only year: YYYY-01-01. If month/year: YYYY-MM-01. If "Present"/"Current"/"Ongoing": set endDate to null and isCurrent to true.
8. Extract the professional summary/profile section EXACTLY as written. If none exists, use empty string. DO NOT generate one.
9. For targetJobTitle: use the MOST RECENT job title from the experience section.

Return ONLY valid JSON with this EXACT structure:

{
  "personalInfo": {
    "fullName": "exact name as written",
    "email": "exact email",
    "phone": "exact phone number",
    "address": "exact address or empty string",
    "linkedinUrl": "exact linkedin URL or empty string",
    "websiteUrl": "exact website URL or empty string",
    "targetJobTitle": "most recent job title from experience"
  },
  "professionalSummary": "exact text from profile/summary/about me section, or empty string if none",
  "experience": [
    {
      "companyName": "exact company name",
      "jobTitle": "exact job title",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD or null",
      "isCurrent": true/false,
      "description": "any paragraph description before bullet points, or empty string",
      "bulletPoints": ["exact bullet point 1 word-for-word", "exact bullet point 2 word-for-word", "...every single bullet point"]
    }
  ],
  "education": [
    {
      "institutionName": "exact institution name",
      "degree": "exact degree name",
      "fieldOfStudy": "exact field of study",
      "startDate": "YYYY-MM-DD",
      "endDate": "YYYY-MM-DD or null",
      "isCurrent": true/false
    }
  ],
  "skills": ["exact skill 1", "exact skill 2", "...every single skill listed"],
  "languages": [
    {
      "languageName": "exact language name",
      "level": "native|fluent|advanced|intermediate|basic"
    }
  ],
  "certificates": [
    {
      "title": "exact cert name",
      "issuer": "exact issuer"
    }
  ],
  "references": [
    {
      "fullName": "exact name",
      "company": "exact company",
      "email": "email or null",
      "phone": "phone or null"
    }
  ],
  "activities": [
    {
      "title": "exact title",
      "description": "exact description or empty"
    }
  ]
}

REMEMBER: Extract EVERYTHING. Lose NOTHING. Change NOTHING. Keep the ORIGINAL ORDER.

CV Text:
---
$rawText
---
''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o',
          'messages': [
            {
              'role': 'system',
              'content': 'You are a precise data extraction tool. You extract structured information from CV text EXACTLY as written, without any modification, summarization, or rephrasing. You never lose any information. You preserve the original order of all items.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.1,
          'max_tokens': 4096,
          'response_format': { "type": "json_object" }
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('Failed to parse CV: ${response.body}');
      }
    } catch (e) {
      throw Exception('AI CV Parse Error: $e');
    }
  }

  /// Generate a personalized cover letter based on CV data and job details
  Future<String> generateCoverLetter({
    required ResumeModel resume,
    required String jobTitle,
    required String companyName,
    required String jobDescription,
    required String language,
  }) async {
    final works = resume.experience.map((e) =>
      "Company: ${e.companyName}, Role: ${e.jobTitle}, Description: ${e.description}, Achievements: ${e.bulletPoints.join(', ')}"
    ).join("\n");

    final edus = resume.education.map((e) =>
      "School: ${e.institutionName}, Degree: ${e.degree}, Field: ${e.fieldOfStudy}"
    ).join("\n");

    final prompt = '''
You are an expert cover letter writer. Write a professional, compelling cover letter.

CANDIDATE INFO:
Name: ${resume.personalInfo.fullName}
Email: ${resume.personalInfo.email}
Phone: ${resume.personalInfo.phone}
Current/Target Title: ${resume.personalInfo.targetJobTitle}

EXPERIENCE:
$works

EDUCATION:
$edus

SKILLS: ${resume.skills.join(", ")}

JOB DETAILS:
Position: $jobTitle
Company: $companyName
Job Description: $jobDescription

INSTRUCTIONS:
1. Write the cover letter in $language.
2. The letter should be 3-4 paragraphs.
3. Opening: Express enthusiasm for the specific role at the specific company.
4. Body: Connect the candidate's experience and skills directly to the job requirements.
5. Closing: End with a strong call to action.
6. Be specific, avoid generic phrases. Reference actual achievements from the CV.
7. Keep a professional but warm tone.
8. Do NOT include date, addresses, or "Dear Hiring Manager" header. Just the letter body.
9. Return ONLY the cover letter text, no JSON, no markdown.
''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert cover letter writer. Write compelling, personalized cover letters that connect candidate experience to job requirements.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'].toString().trim();
      } else {
        throw Exception('Failed to generate cover letter: ${response.body}');
      }
    } catch (e) {
      throw Exception('Cover Letter Generation Error: $e');
    }
  }

  /// Analyze CV strength with AI: keyword relevance, action verbs, suggestions
  Future<Map<String, dynamic>> analyzeCVStrength({
    required ResumeModel resume,
    required String language,
  }) async {
    final works = resume.experience.map((e) =>
      "Role: ${e.jobTitle} at ${e.companyName}\nDescription: ${e.description}\nBullets: ${e.bulletPoints.join('; ')}"
    ).join("\n\n");

    final prompt = '''
Analyze this CV/Resume for professional quality and ATS optimization.
Target Job Title: "${resume.personalInfo.targetJobTitle}"
Language for response: $language

CV DATA:
Name: ${resume.personalInfo.fullName}
Summary: ${resume.professionalSummary ?? "None"}

Experience:
$works

Skills: ${resume.skills.join(", ")}
Languages: ${resume.languages.map((l) => "${l.languageName} (${l.level})").join(", ")}

Analyze and return JSON:
{
  "keywordScore": 0-100 (how well keywords match the target job),
  "actionVerbScore": 0-100 (quality and variety of action verbs in experience),  
  "overallImpression": 0-100 (overall professional impact),
  "strengths": ["strength1", "strength2", "strength3"],
  "missingKeywords": ["keyword1", "keyword2", "keyword3", "keyword4", "keyword5"],
  "suggestions": [
    "Specific improvement suggestion 1",
    "Specific improvement suggestion 2",
    "Specific improvement suggestion 3"
  ]
}

Be specific and actionable. All text must be in $language.
''';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'model': 'gpt-4o-mini',
          'messages': [
            {
              'role': 'system',
              'content': 'You are an expert CV analyst and ATS optimization specialist. Return ONLY valid JSON.'
            },
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.4,
          'response_format': {"type": "json_object"}
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return jsonDecode(content);
      } else {
        throw Exception('Failed to analyze CV: ${response.body}');
      }
    } catch (e) {
      throw Exception('CV Analysis Error: $e');
    }
  }
}
