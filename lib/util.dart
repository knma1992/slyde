import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

/// Bootstraps the desktop window for a slide show.
/// Call once before `runApp`.
Future<void> initSlideShowWindow({
  String title = '',
  Size minimumSize = const Size(800, 600),
  TitleBarStyle titleBarStyle = TitleBarStyle.normal,
}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  final windowOptions = WindowOptions(
    title: title,
    titleBarStyle: titleBarStyle,
    minimumSize: minimumSize,
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
