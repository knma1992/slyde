import 'package:flutter/material.dart';
import 'package:slyde/context_extensions.dart';
import 'package:slyde/widgets/item.dart';

/// Renders an [ItemGroup] as a recursively expandable list.
///
/// Each group lays out as a two-column table: the leading (number, bullet, or
/// an [Item.label]) in a shared, auto-sized column, the text next to it — so
/// labels of different lengths still align like a definition list.
///
/// Items with [Item.additional] expand on tap to reveal their nested group;
/// expanding one item collapses its siblings, and every nesting level runs
/// its own accordion. Items with [Item.alwaysShow] render their nested group
/// permanently and aren't clickable, as are items without additional content.
class ItemList extends StatelessWidget {
  final ItemGroup group;

  const ItemList({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    return _GroupView(group, depth: 0);
  }
}

/// One level of the list. Holds the accordion state for its own items only;
/// nested groups are separate [_GroupView]s with their own state.
class _GroupView extends StatefulWidget {
  final ItemGroup group;
  final int depth;

  /// Styles of the enclosing group, inherited when this group doesn't set
  /// its own — so styles set once at the root flow through all levels.
  final TextStyle? inheritedBodyStyle;
  final TextStyle? inheritedLeadingStyle;
  const _GroupView(
    this.group, {
    required this.depth,
    this.inheritedBodyStyle,
    this.inheritedLeadingStyle,
  });

  TextStyle? get leadingStyle => group.leadingStyle ?? inheritedLeadingStyle;

  @override
  State<_GroupView> createState() => _GroupViewState();
}

class _GroupViewState extends State<_GroupView> {
  int? expandedIndex;

  void _onItemTapped(int index) {
    setState(() {
      // Expanding one item closes any sibling that was open.
      expandedIndex = expandedIndex == index ? null : index;
    });
  }

  TextStyle? _baseStyle(BuildContext context) {
    return widget.group.bodyStyle ??
        widget.inheritedBodyStyle ??
        context.textTheme.displaySmall;
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: IntrinsicColumnWidth(), // shrinks to the widest leading
        1: FlexColumnWidth(), // takes remaining space
      },
      children: [
        for (final (index, item) in widget.group.items.indexed)
          _buildRow(context, index, item),
      ],
    );
  }

  TableRow _buildRow(BuildContext context, int index, Item item) {
    final expanded = item.alwaysShow || expandedIndex == index;
    final onTap = item.isExpandable ? () => _onItemTapped(index) : null;
    final style = _baseStyle(context);

    // Only highlight items the user can actually toggle open.
    TextStyle? adapt(TextStyle? style) => item.isExpandable && expanded
        ? style?.copyWith(color: context.colorScheme.primary)
        : style;

    final leadingStyle = widget.leadingStyle ?? style;
    final leading =
        item.label ??
        switch (widget.group.leading) {
          .number => "${index + 1}.",
          .bullet => "•",
          .none => "",
        };

    // Table has no row spacing, so space rows via bottom padding.
    final isLast = index == widget.group.items.length - 1;
    final bottomPadding = isLast ? 0.0 : (widget.depth == 0 ? 16.0 : 8.0);

    Widget tappable(Widget child) => MouseRegion(
      cursor: onTap != null ? SystemMouseCursors.click : MouseCursor.defer,
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: child,
      ),
    );

    return TableRow(
      children: [
        tappable(
          Padding(
            padding: .only(right: 12.0, bottom: bottomPadding),
            child: Text(leading, textAlign: .right, style: adapt(leadingStyle)),
          ),
        ),
        tappable(
          Padding(
            padding: .only(right: 32.0, bottom: bottomPadding),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                Text(item.text, style: adapt(style)),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: expanded && item.hasAdditional
                      ? Padding(
                          padding: const .only(top: 8.0),
                          child: _GroupView(
                            item.additional!,
                            depth: widget.depth + 1,
                            inheritedBodyStyle: style,
                            inheritedLeadingStyle: widget.leadingStyle,
                          ),
                        )
                      : const SizedBox(width: double.infinity),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
