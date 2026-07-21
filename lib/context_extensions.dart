import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

extension KeyDownEventExtensions on KeyEvent {
  bool get isHKey =>
      (this is KeyDownEvent) && logicalKey == LogicalKeyboardKey.keyH;
  bool get isLeftArrow =>
      (this is KeyDownEvent) && logicalKey == LogicalKeyboardKey.arrowLeft;
  bool get isRightArrow =>
      (this is KeyDownEvent) && logicalKey == LogicalKeyboardKey.arrowRight;

  bool get isCharAdd => character == "+";
  bool get isChardMinus => character == "-";
  bool get isSpace =>
      (this is KeyDownEvent) && logicalKey == LogicalKeyboardKey.space;
}
