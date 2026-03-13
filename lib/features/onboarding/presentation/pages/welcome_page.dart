import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'cv_choice_page.dart';
import '../../../resume/data/models/template_data.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeOut));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onContinue() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const CVChoicePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: c.backgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Stack(
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 80),
                      Expanded(
                        flex: 5,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: ScaleTransition(
                                scale: Tween<double>(begin: 0.95, end: 1.0).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _buildShowcaseForPage(c, _currentPage),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: _buildSliderContent(c),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: _buildPageIndicator(c),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                        child: _buildContinueButton(c),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 20,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => const CVChoicePage()),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: c.textSecondary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      child: Text(
                        'welcome.skip'.tr(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSliderContent(AppColorsDynamic c) {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          _currentPage = index;
        });
      },
      children: [
        _buildSlide(
          c,
          'welcome.slider.title_1'.tr(),
          'welcome.slider.desc_1'.tr(),
          Icons.palette_rounded,
        ),
        _buildSlide(
          c,
          'welcome.slider.title_2'.tr(),
          'welcome.slider.desc_2'.tr(),
          Icons.auto_awesome_rounded,
        ),
        _buildSlide(
          c,
          'welcome.slider.title_3'.tr(),
          'welcome.slider.desc_3'.tr(),
          Icons.tips_and_updates_rounded,
        ),
      ],
    );
  }

  Widget _buildSlide(AppColorsDynamic c, String title, String description, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: c.primaryStart.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: c.primaryStart, size: 32),
          ),
          const SizedBox(height: 16),
          ShaderMask(
            shaderCallback: (bounds) => c.primaryGradient.createShader(bounds),
            child: Text(
              title,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: -1),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(fontSize: 16, color: c.textSecondary, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicator(AppColorsDynamic c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        final isSelected = _currentPage == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isSelected ? 24 : 8,
          decoration: BoxDecoration(
            gradient: isSelected ? c.primaryGradient : null,
            color: isSelected ? null : c.textMuted.withOpacity(0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
// ... templates showcase functions remain same ...

  Widget _buildShowcaseForPage(AppColorsDynamic c, int page) {
    if (page == 1) {
      return _buildAIAtsShowcase(c);
    } else if (page == 2) {
      return _buildAITipsShowcase(c);
    }
    // Default showcase for other pages
    return _buildCVTemplatesShowcase(c);
  }

  Widget _buildCVTemplatesShowcase(AppColorsDynamic c) {
    return Padding(
      key: const ValueKey('cv_templates'),
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              color: c.isDark ? Colors.black : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withOpacity(c.isDark ? 0.3 : 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: _buildTemplateGrid(c),
              ),
            ),
          ),
          Positioned(
            left: 10, top: 60,
            child: _buildFloatingCVCard('assets/images/templates/elegant.png', c.primaryStart, -10),
          ),
          Positioned(
            right: 5, top: 20,
            child: _buildFloatingCVCard('assets/images/templates/classic.png', c.accentGreen, 10),
          ),
          Positioned(
            right: 20, bottom: 30,
            child: _buildFloatingCVCard('assets/images/templates/student.png', c.accent, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                Row(
                  children: const [
                    Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 14, color: Colors.black87),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 14, color: Colors.black87),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Templates',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
              children: [
                _buildMiniTemplate(c.primaryStart, 'Modern', 'assets/images/templates/modern.png'),
                _buildMiniTemplate(c.accentGreen, 'Classic', 'assets/images/templates/classic.png'),
                _buildMiniTemplate(c.accent, 'Creative', 'assets/images/templates/creative.png'),
                _buildMiniTemplate(c.accentOrange, 'Student', 'assets/images/templates/student.png'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTemplate(Color accentColor, String name, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(11)),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
            child: Text(
              name,
              style: TextStyle(fontSize: 8, fontWeight: FontWeight.w800, color: accentColor),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCVCard(String imagePath, Color shadowColor, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        width: 100, height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: shadowColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildAIAtsShowcase(AppColorsDynamic c) {
    return Padding(
      key: const ValueKey('ai_ats_showcase'),
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              color: c.isDark ? Colors.black : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withOpacity(c.isDark ? 0.3 : 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: _buildAIAtsContent(c),
              ),
            ),
          ),
          Positioned(
            left: 5, top: 40,
            child: _buildFloatingAIBadge(c, 'AI Optimized', Icons.auto_awesome, -8),
          ),
          Positioned(
            right: 0, top: 120,
            child: _buildFloatingATSScore(c, 98, 12),
          ),
          Positioned(
            left: 20, bottom: 40,
            child: _buildFloatingKeywordBadge(c, 'Keywords Match', Icons.check_circle, 5),
          ),
        ],
      ),
    );
  }

  Widget _buildAIAtsContent(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
              Row(
                children: const [
                  Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.wifi, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full, size: 14, color: Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/templates/woman_classic.png'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 80,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 2,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(color: c.primaryStart.withOpacity(0.5), blurRadius: 10, spreadRadius: 2),
                      ],
                      color: c.primaryStart,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 80,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          c.primaryStart.withOpacity(0.0),
                          c.primaryStart.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingAIBadge(AppColorsDynamic c, String text, IconData icon, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: c.primaryStart.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: c.primaryStart),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: c.primaryStart)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingATSScore(AppColorsDynamic c, int score, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: c.accentGreen.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 50, height: 50,
                  child: CircularProgressIndicator(
                    value: score / 100,
                    backgroundColor: Colors.grey.shade100,
                    color: c.accentGreen,
                    strokeWidth: 6,
                  ),
                ),
                Text('$score', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: c.accentGreen)),
              ],
            ),
            const SizedBox(height: 8),
            const Text('ATS Score', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingKeywordBadge(AppColorsDynamic c, String text, IconData icon, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: c.accentGreen),
            const SizedBox(width: 6),
            Text(text, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildAITipsShowcase(AppColorsDynamic c) {
    return Padding(
      key: const ValueKey('ai_tips_showcase'),
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              color: c.isDark ? Colors.black : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withOpacity(c.isDark ? 0.3 : 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: _buildAITipsContent(c),
              ),
            ),
          ),
          Positioned(
            left: -10, top: 40,
            child: _buildFloatingActionBadge(c, 'AI Cover Letter', Icons.auto_awesome, c.primaryStart, -12),
          ),
          Positioned(
            right: 0, top: 160,
            child: _buildFloatingActionBadge(c, 'PDF Export', Icons.picture_as_pdf, c.accentOrange, 8),
          ),
          Positioned(
            left: 20, bottom: 60,
            child: _buildFloatingActionBadge(c, 'Smart Skills', Icons.bolt, c.accentGreen, -5),
          ),
        ],
      ),
    );
  }

  Widget _buildAITipsContent(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
              Row(
                children: const [
                  Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.wifi, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full, size: 14, color: Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Fake PDF Document Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.auto_awesome, color: c.primaryStart, size: 16),
                    const SizedBox(width: 8),
                    Text('AI Enhanced Document', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: c.primaryStart)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(width: 100, height: 8, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(width: 140, height: 6, color: Colors.grey.shade200),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Fake Skills Section
          Text('Suggested Skills', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildSkillPill(c, 'Leadership'),
              _buildSkillPill(c, 'Project Management'),
              _buildSkillPill(c, 'Agile'),
              _buildSkillPill(c, 'Communication'),
            ],
          ),
          const Spacer(),
          // Bottom Action Bar Mockup
          Container(
            height: 48,
            decoration: BoxDecoration(
              gradient: c.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.edit_document, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text('Generate with AI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillPill(AppColorsDynamic c, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.primaryStart.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.primaryStart.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.add, size: 12, color: c.primaryStart),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: c.primaryStart)),
        ],
      ),
    );
  }

  Widget _buildFloatingActionBadge(AppColorsDynamic c, String text, IconData icon, Color badgeColor, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
          ],
          border: Border.all(color: badgeColor.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: badgeColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 14, color: badgeColor),
            ),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildSpeedShowcase(AppColorsDynamic c) {
    return Padding(
      key: const ValueKey('speed_showcase'),
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              color: c.isDark ? Colors.black : const Color(0xFF1A1D26),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: c.primaryStart.withOpacity(c.isDark ? 0.3 : 0.2),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32),
                child: _buildSpeedContent(c),
              ),
            ),
          ),
          Positioned(
            left: -10, top: 60,
            child: _buildFloatingSpeedBadge(c, '5 Min', Icons.timer, c.primaryStart, -10),
          ),
          Positioned(
            right: -10, bottom: 80,
            child: _buildFloatingSpeedBadge(c, '3 Steps', Icons.check_circle_outline, c.accentGreen, 10),
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedContent(AppColorsDynamic c) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
              Row(
                children: const [
                  Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.wifi, size: 14, color: Colors.black87),
                  SizedBox(width: 4),
                  Icon(Icons.battery_full, size: 14, color: Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 30),
          // New CV Section
          _buildSpeedActionCard(
            c,
            title: 'New CV',
            subtitle: '5 Minutes',
            icon: Icons.add_circle,
            color: c.primaryStart,
            progress: 0.2, // Visual progress bar
          ),
          const SizedBox(height: 20),
          // Divider
          Row(
            children: [
              Expanded(child: Divider(color: Colors.grey.shade300)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text('OR', style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.bold)),
              ),
              Expanded(child: Divider(color: Colors.grey.shade300)),
            ],
          ),
          const SizedBox(height: 20),
          // Saved CV Section
          _buildSpeedActionCard(
            c,
            title: 'Saved CV',
            subtitle: '3 Steps',
            icon: Icons.file_copy,
            color: c.accentOrange,
            steps: ['Select', 'Edit', 'Export'],
          ),
        ],
      ),
    );
  }

  Widget _buildSpeedActionCard(AppColorsDynamic c, {required String title, required String subtitle, required IconData icon, required Color color, double? progress, List<String>? steps}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
                    Text(subtitle, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey.shade400),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: color.withOpacity(0.1),
                color: color,
                minHeight: 6,
              ),
            ),
          ],
          if (steps != null) ...[
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: steps.map((step) => Row(
                children: [
                  Icon(Icons.check_circle, size: 12, color: color),
                  const SizedBox(width: 4),
                  Text(step, style: TextStyle(fontSize: 10, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                ],
              )).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFloatingSpeedBadge(AppColorsDynamic c, String text, IconData icon, Color badgeColor, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: badgeColor.withOpacity(0.2), blurRadius: 15, offset: const Offset(0, 8)),
          ],
          border: Border.all(color: badgeColor.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: badgeColor),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppColorsDynamic c) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: c.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: c.primaryStart.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _onContinue,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              'welcome.continue'.tr(),
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 0.5),
            ),
          ),
        ),
      ),
    );
  }
}
