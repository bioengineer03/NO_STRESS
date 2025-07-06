import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:no_stress/models/HRV.dart';

class HRVChart extends StatelessWidget {
  final List<HRV> data;

  const HRVChart({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat.Hm(), // visualizza solo ore:minuti
        intervalType: DateTimeIntervalType.hours,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: 'RR peaks (ms)'),
        minimum: 0,
        maximum: 200,
        // puoi settare max se vuoi
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <CartesianSeries>[
        LineSeries<HRV, DateTime>(
          dataSource: data,
          xValueMapper: (HRV hrv, _) => hrv.time,
          yValueMapper: (HRV hrv, _) => hrv.hrv,
          markerSettings: MarkerSettings(isVisible: true),
          color: Color(0xFF1E6F50),
          name: 'HRV',
        )
      ],
    );
  }
}