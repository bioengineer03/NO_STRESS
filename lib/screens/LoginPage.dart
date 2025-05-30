import 'package:flutter/material.dart';
import 'package:no_stress/screens/OnBoarding.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/utils/impact.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Variabili
  // Inizializzo text controllers per verificare username e password inseriti
  final TextEditingController userController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> obscurePassword = ValueNotifier<bool>(true);
  final Impact impact = Impact();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      // Si può usare se vogliamo fare vedere solo la scritta NoStress
      //appBar: AppBar(
       // title: Text("No Stress",style: GoogleFonts.inter(
         //     fontSize: 50,
           //   fontWeight: FontWeight.w600,
           //   color: Color(0xFFF5ECD8),
           // ),),
        //backgroundColor: Color(0xFF1E6F50),
        //centerTitle: true, // Centra il titolo dell'AppBar // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Logo
            Image.asset('images/logo.png',height: 100),
            const SizedBox(
              height: 40,
              ),
            const Text(
              'Welcome',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30,color: Color(0xFF1E6F50)),
            ),
            Padding(
              padding:EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                controller: userController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius:BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Color(0xFF1E6F50), width: 1.7),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: BorderSide(color: Color(0xFF1E6F50), width: 2.0),
                  ),
                  labelText: 'Username',
                  floatingLabelStyle: TextStyle(color: Color(0xFF1E6F50)),
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(color: Color(0xFF4E5D6A)),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                ),
                style: TextStyle(color: Color.fromARGB(255, 16, 18, 17)),
              ),
            ),
            Padding(
              padding:const EdgeInsets.only(left: 15.0, right: 15.0, top: 15, bottom: 15),
              child: ValueListenableBuilder<bool>(
                valueListenable: obscurePassword,
                builder: (context, value, _) {
                  return TextField(
                    obscureText: value,
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(value ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => obscurePassword.value = !value,
                      ),
                      floatingLabelStyle: TextStyle(color: Color(0xFF1E6F50)),
                      hintText: 'Enter Password',
                      hintStyle: TextStyle(color: Color(0xFF4E5D6A)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Color(0xFF1E6F50), width: 1.7),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                        borderSide: BorderSide(color: Color(0xFF1E6F50), width: 2.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              height:50,
              width: 250,
              decoration:BoxDecoration(
                borderRadius: BorderRadius.circular(20)
                ),
              child: ElevatedButton(
                onPressed: () async {
                  // check if credentials are correct
                  // Recupera username e passowrd dai controller
                  final result = await impact.authorize(userController.text, passwordController.text);
                    // If correct, store the username and password in SharedPreferences
                    // and navigate to the Exposure screen (pushReplacement to remove the login screen from the stack)
                    if (result == 200) {
                      // Sen è riuscito salva le credenziali in shared preferences
                      final sp = await SharedPreferences.getInstance();
                      await sp.setString('username', userController.text);
                      await sp.setString('password', passwordController.text);

                      // Verifica se l'onboarding è stato completato e naviga in base al risultato
                      // Se non è stato completato naviga nella pagina di onboarding
                      final onboardingCompleted = sp.getBool('onboarding_completed');
                      if(onboardingCompleted == null || onboardingCompleted == false){
                        Navigator.pushReplacement(
                        // ignore: use_build_context_synchronously
                        context,
                        MaterialPageRoute(
                          builder: (context) => Onboarding(),
                        ),
                      );
                      // Se è stato completato, va direttamente nella HomePage
                      }
                      else{
                        Navigator.pushReplacement(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HomePage(),
                          ),
                        );
                      }
                      // Se le credenziali sono errate, viene mostrato un messaggio di errore tramite un SnackBar
                      }else{
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                        ..removeCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          backgroundColor: Colors.red,
                          behavior: SnackBarBehavior.floating,
                          margin: EdgeInsets.all(8),
                          duration: Duration(seconds: 2),
                          content: Text('Username or Password incorrect')));
                      } 
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E6F50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const Spacer(),
            const Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "By logging in, you agree to NoStress's\nTerms & Conditions and Privacy Policy",
                style: TextStyle(fontSize: 12),
              )
            ),
          ],
        ),
      ),
    );
  }
}