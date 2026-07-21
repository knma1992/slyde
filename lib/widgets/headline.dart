import 'package:flutter/material.dart';
import 'package:slyde/context_extensions.dart';

class Headline extends StatelessWidget {
  final String highlight;
  final String rest;

  const Headline({super.key, required this.highlight, required this.rest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(bottom: 20.0),
      child: RichText(
        text: TextSpan(
          style: context.textTheme.displayLarge,
          children: [
            TextSpan(
              text: highlight,
              style: TextStyle(color: context.colorScheme.primary),
            ),
            TextSpan(text: rest),
          ],
        ),
      ),
    );
  }
}
