import 'package:flutter/material.dart';
import 'package:slyde/context_extensions.dart';

class BulletList extends StatelessWidget {
  final List<String> items;
  final TextStyle? style;
  const BulletList({super.key, required this.items, this.style});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: .start,
      children: [for (final item in items) BulletItem(item, style: style)],
    );
  }
}

class BulletItem extends StatelessWidget {
  final String item;
  final TextStyle? style;
  const BulletItem(this.item, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const .only(right: 32.0),
      child: Row(
        crossAxisAlignment: .start,
        children: [
          Text('• ', style: style ?? context.textTheme.displaySmall),
          Expanded(
            child: Text(item, style: style ?? context.textTheme.displaySmall),
          ),
        ],
      ),
    );
  }
}
