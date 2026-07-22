import 'package:flutter/material.dart';
import 'package:slyde/widgets/item.dart';
import 'package:slyde/widgets/item_list.dart';

/// Convenience shorthand for a plain, static bullet list of strings.
/// For nesting, expansion, labels, or per-level styling use [ItemList].
class BulletList extends StatelessWidget {
  final List<String> items;
  final TextStyle? style;
  const BulletList({super.key, required this.items, this.style});

  @override
  Widget build(BuildContext context) {
    return ItemList(
      group: ItemGroup(bodyStyle: style, [
        for (final item in items) Item(item),
      ]),
    );
  }
}

/// A single bullet row — shorthand for a one-element [BulletList].
class BulletItem extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const BulletItem(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return BulletList(items: [text], style: style);
  }
}
