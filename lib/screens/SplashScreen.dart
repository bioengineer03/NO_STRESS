import 'package:flutter/material.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/screens/LoginPage.dart';
import 'package:no_stress/services/impact.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () => _checkLogin(context));
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
  
  // Metodo privato che controlla se è stato fatto il login oppure no
  void _checkLogin(BuildContext context) async {
    final result = await Impact().refreshTokens();
    if (result == 200) {
      _toHomePage(context);
    } else {
      _toLoginPage(context);
    }
  } //_checkLogin  
}

