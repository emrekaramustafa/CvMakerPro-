import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/presentation/pages/resume_edit_page.dart';
import '../../../resume/presentation/pages/preview_page.dart';
import '../../../resume/presentation/pages/home_page.dart';
import '../../../resume/presentation/providers/resume_provider.dart';

class TemplateSelectionPage extends StatefulWidget {
  final bool isFromImport;
  const TemplateSelectionPage({super.key, this.isFromImport = false});

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage> with SingleTickerProviderStateMixin {
  String? _selectedTemplate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> templates = [
    {
      'id': 'classic', 'name': 'Classic', 'nameKey': 'templates.classic', 'description': 'templates.classic_desc',
      'primaryColor': const Color(0xFF3B82F6), 'image': 'assets/images/templates/classic.png',
    },
    {
      'id': 'modern', 'name': 'Modern', 'nameKey': 'templates.modern', 'description': 'templates.modern_desc',
      'primaryColor': const Color(0xFF6366F1), 'image': 'assets/images/templates/modern.png',
    },
    {
      'id': 'creative', 'name': 'Creative', 'nameKey': 'templates.creative', 'description': 'templates.creative_desc',
      'primaryColor': const Color(0xFFEC4899), 'image': 'assets/images/templates/creative.png',
    },
    {
      'id': 'elegant', 'name': 'Elegant', 'nameKey': 'templates.elegant', 'description': 'templates.elegant_desc',
      'primaryColor': const Color(0xFF1F2937), 'image': 'assets/images/templates/elegant.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _selectedTemplate = context.read<ResumeProvider>().currentResume?.templateId;
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selectedTemplate == null) return;
    final provider = context.read<ResumeProvider>();
    provider.switchTemplate(_selectedTemplate!);
    
    if (widget.isFromImport) {
      // Save the resume, then go to edit page with preview on top
      provider.saveResume();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const ResumeEditPage()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PreviewPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResumeEditPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: c.cardBackgroundSolid,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ShaderMask(
                    shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
                    child: Text(
                      'templates.title'.tr(),
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'templates.subtitle'.tr(),
                    style: TextStyle(fontSize: 15, color: c.textSecondary),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.65,
                      ),
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        return _buildTemplateCard(templates[index], templates[index]['id'] == _selectedTemplate, c);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildContinueButton(c),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, bool isSelected, AppColorsDynamic c) {
    final primaryColor = template['primaryColor'] as Color;
    return GestureDetector(
      onTap: () => setState(() => _selectedTemplate = template['id']),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: c.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? c.primaryStart : c.cardBorder,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: c.primaryStart.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 8)),
          ] : c.isDark ? [] : [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: _buildCVPreview(template),
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.1) : c.surface,
                  border: Border(top: BorderSide(color: c.cardBorder.withOpacity(0.5))),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (template['nameKey'] as String).tr(),
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: isSelected ? primaryColor : c.textPrimary),
                          ),
                          Text(
                            (template['description'] as String).tr(),
                            style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                            maxLines: 1, overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(gradient: c.primaryGradient, shape: BoxShape.circle),
                        child: const Icon(Icons.check, size: 14, color: Colors.white),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCVPreview(Map<String, dynamic> template) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7),
        child: Image.asset(
          template['image'] as String,
          fit: BoxFit.cover,
          width: double.infinity, height: double.infinity,
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppColorsDynamic c) {
    final isEnabled = _selectedTemplate != null;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled ? c.primaryGradient : null,
        color: isEnabled ? null : c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(color: c.primaryStart.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _onContinue : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              'templates.continue'.tr(),
              style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.w700,
                color: isEnabled ? Colors.white : c.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
