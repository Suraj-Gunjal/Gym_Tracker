import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';
import '../../data/services/pose_detection_service.dart';
import '../../data/analyzers/analyzer_factory.dart';
import '../../domain/models/exercise_form.dart';

/// State for the Form Coach feature.
class FormCoachState {
  final bool isInitialized;
  final bool isRunning;
  final CoachableExercise? selectedExercise;
  final Pose? currentPose;
  final FormAnalysisResult? lastAnalysis;
  final int repCount;
  final List<FormFeedback> activeFeedback;
  final String? error;
  final CameraController? cameraController;

  const FormCoachState({
    this.isInitialized = false,
    this.isRunning = false,
    this.selectedExercise,
    this.currentPose,
    this.lastAnalysis,
    this.repCount = 0,
    this.activeFeedback = const [],
    this.error,
    this.cameraController,
  });

  FormCoachState copyWith({
    bool? isInitialized,
    bool? isRunning,
    CoachableExercise? selectedExercise,
    Pose? currentPose,
    FormAnalysisResult? lastAnalysis,
    int? repCount,
    List<FormFeedback>? activeFeedback,
    String? error,
    CameraController? cameraController,
  }) {
    return FormCoachState(
      isInitialized: isInitialized ?? this.isInitialized,
      isRunning: isRunning ?? this.isRunning,
      selectedExercise: selectedExercise ?? this.selectedExercise,
      currentPose: currentPose ?? this.currentPose,
      lastAnalysis: lastAnalysis ?? this.lastAnalysis,
      repCount: repCount ?? this.repCount,
      activeFeedback: activeFeedback ?? this.activeFeedback,
      error: error,
      cameraController: cameraController ?? this.cameraController,
    );
  }
}

/// Provider for Form Coach functionality.
class FormCoachNotifier extends StateNotifier<FormCoachState> {
  final PoseDetectionService _poseService = PoseDetectionService();
  List<CameraDescription>? _cameras;
  CameraDescription? _selectedCamera;
  StreamSubscription? _frameSubscription;

  FormCoachNotifier() : super(const FormCoachState());

  /// Initialize camera and pose detection.
  Future<void> initialize() async {
    try {
      // Get available cameras
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        state = state.copyWith(error: 'No cameras available');
        return;
      }

      // Prefer front camera for form checking
      _selectedCamera = _cameras!.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => _cameras!.first,
      );

      // Initialize camera controller
      final controller = CameraController(
        _selectedCamera!,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.nv21,
      );

      await controller.initialize();

      // Initialize pose detection
      await _poseService.initialize();

      state = state.copyWith(
        isInitialized: true,
        cameraController: controller,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(error: 'Failed to initialize: $e');
    }
  }

  /// Select an exercise to analyze.
  void selectExercise(CoachableExercise exercise) {
    AnalyzerFactory.resetAnalyzer(exercise);
    state = state.copyWith(
      selectedExercise: exercise,
      repCount: 0,
      activeFeedback: [],
      lastAnalysis: null,
    );
  }

  /// Start form analysis.
  Future<void> startAnalysis() async {
    if (!state.isInitialized || state.selectedExercise == null) return;
    if (state.cameraController == null) return;

    final analyzer = AnalyzerFactory.getAnalyzer(state.selectedExercise!);
    analyzer.reset();

    state = state.copyWith(isRunning: true, repCount: 0);

    // Start processing camera frames
    await state.cameraController!.startImageStream((image) async {
      if (!state.isRunning || _selectedCamera == null) return;

      final pose = await _poseService.processImage(image, _selectedCamera!);
      if (pose == null) return;

      final analysis = analyzer.analyze(pose);

      state = state.copyWith(
        currentPose: pose,
        lastAnalysis: analysis,
        repCount: analyzer.repCount,
        activeFeedback: analysis.feedback,
      );
    });
  }

  /// Stop form analysis.
  Future<void> stopAnalysis() async {
    state = state.copyWith(isRunning: false);

    try {
      await state.cameraController?.stopImageStream();
    } catch (e) {
      debugPrint('Error stopping image stream: $e');
    }
  }

  /// Get summary of the current set.
  SetFormSummary? getSummary() {
    if (state.selectedExercise == null) return null;
    return AnalyzerFactory.getAnalyzer(state.selectedExercise!).getSummary();
  }

  /// Switch camera (front/back).
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.length < 2) return;

    final wasRunning = state.isRunning;
    if (wasRunning) await stopAnalysis();

    await state.cameraController?.dispose();

    // Toggle camera
    final currentDirection = _selectedCamera?.lensDirection;
    _selectedCamera = _cameras!.firstWhere(
      (c) => c.lensDirection != currentDirection,
      orElse: () => _cameras!.first,
    );

    final controller = CameraController(
      _selectedCamera!,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.nv21,
    );

    await controller.initialize();
    state = state.copyWith(cameraController: controller);

    if (wasRunning) await startAnalysis();
  }

  @override
  void dispose() {
    _frameSubscription?.cancel();
    state.cameraController?.dispose();
    _poseService.dispose();
    super.dispose();
  }
}

/// Provider instance.
final formCoachProvider =
    StateNotifierProvider<FormCoachNotifier, FormCoachState>((ref) {
      return FormCoachNotifier();
    });
