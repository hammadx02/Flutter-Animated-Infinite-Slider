import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  Size size = Size.zero;
  double angle = 0;

  bool itWasMadeSlide = false;

  double get outSizeLimit => size.width * 0.65;

  void onPanStart(DragStartDetails details) {
    if (!restoreController.isAnimating) {
      setState(() {
        startOffset = details.globalPosition;
      });
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    if (!restoreController.isAnimating) {
      setState(() {
        panOffset = details.globalPosition - startOffset;
      });
    }
  }

  void onPanEnd(DragEndDetails details) {
    if (restoreController.isAnimating) {
      return;
    }
    final velocitX = details.velocity.pixelsPerSecond.dx;
    final positionX = currentPosition.dx;

    if (velocitX < -1000 || positionX < outSizeLimit) {
      widget.onSlideOut?.call(SlideDirection.left);
      print('Slide left');
    }
    restoreController.forward();
  }

  void restoreAnimationListner() {
    if (restoreController.isCompleted) {
      restoreController.reset();
      panOffset = Offset.zero;
      setState(() {});
    }
  }

  void getChildSize() {
    size =
        (_widgetKey.currentContext?.findRenderObject() as RenderBox?)?.size ??
            Size.zero;
  }

  Offset get currentPosition {
    final renderBox =
        _widgetKey.currentContext?.findRenderObject() as RenderBox?;
    return renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
  }

  @override
  void initState() {
    restoreController =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(restoreAnimationListner);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getChildSize();
    });
    super.initState();
  }

  @override
  void dispose() {
    restoreController
      ..removeListener(restoreAnimationListner)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final child = SizedBox(
      key: _widgetKey,
      child: widget.child,
    );
    if (!widget.isEnableDrag) return child;
    return GestureDetector(
      onPanStart: onPanStart,
      onPanUpdate: onPanUpdate,
      onPanEnd: onPanEnd,
      child: AnimatedBuilder(
        animation: restoreController,
        builder: (context, child) {
          final value = 1 - restoreController.value;
          return Transform.translate(
            offset: panOffset * value,
            child: child,
          );
        },
      ),
    );
  }
}
