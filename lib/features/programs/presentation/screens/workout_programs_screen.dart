import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Workout program template.
class WorkoutProgram {
  final String id;
  final String name;
  final String description;
  final String difficulty;
  final int daysPerWeek;
  final int durationWeeks;
  final List<String> goals;
  final String split;
  final List<ProgramDay> days;
  final String? imageUrl;
  final bool isPremium;

  const WorkoutProgram({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.daysPerWeek,
    required this.durationWeeks,
    required this.goals,
    required this.split,
    required this.days,
    this.imageUrl,
    this.isPremium = false,
  });
}

class ProgramDay {
  final String name;
  final String focus;
  final List<ProgramExercise> exercises;
  final String? notes;

  const ProgramDay({
    required this.name,
    required this.focus,
    required this.exercises,
    this.notes,
  });
}

class ProgramExercise {
  final String name;
  final int sets;
  final String reps;
  final String? restSeconds;
  final String? notes;
  final bool isSuperset;

  const ProgramExercise({
    required this.name,
    required this.sets,
    required this.reps,
    this.restSeconds,
    this.notes,
    this.isSuperset = false,
  });
}

/// Pre-built workout programs.
class DefaultWorkoutPrograms {
  static final List<WorkoutProgram> programs = [
    // Push/Pull/Legs
    WorkoutProgram(
      id: 'ppl',
      name: 'Push Pull Legs',
      description:
          'Classic 6-day split targeting push muscles, pull muscles, and legs separately. Great for intermediate lifters.',
      difficulty: 'Intermediate',
      daysPerWeek: 6,
      durationWeeks: 12,
      goals: ['Build Muscle', 'Strength'],
      split: 'PPL',
      days: [
        ProgramDay(
          name: 'Push A',
          focus: 'Chest, Shoulders, Triceps',
          exercises: [
            ProgramExercise(name: 'Bench Press', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Overhead Press', sets: 3, reps: '8-10'),
            ProgramExercise(
              name: 'Incline Dumbbell Press',
              sets: 3,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Lateral Raise', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Tricep Pushdown', sets: 3, reps: '10-12'),
            ProgramExercise(
              name: 'Overhead Tricep Extension',
              sets: 3,
              reps: '10-12',
            ),
          ],
        ),
        ProgramDay(
          name: 'Pull A',
          focus: 'Back, Biceps',
          exercises: [
            ProgramExercise(name: 'Deadlift', sets: 3, reps: '5'),
            ProgramExercise(name: 'Pull-ups', sets: 4, reps: 'AMRAP'),
            ProgramExercise(name: 'Barbell Row', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Face Pulls', sets: 3, reps: '15-20'),
            ProgramExercise(name: 'Barbell Curl', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Hammer Curl', sets: 3, reps: '10-12'),
          ],
        ),
        ProgramDay(
          name: 'Legs A',
          focus: 'Quads, Hamstrings, Glutes',
          exercises: [
            ProgramExercise(name: 'Squat', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Romanian Deadlift', sets: 3, reps: '8-10'),
            ProgramExercise(name: 'Leg Press', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Leg Curl', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Leg Extension', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Calf Raise', sets: 4, reps: '12-15'),
          ],
        ),
        ProgramDay(
          name: 'Push B',
          focus: 'Chest, Shoulders, Triceps',
          exercises: [
            ProgramExercise(name: 'Overhead Press', sets: 4, reps: '6-8'),
            ProgramExercise(
              name: 'Dumbbell Bench Press',
              sets: 3,
              reps: '8-10',
            ),
            ProgramExercise(name: 'Cable Flye', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Arnold Press', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Dips', sets: 3, reps: 'AMRAP'),
            ProgramExercise(name: 'Skull Crushers', sets: 3, reps: '10-12'),
          ],
        ),
        ProgramDay(
          name: 'Pull B',
          focus: 'Back, Biceps',
          exercises: [
            ProgramExercise(name: 'Barbell Row', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Lat Pulldown', sets: 3, reps: '8-10'),
            ProgramExercise(name: 'Seated Cable Row', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Rear Delt Fly', sets: 3, reps: '12-15'),
            ProgramExercise(
              name: 'Incline Dumbbell Curl',
              sets: 3,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Preacher Curl', sets: 3, reps: '10-12'),
          ],
        ),
        ProgramDay(
          name: 'Legs B',
          focus: 'Quads, Hamstrings, Glutes',
          exercises: [
            ProgramExercise(name: 'Front Squat', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Hip Thrust', sets: 3, reps: '8-10'),
            ProgramExercise(
              name: 'Bulgarian Split Squat',
              sets: 3,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Good Morning', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Walking Lunge', sets: 3, reps: '12 each'),
            ProgramExercise(name: 'Seated Calf Raise', sets: 4, reps: '15-20'),
          ],
        ),
      ],
    ),

    // StrongLifts 5x5
    WorkoutProgram(
      id: 'sl5x5',
      name: 'StrongLifts 5x5',
      description:
          'Simple and effective strength program. 3 days per week, focused on compound lifts with progressive overload.',
      difficulty: 'Beginner',
      daysPerWeek: 3,
      durationWeeks: 12,
      goals: ['Strength', 'Foundation'],
      split: 'Full Body',
      days: [
        ProgramDay(
          name: 'Workout A',
          focus: 'Full Body',
          exercises: [
            ProgramExercise(
              name: 'Squat',
              sets: 5,
              reps: '5',
              notes: 'Add 2.5kg each workout',
            ),
            ProgramExercise(
              name: 'Bench Press',
              sets: 5,
              reps: '5',
              notes: 'Add 2.5kg each workout',
            ),
            ProgramExercise(
              name: 'Barbell Row',
              sets: 5,
              reps: '5',
              notes: 'Add 2.5kg each workout',
            ),
          ],
          notes: 'Rest 3-5 minutes between sets',
        ),
        ProgramDay(
          name: 'Workout B',
          focus: 'Full Body',
          exercises: [
            ProgramExercise(
              name: 'Squat',
              sets: 5,
              reps: '5',
              notes: 'Add 2.5kg each workout',
            ),
            ProgramExercise(
              name: 'Overhead Press',
              sets: 5,
              reps: '5',
              notes: 'Add 2.5kg each workout',
            ),
            ProgramExercise(
              name: 'Deadlift',
              sets: 1,
              reps: '5',
              notes: 'Add 5kg each workout',
            ),
          ],
          notes: 'Alternate A/B each session. Rest days between.',
        ),
      ],
    ),

    // PHUL
    WorkoutProgram(
      id: 'phul',
      name: 'PHUL',
      description:
          'Power Hypertrophy Upper Lower - 4 day split combining strength and size. 2 power days, 2 hypertrophy days.',
      difficulty: 'Intermediate',
      daysPerWeek: 4,
      durationWeeks: 12,
      goals: ['Strength', 'Build Muscle'],
      split: 'Upper/Lower',
      days: [
        ProgramDay(
          name: 'Upper Power',
          focus: 'Chest, Back, Shoulders - Heavy',
          exercises: [
            ProgramExercise(name: 'Barbell Bench Press', sets: 4, reps: '3-5'),
            ProgramExercise(
              name: 'Incline Dumbbell Press',
              sets: 4,
              reps: '6-10',
            ),
            ProgramExercise(name: 'Bent Over Row', sets: 4, reps: '3-5'),
            ProgramExercise(name: 'Lat Pulldown', sets: 4, reps: '6-10'),
            ProgramExercise(name: 'Overhead Press', sets: 3, reps: '5-8'),
            ProgramExercise(name: 'Barbell Curl', sets: 3, reps: '6-10'),
            ProgramExercise(name: 'Skullcrusher', sets: 3, reps: '6-10'),
          ],
        ),
        ProgramDay(
          name: 'Lower Power',
          focus: 'Legs - Heavy',
          exercises: [
            ProgramExercise(name: 'Squat', sets: 4, reps: '3-5'),
            ProgramExercise(name: 'Deadlift', sets: 4, reps: '3-5'),
            ProgramExercise(name: 'Leg Press', sets: 4, reps: '10-15'),
            ProgramExercise(name: 'Leg Curl', sets: 3, reps: '6-10'),
            ProgramExercise(name: 'Calf Raise', sets: 4, reps: '6-10'),
          ],
        ),
        ProgramDay(
          name: 'Upper Hypertrophy',
          focus: 'Chest, Back, Shoulders - Volume',
          exercises: [
            ProgramExercise(
              name: 'Incline Barbell Bench',
              sets: 4,
              reps: '8-12',
            ),
            ProgramExercise(name: 'Flat Dumbbell Fly', sets: 4, reps: '8-12'),
            ProgramExercise(name: 'Seated Cable Row', sets: 4, reps: '8-12'),
            ProgramExercise(
              name: 'One Arm Dumbbell Row',
              sets: 4,
              reps: '8-12',
            ),
            ProgramExercise(
              name: 'Dumbbell Lateral Raise',
              sets: 4,
              reps: '8-12',
            ),
            ProgramExercise(
              name: 'Incline Dumbbell Curl',
              sets: 4,
              reps: '8-12',
            ),
            ProgramExercise(name: 'Tricep Pushdown', sets: 4, reps: '8-12'),
          ],
        ),
        ProgramDay(
          name: 'Lower Hypertrophy',
          focus: 'Legs - Volume',
          exercises: [
            ProgramExercise(name: 'Front Squat', sets: 4, reps: '8-12'),
            ProgramExercise(name: 'Barbell Lunge', sets: 4, reps: '8-12'),
            ProgramExercise(name: 'Leg Extension', sets: 4, reps: '10-15'),
            ProgramExercise(name: 'Leg Curl', sets: 4, reps: '10-15'),
            ProgramExercise(name: 'Seated Calf Raise', sets: 4, reps: '8-12'),
            ProgramExercise(name: 'Calf Press', sets: 4, reps: '8-12'),
          ],
        ),
      ],
    ),

    // nSuns 5/3/1
    WorkoutProgram(
      id: 'nsuns531',
      name: 'nSuns 5/3/1 LP',
      description:
          'High volume linear progression based on 5/3/1. Aggressive progression for intermediate lifters.',
      difficulty: 'Advanced',
      daysPerWeek: 5,
      durationWeeks: 16,
      goals: ['Strength', 'Power'],
      split: 'nSuns',
      isPremium: true,
      days: [
        ProgramDay(
          name: 'Day 1 - Bench/OHP',
          focus: 'Chest, Shoulders',
          exercises: [
            ProgramExercise(name: 'Bench Press (T1)', sets: 9, reps: 'Varied'),
            ProgramExercise(
              name: 'Overhead Press (T2)',
              sets: 8,
              reps: 'Varied',
            ),
            ProgramExercise(name: 'Accessories', sets: 3, reps: '8-12'),
          ],
          notes: 'Follow nSuns rep scheme. Add weight when you hit all reps.',
        ),
        ProgramDay(
          name: 'Day 2 - Squat/Sumo DL',
          focus: 'Legs',
          exercises: [
            ProgramExercise(name: 'Squat (T1)', sets: 9, reps: 'Varied'),
            ProgramExercise(
              name: 'Sumo Deadlift (T2)',
              sets: 8,
              reps: 'Varied',
            ),
            ProgramExercise(name: 'Leg Accessories', sets: 3, reps: '8-12'),
          ],
        ),
        ProgramDay(
          name: 'Day 3 - OHP/Incline',
          focus: 'Shoulders, Chest',
          exercises: [
            ProgramExercise(
              name: 'Overhead Press (T1)',
              sets: 9,
              reps: 'Varied',
            ),
            ProgramExercise(
              name: 'Incline Bench (T2)',
              sets: 8,
              reps: 'Varied',
            ),
            ProgramExercise(name: 'Back Accessories', sets: 3, reps: '8-12'),
          ],
        ),
        ProgramDay(
          name: 'Day 4 - Deadlift/Front Squat',
          focus: 'Back, Legs',
          exercises: [
            ProgramExercise(name: 'Deadlift (T1)', sets: 9, reps: 'Varied'),
            ProgramExercise(name: 'Front Squat (T2)', sets: 8, reps: 'Varied'),
            ProgramExercise(name: 'Leg Accessories', sets: 3, reps: '8-12'),
          ],
        ),
        ProgramDay(
          name: 'Day 5 - Bench/CG Bench',
          focus: 'Chest, Triceps',
          exercises: [
            ProgramExercise(name: 'Bench Press (T1)', sets: 9, reps: 'Varied'),
            ProgramExercise(
              name: 'Close Grip Bench (T2)',
              sets: 8,
              reps: 'Varied',
            ),
            ProgramExercise(name: 'Arm Accessories', sets: 3, reps: '8-12'),
          ],
        ),
      ],
    ),

    // Upper/Lower
    WorkoutProgram(
      id: 'upperlower',
      name: 'Upper/Lower Split',
      description:
          'Classic 4-day split alternating upper and lower body. Great balance of frequency and recovery.',
      difficulty: 'Beginner',
      daysPerWeek: 4,
      durationWeeks: 8,
      goals: ['Build Muscle', 'Strength'],
      split: 'Upper/Lower',
      days: [
        ProgramDay(
          name: 'Upper A',
          focus: 'Push Focus',
          exercises: [
            ProgramExercise(name: 'Bench Press', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Barbell Row', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Overhead Press', sets: 3, reps: '8-10'),
            ProgramExercise(name: 'Lat Pulldown', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Dumbbell Curl', sets: 2, reps: '12-15'),
            ProgramExercise(name: 'Tricep Extension', sets: 2, reps: '12-15'),
          ],
        ),
        ProgramDay(
          name: 'Lower A',
          focus: 'Quad Focus',
          exercises: [
            ProgramExercise(name: 'Squat', sets: 4, reps: '6-8'),
            ProgramExercise(name: 'Romanian Deadlift', sets: 3, reps: '8-10'),
            ProgramExercise(name: 'Leg Press', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Leg Curl', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Calf Raise', sets: 3, reps: '15-20'),
          ],
        ),
        ProgramDay(
          name: 'Upper B',
          focus: 'Pull Focus',
          exercises: [
            ProgramExercise(name: 'Pull-ups', sets: 4, reps: 'AMRAP'),
            ProgramExercise(
              name: 'Dumbbell Bench Press',
              sets: 4,
              reps: '8-10',
            ),
            ProgramExercise(name: 'Cable Row', sets: 3, reps: '10-12'),
            ProgramExercise(
              name: 'Dumbbell Shoulder Press',
              sets: 3,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Face Pulls', sets: 3, reps: '15-20'),
            ProgramExercise(name: 'Hammer Curl', sets: 2, reps: '12-15'),
          ],
        ),
        ProgramDay(
          name: 'Lower B',
          focus: 'Glute/Hamstring Focus',
          exercises: [
            ProgramExercise(name: 'Deadlift', sets: 4, reps: '5'),
            ProgramExercise(
              name: 'Bulgarian Split Squat',
              sets: 3,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Hip Thrust', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Leg Extension', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Seated Calf Raise', sets: 3, reps: '15-20'),
          ],
        ),
      ],
    ),

    // Bro Split
    WorkoutProgram(
      id: 'brosplit',
      name: 'Classic Bro Split',
      description:
          'Traditional bodybuilding split hitting each muscle group once per week with high volume.',
      difficulty: 'Intermediate',
      daysPerWeek: 5,
      durationWeeks: 12,
      goals: ['Build Muscle', 'Definition'],
      split: 'Body Part',
      days: [
        ProgramDay(
          name: 'Chest Day',
          focus: 'Chest',
          exercises: [
            ProgramExercise(name: 'Barbell Bench Press', sets: 4, reps: '8-10'),
            ProgramExercise(
              name: 'Incline Dumbbell Press',
              sets: 4,
              reps: '10-12',
            ),
            ProgramExercise(name: 'Decline Press', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Cable Flye', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Push-ups', sets: 3, reps: 'AMRAP'),
          ],
        ),
        ProgramDay(
          name: 'Back Day',
          focus: 'Back',
          exercises: [
            ProgramExercise(name: 'Deadlift', sets: 4, reps: '5-6'),
            ProgramExercise(name: 'Lat Pulldown', sets: 4, reps: '10-12'),
            ProgramExercise(name: 'Barbell Row', sets: 4, reps: '8-10'),
            ProgramExercise(name: 'Seated Cable Row', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Face Pulls', sets: 3, reps: '15-20'),
          ],
        ),
        ProgramDay(
          name: 'Shoulder Day',
          focus: 'Shoulders',
          exercises: [
            ProgramExercise(name: 'Overhead Press', sets: 4, reps: '8-10'),
            ProgramExercise(name: 'Arnold Press', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Lateral Raise', sets: 4, reps: '12-15'),
            ProgramExercise(name: 'Rear Delt Fly', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Shrugs', sets: 4, reps: '10-12'),
          ],
        ),
        ProgramDay(
          name: 'Leg Day',
          focus: 'Legs',
          exercises: [
            ProgramExercise(name: 'Squat', sets: 4, reps: '8-10'),
            ProgramExercise(name: 'Leg Press', sets: 4, reps: '10-12'),
            ProgramExercise(name: 'Romanian Deadlift', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Leg Extension', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Leg Curl', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Calf Raise', sets: 4, reps: '15-20'),
          ],
        ),
        ProgramDay(
          name: 'Arms Day',
          focus: 'Biceps, Triceps',
          exercises: [
            ProgramExercise(name: 'Barbell Curl', sets: 4, reps: '10-12'),
            ProgramExercise(name: 'Close Grip Bench', sets: 4, reps: '8-10'),
            ProgramExercise(name: 'Hammer Curl', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Skull Crushers', sets: 3, reps: '10-12'),
            ProgramExercise(name: 'Preacher Curl', sets: 3, reps: '12-15'),
            ProgramExercise(name: 'Tricep Pushdown', sets: 3, reps: '12-15'),
          ],
        ),
      ],
    ),
  ];
}

/// Programs screen.
class WorkoutProgramsScreen extends StatefulWidget {
  const WorkoutProgramsScreen({super.key});

  @override
  State<WorkoutProgramsScreen> createState() => _WorkoutProgramsScreenState();
}

class _WorkoutProgramsScreenState extends State<WorkoutProgramsScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Beginner', 'Intermediate', 'Advanced'];

  @override
  Widget build(BuildContext context) {
    final programs = DefaultWorkoutPrograms.programs.where((p) {
      if (_selectedFilter == 'All') return true;
      return p.difficulty == _selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(title: const Text('Workout Programs')),
      body: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    onSelected: (_) => setState(() => _selectedFilter = filter),
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Programs list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: programs.length,
              itemBuilder: (context, index) {
                final program = programs[index];
                return _ProgramCard(
                  program: program,
                  onTap: () => _showProgramDetails(program),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showProgramDetails(WorkoutProgram program) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _ProgramDetailScreen(program: program)),
    );
  }
}

class _ProgramCard extends StatelessWidget {
  final WorkoutProgram program;
  final VoidCallback onTap;

  const _ProgramCard({required this.program, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: program.isPremium
              ? Border.all(color: Colors.amber, width: 2)
              : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.secondary.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              program.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (program.isPremium) ...[
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.black,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          program.split,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                  _difficultyBadge(program.difficulty),
                ],
              ),
            ),

            // Body
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    program.description,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _infoChip(
                        Icons.calendar_today,
                        '${program.daysPerWeek} days/week',
                      ),
                      const SizedBox(width: 8),
                      _infoChip(Icons.timer, '${program.durationWeeks} weeks'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    children: program.goals
                        .map(
                          (goal) => Chip(
                            label: Text(
                              goal,
                              style: const TextStyle(fontSize: 11),
                            ),
                            padding: EdgeInsets.zero,
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            backgroundColor: AppColors.surfaceLight,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _difficultyBadge(String difficulty) {
    Color color;
    switch (difficulty) {
      case 'Beginner':
        color = Colors.green;
        break;
      case 'Intermediate':
        color = Colors.orange;
        break;
      case 'Advanced':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _infoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.grey),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[400])),
        ],
      ),
    );
  }
}

/// Program detail screen.
class _ProgramDetailScreen extends StatelessWidget {
  final WorkoutProgram program;

  const _ProgramDetailScreen({required this.program});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(program.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.secondary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.fitness_center,
                    size: 80,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _statCard(
                        'Days/Week',
                        '${program.daysPerWeek}',
                        Icons.calendar_today,
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        'Duration',
                        '${program.durationWeeks} weeks',
                        Icons.timer,
                      ),
                      const SizedBox(width: 12),
                      _statCard('Level', program.difficulty, Icons.trending_up),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Text(
                    program.description,
                    style: TextStyle(
                      color: Colors.grey[300],
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Goals
                  const Text(
                    'Goals',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: program.goals
                        .map(
                          (goal) => Chip(
                            label: Text(goal),
                            backgroundColor: AppColors.primary.withValues(
                              alpha: 0.2,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 24),

                  // Workout days
                  const Text(
                    'Workout Schedule',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),

          // Workout days list
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final day = program.days[index];
              return _DayCard(day: day, dayNumber: index + 1);
            }, childCount: program.days.length),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: () {
              // Start program - would create template from program
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Started ${program.name}!'),
                  backgroundColor: AppColors.success,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.play_arrow),
            label: const Text('Start Program'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            Text(
              label,
              style: TextStyle(color: Colors.grey[500], fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final ProgramDay day;
  final int dayNumber;

  const _DayCard({required this.day, required this.dayNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              'D$dayNumber',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        title: Text(
          day.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          day.focus,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        children: [
          if (day.notes != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      day.notes!,
                      style: TextStyle(color: Colors.grey[400], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...day.exercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise.name,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        if (exercise.notes != null)
                          Text(
                            exercise.notes!,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 11,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${exercise.sets} × ${exercise.reps}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
