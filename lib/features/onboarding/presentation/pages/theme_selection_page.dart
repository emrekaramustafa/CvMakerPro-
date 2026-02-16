import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'template_selection_page.dart';

class ThemeSelectionPage extends StatefulWidget {
  const ThemeSelectionPage({super.key});

  @override
  State<ThemeSelectionPage> createState() => _ThemeSelectionPageState();
}

class _ThemeSelectionPageState extends State<ThemeSelectionPage> with SingleTickerProviderStateMixin {
  Color? _selectedColor;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> themes = [
    {'id': 'indigo', 'name': 'cv_theme.indigo', 'color': const Color(0xFF6366F1)},
    {'id': 'emerald', 'name': 'cv_theme.emerald', 'color': const Color(0xFF10B981)},
    {'id': 'amber', 'name': 'cv_theme.amber', 'color': const Color(0xFFF59E0B)},
    {'id': 'rose', 'name': 'cv_theme.rose', 'color': const Color(0xFFF43F5E)},
    {'id': 'cyan', 'name': 'cv_theme.cyan', 'color': const Color(0xFF06B6D4)},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_selectedColor == null) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const TemplateSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: c.cardBackgroundSolid,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ShaderMask(
                    shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
                    child: Text(
                      'cv_theme.title'.tr(),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'cv_theme.subtitle'.tr(),
                    style: TextStyle(fontSize: 16, color: c.textSecondary),
                  ),
                  const SizedBox(height: 48),
                  Expanded(
                    child: Center(
                      child: Wrap(
                        spacing: 24, runSpacing: 24, alignment: WrapAlignment.center,
                        children: themes.map((theme) {
                          final color = theme['color'] as Color;
                          final isSelected = _selectedColor == color;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: 80, height: 80,
                                  decoration: BoxDecoration(
                                    color: color,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: isSelected ? (c.isDark ? Colors.white : Colors.black87) : Colors.transparent,
                                      width: 4,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: color.withOpacity(0.4),
                                        blurRadius: isSelected ? 25 : 15,
                                        spreadRadius: isSelected ? 5 : 0,
                                      ),
                                    ],
                                  ),
                                  child: isSelected ? const Icon(Icons.check_rounded, color: Colors.white, size: 40) : null,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  (theme['name'] as String).tr(),
                                  style: TextStyle(
                                    color: isSelected ? c.textPrimary : c.textSecondary,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  _buildContinueButton(c),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppColorsDynamic c) {
    final isEnabled = _selectedColor != null;
    return Container(
      width: double.infinity,
      height: 56,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: isEnabled ? c.primaryGradient : null,
        color: isEnabled ? null : c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: c.primaryStart.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isEnabled ? _onContinue : null,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              'cv_language.continue'.tr(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
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
