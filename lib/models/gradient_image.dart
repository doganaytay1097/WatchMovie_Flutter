import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:watch_list/providers/color_theme_data.dart';

class GradientImage extends StatelessWidget {
  final String imagePath;
  

  GradientImage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final colorthemedata = Provider.of<ColorThemeData>(context);
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return  LinearGradient(
          colors: colorthemedata.gradientColors,
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