import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:no_stress/models/HR.dart';
import 'package:no_stress/models/Sleep.dart';
import 'package:no_stress/screens/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';


class Impact{
  // Variabili statistiche, ustae per costruire gli URL delle richieste HTTP verso l'API
  static String baseUrl = 'https://impact.dei.unipd.it/bwthw/';
  static String pingEndpoint = 'gate/v1/ping/';
  static String tokenEndpoint = 'gate/v1/token/';
  static String refreshEndpoint = 'gate/v1/refresh/';

  static String heartrateEndpoint = 'data/v1/heart_rate/patients/';
  static String sleepEndpoint = 'data/v1/sleep/patients/';

  //static String username = 'gMQWqcZXKO';
  //static String password = '12345678!';

  static String patientUsername = 'Jpefaq6m58';
  
  /// ------ Metodi -------
  // Metodo AUTHORIZE (asincrono): ottiene il JWT Token da Impact e lo salva in Shared_Preferences
  Future<int?> authorize(String username,String password) async {
    // Richiesta
    final url = Impact.baseUrl + Impact.tokenEndpoint;
    final body = {'username': username, 'password': password};

    //Risposta
    print('Calling: $url');
    final response = await http.post(Uri.parse(url), body: body);

    //Se la risposta è 200 (OK), viene salvato in Shared_Preferences il token
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body); // decodifico la risposta
      final sp = await SharedPreferences.getInstance(); // Salvo tutto in Shared_Preferences
      sp.setString('access', decodedResponse['access']);
      sp.setString('refresh', decodedResponse['refresh']);
    } //if

    //Ritorna lo statusCode
    return response.statusCode;
  }

  // Metodo REFRESHTOKENS
  // Aggiorna il token di accesso usando il refresh token salvato localmente
  Future<int> refreshTokens() async {
    //Create the request
    final url = Impact.baseUrl + Impact.refreshEndpoint;
    // Ottiene il refresh token da SharedPreferences
    final sp = await SharedPreferences.getInstance();
    final refresh = sp.getString('refresh');

    // Primo controllo su refresh è se esiste, quindi se ho già fatto Login con authorize
    if (refresh != null) {
      final body = {'refresh': refresh};
      //Get the response
      print('Calling: $url');
      // Se esiste, invia una richiesta POST all’endpoint /refresh/
      final response = await http.post(Uri.parse(url), body: body);

      // Se la risposta è 200 OK, aggiorna entrambi i token (access e refresh) localmente
      if (response.statusCode == 200) {
        // access token scaduto, refresh token non scaduto
        final decodedResponse = jsonDecode(response.body);
        final sp = await SharedPreferences.getInstance();
        await sp.setString('access', decodedResponse['access']);
        await sp.setString('refresh', decodedResponse['refresh']);
      }else{
        // access token e refresh token scaduto
        final sp = await SharedPreferences.getInstance();
        await sp.remove('access');
        await sp.remove('refresh');
      }
      //if

      //Ritorna lo status code HTTP della risposta
      return response.statusCode;
    }
    // Se il refresh token non esiste, ritorna 401 (Unauthorized).
    return 401;
  }

  // Metodo HRrequestdata
  Future<List<HR>> getHRdata(DateTime date) async {
    //Initialize the result
    List<HR> result = [];

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    var refresh = sp.getString('refresh');

    //If access token is expired, refresh it
    // Passiamo al token di access il metodo isExpired (pacchetto jwt_decoder)
    // Punto esclamativo su access token perchè potrebbe non esserci
    if(JwtDecoder.isExpired(access!)){
      // ACCESS TOKEN SCADUTO --> valuto il REFRESH TOKEN che mi permette di generare il nuovo access token
      // Attenzione!! Verificare se REFRESH TOKEN E' SCADUTO oppure NO
      if (JwtDecoder.isExpired(refresh!)){
        // ACCESS & REFRESH TOKEN SCADUTI ---> Logout e torno alla LoginPage
        final sp = await SharedPreferences.getInstance();
        await sp.remove('access');
        await sp.remove('refresh'); 
        MaterialPageRoute(builder: ((context) => LoginPage()));
      }else{
        // Caso in cui il refresh token non è scaduto!
        await refreshTokens();
        access = sp.getString('access');
      }
    }//if
    // NON ENTRO NELL'IF SOPRA NEL MOMENTO IN CUI IL MIO ACCESS TOKEN NON E' SCADUTO

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    //Create the (representative) request
    final url = '${Impact.baseUrl}${Impact.heartrateEndpoint}${Impact.patientUsername}/day/$formattedDate/';
    // HttpHeaders = serve per fare una chiamata autenticata (la importo sopra con import 'dart:io')
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
      /*
      print(decodedResponse['data']['date']);
      print(decodedResponse['data']['date'][0]);
      print(decodedResponse['data']['date'][0].runtimeType);
      */
      final dateStr = decodedResponse['data']['date'][0];  // CORRETTO: estrai la stringa data
      // In Body di Response c'è un campo dato dal dizionario data di heartrate, costituito da coppie tempo-valore
      // Solo due valori, perchè abbiamo costruito HR in modo da prendere solo tempo e valore di bpm (confidence) non ci serve

      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        result.add(HR.fromJson(dateStr, decodedResponse['data']['data'][i]));
      }//for
    } //if

    //Return the result
    return result;
  } //getHRdata

  // Metodo Sleeprequestdata
  Future<List<Sleep>> getSleepdata(DateTime date) async {
    //Initialize the result
    List<Sleep> result = [];

    //Get the stored access token (Note that this code does not work if the tokens are null)
    final sp = await SharedPreferences.getInstance();
    var access = sp.getString('access');
    var refresh = sp.getString('refresh');

    //If access token is expired, refresh it
    // Passiamo al token di access il metodo isExpired (pacchetto jwt_decoder)
    // Punto esclamativo su access token perchè potrebbe non esserci
    if(JwtDecoder.isExpired(access!)){
      // ACCESS TOKEN SCADUTO --> valuto il REFRESH TOKEN che mi permette di generare il nuovo access token
      // Attenzione!! Verificare se REFRESH TOKEN E' SCADUTO oppure NO
      if (JwtDecoder.isExpired(refresh!)){
        // Caso in cui il refresh token è scaduto --> occorre implementare lo stesso percorso fatto da authorize
        // Come "crittografare" username e password?
        // ----------------- DA FARE -------------------------
        final sp = await SharedPreferences.getInstance();
        await sp.remove('access');
        await sp.remove('refresh'); 
        MaterialPageRoute(builder: (context) => LoginPage());
          
      }else{
        // Caso in cui il refresh token non è scaduto!
        await refreshTokens();
        access = sp.getString('access');
      }
    }//if
    // NON ENTRO NELL'IF SOPRA NEL MOMENTO IN CUI IL MIO ACCESS TOKEN NON E' SCADUTO

    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    //Create the (representative) request
    final url = '${Impact.baseUrl}${Impact.sleepEndpoint}${Impact.patientUsername}/day/$formattedDate/';
    // HttpHeaders = serve per fare una chiamata autenticata (la importo sopra con import 'dart:io')
    final headers = {HttpHeaders.authorizationHeader: 'Bearer $access'};

    //Get the response
    print('Calling: $url');
    final response = await http.get(Uri.parse(url), headers: headers);
    
    //if OK parse the response, otherwise return null
    if (response.statusCode == 200) {
      final decodedResponse = jsonDecode(response.body);
<<<<<<< HEAD

      final dateStr = decodedResponse['data']['date'][0];  // CORRETTO
      // In Body di Response c'è un campo dato dal dizionario data di sleep, costituito da triplette datainiziosonno - livellosonno - secondisessione
=======
      
>>>>>>> 60227a3 (no_stress TOMMY 1/06/25)
      for (var i = 0; i < decodedResponse['data']['data'].length; i++) {
        result.add(Sleep.fromJson(dateStr, decodedResponse['data']['data'][i]));
      }//for
      
      // In Body di Response c'è un campo dato dal dizionario data di sleep, costituito da triplette datainiziosonno - livellosonno - secondisessione
    } 
    
    //Return the result
    return result;
  } //getSleepdata

}//Impact

  