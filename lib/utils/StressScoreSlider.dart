import 'package:flutter/material.dart';
import 'package:no_stress/utils/ValueSlider.dart';

class StressScoreSlider extends StatelessWidget {
  final int stressScore;

  const StressScoreSlider({super.key, required this.stressScore});

  @override
  Widget build(BuildContext context) {
    double value = stressScore.toDouble().clamp(0, 100);
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Color(0xFF1E6F50),
        inactiveTrackColor: Color(0xFF1E6F50),
        trackHeight: 6,
        thumbShape: ValueSlider(value: stressScore.toString()),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 14),
        thumbColor: Color(0xFF1E6F50),
      ),
      child: Slider(
        value: value,
        min: 0,
        max: 100,
        divisions: 100,
        onChanged: null, // Disabilitato, solo lettura
      ),
    );
  }
}