import 'package:flutter/material.dart';
import 'dart:math' as math;

class ProgressWithIcon extends StatefulWidget {
  const ProgressWithIcon({super.key});

  @override
  ProgressWithIconState createState() => ProgressWithIconState();
}

class ProgressWithIconState extends State<ProgressWithIcon> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001) // Perspective
            // ..rotateX(_controller.value * 2.0 * math.pi) // X-axis rotation
            // 1.0,
            ..rotateY(_controller.value * 6.0 * math.pi), // Y-axis rotation
          child: Container(
            width: 200,
            height: 200,
            child: Image.asset('assets/venus_profile.png'),
          ),
        );
      },
    );
  }
}
