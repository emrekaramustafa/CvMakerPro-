import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../providers/resume_provider.dart';
import 'package:intl/intl.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'resume_edit_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ResumeProvider>().loadResumes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = AppColorsDynamic.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: c.backgroundGradient,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildAppBar(context, c),
              Expanded(
                child: Consumer<ResumeProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(c.primaryStart),
                        ),
                      );
                    }

                    if (provider.resumes.isEmpty) {
                      return _buildEmptyState(c);
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(20),
                      itemCount: provider.resumes.length,
                      itemBuilder: (context, index) {
                        final resume = provider.resumes[index];
                        return _buildResumeCard(context, resume, provider, c);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, AppColorsDynamic c) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_rounded, color: c.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: c.cardBackgroundSolid,
              padding: const EdgeInsets.all(12),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'home.title'.tr(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: c.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
            icon: Icon(Icons.settings_outlined, color: c.textPrimary),
            style: IconButton.styleFrom(
              backgroundColor: c.cardBackgroundSolid,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(AppColorsDynamic c) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.description_outlined,
            size: 80,
            color: c.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 20),
          Text(
            'home.no_resumes'.tr(),
            style: TextStyle(color: c.textSecondary, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildResumeCard(BuildContext context, dynamic resume, ResumeProvider provider, AppColorsDynamic c) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: c.cardBackgroundSolid,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.cardBorder),
        boxShadow: c.isDark ? [] : [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            provider.loadResume(resume);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ResumeEditPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: c.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                      image: (resume.personalInfo.profileImagePath != null &&
                              resume.personalInfo.profileImagePath!.isNotEmpty)
                          ? DecorationImage(
                              image: FileImage(
                                  File(resume.personalInfo.profileImagePath!)),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: (resume.personalInfo.profileImagePath != null &&
                            resume.personalInfo.profileImagePath!.isNotEmpty)
                        ? null
                        : const Icon(Icons.person_rounded, color: Colors.white),
                  ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resume.personalInfo.fullName.isEmpty
                            ? 'Untitled CV'
                            : resume.personalInfo.fullName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: c.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${resume.templateId.toUpperCase()} template - ${DateFormat.yMMMd().format(resume.updatedAt)}',
                        style: TextStyle(fontSize: 13, color: c.textSecondary),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => _confirmDelete(context, resume.id, provider),
                  icon: Icon(Icons.delete_outline_rounded, color: c.error),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String id, ResumeProvider provider) {
    final c = AppColorsDynamic.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: c.surface,
        title: Text('form.delete'.tr()),
        content: Text('home.delete_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('form.cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              provider.deleteResume(id);
              Navigator.pop(context);
            },
            child: Text('form.delete'.tr(), style: TextStyle(color: c.error)),
          ),
        ],
      ),
    );
  }
}
