import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:no_stress/models/BPM.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BPMChart extends StatelessWidget {
  final List<BPM> data;

  const BPMChart({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Hm(), // visualizza solo ore:minuti
        intervalType: DateTimeIntervalType.hours,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'BPM'),
        minimum: 30,
        maximum: 150,
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<BPM, DateTime>(
          dataSource: data,
          xValueMapper: (BPM bpm, _) => bpm.tempo,
          yValueMapper: (BPM bpm, _) => bpm.bpm,
          markerSettings: MarkerSettings(isVisible: true),
          color: Color(0xFF1E6F50),
          name: 'BPM',
        )
      ],
    );
  }
}