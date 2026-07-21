import 'package:flutter/material.dart';
import 'package:slyde/context_extensions.dart';

class AlertText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const AlertText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          context.textTheme.displayLarge?.copyWith(
            color: context.colorScheme.error,
          ),
      textAlign: .center,
    );
  }
}

class HighlightText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const HighlightText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style ??
          context.textTheme.displayMedium?.copyWith(
            color: context.colorScheme.primary,
          ),
      textAlign: .center,
    );
  }
}

class NormalText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const NormalText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? context.textTheme.displayMedium?.copyWith(),
      textAlign: .center,
    );
  }
}

class SmallText extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const SmallText(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ?? context.textTheme.displaySmall?.copyWith(),
      textAlign: .center,
    );
  }
}
