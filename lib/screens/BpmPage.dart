import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:no_stress/providers/data_provider.dart';
import 'package:statistics/statistics.dart';
//import 'package:no_stress/screens/HRVPage.dart';

class BPMPage extends StatelessWidget {
  final List<BPM> bpmData;
  
  const BPMPage({required this.bpmData, super.key});

  @override
  Widget build(BuildContext context) {

    final meanBPM = bpmData.isNotEmpty
      ? bpmData.map((b) => b.bpm).mean.toStringAsFixed(1)
      : '--';
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Trend BPM')),
      body: SingleChildScrollView(
        child: Column(
            children: [
              // Grafico che occupa tutta l'altezza dello schermo
              SizedBox(
                height: screenHeight*0.7,
                child: BPMChart(data: bpmData),
              ),
              SizedBox(height: 20),
              Text('Valore medio del BPM: $meanBPM\nDati calcolati ogni 20 minuti',
                textAlign: TextAlign.center,
                style: const TextStyle(
                fontSize: 16,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(height: 20),
            ]
          ),
        )
    );
  }
}


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

