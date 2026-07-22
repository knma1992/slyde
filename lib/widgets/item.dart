import 'package:flutter/material.dart';

enum Leading { number, none, bullet }

/// A list of [Item]s plus the leading style they share.
///
/// The leading lives on the group, not the item, so every level of a nested
/// list decides its own marker: `ItemGroup(leading: .number, [...])`.
class ItemGroup {
  final List<Item> items;
  final Leading leading;

  /// Style for this group's item text; falls back to the enclosing group's
  /// body style, so setting it once at the root styles all nested levels.
  final TextStyle? bodyStyle;

  /// Style for this group's leadings — markers and [Item.label]s alike.
  /// Inherits from the enclosing group, then falls back to [bodyStyle].
  final TextStyle? leadingStyle;

  const ItemGroup(
    this.items, {
    this.leading = .bullet,
    this.bodyStyle,
    this.leadingStyle,
  });
}

class Item {
  final String text;

  /// Custom leading text for this item, replacing the group's [Leading]
  /// marker — e.g. `Item("fast", label: "Speed:")` for a labeled list.
  final String? label;

  /// Nested group revealed when this item is expanded. Groups nest
  /// arbitrarily deep — any item in [additional] may carry its own group.
  final ItemGroup? additional;
  final bool alwaysShow;
  const Item(this.text, {this.label, this.additional, this.alwaysShow = false});

  /// Whether this item has any additional content to reveal.
  bool get hasAdditional => additional?.items.isNotEmpty ?? false;

  /// Tappable only when there is additional content to reveal and it isn't
  /// already forced open via [alwaysShow].
  bool get isExpandable => hasAdditional && !alwaysShow;
}
