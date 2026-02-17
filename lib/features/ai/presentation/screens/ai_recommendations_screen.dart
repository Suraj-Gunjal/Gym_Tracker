import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// AI workout recommendation system.
class WorkoutRecommendation {
  final String title;
  final String description;
  final String reason;
  final List<String> exercises;
  final int estimatedDuration;
  final RecommendationType type;
  final double confidence;

  const WorkoutRecommendation({
    required this.title,
    required this.description,
    required this.reason,
    required this.exercises,
    required this.estimatedDuration,
    required this.type,
    required this.confidence,
  });
}

enum RecommendationType {
  recovery('Recovery Day', Icons.self_improvement, Colors.green),
  strength('Strength Focus', Icons.fitness_center, Colors.orange),
  volume('High Volume', Icons.trending_up, Colors.blue),
  deload('Deload Week', Icons.spa, Colors.purple),
  weak_point('Weak Point', Icons.warning_amber, Colors.amber),
  cardio('Cardio', Icons.directions_run, Colors.red);

  const RecommendationType(this.label, this.icon, this.color);
  final String label;
  final IconData icon;
  final Color color;
}

/// Insight categories.
enum InsightCategory {
  progress('Progress', Icons.trending_up),
  recovery('Recovery', Icons.bed),
  consistency('Consistency', Icons.calendar_month),
  strength('Strength', Icons.fitness_center),
  volume('Volume', Icons.bar_chart);

  const InsightCategory(this.label, this.icon);
  final String label;
  final IconData icon;
}

class WorkoutInsight {
  final String title;
  final String description;
  final InsightCategory category;
  final bool isPositive;
  final String? actionItem;

  const WorkoutInsight({
    required this.title,
    required this.description,
    required this.category,
    required this.isPositive,
    this.actionItem,
  });
}

/// AI recommendations screen.
class AIRecommendationsScreen extends StatefulWidget {
  const AIRecommendationsScreen({super.key});

  @override
  State<AIRecommendationsScreen> createState() =>
      _AIRecommendationsScreenState();
}

class _AIRecommendationsScreenState extends State<AIRecommendationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isLoading = true;
  List<WorkoutRecommendation> _recommendations = [];
  List<WorkoutInsight> _insights = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadRecommendations();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadRecommendations() async {
    // Simulate AI analysis
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
      _recommendations = _generateRecommendations();
      _insights = _generateInsights();
    });
  }

  List<WorkoutRecommendation> _generateRecommendations() {
    // In real app, this would analyze workout history
    return [
      WorkoutRecommendation(
        title: "Today's Recommended: Pull Day",
        description:
            "Based on your workout history, your back and biceps are fully recovered and ready to train.",
        reason: "Last pull workout: 3 days ago. Estimated recovery: 100%",
        exercises: [
          'Deadlift - 4×5',
          'Barbell Row - 4×8',
          'Lat Pulldown - 3×10',
          'Face Pulls - 3×15',
          'Barbell Curl - 3×12',
        ],
        estimatedDuration: 60,
        type: RecommendationType.strength,
        confidence: 0.92,
      ),
      WorkoutRecommendation(
        title: 'Shoulder Volume',
        description:
            "Your shoulders haven't received as much direct volume lately. Consider adding extra shoulder work.",
        reason: "Shoulder volume is 30% below your average",
        exercises: [
          'Overhead Press - 4×8',
          'Lateral Raise - 4×15',
          'Face Pulls - 3×15',
          'Rear Delt Fly - 3×15',
        ],
        estimatedDuration: 45,
        type: RecommendationType.weak_point,
        confidence: 0.85,
      ),
      WorkoutRecommendation(
        title: 'Active Recovery',
        description:
            "You've trained 5 days in a row. Consider light cardio or mobility work to aid recovery.",
        reason:
            "High training frequency detected. Recovery optimization suggested.",
        exercises: [
          '20 min light cardio',
          'Full body stretch - 15 min',
          'Foam rolling - 10 min',
        ],
        estimatedDuration: 45,
        type: RecommendationType.recovery,
        confidence: 0.78,
      ),
      WorkoutRecommendation(
        title: 'Deload Week Suggested',
        description:
            "You've been pushing hard for 4 weeks. A deload week can help prevent overtraining.",
        reason: "Training intensity has increased 15% over the past month",
        exercises: [
          'Reduce all weights by 40-50%',
          'Maintain same rep ranges',
          'Focus on form and control',
        ],
        estimatedDuration: 45,
        type: RecommendationType.deload,
        confidence: 0.72,
      ),
    ];
  }

  List<WorkoutInsight> _generateInsights() {
    return [
      WorkoutInsight(
        title: 'Bench Press PR Approaching',
        description:
            "You're on track to hit a new bench press PR. Your estimated 1RM has increased by 5kg in the past month.",
        category: InsightCategory.strength,
        isPositive: true,
        actionItem: "Try 85% of your new estimated 1RM next session",
      ),
      WorkoutInsight(
        title: 'Great Consistency',
        description:
            "You've maintained an 85% workout completion rate over the past 30 days. Keep it up!",
        category: InsightCategory.consistency,
        isPositive: true,
      ),
      WorkoutInsight(
        title: 'Leg Volume Declining',
        description:
            "Your leg training volume has dropped 25% compared to last month. Consider prioritizing leg work.",
        category: InsightCategory.volume,
        isPositive: false,
        actionItem: "Add an extra leg day this week",
      ),
      WorkoutInsight(
        title: 'Rest Time Increasing',
        description:
            "Your average rest time has increased from 90s to 120s. This might indicate fatigue.",
        category: InsightCategory.recovery,
        isPositive: false,
        actionItem: "Consider a deload or extra rest day",
      ),
      WorkoutInsight(
        title: 'Squat Form Improvement',
        description:
            "Your squat volume has increased while maintaining the same RPE. Your form is likely improving!",
        category: InsightCategory.progress,
        isPositive: true,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('AI Coach'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Recommendations'),
            Tab(text: 'Insights'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() => _isLoading = true);
              _loadRecommendations();
            },
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: _isLoading
          ? _buildLoadingState()
          : TabBarView(
              controller: _tabController,
              children: [_buildRecommendationsTab(), _buildInsightsTab()],
            ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Analyzing your workout data...',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Generating personalized recommendations',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendationsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // AI header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary.withValues(alpha: 0.3),
                AppColors.secondary.withValues(alpha: 0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.psychology, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'AI Coach Analysis',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      'Based on 47 workouts analyzed',
                      style: TextStyle(color: Colors.grey[400], fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Recommendations
        const Text(
          'Workout Suggestions',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._recommendations.map(
          (rec) => _RecommendationCard(recommendation: rec),
        ),
      ],
    );
  }

  Widget _buildInsightsTab() {
    final positiveInsights = _insights.where((i) => i.isPositive).toList();
    final negativeInsights = _insights.where((i) => !i.isPositive).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _summaryItem(
                positiveInsights.length.toString(),
                'Positive',
                Colors.green,
              ),
              Container(width: 1, height: 40, color: Colors.grey[700]),
              _summaryItem(
                negativeInsights.length.toString(),
                'Areas to Improve',
                Colors.orange,
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Positive insights
        if (positiveInsights.isNotEmpty) ...[
          _sectionHeader('Doing Great', Colors.green),
          ...positiveInsights.map((insight) => _InsightCard(insight: insight)),
          const SizedBox(height: 20),
        ],

        // Areas to improve
        if (negativeInsights.isNotEmpty) ...[
          _sectionHeader('Areas to Improve', Colors.orange),
          ...negativeInsights.map((insight) => _InsightCard(insight: insight)),
        ],
      ],
    );
  }

  Widget _summaryItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(color: Colors.grey[500])),
      ],
    );
  }

  Widget _sectionHeader(String title, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final WorkoutRecommendation recommendation;

  const _RecommendationCard({required this.recommendation});

  @override
  Widget build(BuildContext context) {
    final type = recommendation.type;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: type.color.withValues(alpha: 0.3)),
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.all(16),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: type.color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(type.icon, color: type.color),
        ),
        title: Text(
          recommendation.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: type.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                type.label,
                style: TextStyle(
                  color: type.color,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(recommendation.confidence * 100).toInt()}%',
              style: TextStyle(color: type.color, fontWeight: FontWeight.bold),
            ),
            Text(
              'confidence',
              style: TextStyle(color: Colors.grey[600], fontSize: 10),
            ),
          ],
        ),
        children: [
          Text(
            recommendation.description,
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 12),

          // Reason
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_outline, size: 18, color: Colors.amber),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    recommendation.reason,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Exercises
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Suggested Exercises:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 8),
          ...recommendation.exercises.map(
            (exercise) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, size: 16, color: type.color),
                  const SizedBox(width: 8),
                  Text(exercise),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Duration & Start button
          Row(
            children: [
              Icon(Icons.timer, size: 16, color: Colors.grey[500]),
              const SizedBox(width: 4),
              Text(
                '${recommendation.estimatedDuration} min',
                style: TextStyle(color: Colors.grey[500]),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Starting: ${recommendation.title}'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                icon: const Icon(Icons.play_arrow, size: 18),
                label: const Text('Start Workout'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InsightCard extends StatelessWidget {
  final WorkoutInsight insight;

  const _InsightCard({required this.insight});

  @override
  Widget build(BuildContext context) {
    final color = insight.isPositive ? Colors.green : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(insight.category.icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      insight.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      insight.category.label,
                      style: TextStyle(color: Colors.grey[500], fontSize: 12),
                    ),
                  ],
                ),
              ),
              Icon(
                insight.isPositive ? Icons.thumb_up : Icons.warning_amber,
                color: color,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight.description,
            style: TextStyle(color: Colors.grey[400], fontSize: 13),
          ),
          if (insight.actionItem != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.tips_and_updates, size: 16, color: color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      insight.actionItem!,
                      style: TextStyle(
                        color: color,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
