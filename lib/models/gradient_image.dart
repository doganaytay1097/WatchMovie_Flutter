import 'package:flutter/material.dart';

class GradientImage extends StatelessWidget {
  final String imagePath;

  GradientImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return const LinearGradient(
          colors: [
            Color(0xffFF204E),
            Color(0xffA0153E),
            Color(0xff5D0E41),
            Color(0xff00224D),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Image.asset(
        imagePath,
        height: 180,
      ),
    );
  }
}