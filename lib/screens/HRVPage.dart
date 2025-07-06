import 'package:flutter/material.dart';
import 'package:no_stress/models/HRV.dart';
import 'package:no_stress/utils/HRVChart.dart';
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
              Text('Average HRV: $meanHRV (ms)\nData calculated every 20 minutes',
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

