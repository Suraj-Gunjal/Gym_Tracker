import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';

/// Onboarding data model.
class OnboardingData {
  String? name;
  Gender? gender;
  int? age;
  double? weight;
  double? height;
  FitnessLevel? fitnessLevel;
  FitnessGoal? primaryGoal;
  List<String> preferredWorkoutDays = [];
  int workoutDuration = 60;
  bool hasGymAccess = true;
  List<String> availableEquipment = [];
  bool enableNotifications = true;
  TimeOfDay? preferredWorkoutTime;
}

enum Gender { male, female, other }

enum FitnessLevel {
  beginner('Beginner', 'New to fitness or returning after a long break'),
  intermediate('Intermediate', '6+ months of consistent training'),
  advanced('Advanced', '2+ years of serious training');

  const FitnessLevel(this.label, this.description);
  final String label;
  final String description;
}

enum FitnessGoal {
  buildMuscle('Build Muscle', 'Gain size and strength', Icons.fitness_center),
  loseWeight(
    'Lose Weight',
    'Burn fat and get lean',
    Icons.local_fire_department,
  ),
  getStronger('Get Stronger', 'Increase max lifts', Icons.trending_up),
  stayActive('Stay Active', 'General fitness and health', Icons.directions_run),
  athletic('Athletic Performance', 'Sport-specific training', Icons.sports),
  bodyRecomp(
    'Body Recomposition',
    'Build muscle while losing fat',
    Icons.swap_vert,
  );

  const FitnessGoal(this.label, this.description, this.icon);
  final String label;
  final String description;
  final IconData icon;
}

/// Onboarding flow screen.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({super.key, required this.onComplete});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  final _data = OnboardingData();
  int _currentPage = 0;
  final int _totalPages = 7;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _completeOnboarding() {
    // Save onboarding data
    // In real app, would save to SharedPreferences or database
    widget.onComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: List.generate(
                  _totalPages,
                  (index) => Expanded(
                    child: Container(
                      height: 4,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: index <= _currentPage
                            ? AppColors.primary
                            : Colors.grey[800],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _currentPage = page),
                children: [
                  _WelcomePage(onNext: _nextPage),
                  _BasicInfoPage(data: _data, onUpdate: () => setState(() {})),
                  _FitnessLevelPage(
                    data: _data,
                    onUpdate: () => setState(() {}),
                  ),
                  _GoalsPage(data: _data, onUpdate: () => setState(() {})),
                  _SchedulePage(data: _data, onUpdate: () => setState(() {})),
                  _EquipmentPage(data: _data, onUpdate: () => setState(() {})),
                  _NotificationsPage(
                    data: _data,
                    onUpdate: () => setState(() {}),
                  ),
                ],
              ),
            ),

            // Navigation buttons
            if (_currentPage > 0)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    if (_currentPage > 0)
                      TextButton.icon(
                        onPressed: _previousPage,
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _canProceed() ? _nextPage : null,
                      icon: Icon(
                        _currentPage == _totalPages - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentPage == _totalPages - 1
                            ? 'Get Started'
                            : 'Continue',
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0:
        return true; // Welcome page
      case 1:
        return _data.name?.isNotEmpty == true && _data.gender != null;
      case 2:
        return _data.fitnessLevel != null;
      case 3:
        return _data.primaryGoal != null;
      case 4:
        return _data.preferredWorkoutDays.isNotEmpty;
      case 5:
        return true; // Equipment is optional
      case 6:
        return true; // Notifications is optional
      default:
        return true;
    }
  }
}

/// Welcome page.
class _WelcomePage extends StatelessWidget {
  final VoidCallback onNext;

  const _WelcomePage({required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.fitness_center,
              size: 60,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 32),
          const Text(
            'Welcome to\nGym Tracker',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Your personal fitness companion for tracking workouts, monitoring progress, and achieving your goals.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[400],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 48),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onNext,
              icon: const Icon(Icons.arrow_forward),
              label: const Text("Let's Get Started"),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onNext, // Skip to main app
            child: const Text('Skip Setup'),
          ),
        ],
      ),
    );
  }
}

/// Basic info page.
class _BasicInfoPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _BasicInfoPage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's get to know you",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'This helps us personalize your experience',
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),

          // Name input
          TextField(
            onChanged: (value) {
              data.name = value;
              onUpdate();
            },
            decoration: InputDecoration(
              labelText: 'Your Name',
              hintText: 'What should we call you?',
              prefixIcon: const Icon(Icons.person_outline),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Gender selection
          const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: Gender.values.map((gender) {
              final isSelected = data.gender == gender;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    data.gender = gender;
                    onUpdate();
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          gender == Gender.male
                              ? Icons.male
                              : gender == Gender.female
                              ? Icons.female
                              : Icons.transgender,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          gender.name[0].toUpperCase() +
                              gender.name.substring(1),
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey,
                            fontWeight: isSelected ? FontWeight.bold : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),

          // Age, Weight, Height
          Row(
            children: [
              Expanded(
                child: _NumberInputField(
                  label: 'Age',
                  suffix: 'years',
                  onChanged: (value) {
                    data.age = value?.toInt();
                    onUpdate();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _NumberInputField(
                  label: 'Weight',
                  suffix: 'kg',
                  decimal: true,
                  onChanged: (value) {
                    data.weight = value;
                    onUpdate();
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _NumberInputField(
                  label: 'Height',
                  suffix: 'cm',
                  onChanged: (value) {
                    data.height = value;
                    onUpdate();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberInputField extends StatelessWidget {
  final String label;
  final String suffix;
  final bool decimal;
  final Function(double?) onChanged;

  const _NumberInputField({
    required this.label,
    required this.suffix,
    this.decimal = false,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.numberWithOptions(decimal: decimal),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          decimal ? RegExp(r'[\d.]') : RegExp(r'\d'),
        ),
      ],
      onChanged: (value) => onChanged(double.tryParse(value)),
      decoration: InputDecoration(
        labelText: label,
        suffixText: suffix,
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

/// Fitness level page.
class _FitnessLevelPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _FitnessLevelPage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your fitness level?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Be honest — we'll tailor your experience accordingly",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),

          ...FitnessLevel.values.map((level) {
            final isSelected = data.fitnessLevel == level;
            return GestureDetector(
              onTap: () {
                data.fitnessLevel = level;
                onUpdate();
              },
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.15)
                      : AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : Colors.grey.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        level == FitnessLevel.beginner
                            ? Icons.emoji_people
                            : level == FitnessLevel.intermediate
                            ? Icons.directions_run
                            : Icons.sports_gymnastics,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            level.label,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? AppColors.primary : null,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            level.description,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isSelected)
                      Icon(Icons.check_circle, color: AppColors.primary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Goals page.
class _GoalsPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _GoalsPage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "What's your primary goal?",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "We'll optimize your experience for this goal",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),

          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: FitnessGoal.values.map((goal) {
              final isSelected = data.primaryGoal == goal;
              return GestureDetector(
                onTap: () {
                  data.primaryGoal = goal;
                  onUpdate();
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 2,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.grey.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          goal.icon,
                          color: isSelected ? Colors.white : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        goal.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.primary : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        goal.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Schedule page.
class _SchedulePage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _SchedulePage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'When do you workout?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Select your typical workout days",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 32),

          // Day selection
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: days.map((day) {
              final isSelected = data.preferredWorkoutDays.contains(day);
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    data.preferredWorkoutDays.remove(day);
                  } else {
                    data.preferredWorkoutDays.add(day);
                  }
                  onUpdate();
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      day[0],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${data.preferredWorkoutDays.length} days per week',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 32),

          // Workout duration
          const Text(
            'Typical workout duration',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [30, 45, 60, 90, 120].map((minutes) {
              final isSelected = data.workoutDuration == minutes;
              return GestureDetector(
                onTap: () {
                  data.workoutDuration = minutes;
                  onUpdate();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$minutes min',
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : null,
                      color: isSelected ? Colors.white : Colors.grey,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Preferred time
          const Text(
            'Preferred workout time',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children:
                [
                  _timeOption(
                    'Morning',
                    Icons.wb_sunny_outlined,
                    const TimeOfDay(hour: 7, minute: 0),
                  ),
                  _timeOption(
                    'Afternoon',
                    Icons.wb_cloudy_outlined,
                    const TimeOfDay(hour: 12, minute: 0),
                  ),
                  _timeOption(
                    'Evening',
                    Icons.nights_stay_outlined,
                    const TimeOfDay(hour: 18, minute: 0),
                  ),
                ].map((option) {
                  final isSelected =
                      data.preferredWorkoutTime?.hour == option.$3.hour;
                  return GestureDetector(
                    onTap: () {
                      data.preferredWorkoutTime = option.$3;
                      onUpdate();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            option.$2,
                            size: 18,
                            color: isSelected ? Colors.white : Colors.grey,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            option.$1,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : null,
                              color: isSelected ? Colors.white : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  (String, IconData, TimeOfDay) _timeOption(
    String label,
    IconData icon,
    TimeOfDay time,
  ) {
    return (label, icon, time);
  }
}

/// Equipment page.
class _EquipmentPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _EquipmentPage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    final equipment = [
      ('Barbell', Icons.fitness_center),
      ('Dumbbells', Icons.fitness_center),
      ('Cables', Icons.settings_ethernet),
      ('Machines', Icons.settings),
      ('Kettlebells', Icons.sports_handball),
      ('Pull-up Bar', Icons.accessibility),
      ('Bench', Icons.weekend),
      ('Squat Rack', Icons.view_column),
      ('Bodyweight Only', Icons.self_improvement),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What equipment do you have?',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "Select all that apply",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),

          // Gym access toggle
          SwitchListTile(
            value: data.hasGymAccess,
            onChanged: (value) {
              data.hasGymAccess = value;
              if (value) {
                data.availableEquipment = equipment.map((e) => e.$1).toList();
              } else {
                data.availableEquipment = ['Bodyweight Only'];
              }
              onUpdate();
            },
            title: const Text('Full Gym Access'),
            subtitle: const Text('Access to all standard gym equipment'),
            tileColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(height: 24),

          // Equipment grid
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: equipment.map((item) {
              final isSelected = data.availableEquipment.contains(item.$1);
              return GestureDetector(
                onTap: () {
                  if (isSelected) {
                    data.availableEquipment.remove(item.$1);
                  } else {
                    data.availableEquipment.add(item.$1);
                  }
                  onUpdate();
                },
                child: Container(
                  width: (MediaQuery.of(context).size.width - 60) / 3,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        item.$2,
                        color: isSelected ? AppColors.primary : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        item.$1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? AppColors.primary : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

/// Notifications page.
class _NotificationsPage extends StatelessWidget {
  final OnboardingData data;
  final VoidCallback onUpdate;

  const _NotificationsPage({required this.data, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "You're all set!",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "One last thing — stay on track with reminders",
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 48),

          // Notification illustration
          Center(
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_active,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Notification toggle
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  value: data.enableNotifications,
                  onChanged: (value) {
                    data.enableNotifications = value;
                    onUpdate();
                  },
                  title: const Text('Workout Reminders'),
                  subtitle: const Text('Get reminded on your workout days'),
                  contentPadding: EdgeInsets.zero,
                ),
                const Divider(),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.emoji_events),
                  title: const Text('Achievement Alerts'),
                  subtitle: const Text('Celebrate when you hit milestones'),
                  trailing: Switch(
                    value: data.enableNotifications,
                    onChanged: null,
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.trending_up),
                  title: const Text('Progress Updates'),
                  subtitle: const Text('Weekly progress summaries'),
                  trailing: Switch(
                    value: data.enableNotifications,
                    onChanged: null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.2),
                  AppColors.secondary.withValues(alpha: 0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Profile Summary',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _summaryRow('Name', data.name ?? 'Not set'),
                _summaryRow('Level', data.fitnessLevel?.label ?? 'Not set'),
                _summaryRow('Goal', data.primaryGoal?.label ?? 'Not set'),
                _summaryRow(
                  'Schedule',
                  '${data.preferredWorkoutDays.length} days/week',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[500])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
