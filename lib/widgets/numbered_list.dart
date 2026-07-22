import 'package:flutter/material.dart';
import 'package:slyde/context_extensions.dart';
import 'package:slyde/widgets/bullet_list.dart';
import 'package:slyde/widgets/item.dart';

class NumberedList extends StatefulWidget {
  final List<Item> items;
  final TextStyle? bodyStyle;
  final TextStyle? numberStyle;
  final TextStyle? additionalStyle;
  const NumberedList({
    super.key,
    required this.items,
    this.bodyStyle,
    this.numberStyle,
    this.additionalStyle,
  });

  @override
  State<NumberedList> createState() => _NumberedListState();
}

class _NumberedListState extends State<NumberedList> {
  int? expandedIndex;

  void _onItemTapped(int index) {
    setState(() {
      // Expanding one item closes any other that was open.
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: .start,
      children: [
        for (final (number, item) in widget.items.indexed)
          _NumberedItem(
            number,
            item,
            expanded: item.alwaysShow || expandedIndex == number,
            onTap: item.isExpandable ? () => _onItemTapped(number) : null,
            bodyStyle: widget.bodyStyle,
            numberStyle: widget.numberStyle,
            additionalStyle: widget.additionalStyle,
          ),
      ],
    );
  }
}

class _NumberedItem extends StatelessWidget {
  final int number;
  final Item item;
  final bool expanded;
  final VoidCallback? onTap;

  final TextStyle? bodyStyle;
  final TextStyle? numberStyle;
  final TextStyle? additionalStyle;
  const _NumberedItem(
    this.number,
    this.item, {
    required this.expanded,
    required this.onTap,
    this.bodyStyle,
    this.numberStyle,
    this.additionalStyle,
  });

  TextStyle? adaptingStyle(BuildContext context, TextStyle? style) {
    // Only highlight items the user can actually toggle open.
    if (item.isExpandable && expanded) {
      return style?.copyWith(color: context.colorScheme.primary);
    }
    return style;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const .only(right: 32.0),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              crossAxisAlignment: .start,
              children: [
                Text(
                  "${number + 1}. ",
                  style: adaptingStyle(
                    context,
                    numberStyle ?? context.textTheme.displaySmall,
                  ),
                ),
                Expanded(
                  child: Text(
                    item.text,
                    style: adaptingStyle(
                      context,
                      bodyStyle ?? context.textTheme.displaySmall,
                    ),
                  ),
                ),
              ],
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: expanded
                  ? Padding(
                      padding: const .only(top: 8.0),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          for (final additional in item.additional ?? [])
                            Padding(
                              padding: const .fromLTRB(64, 4, 4, 4),
                              child: BulletItem(
                                additional,
                                style: adaptingStyle(
                                  context,
                                  additionalStyle ??
                                      context.textTheme.displaySmall,
                                ),
                              ),
                            ),
                        ],
                      ),
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      ),
    );
  }
}
