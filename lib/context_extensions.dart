import 'package:flutter/material.dart';

extension ColorSchemeExtensions on ColorScheme {
  bool get isDarkMode => brightness == Brightness.dark;
  bool get isLightMode => brightness == Brightness.light;
}

extension ContextExtensions on BuildContext {
  Orientation get orientation => MediaQuery.orientationOf(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  ThemeData get theme => Theme.of(this);
}
