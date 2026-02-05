import 'dart:io';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../providers/resume_provider.dart';
import '../../../data/models/personal_info_model.dart';

class PersonalInfoForm extends StatefulWidget {
  const PersonalInfoForm({super.key});

  @override
  State<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends State<PersonalInfoForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _jobTitleController;
  late TextEditingController _addressController;
  late TextEditingController _linkedinController;
  
  DateTime? _birthDate;
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();
  
  @override
  void initState() {
    super.initState();
    final resume = context.read<ResumeProvider>().currentResume;
    final info = resume?.personalInfo;
    
    _nameController = TextEditingController(text: info?.fullName);
    _emailController = TextEditingController(text: info?.email);
    _phoneController = TextEditingController(text: info?.phone);
    _jobTitleController = TextEditingController(text: info?.targetJobTitle);
    _addressController = TextEditingController(text: info?.address);
    _linkedinController = TextEditingController(text: info?.linkedinUrl);
    _birthDate = info?.birthDate;
    _profileImagePath = info?.profileImagePath;
    
    // Listen to changes to update provider
    _nameController.addListener(_updateProvider);
    _emailController.addListener(_updateProvider);
    _phoneController.addListener(_updateProvider);
    _jobTitleController.addListener(_updateProvider);
    _addressController.addListener(_updateProvider);
    _linkedinController.addListener(_updateProvider);
  }
  
  void _updateProvider() {
    final provider = context.read<ResumeProvider>();
    provider.updatePersonalInfo(PersonalInfoModel(
      fullName: _nameController.text,
      birthDate: _birthDate,
      email: _emailController.text,
      phone: _phoneController.text,
      targetJobTitle: _jobTitleController.text,
      address: _addressController.text,
      linkedinUrl: _linkedinController.text,
      profileImagePath: _profileImagePath,
    ));
  }

  Future<void> _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(1995, 1, 1),
      firstDate: DateTime(1940),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryStart,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _birthDate) {
      setState(() {
        _birthDate = picked;
      });
      _updateProvider();
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 500,
        maxHeight: 500,
        imageQuality: 85,
      );
      
      if (image != null) {
        // Copy image to app directory for persistence
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String newPath = '${appDir.path}/$fileName';
        
        await File(image.path).copy(newPath);
        
        setState(() {
          _profileImagePath = newPath;
        });
        _updateProvider();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _removeImage() {
    setState(() {
      _profileImagePath = null;
    });
    _updateProvider();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Premium Profile Picture Section
            _buildProfilePictureWidget(),
            const SizedBox(height: 32),
            
            // Form Fields with Premium Styling
            _buildPremiumTextField(
              controller: _nameController,
              label: 'form.full_name'.tr(),
              icon: Icons.person_rounded,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            
            _buildPremiumTextField(
              controller: _jobTitleController,
              label: 'form.target_job_title'.tr(),
              icon: Icons.work_rounded,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            
            // Birth Date Picker
            _buildBirthDatePicker(),
            const SizedBox(height: 16),
            _buildPremiumTextField(
              controller: _emailController,
              label: 'form.email'.tr(),
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              isRequired: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'form.required'.tr();
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildPremiumTextField(
              controller: _phoneController,
              label: 'form.phone'.tr(),
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildPremiumTextField(
              controller: _addressController,
              label: 'form.address'.tr(),
              icon: Icons.location_on_rounded,
              isRequired: true,
            ),
            const SizedBox(height: 16),
            _buildPremiumTextField(
              controller: _linkedinController,
              label: 'Website/LinkedIn URL',
              icon: Icons.link_rounded,
              isRequired: true,
            ),
            const SizedBox(height: 100), // Space for FAB
          ],
        ),
      ),
    );
  }

  Widget _buildBirthDatePicker() {
    return GestureDetector(
      onTap: _pickBirthDate,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: AppColors.cardBackgroundSolid,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.cardBorder, width: 1),
          ),
          child: Row(
            children: [
              ShaderMask(
                shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
                child: const Icon(Icons.cake_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'form.birth_date'.tr(),
                      style: TextStyle(
                        color: _birthDate != null ? AppColors.primaryStart : AppColors.textTertiary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _birthDate != null 
                          ? DateFormat.yMMMd(context.locale.toString()).format(_birthDate!)
                          : 'Select date',
                      style: TextStyle(
                        color: _birthDate != null ? AppColors.textPrimary : AppColors.textMuted,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_drop_down_rounded,
                color: AppColors.textTertiary,
                size: 28,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilePictureWidget() {
    return Column(
      children: [
        // Premium Profile Picture Container
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: _profileImagePath == null 
                  ? AppColors.cardGradient 
                  : null,
              border: Border.all(
                color: AppColors.primaryStart.withOpacity(0.5),
                width: 3,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withOpacity(0.3),
                  blurRadius: 25,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipOval(
              child: _profileImagePath != null
                  ? Image.file(
                      File(_profileImagePath!),
                      fit: BoxFit.cover,
                      width: 130,
                      height: 130,
                    )
                  : BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          shape: BoxShape.circle,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ShaderMask(
                              shaderCallback: (bounds) => 
                                  AppColors.primaryGradient.createShader(bounds),
                              child: const Icon(
                                Icons.add_a_photo_rounded,
                                size: 36,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (_profileImagePath != null)
          TextButton.icon(
            onPressed: _removeImage,
            icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
            label: Text(
              'form.delete'.tr(), 
              style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          )
        else
          Text(
            'Tap to add photo',
            style: TextStyle(
              color: AppColors.textTertiary, 
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
      ],
    );
  }
  
  Widget _buildPremiumTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    bool isRequired = false,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: isRequired ? '$label *' : label,
          prefixIcon: ShaderMask(
            shaderCallback: (bounds) => AppColors.primaryGradient.createShader(bounds),
            child: Icon(icon, color: Colors.white, size: 22),
          ),
          filled: true,
          fillColor: AppColors.cardBackgroundSolid,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.cardBorder, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primaryStart, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
        keyboardType: keyboardType,
        validator: validator ?? (isRequired
            ? (value) {
                if (value == null || value.isEmpty) {
                  return 'form.required'.tr();
                }
                return null;
              }
            : null),
      ),
    );
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _jobTitleController.dispose();
    _addressController.dispose();
    _linkedinController.dispose();
    super.dispose();
  }
}
