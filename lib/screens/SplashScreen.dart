import 'package:flutter/material.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/screens/LoginPage.dart';
import 'package:no_stress/screens/OnBoardingPage.dart';
import 'package:no_stress/services/impact.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mi visualizza il logo dell'applicazione per 3 secondi
    // Chiama il metodo _checkOnboardingAndLogin che verifica se l'Onboarding è già stata visualizzata e l'autenticazione dell'utente
    Future.delayed(const Duration(seconds: 3), () => _checkOnboardingAndLogin(context));
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          width: 150,
          height: 150,
        )
      )
    );
  } // build

  // Metodo privato per navigazione da SplashScreen a HomePage
  void _toHomePage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  } 

  // Metodo privato per navigazione da SplashScreen a LoginPage
  void _toLoginPage(BuildContext context) {
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: ((context) => LoginPage())));
  } 
  // Metodo privato che controlla se l'utente ha completato l'onboarding
  void _toOnboardingPage(BuildContext context) { // Nuovo metodo per la navigazione all'onboarding
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => const OnboardingScreen()));
  }
  
  // Metodo privato che controlla se è stato fatto il login oppure no
  /*void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  } //_checkLogin  */
  void _checkOnboardingAndLogin(BuildContext context) async {
    final sp = await SharedPreferences.getInstance();
    final onboardingCompleted = sp.getBool('onboarding_completed') ?? false; // Prende lo stato dell'onboarding

    if (!onboardingCompleted) {
      _toOnboardingPage(context); // Se l'onboarding non è stato completato, vai alla pagina di onboarding
    } else {
      // Se l'onboarding è stato completato, procedi con il controllo del login
      final result = await Impact().refreshTokens();
      if (result == 200) {
        _toHomePage(context);
      } else {
        _toLoginPage(context);
      }
    }
  }
}

