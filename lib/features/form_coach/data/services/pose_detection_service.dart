import 'dart:async';
import 'dart:ui';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_pose_detection/google_mlkit_pose_detection.dart';

/// Service for detecting body poses from camera frames.
class PoseDetectionService {
  PoseDetector? _poseDetector;
  bool _isProcessing = false;
  bool _isInitialized = false;

  /// Stream controller for detected poses.
  final _poseController = StreamController<Pose?>.broadcast();

  /// Stream of detected poses.
  Stream<Pose?> get poseStream => _poseController.stream;

  /// Whether the service is currently processing a frame.
  bool get isProcessing => _isProcessing;

  /// Initialize the pose detector.
  Future<void> initialize() async {
    if (_isInitialized) return;

    final options = PoseDetectorOptions(
      mode: PoseDetectionMode.stream, // Optimized for real-time
      model: PoseDetectionModel.base, // Base model for speed
    );

    _poseDetector = PoseDetector(options: options);
    _isInitialized = true;
  }

  /// Process a camera image and detect poses.
  Future<Pose?> processImage(
    CameraImage image,
    CameraDescription camera,
  ) async {
    if (!_isInitialized || _poseDetector == null) {
      throw StateError('PoseDetectionService not initialized');
    }

    // Skip if still processing previous frame
    if (_isProcessing) return null;
    _isProcessing = true;

    try {
      final inputImage = _convertCameraImage(image, camera);
      if (inputImage == null) {
        _isProcessing = false;
        return null;
      }

      final poses = await _poseDetector!.processImage(inputImage);
      final pose = poses.isNotEmpty ? poses.first : null;

      _poseController.add(pose);
      return pose;
    } catch (e) {
      debugPrint('Pose detection error: $e');
      return null;
    } finally {
      _isProcessing = false;
    }
  }

  /// Convert CameraImage to InputImage for ML Kit.
  InputImage? _convertCameraImage(CameraImage image, CameraDescription camera) {
    // Get rotation based on camera sensor orientation
    final rotation = _getInputImageRotation(camera);
    if (rotation == null) return null;

    // Get the image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null) return null;

    // Build plane data
    final plane = image.planes.first;

    // Concatenate all plane bytes
    final bytes = Uint8List.fromList(
      image.planes.expand((plane) => plane.bytes).toList(),
    );

    return InputImage.fromBytes(
      bytes: bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  /// Get the rotation for the camera.
  InputImageRotation? _getInputImageRotation(CameraDescription camera) {
    final sensorOrientation = camera.sensorOrientation;

    switch (sensorOrientation) {
      case 0:
        return InputImageRotation.rotation0deg;
      case 90:
        return InputImageRotation.rotation90deg;
      case 180:
        return InputImageRotation.rotation180deg;
      case 270:
        return InputImageRotation.rotation270deg;
      default:
        return null;
    }
  }

  /// Dispose resources.
  Future<void> dispose() async {
    await _poseDetector?.close();
    await _poseController.close();
    _poseDetector = null;
    _isInitialized = false;
  }
}
