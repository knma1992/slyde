import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// The native window this slide show runs in, or `null` when there is none.
///
/// Answers `null` in widget tests and anywhere the nativeapi library is not
/// loaded, so callers can drive the window without guarding every platform.
Window? get slideShowWindow {
  try {
    return WindowManager.instance.getCurrent();
  } on ArgumentError {
    // No native library: widget tests run in a plain Dart VM.
    return null;
  }
}

/// Bootstraps the desktop window for a slide show.
/// Call once before `runApp`.
Future<void> initSlideShowWindow({
  String title = '',
  Size minimumSize = const Size(800, 600),
  TitleBarStyle titleBarStyle = TitleBarStyle.normal,
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  final window = slideShowWindow;
  if (window == null) return;

  window.titleBarStyle = titleBarStyle;
  // Keep the native close/minimise/zoom buttons, as 0.5.x did by default.
  window.isWindowControlButtonsVisible = true;
  window.title = title;
  window.minimumSize = minimumSize.toNative();

  window.show();
  window.focus();
}
