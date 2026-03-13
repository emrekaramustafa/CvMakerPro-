import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class TemplateData {
  static final List<Map<String, dynamic>> templates = [
    {
      'id': 'modern',
      'name': 'template_names.modern.name',
      'category': 'modern',
      'categories': ['modern', 'academic'],
      'image': 'assets/images/templates/modern.png', 
      'color': const Color(0xFF6366F1),
      'description': 'template_names.modern.desc',
    },
    {
      'id': 'classic',
      'name': 'template_names.classic.name',
      'category': 'professional',
      'categories': ['professional', 'simple'],
      'image': 'assets/images/templates/classic.png',
      'color': const Color(0xFF4B5563),
      'description': 'template_names.classic.desc',
    },
    {
      'id': 'creative',
      'name': 'template_names.creative.name',
      'category': 'creative',
      'categories': ['creative'],
      'image': 'assets/images/templates/creative.png',
      'color': const Color(0xFFEC4899),
      'description': 'template_names.creative.desc',
    },

    {
      'id': 'elegant',
      'name': 'template_names.elegant.name',
      'category': 'professional',
      'categories': ['professional', 'simple', 'academic'],
      'image': 'assets/images/templates/elegant.png',
      'color': const Color(0xFF1E293B),
      'description': 'template_names.elegant.desc',
    },

    {
      'id': 'student',
      'name': 'template_names.student.name',
      'category': 'professional',
      'categories': ['professional', 'academic'],
      'image': 'assets/images/templates/student.png',
      'color': const Color(0xFFF59E0B),
      'description': 'template_names.student.desc',
    },

    {
      'id': 'startup',
      'name': 'template_names.startup.name',
      'category': 'modern',
      'categories': ['modern'],
      'image': 'assets/images/templates/startup.png',
      'color': const Color(0xFFF43F5E),
      'description': 'template_names.startup.desc',
    },

    {
      'id': 'british_green',
      'name': 'template_names.british_green.name',
      'category': 'modern',
      'categories': ['modern', 'professional'],
      'image': 'assets/images/templates/british_green.png',
      'color': const Color(0xFF004225),
      'description': 'template_names.british_green.desc',
    },

  ];

  static List<String> get categories => [
    'form.categories.all'.tr(),
    'form.categories.modern'.tr(),
    'form.categories.professional'.tr(),
    'form.categories.creative'.tr(),
    'form.categories.simple'.tr(),
    'form.categories.academic'.tr()
  ];
}
