import 'package:intl/intl.dart';

class HR{
  /* Definisce una classe HR con due campi:
  - time: la data e ora della misurazione (DateTime)
  - value: il valore della frequenza cardiaca (int)
  */
  final DateTime time;
  final int value;

  HR({required this.time, required this.value});
  /* Costruttore standard con parametri nominati. 
  Crea un oggetto HR a partire da una data time e un valore value.
  */

  // Costruttore fromJson che permette di creare un oggetto HR da una struttura JSON.
  /* - date è una stringa in formato "yyyy-MM-dd" (es. "2024-06-01")
     - json["time"] è l'orario nel giorno (es. "14:30:00")
     - La DateFormat costruisce un DateTime combinando le due stringhe ("2024-06-01 14:30:00").
     - json["value"] è un numero, rappresentato come stringa, che viene convertito in int.
  */
  HR.fromJson(String date, Map<String, dynamic> json) :
      time = DateFormat('yyyy-MM-dd HH:mm:ss').parse('$date ${json["time"]}'),
      value = json["value"];
  
  /*
  @override
  String toString() {
    return 'HR(time: $time, value: $value)';
  }//toString
  */
  
}//HR

