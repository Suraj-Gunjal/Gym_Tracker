import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Muscle group data for heatmap visualization.
enum MuscleGroup {
  chest('Chest', MuscleCategory.push),
  shoulders('Shoulders', MuscleCategory.push),
  triceps('Triceps', MuscleCategory.push),
  back('Back', MuscleCategory.pull),
  biceps('Biceps', MuscleCategory.pull),
  forearms('Forearms', MuscleCategory.pull),
  core('Core', MuscleCategory.core),
  obliques('Obliques', MuscleCategory.core),
  quads('Quads', MuscleCategory.legs),
  hamstrings('Hamstrings', MuscleCategory.legs),
  glutes('Glutes', MuscleCategory.legs),
  calves('Calves', MuscleCategory.legs),
  traps('Traps', MuscleCategory.pull);

  const MuscleGroup(this.label, this.category);
  final String label;
  final MuscleCategory category;
}

enum MuscleCategory {
  push('Push'),
  pull('Pull'),
  legs('Legs'),
  core('Core');

  const MuscleCategory(this.label);
  final String label;
}

/// Recovery status for muscles.
enum RecoveryStatus {
  fresh(1.0, 'Fresh', Colors.green),
  recovered(0.8, 'Recovered', Color(0xFF66BB6A)),
  moderate(0.6, 'Moderate', Colors.yellow),
  fatigued(0.4, 'Fatigued', Colors.orange),
  sore(0.2, 'Sore', Colors.deepOrange),
  exhausted(0.0, 'Exhausted', Colors.red);

  const RecoveryStatus(this.value, this.label, this.color);
  final double value;
  final String label;
  final Color color;

  static RecoveryStatus fromValue(double value) {
    if (value >= 0.9) return fresh;
    if (value >= 0.7) return recovered;
    if (value >= 0.5) return moderate;
    if (value >= 0.3) return fatigued;
    if (value >= 0.1) return sore;
    return exhausted;
  }
}

/// Muscle activation data from exercise.
class MuscleActivation {
  final MuscleGroup muscle;
  final double intensity; // 0.0 to 1.0
  final DateTime lastWorked;
  final int setsPerformed;
  final int totalVolume;

  const MuscleActivation({
    required this.muscle,
    required this.intensity,
    required this.lastWorked,
    this.setsPerformed = 0,
    this.totalVolume = 0,
  });

  /// Calculate recovery percentage based on hours since last workout.
  double get recoveryPercentage {
    final hoursSince = DateTime.now().difference(lastWorked).inHours;
    // Full recovery assumed at 72 hours for high intensity
    final recoveryHours =
        24 + (intensity * 48); // 24-72 hours based on intensity
    final recovery = hoursSince / recoveryHours;
    return recovery.clamp(0.0, 1.0);
  }

  RecoveryStatus get status => RecoveryStatus.fromValue(recoveryPercentage);
}

/// Exercise to muscle group mapping.
class ExerciseMuscleMapping {
  static const Map<String, Map<MuscleGroup, double>> exerciseToMuscles = {
    // Chest exercises
    'bench press': {
      MuscleGroup.chest: 1.0,
      MuscleGroup.triceps: 0.6,
      MuscleGroup.shoulders: 0.4,
    },
    'incline bench press': {
      MuscleGroup.chest: 0.9,
      MuscleGroup.shoulders: 0.6,
      MuscleGroup.triceps: 0.5,
    },
    'dumbbell fly': {MuscleGroup.chest: 1.0, MuscleGroup.shoulders: 0.3},
    'push up': {
      MuscleGroup.chest: 0.8,
      MuscleGroup.triceps: 0.6,
      MuscleGroup.shoulders: 0.4,
      MuscleGroup.core: 0.3,
    },
    'dips': {
      MuscleGroup.chest: 0.7,
      MuscleGroup.triceps: 0.8,
      MuscleGroup.shoulders: 0.4,
    },

    // Back exercises
    'deadlift': {
      MuscleGroup.back: 0.9,
      MuscleGroup.hamstrings: 0.7,
      MuscleGroup.glutes: 0.8,
      MuscleGroup.traps: 0.5,
      MuscleGroup.forearms: 0.4,
      MuscleGroup.core: 0.5,
    },
    'barbell row': {
      MuscleGroup.back: 1.0,
      MuscleGroup.biceps: 0.6,
      MuscleGroup.traps: 0.5,
      MuscleGroup.forearms: 0.3,
    },
    'lat pulldown': {
      MuscleGroup.back: 1.0,
      MuscleGroup.biceps: 0.5,
      MuscleGroup.forearms: 0.3,
    },
    'pull up': {
      MuscleGroup.back: 1.0,
      MuscleGroup.biceps: 0.7,
      MuscleGroup.forearms: 0.5,
      MuscleGroup.core: 0.3,
    },
    'chin up': {
      MuscleGroup.back: 0.8,
      MuscleGroup.biceps: 0.9,
      MuscleGroup.forearms: 0.5,
    },
    'cable row': {
      MuscleGroup.back: 0.9,
      MuscleGroup.biceps: 0.5,
      MuscleGroup.traps: 0.4,
    },

    // Shoulder exercises
    'overhead press': {
      MuscleGroup.shoulders: 1.0,
      MuscleGroup.triceps: 0.5,
      MuscleGroup.traps: 0.3,
    },
    'military press': {
      MuscleGroup.shoulders: 1.0,
      MuscleGroup.triceps: 0.5,
      MuscleGroup.core: 0.3,
    },
    'lateral raise': {MuscleGroup.shoulders: 1.0},
    'front raise': {MuscleGroup.shoulders: 0.9, MuscleGroup.chest: 0.2},
    'face pull': {
      MuscleGroup.shoulders: 0.7,
      MuscleGroup.traps: 0.5,
      MuscleGroup.back: 0.3,
    },
    'shrugs': {MuscleGroup.traps: 1.0},

    // Arm exercises
    'bicep curl': {MuscleGroup.biceps: 1.0, MuscleGroup.forearms: 0.3},
    'hammer curl': {MuscleGroup.biceps: 0.8, MuscleGroup.forearms: 0.5},
    'tricep extension': {MuscleGroup.triceps: 1.0},
    'tricep pushdown': {MuscleGroup.triceps: 1.0},
    'skull crusher': {MuscleGroup.triceps: 1.0},
    'wrist curl': {MuscleGroup.forearms: 1.0},

    // Leg exercises
    'squat': {
      MuscleGroup.quads: 1.0,
      MuscleGroup.glutes: 0.8,
      MuscleGroup.hamstrings: 0.4,
      MuscleGroup.core: 0.4,
      MuscleGroup.calves: 0.2,
    },
    'leg press': {
      MuscleGroup.quads: 1.0,
      MuscleGroup.glutes: 0.6,
      MuscleGroup.hamstrings: 0.3,
    },
    'leg extension': {MuscleGroup.quads: 1.0},
    'leg curl': {MuscleGroup.hamstrings: 1.0},
    'romanian deadlift': {
      MuscleGroup.hamstrings: 1.0,
      MuscleGroup.glutes: 0.8,
      MuscleGroup.back: 0.4,
    },
    'hip thrust': {MuscleGroup.glutes: 1.0, MuscleGroup.hamstrings: 0.5},
    'lunge': {
      MuscleGroup.quads: 0.9,
      MuscleGroup.glutes: 0.7,
      MuscleGroup.hamstrings: 0.4,
    },
    'bulgarian split squat': {
      MuscleGroup.quads: 0.9,
      MuscleGroup.glutes: 0.8,
      MuscleGroup.hamstrings: 0.3,
    },
    'calf raise': {MuscleGroup.calves: 1.0},

    // Core exercises
    'plank': {
      MuscleGroup.core: 1.0,
      MuscleGroup.obliques: 0.5,
      MuscleGroup.shoulders: 0.3,
    },
    'crunch': {MuscleGroup.core: 1.0},
    'sit up': {MuscleGroup.core: 0.9, MuscleGroup.obliques: 0.3},
    'leg raise': {MuscleGroup.core: 1.0, MuscleGroup.obliques: 0.4},
    'russian twist': {MuscleGroup.obliques: 1.0, MuscleGroup.core: 0.6},
    'cable crunch': {MuscleGroup.core: 1.0},
    'ab wheel': {MuscleGroup.core: 1.0, MuscleGroup.shoulders: 0.3},
  };

  /// Get muscle activation for an exercise.
  static Map<MuscleGroup, double>? getMusclesToActivation(String exerciseName) {
    final normalized = exerciseName.toLowerCase().trim();

    // Direct match
    if (exerciseToMuscles.containsKey(normalized)) {
      return exerciseToMuscles[normalized];
    }

    // Partial match
    for (final entry in exerciseToMuscles.entries) {
      if (normalized.contains(entry.key) || entry.key.contains(normalized)) {
        return entry.value;
      }
    }

    return null;
  }
}

/// Muscle heatmap screen.
class MuscleHeatmapScreen extends StatefulWidget {
  final List<MuscleActivation> activations;

  const MuscleHeatmapScreen({super.key, this.activations = const []});

  @override
  State<MuscleHeatmapScreen> createState() => _MuscleHeatmapScreenState();
}

class _MuscleHeatmapScreenState extends State<MuscleHeatmapScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFront = true;

  // Sample data - in real app would come from workout history
  Map<MuscleGroup, MuscleActivation> _activationMap = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initializeSampleData();
  }

  void _initializeSampleData() {
    // Sample activation data - would come from actual workout history
    final now = DateTime.now();
    _activationMap = {
      MuscleGroup.chest: MuscleActivation(
        muscle: MuscleGroup.chest,
        intensity: 0.8,
        lastWorked: now.subtract(const Duration(hours: 24)),
        setsPerformed: 12,
        totalVolume: 5400,
      ),
      MuscleGroup.shoulders: MuscleActivation(
        muscle: MuscleGroup.shoulders,
        intensity: 0.6,
        lastWorked: now.subtract(const Duration(hours: 24)),
        setsPerformed: 6,
        totalVolume: 1800,
      ),
      MuscleGroup.triceps: MuscleActivation(
        muscle: MuscleGroup.triceps,
        intensity: 0.5,
        lastWorked: now.subtract(const Duration(hours: 24)),
        setsPerformed: 6,
        totalVolume: 1200,
      ),
      MuscleGroup.back: MuscleActivation(
        muscle: MuscleGroup.back,
        intensity: 0.9,
        lastWorked: now.subtract(const Duration(hours: 48)),
        setsPerformed: 16,
        totalVolume: 8000,
      ),
      MuscleGroup.biceps: MuscleActivation(
        muscle: MuscleGroup.biceps,
        intensity: 0.6,
        lastWorked: now.subtract(const Duration(hours: 48)),
        setsPerformed: 8,
        totalVolume: 2000,
      ),
      MuscleGroup.quads: MuscleActivation(
        muscle: MuscleGroup.quads,
        intensity: 0.85,
        lastWorked: now.subtract(const Duration(hours: 72)),
        setsPerformed: 14,
        totalVolume: 9800,
      ),
      MuscleGroup.hamstrings: MuscleActivation(
        muscle: MuscleGroup.hamstrings,
        intensity: 0.7,
        lastWorked: now.subtract(const Duration(hours: 72)),
        setsPerformed: 8,
        totalVolume: 4000,
      ),
      MuscleGroup.glutes: MuscleActivation(
        muscle: MuscleGroup.glutes,
        intensity: 0.75,
        lastWorked: now.subtract(const Duration(hours: 72)),
        setsPerformed: 10,
        totalVolume: 6000,
      ),
      MuscleGroup.core: MuscleActivation(
        muscle: MuscleGroup.core,
        intensity: 0.4,
        lastWorked: now.subtract(const Duration(hours: 96)),
        setsPerformed: 4,
        totalVolume: 0,
      ),
    };

    // Add provided activations
    for (final activation in widget.activations) {
      _activationMap[activation.muscle] = activation;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Muscle Recovery'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Heatmap'),
            Tab(text: 'Details'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildHeatmapView(), _buildDetailsView()],
      ),
    );
  }

  Widget _buildHeatmapView() {
    return Column(
      children: [
        // View toggle
        Padding(
          padding: const EdgeInsets.all(16),
          child: SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: true,
                label: Text('Front'),
                icon: Icon(Icons.person),
              ),
              ButtonSegment(
                value: false,
                label: Text('Back'),
                icon: Icon(Icons.person_outline),
              ),
            ],
            selected: {_showFront},
            onSelectionChanged: (value) {
              setState(() => _showFront = value.first);
            },
          ),
        ),

        // Body visualization
        Expanded(
          child: Center(
            child: _BodyVisualization(
              showFront: _showFront,
              activations: _activationMap,
              onMuscleSelected: _showMuscleDetails,
            ),
          ),
        ),

        // Legend
        _buildLegend(),
      ],
    );
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const Text(
            'Recovery Status',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _legendItem(Colors.green, 'Fresh'),
              _legendItem(Colors.yellow, 'Moderate'),
              _legendItem(Colors.orange, 'Fatigued'),
              _legendItem(Colors.red, 'Exhausted'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildDetailsView() {
    final groupedByCategory = <MuscleCategory, List<MuscleActivation>>{};
    for (final activation in _activationMap.values) {
      final category = activation.muscle.category;
      groupedByCategory.putIfAbsent(category, () => []);
      groupedByCategory[category]!.add(activation);
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary cards
        _buildSummaryCards(),
        const SizedBox(height: 16),

        // Muscle details by category
        for (final category in MuscleCategory.values)
          if (groupedByCategory.containsKey(category)) ...[
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                category.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ...groupedByCategory[category]!.map(_buildMuscleCard),
          ],
      ],
    );
  }

  Widget _buildSummaryCards() {
    final freshMuscles = _activationMap.values
        .where((a) => a.recoveryPercentage >= 0.8)
        .length;
    final fatiguedMuscles = _activationMap.values
        .where((a) => a.recoveryPercentage < 0.5)
        .length;

    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            'Ready to Train',
            '$freshMuscles muscles',
            Icons.check_circle,
            Colors.green,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _summaryCard(
            'Need Recovery',
            '$fatiguedMuscles muscles',
            Icons.warning_amber,
            Colors.orange,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard(
    String title,
    String subtitle,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
          Text(subtitle, style: TextStyle(color: Colors.grey[400])),
        ],
      ),
    );
  }

  Widget _buildMuscleCard(MuscleActivation activation) {
    final recovery = activation.recoveryPercentage;
    final status = activation.status;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Icon(
                    _getMuscleIcon(activation.muscle),
                    color: status.color,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      activation.muscle.label,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${_getTimeSince(activation.lastWorked)} ago',
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status.label,
                  style: TextStyle(
                    color: status.color,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Recovery progress
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: recovery,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation(status.color),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${(recovery * 100).toInt()}% recovered',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
              Text(
                '${activation.setsPerformed} sets • ${_formatVolume(activation.totalVolume)}',
                style: TextStyle(color: Colors.grey[500], fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showMuscleDetails(MuscleGroup muscle) {
    final activation = _activationMap[muscle];
    if (activation == null) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              muscle.label,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildMuscleCard(activation),
            const SizedBox(height: 16),
            // Suggested exercises
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Suggested Exercises',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            ...ExerciseMuscleMapping.exerciseToMuscles.entries
                .where(
                  (e) => e.value.containsKey(muscle) && e.value[muscle]! >= 0.7,
                )
                .take(3)
                .map(
                  (e) => ListTile(
                    leading: const Icon(Icons.fitness_center),
                    title: Text(
                      e.key
                          .split(' ')
                          .map((w) => w[0].toUpperCase() + w.substring(1))
                          .join(' '),
                    ),
                    trailing: Text('${(e.value[muscle]! * 100).toInt()}%'),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  IconData _getMuscleIcon(MuscleGroup muscle) {
    switch (muscle.category) {
      case MuscleCategory.push:
        return Icons.arrow_forward;
      case MuscleCategory.pull:
        return Icons.arrow_back;
      case MuscleCategory.legs:
        return Icons.directions_walk;
      case MuscleCategory.core:
        return Icons.circle_outlined;
    }
  }

  String _getTimeSince(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 0) return '${diff.inDays}d';
    if (diff.inHours > 0) return '${diff.inHours}h';
    return '${diff.inMinutes}m';
  }

  String _formatVolume(int volume) {
    if (volume >= 1000) {
      return '${(volume / 1000).toStringAsFixed(1)}k kg';
    }
    return '$volume kg';
  }
}

/// Body visualization widget.
class _BodyVisualization extends StatelessWidget {
  final bool showFront;
  final Map<MuscleGroup, MuscleActivation> activations;
  final Function(MuscleGroup) onMuscleSelected;

  const _BodyVisualization({
    required this.showFront,
    required this.activations,
    required this.onMuscleSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Body outline
        CustomPaint(
          size: const Size(200, 400),
          painter: _BodyOutlinePainter(showFront: showFront),
        ),

        // Muscle overlays
        if (showFront) ..._buildFrontMuscles() else ..._buildBackMuscles(),
      ],
    );
  }

  List<Widget> _buildFrontMuscles() {
    return [
      _muscleButton(
        MuscleGroup.shoulders,
        const Offset(-55, 70),
        const Size(30, 35),
      ),
      _muscleButton(
        MuscleGroup.shoulders,
        const Offset(55, 70),
        const Size(30, 35),
      ),
      _muscleButton(MuscleGroup.chest, const Offset(0, 90), const Size(70, 50)),
      _muscleButton(
        MuscleGroup.biceps,
        const Offset(-70, 110),
        const Size(20, 45),
      ),
      _muscleButton(
        MuscleGroup.biceps,
        const Offset(70, 110),
        const Size(20, 45),
      ),
      _muscleButton(MuscleGroup.core, const Offset(0, 160), const Size(50, 60)),
      _muscleButton(
        MuscleGroup.obliques,
        const Offset(-35, 165),
        const Size(20, 40),
      ),
      _muscleButton(
        MuscleGroup.obliques,
        const Offset(35, 165),
        const Size(20, 40),
      ),
      _muscleButton(
        MuscleGroup.forearms,
        const Offset(-75, 165),
        const Size(15, 40),
      ),
      _muscleButton(
        MuscleGroup.forearms,
        const Offset(75, 165),
        const Size(15, 40),
      ),
      _muscleButton(
        MuscleGroup.quads,
        const Offset(-25, 250),
        const Size(35, 80),
      ),
      _muscleButton(
        MuscleGroup.quads,
        const Offset(25, 250),
        const Size(35, 80),
      ),
      _muscleButton(
        MuscleGroup.calves,
        const Offset(-20, 345),
        const Size(20, 45),
      ),
      _muscleButton(
        MuscleGroup.calves,
        const Offset(20, 345),
        const Size(20, 45),
      ),
    ];
  }

  List<Widget> _buildBackMuscles() {
    return [
      _muscleButton(MuscleGroup.traps, const Offset(0, 55), const Size(60, 30)),
      _muscleButton(
        MuscleGroup.shoulders,
        const Offset(-55, 75),
        const Size(30, 35),
      ),
      _muscleButton(
        MuscleGroup.shoulders,
        const Offset(55, 75),
        const Size(30, 35),
      ),
      _muscleButton(MuscleGroup.back, const Offset(0, 110), const Size(65, 70)),
      _muscleButton(
        MuscleGroup.triceps,
        const Offset(-70, 115),
        const Size(20, 40),
      ),
      _muscleButton(
        MuscleGroup.triceps,
        const Offset(70, 115),
        const Size(20, 40),
      ),
      _muscleButton(
        MuscleGroup.forearms,
        const Offset(-75, 165),
        const Size(15, 40),
      ),
      _muscleButton(
        MuscleGroup.forearms,
        const Offset(75, 165),
        const Size(15, 40),
      ),
      _muscleButton(
        MuscleGroup.glutes,
        const Offset(0, 220),
        const Size(55, 45),
      ),
      _muscleButton(
        MuscleGroup.hamstrings,
        const Offset(-25, 280),
        const Size(30, 65),
      ),
      _muscleButton(
        MuscleGroup.hamstrings,
        const Offset(25, 280),
        const Size(30, 65),
      ),
      _muscleButton(
        MuscleGroup.calves,
        const Offset(-20, 355),
        const Size(20, 40),
      ),
      _muscleButton(
        MuscleGroup.calves,
        const Offset(20, 355),
        const Size(20, 40),
      ),
    ];
  }

  Widget _muscleButton(MuscleGroup muscle, Offset position, Size size) {
    final activation = activations[muscle];
    final color = activation != null
        ? activation.status.color
        : Colors.grey.withValues(alpha: 0.3);
    final recovery = activation?.recoveryPercentage ?? 1.0;

    return Positioned(
      left: 100 + position.dx - size.width / 2,
      top: position.dy - size.height / 2,
      child: GestureDetector(
        onTap: () => onMuscleSelected(muscle),
        child: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.6 + (0.4 * (1 - recovery))),
            borderRadius: BorderRadius.circular(size.width / 4),
            border: Border.all(color: color, width: 2),
          ),
        ),
      ),
    );
  }
}

class _BodyOutlinePainter extends CustomPainter {
  final bool showFront;

  _BodyOutlinePainter({required this.showFront});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final centerX = size.width / 2;

    // Simple body outline
    final path = Path();

    // Head
    path.addOval(
      Rect.fromCenter(center: Offset(centerX, 25), width: 40, height: 45),
    );

    // Neck
    path.moveTo(centerX - 10, 45);
    path.lineTo(centerX - 10, 55);
    path.moveTo(centerX + 10, 45);
    path.lineTo(centerX + 10, 55);

    // Torso
    path.moveTo(centerX - 45, 55);
    path.lineTo(centerX - 35, 190);
    path.lineTo(centerX - 25, 215);
    path.lineTo(centerX - 30, 220);

    path.moveTo(centerX + 45, 55);
    path.lineTo(centerX + 35, 190);
    path.lineTo(centerX + 25, 215);
    path.lineTo(centerX + 30, 220);

    // Shoulders
    path.moveTo(centerX - 45, 55);
    path.lineTo(centerX - 70, 65);
    path.moveTo(centerX + 45, 55);
    path.lineTo(centerX + 70, 65);

    // Arms
    path.moveTo(centerX - 70, 65);
    path.lineTo(centerX - 85, 200);
    path.moveTo(centerX + 70, 65);
    path.lineTo(centerX + 85, 200);

    // Legs
    path.moveTo(centerX - 30, 220);
    path.lineTo(centerX - 40, 340);
    path.lineTo(centerX - 35, 395);
    path.moveTo(centerX + 30, 220);
    path.lineTo(centerX + 40, 340);
    path.lineTo(centerX + 35, 395);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
