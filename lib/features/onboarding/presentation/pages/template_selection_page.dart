import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../resume/presentation/pages/resume_edit_page.dart';
import '../../../resume/presentation/pages/preview_page.dart';
import '../../../resume/presentation/pages/home_page.dart';
import '../../../resume/presentation/providers/resume_provider.dart';
import 'cv_choice_page.dart';
import '../../../resume/data/models/template_data.dart';

class TemplateSelectionPage extends StatefulWidget {
  final bool isFromImport;
  const TemplateSelectionPage({super.key, this.isFromImport = false});

  @override
  State<TemplateSelectionPage> createState() => _TemplateSelectionPageState();
}

class _TemplateSelectionPageState extends State<TemplateSelectionPage> with SingleTickerProviderStateMixin {
  String? _selectedTemplate;
  int _current = 0;
  String _selectedCategory = 'form.categories.all'.tr();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final CarouselSliderController _carouselController = CarouselSliderController();

  // Use shared data
  List<String> get _categories => TemplateData.categories;
  List<Map<String, dynamic>> get _templates => TemplateData.templates;

  @override
  void initState() {
    super.initState();
    _selectedTemplate = context.read<ResumeProvider>().currentResume?.templateId;
    
    // Find index of selected template for carousel
    if (_selectedTemplate != null) {
      final index = _templates.indexWhere((t) => t['id'] == _selectedTemplate);
      if (index != -1) _current = index;
    }

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
      // Save the resume, then go to HomePage as root, then push Edit and Preview
      provider.saveResume();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResumeEditPage()),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const PreviewPage()),
      );
    } else {
      // For new CV flow, also ensure HomePage is at the base
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomePage()),
        (route) => false,
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const ResumeEditPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final displayTemplates = _selectedCategory == 'form.categories.all'.tr() 
        ? _templates 
        : _templates.where((t) => 'form.categories.${t['category'].toString().toLowerCase()}'.tr() == _selectedCategory).toList();
    final c = AppColorsDynamic.of(context);
    final isRoot = !Navigator.canPop(context);
    final canGoBack = !widget.isFromImport && !isRoot;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => HomePage()),
          (route) => false,
        );
      },
      child: Scaffold(
        body: Container(
        decoration: BoxDecoration(gradient: c.backgroundGradient),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!widget.isFromImport)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                    child: IconButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (_) => HomePage()),
                            (route) => false,
                          );
                        }
                      },
                      icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
                      style: IconButton.styleFrom(
                        backgroundColor: c.cardBackgroundSolid,
                        padding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                if (!widget.isFromImport) const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Category Filter
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(category),
                          selected: isSelected,
                          onSelected: (bool selected) {
                            setState(() {
                              _selectedCategory = category;
                              _current = 0; // Reset carousel index
                            });
                          },
                          backgroundColor: c.cardBackgroundSolid,
                          selectedColor: c.primaryStart.withValues(alpha: 0.2),
                          labelStyle: TextStyle(
                            color: isSelected ? c.primaryStart : c.textSecondary,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                              color: isSelected ? c.primaryStart : c.cardBorder,
                            ),
                          ),
                          showCheckmark: false,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                Expanded(
                  child: displayTemplates.isEmpty 
                  ? Center(child: Text("templates.no_found".tr(), style: TextStyle(color: c.textSecondary)))
                  : CarouselSlider.builder(
                    carouselController: _carouselController,
                    itemCount: displayTemplates.length,
                    itemBuilder: (context, index, realIndex) {
                      final template = displayTemplates[index];
                      final isSelected = template['id'] == _selectedTemplate;
                      return _buildTemplateCard(template, isSelected, c);
                    },
                    options: CarouselOptions(
                      height: double.infinity,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                      initialPage: _current,
                      viewportFraction: 0.75,
                      onPageChanged: (index, reason) {
                        setState(() {
                          _current = index;
                          _selectedTemplate = displayTemplates[index]['id'];
                        });
                      },
                    ),
                  ),
                ),

                // Dots Indicator
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: displayTemplates.asMap().entries.map((entry) {
                    return Container(
                      width: 7.0,
                      height: 7.0,
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.textPrimary.withValues(alpha: _current == entry.key ? 0.9 : 0.2),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: _buildContinueButton(c, displayTemplates),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _buildTemplateCard(Map<String, dynamic> template, bool isSelected, AppColorsDynamic c) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedTemplate = template['id']);
        _onContinue();
      },
      child: Container(
        decoration: BoxDecoration(
          color: c.cardBackgroundSolid,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(
            color: isSelected ? c.primaryStart : c.cardBorder,
            width: isSelected ? 2.5 : 1,
          ),
        ),
        child: Column(
          children: [
            // Image / Preview Area
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: (template['color'] as Color).withValues(alpha: 0.05),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                ),
                child: Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                    child: Image.asset(
                      template['image'] as String,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                ),
              ),
            ),
            
            // Info Area
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isSelected ? (template['color'] as Color).withValues(alpha: 0.05) : null,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(22)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    template['name'].toString().tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? template['color'] : c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    template['description'].toString().tr(),
                    style: TextStyle(
                      fontSize: 12,
                      color: c.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContinueButton(AppColorsDynamic c, List<Map<String, dynamic>> displayTemplates) {
    final isEnabled = _selectedTemplate != null;
    final selectedIdx = displayTemplates.indexWhere((t) => t['id'] == _selectedTemplate);
    final templateColor = selectedIdx != -1 ? displayTemplates[selectedIdx]['color'] as Color : c.primaryStart;

    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        color: isEnabled ? templateColor : c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        boxShadow: isEnabled ? [
          BoxShadow(color: templateColor.withValues(alpha: 0.4), blurRadius: 20, offset: const Offset(0, 8)),
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
