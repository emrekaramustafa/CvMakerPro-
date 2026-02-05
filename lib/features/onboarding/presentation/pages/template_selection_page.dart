import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'cv_choice_page.dart';

class TemplateSelectionPage extends StatefulWidget {
  const TemplateSelectionPage({super.key});

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage> with SingleTickerProviderStateMixin {
  String? _selectedTemplate;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> templates = [
    {
      'id': 'classic',
      'name': 'Classic',
      'nameKey': 'templates.classic',
      'description': 'templates.classic_desc',
      'primaryColor': const Color(0xFF1E3A5F),
      'secondaryColor': const Color(0xFF2C5282),
      'accentColor': const Color(0xFF4A5568),
    },
    {
      'id': 'modern',
      'name': 'Modern',
      'nameKey': 'templates.modern',
      'description': 'templates.modern_desc',
      'primaryColor': const Color(0xFF6366F1),
      'secondaryColor': const Color(0xFF8B5CF6),
      'accentColor': const Color(0xFF06B6D4),
    },
    {
      'id': 'creative',
      'name': 'Creative',
      'nameKey': 'templates.creative',
      'description': 'templates.creative_desc',
      'primaryColor': const Color(0xFFEC4899),
      'secondaryColor': const Color(0xFFF97316),
      'accentColor': const Color(0xFF10B981),
      'hasColoredBackground': true,
    },
    {
      'id': 'elegant',
      'name': 'Elegant',
      'nameKey': 'templates.elegant',
      'description': 'templates.elegant_desc',
      'primaryColor': const Color(0xFF1F2937),
      'secondaryColor': const Color(0xFFD4AF37),
      'accentColor': const Color(0xFF6B7280),
    },
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
    if (_selectedTemplate == null) return;
    
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CVChoicePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  
                  // Back Button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded, color: AppColors.textPrimary),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.cardBackgroundSolid,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                  const SizedBox(height: 20),
                  
                  // Title
                  ShaderMask(
                    shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                    child: Text(
                      'templates.title'.tr(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'templates.subtitle'.tr(),
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Templates Grid
                  Expanded(
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.65,
                      ),
                      itemCount: templates.length,
                      itemBuilder: (context, index) {
                        final template = templates[index];
                        final isSelected = template['id'] == _selectedTemplate;
                        return _buildTemplateCard(template, isSelected);
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Continue Button
                  _buildContinueButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, bool isSelected) {
    final primaryColor = template['primaryColor'] as Color;
    final secondaryColor = template['secondaryColor'] as Color;
    final hasColoredBg = template['hasColoredBackground'] == true;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTemplate = template['id'];
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppColors.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primaryStart : AppColors.cardBorder,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: AppColors.primaryStart.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ] : [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            children: [
              // CV Preview
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: _buildCVPreview(template, hasColoredBg, primaryColor, secondaryColor),
                ),
              ),
              
              // Template Name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withOpacity(0.1) : AppColors.surface,
                  border: Border(
                    top: BorderSide(color: AppColors.cardBorder.withOpacity(0.5)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (template['nameKey'] as String).tr(),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? primaryColor : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            (template['description'] as String).tr(),
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          shape: BoxShape.circle,
                        ),
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

  Widget _buildCVPreview(Map<String, dynamic> template, bool hasColoredBg, Color primaryColor, Color secondaryColor) {
    return Container(
      decoration: BoxDecoration(
        color: hasColoredBg 
            ? LinearGradient(colors: [primaryColor, secondaryColor]).colors.first.withOpacity(0.15)
            : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300, width: 0.5),
      ),
      child: Stack(
        children: [
          // Colored sidebar for creative template
          if (hasColoredBg)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              width: 35,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [primaryColor, secondaryColor],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    bottomLeft: Radius.circular(7),
                  ),
                ),
              ),
            ),
          
          // CV Content
          Padding(
            padding: EdgeInsets.only(
              left: hasColoredBg ? 40 : 10,
              right: 10,
              top: 10,
              bottom: 10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar with real face placeholder
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                        ),
                        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1),
                      ),
                      child: ClipOval(
                        child: Icon(
                          Icons.person,
                          size: 16,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 6,
                            width: 50,
                            decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            height: 4,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Section header
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                
                // Content lines
                ...List.generate(3, (i) => Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(1),
                  ),
                )),
                
                const SizedBox(height: 6),
                
                // Another section
                Container(
                  height: 5,
                  width: 35,
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 4),
                
                ...List.generate(2, (i) => Container(
                  margin: const EdgeInsets.only(bottom: 3),
                  height: 3,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(1),
                  ),
                )),
                
                const Spacer(),
                
                // Skills section
                Row(
                  children: List.generate(3, (i) => Container(
                    margin: const EdgeInsets.only(right: 3),
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    decoration: BoxDecoration(
                      color: primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(color: primaryColor.withOpacity(0.3), width: 0.5),
                    ),
                    child: Container(
                      width: 12,
                      height: 3,
                      color: primaryColor.withOpacity(0.6),
                    ),
                  )),
                ),
              ],
            ),
          ),
          
          // Elegant gold accent
          if (template['id'] == 'elegant')
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [secondaryColor, secondaryColor.withOpacity(0.3)],
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(7),
                    topRight: Radius.circular(7),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final isEnabled = _selectedTemplate != null;
    
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: isEnabled ? AppColors.primaryGradient : null,
        color: isEnabled ? null : AppColors.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(
            color: AppColors.primaryStart.withOpacity(0.4),
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
              'templates.continue'.tr(),
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isEnabled ? Colors.white : AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
