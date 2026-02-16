import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class AILoadingOverlay extends StatefulWidget {
  const AILoadingOverlay({super.key});

  @override
  State<AILoadingOverlay> createState() => _AILoadingOverlayState();
}

class _AILoadingOverlayState extends State<AILoadingOverlay> with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late AnimationController _stepController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  int _currentStep = 0;

  final List<Map<String, dynamic>> _steps = [
    {'icon': Icons.picture_as_pdf_rounded, 'key': 'cv_choice.step_extracting'},
    {'icon': Icons.psychology_rounded, 'key': 'cv_choice.step_analyzing'},
    {'icon': Icons.auto_awesome_rounded, 'key': 'cv_choice.step_structuring'},
    {'icon': Icons.check_circle_rounded, 'key': 'cv_choice.step_finalizing'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.1).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.repeat(reverse: true);

    _rotateController = AnimationController(vsync: this, duration: const Duration(milliseconds: 3000));
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));
    _rotateController.repeat();

    _stepController = AnimationController(vsync: this, duration: const Duration(seconds: 12));
    _stepController.addListener(() {
      final newStep = (_stepController.value * _steps.length).floor().clamp(0, _steps.length - 1);
      if (newStep != _currentStep) setState(() => _currentStep = newStep);
    });
    _stepController.forward();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    _stepController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity, height: double.infinity,
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              _buildAnimatedIcon(c),
              const SizedBox(height: 48),
              ShaderMask(
                shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
                child: Text(
                  'cv_choice.ai_working'.tr(),
                  style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -0.5),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'cv_choice.ai_working_desc'.tr(),
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: c.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 48),
              _buildStepIndicators(c),
              const Spacer(flex: 3),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: Text(
                  'cv_choice.ai_patience'.tr(),
                  style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(AppColorsDynamic c) {
    return SizedBox(
      width: 160, height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotateAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotateAnimation.value,
                child: Container(
                  width: 150, height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: SweepGradient(
                      colors: [
                        c.primaryStart.withOpacity(0.0),
                        c.primaryStart.withOpacity(0.6),
                        c.primaryEnd.withOpacity(0.8),
                        c.primaryStart.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.3, 0.7, 1.0],
                    ),
                  ),
                ),
              );
            },
          ),
          Container(
            width: 130, height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.isDark ? const Color(0xFF1A1F35) : Colors.white,
              boxShadow: [
                BoxShadow(color: c.primaryStart.withOpacity(0.2), blurRadius: 30, spreadRadius: 5),
              ],
            ),
          ),
          ScaleTransition(
            scale: _pulseAnimation,
            child: ShaderMask(
              shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
              child: const Icon(Icons.auto_awesome, size: 52, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicators(AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        children: List.generate(_steps.length, (index) {
          final step = _steps[index];
          final isActive = index == _currentStep;
          final isDone = index < _currentStep;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
            margin: const EdgeInsets.symmetric(vertical: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: isActive
                  ? c.primaryStart.withOpacity(0.15)
                  : isDone ? c.surface.withOpacity(0.5) : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isActive
                    ? c.primaryStart.withOpacity(0.4)
                    : isDone ? c.primaryStart.withOpacity(0.2) : c.cardBorder.withOpacity(0.5),
                width: isActive ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: isActive || isDone ? c.primaryGradient : null,
                    color: isActive || isDone ? null : c.cardBackgroundSolid,
                  ),
                  child: Icon(
                    isDone ? Icons.check_rounded : step['icon'] as IconData,
                    size: 16,
                    color: isActive || isDone ? Colors.white : c.textMuted,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    (step['key'] as String).tr(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive ? c.textPrimary : isDone ? c.textSecondary : c.textTertiary,
                    ),
                  ),
                ),
                if (isActive)
                  SizedBox(
                    width: 18, height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(c.primaryStart.withOpacity(0.7)),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
