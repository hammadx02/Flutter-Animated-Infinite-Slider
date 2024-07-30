import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vice_app/core/shared/domain/entities/magazine.dart';
import 'package:vice_app/core/shared/presentation/widgets/magazine_cover_image.dart';

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

class _InfiniteDragableSliderState extends State<InfiniteDragableSlider> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        4,
        (stackIndex) {
          return Transform.translate(
            offset: Offset(-70, 30),
            child: Transform.scale(
              scale: 0.6,
              child: Transform.rotate(
                angle: -pi * 0.1,
                child: MagazineCoverImage(
                  magazine: Magazine.fakeMagazinesValues[0],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
