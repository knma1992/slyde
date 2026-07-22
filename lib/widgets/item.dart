class Item {
  final String text;
  final List<String>? additional;
  final bool alwaysShow;
  const Item(this.text, {this.additional, this.alwaysShow = false});

  /// Whether this item has any additional content to reveal.
  bool get hasAdditional => additional?.isNotEmpty ?? false;

  /// Tappable only when there is additional content to reveal and it isn't
  /// already forced open via [alwaysShow].
  bool get isExpandable => hasAdditional && !alwaysShow;
}
