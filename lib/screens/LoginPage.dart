import 'package:flutter/material.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/screens/OnBoardingPage.dart';
import 'package:no_stress/services/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; 

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Variabili
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  final Impact impact = Impact();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24.0,
          ), // margini laterali per tutta la pagina
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset('assets/images/logo.png', scale: 7),
              const SizedBox(height: 20),
              // Logo
              Text(
                'Welcome',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 30,
                  color: Color(0xFF1E6F50),
                ),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: TextField(
                  controller: userController,
                  style: GoogleFonts.poppins(
                    color: const Color.fromARGB(255, 16, 18, 17),
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Color(0xFF1E6F50),
                        width: 1.7,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide(
                        color: Color(0xFF1E6F50),
                        width: 2.0,
                      ),
                    ),
                    labelText: 'Username',
                    labelStyle: GoogleFonts.poppins(
                      color: const Color(0xFF1E6F50),
                    ),
                    floatingLabelStyle: GoogleFonts.poppins(
                      color: Color(0xFF1E6F50),
                    ),
                    hintText: 'Enter your username',
                    hintStyle: GoogleFonts.poppins(color: Color(0xFF1E6F50)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  right: 15.0,
                  top: 15,
                  bottom: 15,
                ),
                child: ValueListenableBuilder<bool>(
                  valueListenable: obscurePassword,
                  builder: (context, value, _) {
                    return TextField(
                      obscureText: value,
                      controller: passwordController,
                      style: GoogleFonts.poppins(
                        color: const Color.fromARGB(255, 16, 18, 17),
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: GoogleFonts.poppins(
                          color: const Color(0xFF1E6F50),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            value ? Icons.visibility_off : Icons.visibility,
                          ),
                          onPressed: () => obscurePassword.value = !value,
                        ),
                        floatingLabelStyle: GoogleFonts.poppins(
                          color: Color(0xFF1E6F50),
                        ),
                        hintText: 'Enter Password',
                        hintStyle: GoogleFonts.poppins(
                          color: Color(0xFF1E6F50),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 18,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Color(0xFF1E6F50),
                            width: 1.7,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(
                            color: Color(0xFF1E6F50),
                            width: 2.0,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton(
                  onPressed: () async {
                    final sp = await SharedPreferences.getInstance();
                    // (1) CASO IN CUI STO FACENDO LOGIN DOPO LOGOUT
                    if (sp.getString('username') != null) {
                      if (userController.text == sp.getString('username')) {
                        // Caso in cui fa login con credenziale username giusta
                        final result = await impact.authorize(
                          userController.text,
                          passwordController.text,
                        );
                        if (result == 200) {
                          // Verifica se l'onboarding è stato completato e naviga in base al risultato
                          // Se non è stato completato naviga nella pagina di onboarding
                          final onboardingCompleted = sp.getBool(
                            'onboarding_completed',
                          );
                          if (onboardingCompleted == null ||
                              onboardingCompleted == false) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OnboardingScreen(),
                              ),
                            );
                            // Se è stato completato, va direttamente nella HomePage
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          }
                        // Se le credenziali sono errate, viene mostrato un messaggio di errore tramite un SnackBar
                        } else {
                          ScaffoldMessenger.of(context)
                            ..removeCurrentSnackBar()
                            ..showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.red,
                                behavior: SnackBarBehavior.floating,
                                margin: EdgeInsets.all(8),
                                duration: Duration(seconds: 2),
                                content: Text(
                                  'Password incorrect',
                                  style: TextStyle(fontFamily: 'Poppins'),
                                ),
                              ),
                            );
                        }
                      } else {
                        // Caso in cui fa login con credenziale username sbagliata
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(8),
                              duration: Duration(seconds: 2),
                              content: Text(
                                'Username incorrect',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          );
                      }
                    } else {
                      // non ho username salvati in Shared Preferences
                      // (2) PRIMA VOLTA CHE FACCIO LOGIN
                      final result = await impact.authorize(
                        userController.text,
                        passwordController.text,
                      );
                      if (result == 200) {
                        // Se è riuscito salva le credenziali in shared preferences
                        final sp = await SharedPreferences.getInstance();
                        await sp.setString('username', userController.text);
                        await sp.setString('password', passwordController.text);
                        // Dato che è la prima volta va nell'onboarding
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OnboardingScreen(),
                          ),
                        );
                      // Se le credenziali sono errate, viene mostrato un messaggio di errore tramite un SnackBar
                      } else {
                        ScaffoldMessenger.of(context)
                          ..removeCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(8),
                              duration: Duration(seconds: 2),
                              content: Text(
                                'Username or Password incorrect',
                                style: TextStyle(fontFamily: 'Poppins'),
                              ),
                            ),
                          );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    textStyle: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  child: Text(
                    'Login',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 100),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  "By logging in, you agree to NoStress's\nTerms & Conditions and Privacy Policy",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
