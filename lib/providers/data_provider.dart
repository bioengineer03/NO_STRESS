//import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:no_stress/models/HR.dart';
import 'package:no_stress/models/Sleep.dart';
import 'package:no_stress/utils/impact.dart';
import 'package:no_stress/utils/dati.dart';



class DataProvider extends ChangeNotifier {
  // Variabili di stato
  DateTime currentDate = DateTime.now();
  List<HR> heartRates = []; // lista dati HR
  List<Sleep> sleep = []; // lista dati sleep
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
    heartRates = await impact.getHRdata(date);
    sleep = await impact.getSleepdata(date);
    
    stressscore = _calculateStressScore(heartRates,sleep);
    meanBPM = _meanBPM(heartRates);
    
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
    double w1 = 0.4;
    double w2 = 0.6;

    return (100*(w1*meanBpm.clamp(0,150) + w2*(1-efficiency.clamp(0.0, 1.0)))).round().clamp(0, 100);

  }

  int _meanBPM(List<HR> hr){
    return Dati.meanBpm(hr).round();
  }
  
  void addDay() {
    currentDate = currentDate.add(Duration(days: 1));
    //getDataOfDay(currentDate);
    notifyListeners();
  }
  
  void subtractDay() {
    currentDate = currentDate.subtract(Duration(days: 1));
    //getDataOfDay(currentDate);
    notifyListeners();
  }

  void updateStressScore(int change) {
    stressscore = (stressscore + change).clamp(0, 100);
    notifyListeners(); // Notifica i listener (come HomePage) del cambiamento
  }

}

