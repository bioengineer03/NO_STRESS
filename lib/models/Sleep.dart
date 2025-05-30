import 'package:intl/intl.dart';
// Questa classe ha lo scopo di generare una lista simulata di dati
// di frequenza cardiaca per ogni ora di una giornata
class Sleep{
  // Variabili
  // Consideriamo le tre variabili appartenenti al dizionario data della tipologia di dati sleep
  //final DateTime time; // ora di inizio --> La tolgo perchè tanto a me interessa solo la giornata, che è il campo date,
  // fuori dalla seconda componente data
  final DateTime data;
  final double duration; // durata totale del sonno in ms
  final double minutesAwake; //minuti svegli
  final double minutesAsleep; //minuti in cui dorme
  final double minutesToFallAsleep;
  final double minutesAfterWakeUp;

  Sleep({required this.data,required this.duration,required this.minutesAwake, required this.minutesAsleep, required this.minutesToFallAsleep,required this.minutesAfterWakeUp});

  Sleep.fromJson(String date, Map<String, dynamic> json):
    data = DateFormat('yyyy-MM-dd').parse(date),
    duration = (json["duration"] as num).toDouble(),
    minutesAwake = (json["minutesAwake"] as num).toDouble(),
    minutesAsleep = (json["minutesAsleep"] as num).toDouble(),
    minutesToFallAsleep = (json["minutesToFallAsleep"] as num).toDouble(),
    minutesAfterWakeUp = (json["minutesAfterWakeUp"] as num).toDouble();

  /*
  @override
  String toString() {
    return 'Sleep(duration: $duration, minutesAwake:$minutesAwake, minutesAsleep: $minutesAsleep,minutesToFallAsleep: $minutesToFallAsleep, minutesAfterWakeUp: $minutesAfterWakeUp )';
  }//toString
  */
}//Sleep

