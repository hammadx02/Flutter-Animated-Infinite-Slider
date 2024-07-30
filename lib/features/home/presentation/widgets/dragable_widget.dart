import 'package:flutter/material.dart';

enum SlideDirection { left, right }

class DragableWidget extends StatefulWidget {
  const DragableWidget({
    super.key,
    required this.child,
    this.onSlideOut,
    this.onPressed,
    required this.isEnableDrag,
  });

  final Widget child;
  final ValueChanged<SlideDirection>? onSlideOut;
  final VoidCallback? onPressed;
  final bool isEnableDrag;

  @override
  State<DragableWidget> createState() => _DragableWidgetState();
}

class _DragableWidgetState extends State<DragableWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController restoreController;

  final _widgetKey = GlobalKey();
  Offset startOffset = Offset.zero;
  Offset panOffset = Offset.zero;
  double angle = 0;

  @override
  void initState() {
    restoreController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration);
    super.initState();
  }

  @override
  void dispose() {
    restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        setState(() {
          startOffset = details.globalPosition;
        });
      },
      onPanUpdate: (details) {
        setState(() {
          panOffset = details.globalPosition - startOffset;
        });
      },
      child: Transform.translate(
        offset: panOffset,
        child: widget.child,
      ),
    );
  }
}
