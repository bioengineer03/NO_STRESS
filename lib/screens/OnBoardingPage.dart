import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_stress/models/onboarding_content.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:no_stress/utils/onboarding_page.dart';
import 'package:no_stress/widgets/onboard_button.dart';
import 'package:no_stress/utils/last_onboarding_content.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final TextEditingController _user_nameController = TextEditingController();
  // Variabile per il sesso selezionato
  String? _selectedGender;

  List<OnboardingContent> onboardingPages = [
    OnboardingContent(
      title: 'Welcome to NoStress',
      description:
          'Your journey to well-being starts here. We help you monitor and understand your stress levels, day by day.',
      imagePath: 'assets/images/undraw_yoga_i399.png',
    ),
    OnboardingContent(
      title: 'Track stress, sleep, and heart rate',
      description:
          'NoStress analyzes your sleep and heart rate data to give you a personalized daily stress score.',
      imagePath: 'assets/images/undraw_organizing-data_uns9.png',
    ),
    OnboardingContent(
      title: 'Check in with yourself',
      description:
          'Answer a short daily questionnaire. Your stress score adjusts to your emotional state, not just your physiological data.',
      imagePath: 'assets/images/undraw_to-do-list_eoia.png',
    ),
    OnboardingContent(
      title: "Let's personalize your experience",
      description: 'Your journey starts here – tell us your name',
      imagePath: 'assets/images/undraw_engineering-team_13ax.png',
    ),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _navigateToHome() async {
    final sp = await SharedPreferences.getInstance();
    await sp.setBool('onboarding_completed', true);
    // Naviga alla tua Home Screen
    if (_currentPage == onboardingPages.length - 1) {
      if (_user_nameController.text.isNotEmpty) {
        await sp.setString('user_name', _user_nameController.text);
      }
      if (_selectedGender != null) {
        await sp.setString('userGender', _selectedGender!);
      }
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  void dispose() {
    _user_nameController
        .dispose(); // Libera il controller quando il widget viene distrutto
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView per le schermate scorrevoli
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              // Se è l'ultima pagina, mostra il widget con gli input
              if (index == onboardingPages.length - 1) {
                return LastOnboardingPageContent(
                  content: onboardingPages[index],
                  nameController: _user_nameController,
                  selectedGender: _selectedGender,
                  onGenderChanged: (String? newValue) {
                    setState(() {
                      _selectedGender = newValue;
                    });
                  },
                );
              }
              // Altrimenti, mostra la pagina di onboarding standard
              return OnboardingPage(content: onboardingPages[index]);
            },
          ),
          // Pulsante "Salta" (Skip) in alto a destra
          Positioned(
            top: 20,
            right: 20,
            child: TextButton(
              onPressed: _navigateToHome, // Salta direttamente alla home
              child: Text(
                'Skip',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w500,
                  fontSize: 19,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          // Controlli in basso (indicatori e pulsante)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Row per i puntini indicatori
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Pulsante "Avanti" o "Inizia"
                  OnboardButton(
                    text:
                        _currentPage == onboardingPages.length - 1
                            ? 'Start' // Testo per l'ultima pagina
                            : 'Next', // Testo per le pagine precedenti
                    onPressed: () {
                      if (_currentPage == onboardingPages.length - 1) {
                        _navigateToHome(); // Se è l'ultima pagina, avvia l'app
                      } else {
                        // Altrimenti, vai alla pagina successiva
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeIn,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: _currentPage == index ? Color(0xFF1E6F50) : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
