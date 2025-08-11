import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedBrandLogo extends StatefulWidget {
  const AnimatedBrandLogo({super.key});

  @override
  _AnimatedBrandLogoState createState() => _AnimatedBrandLogoState();
}

class _AnimatedBrandLogoState extends State<AnimatedBrandLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2.0 * pi,
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: List.generate(8, (index) {
                final angle = (pi / 4) * index;
                return Transform(
                  transform: Matrix4.identity()
                    ..translate(50 * cos(angle), 50 * sin(angle)),
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: index % 2 == 0
                        ? Colors.green
                        : Colors.blue,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'MicroHabit',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
