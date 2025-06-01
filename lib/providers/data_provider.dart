//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:no_stress/models/HR.dart';
import 'package:no_stress/models/Sleep.dart';
import 'package:no_stress/utils/impact.dart';
import 'package:no_stress/utils/dati.dart';
import 'dart:math';



class DataProvider extends ChangeNotifier {
  // Variabili di stato
  DateTime currentDate = DateTime.now();
  List<HR> heartRates = []; // lista dati HR
  List<Sleep> sleep = []; // lista dati sleep
  List<Map<String, dynamic>> hrvTrend = []; // lista di mappe con i dati HRV-time
  List<HRV> hrvList = []; // Lista degli HRV per il plot
  List<Map<String, dynamic>> bpmTrend = []; // Mappe per BPM time
  List<BPM> bpmList = []; // Lista degli BPM per il plot
  String name = "User"; // nome utente
  String surname = ""; // cognome utente

  double w1 = 0.35;
  double w2 = 0.25;
  double w3 = 0.20;
  double w4 = 0.30; // peso media BPM
  double w5 = 0.30;
  int stressscore = 0;
  int meanBPM = 0;

  final Impact impact = Impact(); // Inizializzo istanza impact
  
  DataProvider(){
    getDataOfDay(currentDate);
  }

  bool get loading {
    return stressscore < 0;
  }

  void getDataOfDay(DateTime date) async{
    _loading();
    currentDate = date;

    // Aggiungo un try e catch per evitare crush qual'ora non vengano presi 
    //correttamente i dati del giorno
    try{
      heartRates = await impact.getHRdata(date);
    } catch(e){
      print("Errore durante il recupero dei dati HR: $e");
      heartRates = [];
    }
    try{
      sleep = await impact.getSleepdata(date);
    } catch(e){
      print("Errore durante il recupero dei dati Sleep: $e");
      sleep = [];
    }
    
    
    stressscore = _calculateStressScore(heartRates,sleep);
<<<<<<< HEAD
    meanBPM = _meanBPM(heartRates);
    
=======
    hrvTrend = _getHRVTrend(heartRates); // ritorna la lista di mappe con i dati HRV-time creata sotto
    hrvList = hrvTrend.map((e) => HRV(time: e['time'], hrv: e['hrv'])).toList();

    bpmTrend = _getBpmTrend(heartRates); // ritorna la lista di mappe con i dati BPM-time creata sotto
    bpmList = bpmTrend.map((e) => BPM(tempo: e['time'], bpm: e['bpm'])).toList();
>>>>>>> 60227a3 (no_stress TOMMY 1/06/25)
    notifyListeners();
  }
  
  void _loading(){
    heartRates =[];
    sleep = [];
    stressscore = -1;
    notifyListeners();
  }

  int _calculateStressScore(List<HR> hr,List<Sleep> sleep){
    // Indica il numero di volte che ha dormito durante il giorno
    // Ovvero corrisponde al numero di oggetti Sleep che abbiamo dentro la lista sleep
    int meanBpm = Dati.meanBpm(hr);
    double efficiency = Dati.getEfficiency(sleep);
     // Normalizza BPM: 40 bpm = 0 (rilassato), 100 bpm = 1 (stress alto)
    double bpmNorm = ((meanBpm - 40) / 60).clamp(0.0, 1.0);
    double inefficiency = (1 - efficiency).clamp(0.0, 1.0);

    double w1 = 0.4;
    double w2 = 0.6;

<<<<<<< HEAD
    return (100*(w1*meanBpm.clamp(0,150) + w2*(1-efficiency.clamp(0.0, 1.0)))).round().clamp(0, 100);

=======
    //return (100*(w1*meanBpm + w2*(1-efficiency))).round().clamp(0,100);
    return (100 * (w1 * bpmNorm + w2 * inefficiency)).round().clamp(0, 100);
>>>>>>> 60227a3 (no_stress TOMMY 1/06/25)
  }

  int _meanBPM(List<HR> hr){
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

  void updateStressScore(int change) {
    stressscore = (stressscore + change).clamp(0, 100);
    notifyListeners(); // Notifica i listener (come HomePage) del cambiamento
  }

  List<Map<String, dynamic>> _getHRVTrend(List<HR> heartRates, {Duration window = const Duration(minutes: 20)}) {
    if (heartRates.length < 2) return [];

    List<Map<String, dynamic>> hrvTrend = [];

    // Ordina i dati per tempo
    heartRates.sort((a, b) => a.time.compareTo(b.time));

    DateTime start = heartRates.first.time;
    DateTime end = heartRates.last.time;

    while (start.isBefore(end)) {
      DateTime windowEnd = start.add(window);
      List<HR> windowHRs = heartRates.where((hr) => hr.time.isAfter(start) && hr.time.isBefore(windowEnd)).toList();

      if (windowHRs.length >= 2) {
        double hrv = _calculateSDNN(windowHRs);
        hrvTrend.add({
          'time': start,
          'hrv': hrv,
        });
      }
      start = windowEnd;
    }
    return hrvTrend;
  }

  double _calculateSDNN(List<HR> hrList) {
    List<double> rrList = hrList.map((hr) => 60000 / hr.value).toList();
    double mean = rrList.reduce((a, b) => a + b) / rrList.length;
    double variance = rrList.map((rr) => pow(rr - mean, 2)).reduce((a, b) => a + b) / rrList.length;
    return sqrt(variance);
  }

  List<Map<String, dynamic>> _getBpmTrend(List<HR> heartRates, {Duration window = const Duration(minutes: 20)}) {
    if (heartRates.length < 2) return [];

    // Ordina per tempo
    heartRates.sort((a, b) => a.time.compareTo(b.time));

    DateTime start = heartRates.first.time;
    DateTime end = heartRates.last.time;

    List<Map<String, dynamic>> bpmTrend = [];

    while (start.isBefore(end)) {
      DateTime windowEnd = start.add(window);

      // Filtra HR in questa finestra
      List<HR> windowHRs = heartRates.where((hr) =>
        hr.time.isAfter(start) && hr.time.isBefore(windowEnd)
      ).toList();

      if (windowHRs.isNotEmpty) {
        double avgBpm = windowHRs.map((hr) => hr.value).reduce((a, b) => a + b) / windowHRs.length;
        bpmTrend.add({
          'time': start,
          'bpm': avgBpm,
        });
      }
      start = windowEnd;
    }
    return bpmTrend;
  }
 
}

class HRV {
  final DateTime time;
  final double hrv;

  HRV({required this.time, required this.hrv});
}

class BPM {
  final DateTime tempo;
  final double bpm;

  BPM({required this.tempo, required this.bpm});
}

