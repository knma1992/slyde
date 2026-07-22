import 'package:flutter/material.dart';
import 'package:slyde/slyde.dart';

Future<void> main() async {
  await initSlideShowWindow(title: 'Slyde Example');
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final slydeTheme = SlydeTheme(ThemeData.dark().textTheme);
    return MaterialApp(
      title: 'Slyde Example',
      debugShowCheckedModeBanner: false,
      theme: slydeTheme.light(),
      darkTheme: slydeTheme.dark(),
      home: const SlideShow(
        slides: [
          _TitleSlide(),
          _StyledTextSlide(),
          _BulletSlide(),
          _ExpandableSlide(),
          _LabeledSlide(),
          _ProsConsSlide(),
          _MarkdownSlide(),
        ],
      ),
    );
  }
}

/// Styled texts, centered — a typical opening slide.
class _TitleSlide extends StatelessWidget {
  const _TitleSlide();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 24,
        children: [
          HighlightText("Slyde"),
          NormalText("Presentations as plain Flutter widgets"),
          SmallText("→ / ← navigate · + / − zoom · Space reset · H title bar"),
        ],
      ),
    );
  }
}

/// The four text widgets side by side.
class _StyledTextSlide extends StatelessWidget {
  const _StyledTextSlide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        Headline(highlight: "Styled ", rest: "text"),
        Expanded(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 24,
            children: [
              AlertText("AlertText shouts in the error color"),
              HighlightText("HighlightText pops in the primary color"),
              NormalText("NormalText carries the regular content"),
              SmallText("SmallText for footnotes and asides"),
            ],
          ),
        ),
      ],
    );
  }
}

/// BulletList — the simple, static shorthand.
class _BulletSlide extends StatelessWidget {
  const _BulletSlide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        Headline(highlight: "Bullet", rest: "List"),
        BulletList(
          items: [
            "Just a list of strings",
            "One shared style, no interaction",
            "Sugar over ItemList under the hood",
          ],
        ),
        SizedBox(height: 32),
        BulletItem("BulletItem renders a single row"),
      ],
    );
  }
}

/// ItemList — click an item to expand it; siblings collapse automatically,
/// and nesting recurses (sub-items can expand too).
class _ExpandableSlide extends StatelessWidget {
  const _ExpandableSlide();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: .start,
      children: [
        Headline(highlight: "ItemList ", rest: "— click around"),
        ItemList(
          group: ItemGroup(leading: .number, [
            Item(
              "Expandable — click me",
              additional: ItemGroup([
                Item("Revealed on click"),
                Item(
                  "This one nests even deeper",
                  additional: ItemGroup(leading: .number, [
                    Item("Every level runs its own accordion"),
                  ]),
                ),
              ]),
            ),
            Item(
              "Also expandable — I collapse my sibling",
              additional: ItemGroup([
                Item("Only one open per level"),
              ]),
            ),
            Item("No additional content, so not clickable"),
            Item(
              "alwaysShow keeps its content pinned",
              alwaysShow: true,
              additional: ItemGroup([
                Item("Always visible, never clickable"),
              ]),
            ),
          ]),
        ),
      ],
    );
  }
}

/// Labels replace the group marker per item — a definition list.
class _LabeledSlide extends StatelessWidget {
  const _LabeledSlide();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Headline(highlight: "Labels ", rest: "align in a column"),
        ItemList(
          group: ItemGroup(
            leadingStyle: context.textTheme.displaySmall?.copyWith(
              color: context.colorScheme.primary,
            ),
            const [
              Item("Custom leading text per item", label: "label:"),
              Item("Auto-sized to the widest label", label: "column:"),
              Item(
                "Labeled items can expand too",
                label: "bonus:",
                additional: ItemGroup([
                  Item("Everything composes"),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Two static groups with per-level styles — the classic pros/cons slide.
class _ProsConsSlide extends StatelessWidget {
  const _ProsConsSlide();

  @override
  Widget build(BuildContext context) {
    final header = context.textTheme.displayLarge?.copyWith(
      color: context.colorScheme.primary,
    );
    return Column(
      crossAxisAlignment: .start,
      children: [
        const Headline(highlight: "Styles ", rest: "inherit per group"),
        ItemList(
          group: ItemGroup(
            leading: .none,
            bodyStyle: header,
            [
              Item(
                "Pros:",
                alwaysShow: true,
                additional: ItemGroup(
                  bodyStyle: context.textTheme.displaySmall,
                  const [
                    Item("Group styles flow into nested groups"),
                    Item("Any level can override for its subtree"),
                  ],
                ),
              ),
              Item(
                "Cons:",
                alwaysShow: true,
                additional: ItemGroup(
                  bodyStyle: context.textTheme.displaySmall,
                  const [
                    Item("You may never open a slide tool again"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Markdown from an asset. Implements [NonZoomableSlide] so the mouse wheel
/// scrolls the content instead of zooming the slide.
class _MarkdownSlide extends StatelessWidget implements NonZoomableSlide {
  const _MarkdownSlide();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: MarkdownWidgetBlock(assetPath: 'assets/demo.md'),
    );
  }
}
