import 'dart:ui';

import 'package:flutter/material.dart';

class BlurImagePageScaffold extends StatelessWidget {
  const BlurImagePageScaffold({Key? key, this.imagePath, required this.body})
      : super(key: key);
  final body;
  final imagePath;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.fill),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.black.withOpacity(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: body,
          ),
        ),
      ),
    );
  }
}
