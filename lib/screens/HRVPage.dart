import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:no_stress/providers/data_provider.dart';
import 'package:statistics/statistics.dart';

class HRVPage extends StatelessWidget {
  final List<HRV> hrvData;
  
  const HRVPage({required this.hrvData, super.key});

  @override
  Widget build(BuildContext context) {

    final meanHRV = hrvData.isNotEmpty
      ? hrvData.map((b) => b.hrv).mean.toStringAsFixed(1)
      : '--';
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(title: Text('Trend HRV')),
      body: SingleChildScrollView(
        child: Column(
            children: [
              // Grafico che occupa tutta l'altezza dello schermo
              SizedBox(
                height: screenHeight*0.7,
                child: HRVChart(data: hrvData),
              ),
              SizedBox(height: 20),
              Text('Valore medio di HRV: $meanHRV (ms)\nDati calcolati ogni 20 minuti',
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
        title: AxisTitle(text: 'SDNN (ms)'),
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



class HealthStatCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const HealthStatCard({
    Key? key,
    required this.title,
    required this.subtitle,
    this.value,
    required this.icon,
    this.color = Colors.green,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, size: 32, color: color),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text(subtitle,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                  ],
                ),
              ),
              if (value != null) 
                Text(
                  value!,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
                ),
              SizedBox(width: 8),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}