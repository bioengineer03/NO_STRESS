//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:no_stress/models/BPM.dart';
import 'package:no_stress/models/HR.dart';
import 'package:no_stress/models/Sleep.dart';
import 'package:no_stress/models/HRV.dart';
import 'package:no_stress/services/impact.dart';
import 'package:no_stress/utils/dati.dart';

class DataProvider extends ChangeNotifier {
  // Variabili di stato
  DateTime currentDate = DateTime.now();
  List<HR> heartRates = []; // lista dati HR
  List<Sleep> sleep = []; // lista dati sleep
  List<Map<String, dynamic>> hrvTrend =
      []; // lista di mappe con i dati HRV-time
  List<HRV> hrvList = []; // Lista degli HRV per il plot
  List<Map<String, dynamic>> bpmTrend = []; // Mappe per BPM time
  List<BPM> bpmList = []; // Lista degli BPM per il plot
  List<int> weekStressscore = [];
  List<DateTime> date_settimana = [];
  String name = "User"; // nome utente
  String surname = ""; // cognome utente

  double w1 = 0.35;
  double w2 = 0.25;
  double w3 = 0.20;
  double w4 = 0.30; // peso media BPM
  double w5 = 0.30;
  double stressscore = 0;
  String stress_score = "";
  int meanBPM = 0;

  final Impact impact = Impact(); // Inizializzo istanza impact

  DataProvider() {
    getDataOfDay(currentDate);
  }

  bool get loading {
    return stressscore < 0;
  }

  void getDataOfDay(DateTime date) async {
    _loading();
    currentDate = date;

    // Aggiungo un try e catch per evitare crush qual'ora non vengano presi
    //correttamente i dati del giorno
    
    try {
      heartRates = await impact.getHRdata(date);
    } catch (e) {
      print("Errore durante il recupero dei dati HR: $e");
      heartRates = [];
    }
    try {
      sleep = await impact.getSleepdata(date);
    } catch (e) {
      print("Errore durante il recupero dei dati Sleep: $e");
      sleep = [];
    }
    
    /*
    // Ho creato una lista che raccoglie i valori di stress score di tutta la settimana
    for (int i = 0; i < 7; i++) {
      DateTime data = date.subtract(Duration(days: i));
      try {
        heartRates = await impact.getHRdata(data);
      } catch (e) {
        heartRates = [];
      }
      try {
        sleep = await impact.getSleepdata(data);
      } catch (e) {
        sleep = [];
      }
      stressscore_temp = _calculateStressScore(heartRates, sleep);
      weekStressscore.add(stressscore);
    }
    */
    
    stressscore = _calculateStressScore(heartRates, sleep);
    meanBPM = _meanBPM(heartRates);

    hrvTrend = _getHRVTrend(
      heartRates,
    ); // ritorna la lista di mappe con i dati HRV-time creata sotto
    hrvList = hrvTrend.map((e) => HRV(time: e['time'], hrv: e['hrv'])).toList();

    bpmTrend = _getBpmTrend(
      heartRates,
    ); // ritorna la lista di mappe con i dati BPM-time creata sotto
    bpmList =
        bpmTrend.map((e) => BPM(tempo: e['time'], bpm: e['bpm'])).toList();

    notifyListeners();
  }

  void _loading() {
    heartRates = [];
    sleep = [];
    stressscore = -1;
    notifyListeners();
  }

  double _calculateStressScore(List<HR> hr, List<Sleep> sleep) {
    // Indica il numero di volte che ha dormito durante il giorno
    // Ovvero corrisponde al numero di oggetti Sleep che abbiamo dentro la lista sleep
    var lengthHR = hr.length;
    var lengthSleep = sleep.length;
    if (lengthHR == 0 && lengthSleep == 0) {
      return -1;
    } else {
      int meanBpm = Dati.meanBpm(hr);
      double efficiency = Dati.getEfficiency(sleep);
      // Normalizza BPM: 40 bpm = 0 (rilassato), 100 bpm = 1 (stress alto)
      double bpmNorm = ((meanBpm - 50) / 60).clamp(0.0, 1.0);
      double inefficiency = (1 - efficiency).clamp(0.0, 1.0);

      double w1 = 0.5;
      double w2 = 0.5;

      //return (100*(w1*meanBpm + w2*(1-efficiency))).round().clamp(0,100);
      stress_score = (100 * (w1 * bpmNorm + w2 * inefficiency)).toStringAsFixed(2);
      return double.parse(stress_score).clamp(0, 100);
    }
  }

  int _meanBPM(List<HR> hr) {
    return Dati.meanBpm(hr).round();
  }

  void addDay() {
    currentDate = currentDate.add(Duration(days: 1));
    getDataOfDay(currentDate);

    notifyListeners();
  }

  void subtractDay() {
    currentDate = currentDate.subtract(Duration(days: 1));
    getDataOfDay(currentDate);
    notifyListeners();
  }

  void updateStressScore(double change) {
    stressscore = (stressscore + change).clamp(0, 100);
    notifyListeners(); // Notifica i listener (come HomePage) del cambiamento
  }

  List<Map<String, dynamic>> _getHRVTrend(
    List<HR> heartRates, {
    Duration window = const Duration(minutes: 20),
  }) {
    if (heartRates.length < 2) return [];

    List<Map<String, dynamic>> hrvTrend = [];

    // Ordina i dati per tempo
    heartRates.sort((a, b) => a.time.compareTo(b.time));

    DateTime start = heartRates.first.time;
    DateTime end = heartRates.last.time;

    while (start.isBefore(end)) {
      DateTime windowEnd = start.add(window);
      List<HR> windowHRs =
          heartRates
              .where(
                (hr) => hr.time.isAfter(start) && hr.time.isBefore(windowEnd),
              )
              .toList();

      if (windowHRs.length >= 2) {
        double hrv = Dati.calculateSDNN(windowHRs);
        hrvTrend.add({'time': start, 'hrv': hrv});
      }
      start = windowEnd;
    }
    return hrvTrend;
  }

  List<Map<String, dynamic>> _getBpmTrend(
    List<HR> heartRates, {
    Duration window = const Duration(minutes: 20),
  }) {
    if (heartRates.length < 2) return [];

    // Ordina per tempo
    heartRates.sort((a, b) => a.time.compareTo(b.time));

    DateTime start = heartRates.first.time;
    DateTime end = heartRates.last.time;

    List<Map<String, dynamic>> bpmTrend = [];

    while (start.isBefore(end)) {
      DateTime windowEnd = start.add(window);

      // Filtra HR in questa finestra
      List<HR> windowHRs =
          heartRates
              .where(
                (hr) => hr.time.isAfter(start) && hr.time.isBefore(windowEnd),
              )
              .toList();

      if (windowHRs.isNotEmpty) {
        double avgBpm =
            windowHRs.map((hr) => hr.value).reduce((a, b) => a + b) /
            windowHRs.length;
        bpmTrend.add({'time': start, 'bpm': avgBpm});
      }
      start = windowEnd;
    }
    return bpmTrend;
  }
}

