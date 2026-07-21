import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:markdown_widget/config/configs.dart';
import 'package:markdown_widget/widget/blocks/leaf/code_block.dart';
import 'package:markdown_widget/widget/markdown_block.dart';

const double _markdownTextScale = 1.2;

class MarkdownWidgetBlock extends StatefulWidget {
  final String assetPath;
  const MarkdownWidgetBlock({super.key, required this.assetPath});

  @override
  State<MarkdownWidgetBlock> createState() => _MarkdownWidgetBlockState();
}

class _MarkdownWidgetBlockState extends State<MarkdownWidgetBlock> {
  // Loaded once and cached, so rebuilds don't re-read the asset.
  late Future<String> _markdown;

  @override
  void initState() {
    super.initState();
    _markdown = rootBundle.loadString(widget.assetPath);
  }

  @override
  void didUpdateWidget(MarkdownWidgetBlock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _markdown = rootBundle.loadString(widget.assetPath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _markdown,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(_markdownTextScale)),
          child: MarkdownBlock(config: markdownConfig, data: snapshot.data!),
        );
      },
    );
  }
}

final markdownConfig = MarkdownConfig.darkConfig.copy(
  configs: [
    PreConfig.darkConfig.copy(
      theme: zedOneDarkTheme,
      decoration: const BoxDecoration(
        color: Color(0xff1e1e1e),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    ),
  ],
);

const zedOneDarkTheme = {
  'root': TextStyle(
    backgroundColor: Color(0x1e1e1eff),
    color: Color(0xFFABB2BF),
  ),
  'keyword': TextStyle(color: Color(0xFFC678DD)),
  'built_in': TextStyle(color: Color(0xFFE5C07B)),
  'type': TextStyle(color: Color(0xFFE5C07B)),
  'literal': TextStyle(color: Color(0xFFD19A66)),
  'number': TextStyle(color: Color(0xFFD19A66)),
  'string': TextStyle(color: Color(0xFF98C379)),
  'comment': TextStyle(color: Color(0xFF5C6370), fontStyle: FontStyle.italic),
  'function': TextStyle(color: Color(0xFF61AFEF)),
  'class': TextStyle(color: Color(0xFFE5C07B)),
  'attr': TextStyle(color: Color(0xFFD19A66)),
  'params': TextStyle(color: Color(0xFFABB2BF)),
  'punctuation': TextStyle(color: Color(0xFFABB2BF)),
  'meta': TextStyle(color: Color(0xFF61AFEF)),
  'title': TextStyle(color: Color(0xFF61AFEF)),
  'section': TextStyle(color: Color(0xFFE06C75)),
  'addition': TextStyle(color: Color(0xFF98C379)),
  'deletion': TextStyle(color: Color(0xFFE06C75)),
  'selector-class': TextStyle(color: Color(0xFFE5C07B)),
  'selector-id': TextStyle(color: Color(0xFF61AFEF)),
  'subst': TextStyle(color: Color(0xFFE06C75)),
  'symbol': TextStyle(color: Color(0xFF56B6C2)),
};
