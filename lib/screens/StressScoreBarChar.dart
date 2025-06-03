import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class StressScoreBarChart extends StatelessWidget {
  final List<int> stressScores; // 7 valori
  final DateTime today;

  const StressScoreBarChart({
    super.key,
    required this.stressScores,
    required this.today,
  });

  @override
  Widget build(BuildContext context) {
    List<String> weekDays = List.generate(7, (index) {
      final day = today.subtract(Duration(days: 6 - index));
      return DateFormat.E().format(day); // 'Mon', 'Tue', etc.
    });

    return AspectRatio(
      aspectRatio: 1.3,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 100, // assuming stress score is out of 100
          barTouchData: BarTouchData(enabled: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 32),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt();
                  if (index < 0 || index >= weekDays.length) return const SizedBox();
                  return Text(
                    weekDays[index],
                    style: const TextStyle(fontSize: 12),
                  );
                },
                reservedSize: 32,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(stressScores.length, (index) {
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: stressScores[index].toDouble(),
                  color: Colors.blueAccent,
                  width: 18,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}