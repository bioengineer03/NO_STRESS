import 'package:flutter/material.dart';
import 'package:no_stress/models/BPM.dart';
import 'package:no_stress/utils/BPMChart.dart';
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



