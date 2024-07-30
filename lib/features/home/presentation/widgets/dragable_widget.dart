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
  Widget build(BuildContext context) {
    return GestureDetector(
      child: widget.child,
    );
  }
}
