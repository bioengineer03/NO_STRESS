class Sleep{
  // Variabili
  final double duration; // durata totale del sonno in ms
  final double minutesAwake; //minuti svegli
  final double minutesAsleep; //minuti in cui dorme
  final double minutesToFallAsleep;
  final double minutesAfterWakeUp;

  Sleep({required this.duration,required this.minutesAwake, required this.minutesAsleep, required this.minutesToFallAsleep,required this.minutesAfterWakeUp});
  
  Sleep.fromJson(String date, Map<String, dynamic> json):
    //data = DateFormat('yyyy-MM-dd').parse(date),
    duration = (json["duration"] as num).toDouble(),
    minutesAwake = (json["minutesAwake"] as num).toDouble(),
    minutesAsleep = (json["minutesAsleep"] as num).toDouble(),
    minutesToFallAsleep = (json["minutesToFallAsleep"] as num).toDouble(),
    minutesAfterWakeUp = (json["minutesAfterWakeUp"] is num)
    ? (json["minutesAfterWakeUp"] as num).toDouble()
    : 0.0;
  
  /*
  @override
  String toString() {
    return 'Sleep(duration: $duration, minutesAwake:$minutesAwake, minutesAsleep: $minutesAsleep,minutesToFallAsleep: $minutesToFallAsleep, minutesAfterWakeUp: $minutesAfterWakeUp )';
  }//toString
  */
  
}//Sleep