import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'language_selection_page.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
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
    super.dispose();
  }

  void _onContinue() {
    // Navigate to Language Selection Page
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LanguageSelectionPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Column(
                children: [
                  // CV Templates Display Area
                  Expanded(
                    flex: 5,
                    child: _buildCVTemplatesShowcase(),
                  ),
                  
                  // Welcome Text & Info
                  Expanded(
                    flex: 4,
                    child: _buildWelcomeContent(),
                  ),
                  
                  // Continue Button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                    child: _buildContinueButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCVTemplatesShowcase() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Phone frame with templates
          Container(
            width: 280,
            height: 380,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withOpacity(0.3),
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
                child: _buildTemplateGrid(),
              ),
            ),
          ),
          
          // Floating CV cards
          Positioned(
            left: 10,
            top: 60,
            child: _buildFloatingCVCard(
              'John Doe',
              'Software Engineer',
              AppColors.primaryStart,
              -10,
            ),
          ),
          Positioned(
            right: 5,
            top: 20,
            child: _buildFloatingCVCard(
              'Emily Kim',
              'Product Manager',
              AppColors.accentGreen,
              10,
            ),
          ),
          Positioned(
            right: 20,
            bottom: 30,
            child: _buildFloatingCVCard(
              'David White',
              'UX Designer',
              AppColors.accent,
              5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateGrid() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status bar simulation
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('9:41', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87)),
                Row(
                  children: [
                    Icon(Icons.signal_cellular_4_bar, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Icon(Icons.wifi, size: 14, color: Colors.black87),
                    const SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 14, color: Colors.black87),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // Templates text
          Center(
            child: Text(
              'Templates',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // Template previews grid
          Expanded(
            child: GridView.count(
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.7,
              children: [
                _buildMiniTemplate(AppColors.primaryStart, 'Modern'),
                _buildMiniTemplate(AppColors.accentGreen, 'Classic'),
                _buildMiniTemplate(AppColors.accent, 'Creative'),
                _buildMiniTemplate(AppColors.accentOrange, 'Professional'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTemplate(Color accentColor, String name) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar
          Row(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: accentColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(width: 40, height: 4, color: Colors.grey.shade400),
                    const SizedBox(height: 2),
                    Container(width: 30, height: 3, color: Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Content lines
          ...List.generate(5, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 3),
            child: Container(
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          )),
          const Spacer(),
          Center(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCVCard(String name, String title, Color color, double rotation) {
    return Transform.rotate(
      angle: rotation * 3.14159 / 180,
      child: Container(
        width: 100,
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.person, size: 14, color: color),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 7,
                color: Colors.grey.shade600,
              ),
            ),
            const Spacer(),
            // Fake content lines
            ...List.generate(3, (i) => Container(
              margin: const EdgeInsets.only(bottom: 3),
              height: 3,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Welcome Title
          ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Text(
              'welcome.title'.tr(),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'welcome.subtitle'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          
          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStatItem('1M+', 'welcome.users'.tr()),
              const SizedBox(width: 40),
              _buildStatItem('4.8', 'welcome.rating'.tr()),
            ],
          ),
          const SizedBox(height: 24),
          
          // Description
          Text(
            'welcome.description'.tr(),
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textTertiary,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.emoji_events, color: AppColors.accentOrange, size: 20),
            const SizedBox(width: 6),
            ShaderMask(
              shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 6),
            Icon(Icons.emoji_events, color: AppColors.accentOrange, size: 20),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
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
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
