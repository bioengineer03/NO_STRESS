import 'package:flutter/material.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/screens/LoginPage.dart';
import 'package:no_stress/utils/impact.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mi visualizza il logo dell'applicazione per 3 secondi
    // Chiama il metodo _checkLogin che verifica l'autenticazione dell'utente
    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
    return Scaffold(
        body: Center(
            child: Image.asset(
              'assets/images/logo.png',
            scale: 6,
            )
          )
        );
  } // build

  // Metodo per navigazione da SplashScreen a HomePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  } 

  // Metodo per navigazione da SplashScreen a LoginPage
  void _toLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  } 
  // Method for checking if the user has still valid tokens
  // If yes, navigate to ExposurePage, if not, navigate to LoginPage
  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  } //_checkLogin  
}

