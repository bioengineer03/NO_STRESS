import 'package:flutter/material.dart';
import 'dart:math';

class MiniGamePage extends StatefulWidget {
  @override
  _MiniGamePageState createState() => _MiniGamePageState();
}

class _MiniGamePageState extends State<MiniGamePage> {
  int score = 0;
  Offset targetPosition = Offset(100, 100);
  final double targetSize = 60;
  final Random random = Random();

  void moveTarget() {
    final width = MediaQuery.of(context).size.width - targetSize;
    final height = MediaQuery.of(context).size.height - targetSize - 100; // to avoid app bar

    setState(() {
      targetPosition = Offset(
        random.nextDouble() * width,
        random.nextDouble() * height,
      );
    });
  }

  void onTap() {
    setState(() {
      score++;
      moveTarget();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    moveTarget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Relax Game')),
      body: Stack(
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                child: Text(
                  'Score: $score',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                ),
              ],
            ),
          ),
          Positioned(
            top: targetPosition.dy,
            left: targetPosition.dx,
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                width: targetSize,
                height: targetSize,
                decoration: BoxDecoration(
                  color: Color(0xFF1E6F50),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}