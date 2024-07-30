import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vice_app/features/home/presentation/widgets/dragable_widget.dart';

class InfiniteDragableSlider extends StatefulWidget {
  const InfiniteDragableSlider({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.index = 0,
  });

  final Function(BuildContext context, int index) itemBuilder;
  final int itemCount;
  final int index;

  @override
  State<InfiniteDragableSlider> createState() => _InfiniteDragableSliderState();
}

class _InfiniteDragableSliderState extends State<InfiniteDragableSlider>
    with SingleTickerProviderStateMixin {
  final double defaultAngle18Degree = -pi * 0.1;

  late AnimationController controller;
  late int index;
  Offset getOffset(int stackIndex) {
    return {
          0: Offset(0, 30),
          1: Offset(-70, 30),
          2: Offset(70, 30),
        }[stackIndex] ??
        Offset(0, 0);
  }

  double getAngle(int stackIndex) {
    return {
          0: 0.0,
          1: -defaultAngle18Degree,
          2: defaultAngle18Degree,
        }[stackIndex] ??
        0.0;
  }

  double getScale(int stackIndex) {
    return {
          0: 0.6,
          1: 0.9,
          2: 0.95,
        }[stackIndex] ??
        1.0;
  }

  void animationListener() {
    if (controller.isCompleted) {
      setState(() {
        // it help us make it infinite slide
        if (widget.itemCount == ++index) {
          index = 0;
        }
      });
      controller.reset();
    }
  }

  void onSlideOut(SlideDirection direction) {
    controller.forward();
  }

  @override
  void initState() {
    index = widget.index;
    controller =
        AnimationController(vsync: this, duration: kThemeAnimationDuration)
          ..addListener(animationListener);
    super.initState();
  }

  @override
  void dispose() {
    controller..removeListener(animationListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        4,
        (stackIndex) {
          final modIndex = (index + 3 - stackIndex) % widget.itemCount;
          return Transform.translate(
            offset: getOffset(stackIndex),
            child: Transform.scale(
              scale: getScale(stackIndex),
              child: Transform.rotate(
                angle: getAngle(stackIndex),
                child: DragableWidget(
                  onSlideOut: onSlideOut,
                  child: widget.itemBuilder(context, modIndex),
                  isEnableDrag: stackIndex == 3,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
