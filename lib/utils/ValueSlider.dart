import 'package:flutter/material.dart';

class ValueSlider extends SliderComponentShape {
  final double thumbRadius;
  final String value;

  ValueSlider({this.thumbRadius = 10.0, required this.value});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size(thumbRadius * 2, thumbRadius * 3);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Disegna il cerchio del thumb
    final Paint paint = Paint()..color = sliderTheme.thumbColor ?? Color(0xFF1E6F50);
    canvas.drawCircle(center, thumbRadius, paint);

    // Disegna il testo sopra il thumb
    final TextSpan span = TextSpan(
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
      text: this.value,
    );
    final TextPainter tp = TextPainter(
      text: span,
      textAlign: TextAlign.center,
      textDirection: textDirection,
    );
    tp.layout();

    final Offset textCenter = Offset(center.dx - tp.width / 2, center.dy - thumbRadius - tp.height - 12);
    tp.paint(canvas, textCenter);
  }
}

