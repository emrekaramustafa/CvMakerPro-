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
    // Construct a detailed prompt
    final works = resume.experience.map((e) => 
      "Company: ${e.companyName}, Role: ${e.jobTitle}, Desc: ${e.description}"
    ).join("\n");
    
    final edus = resume.education.map((e) => 
      "School: ${e.institutionName}, Degree: ${e.degree}"
    ).join("\n");

    return '''
    The user is applying for the position of "$jobTitle".
    Target Language: "$language".
    
    Current Data:
    Name: ${resume.personalInfo.fullName}
    Experience:
    $works
    Education:
    $edus
    Skills: ${resume.skills.join(", ")}
    
    Task:
    1. Write a professional summary in $language.
    2. Rewrite experience bullet points to be achievement-oriented (Action Verbs) in $language.
    3. Suggest missing skills for "$jobTitle" in $language.
    
    Output Format (JSON):
    {
      "summary": "...",
      "experience": [
        {
          "company": "Matches input",
          "role": "Matches input",
          "bullet_points": ["bullet 1", "bullet 2"]
        }
      ],
      "skills": ["skill1", "skill2", ...]
    }
    ''';
  }
}
