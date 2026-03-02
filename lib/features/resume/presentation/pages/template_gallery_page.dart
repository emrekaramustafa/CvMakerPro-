import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../core/theme/app_colors.dart';

import '../providers/resume_provider.dart';
import '../../data/models/template_data.dart';

class TemplateGalleryPage extends StatefulWidget {
  const TemplateGalleryPage({super.key});

  @override
  State<TemplateGalleryPage> createState() => _TemplateGalleryPageState();
}

class _TemplateGalleryPageState extends State<TemplateGalleryPage> {
  int _current = 0;
  String _selectedCategory = 'form.categories.all'.tr();
  final CarouselSliderController _controller = CarouselSliderController();

  // Use shared data
  List<String> get _categories => TemplateData.categories;
  List<Map<String, dynamic>> get _templates => TemplateData.templates;



  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);

    
    // Better filtering logic
    final displayTemplates = _selectedCategory == 'form.categories.all'.tr() 
        ? _templates 
        : _templates.where((t) {
            final cats = t['categories'] as List<String>? ?? [t['category'].toString()];
            return cats.any((cT) => 'form.categories.${cT.toLowerCase()}'.tr() == _selectedCategory);
          }).toList();



    return Scaffold(
      backgroundColor: c.background,
      appBar: AppBar(
        title: Text('templates.title'.tr(), style: TextStyle(color: c.textPrimary, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: c.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filter
          SizedBox(
            height: 50,
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
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: isSelected ? c.primaryStart : c.cardBorder,
                      ),
                    ),
                    checkmarkColor: c.primaryStart,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 20),

          // Template Carousel
          Expanded(
            child: displayTemplates.isEmpty 
            ? Center(child: Text("templates.no_found".tr(), style: TextStyle(color: c.textSecondary)))
            : CarouselSlider.builder(
              carouselController: _controller,
              itemCount: displayTemplates.length,
              itemBuilder: (context, index, realIndex) {
                final template = displayTemplates[index];
                return _buildTemplateCard(context, template, c);
              },
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height * 0.6,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
                initialPage: 0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
            ),
          ),
          
          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: displayTemplates.asMap().entries.map((entry) {
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withValues(alpha: _current == entry.key ? 0.9 : 0.4),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          
          // Action Button
          Padding(
            padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 74),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  final selectedTemplate = displayTemplates[_current];
                  context.read<ResumeProvider>().switchTemplate(selectedTemplate['id']);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('templates.changed'.tr(args: [selectedTemplate['name'].toString().tr()])),
                      backgroundColor: c.success,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: displayTemplates.isNotEmpty ? displayTemplates[_current]['color'] : c.primaryStart,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                ),
                child: Text(
                  'templates.use_this'.tr(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(BuildContext context, Map<String, dynamic> template, AppColorsDynamic c) {
    return GestureDetector(
      onTap: () {
        context.read<ResumeProvider>().switchTemplate(template['id']);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('templates.changed'.tr(args: [template['name'].toString().tr()])),
            backgroundColor: c.success,
          ),
        );
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.75,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: c.cardBorder, width: 2),
      ),
      child: Column(
        children: [
          // Image / Preview Area
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: (template['color'] as Color).withValues(alpha: 0.1),
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
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    template['name'].toString().tr(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: template['id'] == 'elegant' && Theme.of(context).brightness == Brightness.dark 
                          ? Colors.amberAccent 
                          : c.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    template['description'].toString().tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: c.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
