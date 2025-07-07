import 'dart:math';
import 'package:no_stress/models/HR.dart';
import 'package:no_stress/models/Sleep.dart';


class Dati {
  // Metodo che restituisce la media dei battiti cardiaci
  static int meanBpm(List<HR> heartrates) {
    if (heartrates.isEmpty) {
      return 0; // nessun problema perchè nella formula è al numeratore
    }else{
      int sommaBpm = 0;
    for (HR heartrate in heartrates) {
      sommaBpm += heartrate.value;
    }
    return (sommaBpm / heartrates.length).round(); // Valore di media dei battiti cardiaci
    }
  }

  static double getEfficiency(List<Sleep> sleep){
    if (sleep.isEmpty){
      return 0;
    }else{
      double tempoTotaleSonno = 0;
      double tempoTotaleLetto = 0;
      double duration = 0;
      double sommaDuration = 0;
      double sommaMinutestofallasleep = 0;
      double sommaMinutesafterwakeup = 0;
      double minutesAfterWakeUp = 0;
      double minutesToFallAsleep = 0;
      List valueDuration = [];
      List valueMinutestofallasleep = [];
      List valueMinutesafterwakeup = [];
      for (Sleep s in sleep){
        valueDuration.add(s.duration);
        sommaDuration = sommaDuration + s.duration;
        duration = (sommaDuration/(valueDuration.length))/1000;
        valueMinutestofallasleep.add(s.minutesToFallAsleep);
        sommaMinutestofallasleep = sommaMinutestofallasleep + s.minutesToFallAsleep;
        minutesToFallAsleep = (sommaMinutestofallasleep/(valueMinutestofallasleep.length))*60;
        valueMinutesafterwakeup.add(s.minutesAfterWakeUp);
        sommaMinutesafterwakeup = sommaMinutesafterwakeup + s.minutesAfterWakeUp;
        minutesAfterWakeUp = (sommaMinutesafterwakeup/(valueMinutesafterwakeup.length))*60;
      }
      tempoTotaleSonno = duration;
      tempoTotaleLetto = duration + minutesToFallAsleep + minutesAfterWakeUp;
      return (tempoTotaleSonno)/(tempoTotaleLetto);
    }
  }

  //Il metodo _calculateSDNN calcola la SDNN (Standard Deviation of NN intervals), 
  //un parametro usato comunemente in ambito Heart Rate Variability (HRV) 
  //per valutare la variabilità della frequenza cardiaca.
  static double calculateSDNN(List<HR> hrList) {
    List<double> rrList = hrList.map((hr) => 60000 / hr.value).toList();
    double mean = rrList.reduce((a, b) => a + b) / rrList.length;
    double variance =
        rrList.map((rr) => pow(rr - mean, 2)).reduce((a, b) => a + b) /
        rrList.length;
    return sqrt(variance);
  }
}