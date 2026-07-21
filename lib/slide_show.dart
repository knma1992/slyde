import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:window_manager/window_manager.dart';

class SlideShow extends StatefulWidget {
  const SlideShow({super.key, required this.slides});

  final List<Widget> slides;

  @override
  State<SlideShow> createState() => _SlideShowState();
}

class _SlideShowState extends State<SlideShow> {
  int _index = 0;
  double _scale = 1.0;
  bool _titleBarVisible = true;

  // Nav-button hover state.
  bool _navVisible = false;
  Timer? _hideTimer;

  final _focusNode = FocusNode();
  final _controller = TransformationController();

  bool get _isFirst => _index == 0;
  bool get _isLast => _index == widget.slides.length - 1;

  @override
  void dispose() {
    _hideTimer?.cancel();
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _next() => setState(() {
    if (!_isLast) _index++;
  });

  void _previous() => setState(() {
    if (!_isFirst) _index--;
  });

  void _increaseScale() =>
      setState(() => _scale = (_scale + 0.04).clamp(0.5, 2.0));

  void _decreaseScale() =>
      setState(() => _scale = (_scale - 0.04).clamp(0.5, 2.0));

  void _resetScale() => setState(() => _scale = 1.0);

  // --- Input ---------------------------------------------------------------
  Future<void> _onKeyEvent(KeyEvent event) async {
    final key = event.logicalKey;
    final isDown = event is KeyDownEvent;

    if (event.character == '+') {
      _increaseScale();
    } else if (event.character == '-') {
      _decreaseScale();
    } else if (isDown && key == LogicalKeyboardKey.keyH) {
      _titleBarVisible = !_titleBarVisible;
      await windowManager.setTitleBarStyle(
        _titleBarVisible ? TitleBarStyle.normal : TitleBarStyle.hidden,
      );
    } else if (isDown && key == LogicalKeyboardKey.arrowLeft) {
      _previous();
    } else if (isDown && key == LogicalKeyboardKey.arrowRight) {
      _next();
    } else if (isDown && key == LogicalKeyboardKey.space) {
      _resetScale();
    }
  }

  void _showNav() {
    _hideTimer?.cancel();
    setState(() => _navVisible = true);
  }

  void _hideNavSoon() {
    _hideTimer = Timer(const Duration(seconds: 1), () {
      if (mounted) setState(() => _navVisible = false);
    });
  }

  // --- Build ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) {
        _onKeyEvent(event);
        return KeyEventResult.ignored;
      },
      // Scale a fixed 1920-wide design canvas to fit the window.
      child: LayoutBuilder(
        builder: (context, constraints) {
          final designWidth = 1920 / _scale;
          final aspectRatio = constraints.maxWidth / constraints.maxHeight;
          // On 16:9 this equals 1080/scale; on taller screens it grows.
          final designHeight = (designWidth / aspectRatio).clamp(
            1080 / _scale,
            double.infinity,
          );

          return Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: FittedBox(
              fit: BoxFit.contain,
              alignment: Alignment.center,
              child: ClipRect(
                child: SizedBox(
                  width: designWidth,
                  height: designHeight,
                  child: Scaffold(
                    body: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(32, 20, 32, 16),
                        child: InteractiveViewer(
                          transformationController: _controller,
                          child: widget.slides[_index],
                        ),
                      ),
                    ),
                    bottomNavigationBar: _buildNavBar(context),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Hover-reveal navigation controls.
        MouseRegion(
          onEnter: (_) => _showNav(),
          onExit: (_) => _hideNavSoon(),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: _navVisible ? 1.0 : 0.0,
            child: IgnorePointer(
              ignoring: !_navVisible,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  spacing: 16,
                  mainAxisAlignment: .center,
                  children: [
                    IconButton.filled(
                      onPressed: _isFirst ? null : _previous,
                      icon: const Icon(Icons.arrow_back),
                    ),
                    Text(
                      '${_index + 1} / ${widget.slides.length}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    IconButton.filled(
                      onPressed: _isLast ? null : _next,
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Always-visible slide number in the bottom-right corner.
        Positioned(
          right: 24,
          child: Text(
            '${_index + 1}',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      ],
    );
  }
}
