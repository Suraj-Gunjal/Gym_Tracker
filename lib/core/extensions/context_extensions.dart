import 'package:flutter/material.dart';

/// Extension methods on BuildContext for easier access to common values.
extension ContextExtensions on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);

  /// Get the current text theme
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get the current color scheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Get the media query data
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get the screen size
  Size get screenSize => MediaQuery.sizeOf(this);

  /// Get the screen width
  double get screenWidth => screenSize.width;

  /// Get the screen height
  double get screenHeight => screenSize.height;

  /// Check if the device is in landscape mode
  bool get isLandscape => screenWidth > screenHeight;

  /// Check if it's a tablet-sized screen (width >= 600)
  bool get isTablet => screenWidth >= 600;

  /// Check if it's a desktop-sized screen (width >= 1200)
  bool get isDesktop => screenWidth >= 1200;

  /// Get the bottom padding (safe area)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get the top padding (safe area)
  double get topPadding => mediaQuery.padding.top;

  /// Get keyboard height
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Check if keyboard is visible
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Show a snackbar
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? colorScheme.error : null,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show a success snackbar
  void showSuccess(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Show an error snackbar
  void showError(String message) {
    showSnackBar(message, isError: true);
  }

  /// Pop the current route
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Check if we can pop
  bool get canPop => Navigator.of(this).canPop();
}
