import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:no_stress/models/HR.dart';

class HRChart extends StatelessWidget {
  final List<HR> data;
  // data corrisponde alla lista di oggetti HR

  HRChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: Text('Nessun dato disponibile'));
    }

    // Ordino i dati per time, per sicurezza
    data.sort((a, b) => a.time.compareTo(b.time));

    // Mappo il tempo in secondi dall'inizio del primo dato (per scala x)
    final DateTime startTime = data.first.time;
    List<FlSpot> spots = data.map((hr) {
      final diffSeconds = hr.time.difference(startTime).inSeconds.toDouble();
      return FlSpot(diffSeconds, hr.value.toDouble());
    }).toList();

    // Formatter per asse X (tempo)
    String formatTime(double seconds) {
      final DateTime time = startTime.add(Duration(seconds: seconds.toInt()));
      return DateFormat.Hms().format(time);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: spots.last.x,
          minY: 0,
          maxY: (data.map((e) => e.value).reduce((a, b) => a > b ? a : b) * 1.2),
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: (spots.last.x / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(formatTime(value), style: TextStyle(fontSize: 10)),
                    );
                  },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(value.toInt().toString(), style: TextStyle(fontSize: 10));
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: Colors.red,
              barWidth: 3,
              dotData: FlDotData(show: true),
            )
          ],
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
        ),
      ),
    );
  }
}