import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vice_app/core/shared/domain/entities/magazine.dart';
import 'package:vice_app/core/shared/presentation/widgets/magazine_cover_image.dart';

class InfiniteDragableSlider extends StatelessWidget {
  const InfiniteDragableSlider({
    super.key,
  });

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

