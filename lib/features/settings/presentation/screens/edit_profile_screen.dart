import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/remote_auth_provider.dart';

/// Screen for editing user profile.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  late TextEditingController _goalController;
  File? _selectedImage;
  bool _isLoading = false;

  // Fitness goals
  String _selectedGoal = 'Build Muscle';
  final _fitnessGoals = [
    'Build Muscle',
    'Lose Weight',
    'Increase Strength',
    'Improve Endurance',
    'Stay Active',
    'Body Recomposition',
  ];

  // Experience level
  String _experienceLevel = 'Intermediate';
  final _experienceLevels = ['Beginner', 'Intermediate', 'Advanced', 'Expert'];

  @override
  void initState() {
    super.initState();
    final user = ref.read(remoteAuthProvider).user;
    _nameController = TextEditingController(text: user?.displayName ?? '');
    _bioController = TextEditingController();
    _goalController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _goalController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              if (_selectedImage != null)
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text(
                    'Remove Photo',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    setState(() => _selectedImage = null);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );

    if (source != null) {
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() => _selectedImage = File(pickedFile.path));
      }
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      // Save profile logic would go here
      // For now, just update display name
      final authNotifier = ref.read(remoteAuthProvider.notifier);
      await authNotifier.updateProfile(
        displayName: _nameController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update profile: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(remoteAuthProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Save'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile picture
            Center(
              child: GestureDetector(
                onTap: _pickImage,
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withOpacity(0.2),
                      backgroundImage: _selectedImage != null
                          ? FileImage(_selectedImage!)
                          : (user?.avatarUrl != null
                                    ? NetworkImage(user!.avatarUrl!)
                                    : null)
                                as ImageProvider?,
                      child: _selectedImage == null && user?.avatarUrl == null
                          ? Icon(
                              Icons.person,
                              size: 60,
                              color: AppColors.primary,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.backgroundDark,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: _pickImage,
                child: const Text('Change Photo'),
              ),
            ),
            const SizedBox(height: 24),

            // Name field
            _buildTextField(
              controller: _nameController,
              label: 'Display Name',
              hint: 'Enter your name',
              icon: Icons.person_outline,
            ),
            const SizedBox(height: 16),

            // Bio field
            _buildTextField(
              controller: _bioController,
              label: 'Bio',
              hint: 'Tell us about yourself',
              icon: Icons.info_outline,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Fitness Goal
            _buildSectionHeader('Fitness Goal'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _fitnessGoals.map((goal) {
                final isSelected = _selectedGoal == goal;
                return ChoiceChip(
                  label: Text(goal),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedGoal = goal);
                  },
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : null,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Experience Level
            _buildSectionHeader('Experience Level'),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: _experienceLevels.map((level) {
                  return RadioListTile<String>(
                    title: Text(level),
                    subtitle: Text(_getExperienceDescription(level)),
                    value: level,
                    groupValue: _experienceLevel,
                    onChanged: (value) {
                      if (value != null)
                        setState(() => _experienceLevel = value);
                    },
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Weekly goal
            _buildTextField(
              controller: _goalController,
              label: 'Weekly Workout Goal',
              hint: 'e.g., 4 workouts per week',
              icon: Icons.flag_outlined,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        color: AppColors.primary,
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  String _getExperienceDescription(String level) {
    switch (level) {
      case 'Beginner':
        return 'New to weight training (< 1 year)';
      case 'Intermediate':
        return '1-3 years of consistent training';
      case 'Advanced':
        return '3-5 years of serious training';
      case 'Expert':
        return '5+ years, competitive athlete';
      default:
        return '';
    }
  }
}
