import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_list/providers/color_theme_data.dart';

class GradientText extends StatelessWidget {
  final String textPath;

  GradientText({required this.textPath});

  @override
  Widget build(BuildContext context) {
    final colorthemedata = Provider.of<ColorThemeData>(context);
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: colorthemedata.gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcATop,
      child: Text(textPath,
      style: const TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
      ),
    );
  }
}