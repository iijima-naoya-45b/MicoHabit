import 'package:flutter/material.dart';

class ColorPalette extends StatelessWidget {
  const ColorPalette({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const <Widget>[
        ColorCircle(color: Colors.green, label: 'プライマリー', code: '#2D7D32'),
        ColorCircle(color: Colors.blue, label: 'セカンダリー', code: '#1976D2'),
        ColorCircle(color: Colors.orange, label: 'アクセント', code: '#FF8F00'),
      ],
    );
  }
}

class ColorCircle extends StatelessWidget {
  const ColorCircle({
    super.key,
    required this.color,
    required this.label,
    required this.code,
  });

  final Color color;
  final String label;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        CircleAvatar(radius: 40, backgroundColor: color),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(code, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
