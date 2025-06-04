import 'package:flutter/material.dart';
import 'package:no_stress/models/onboarding_content.dart';
import 'package:no_stress/models/onboarding_page.dart';
import 'package:no_stress/models/onboard_button.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Importa la tua home screen
// import 'package:your_app_name/screens/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  List<OnboardingContent> onboardingPages = [
    OnboardingContent(
      title: 'Welcome to NoStress',
      description: 'Your journey to well-being starts here. We help you monitor and understand your stress levels, day by day.',
      imagePath: 'assets/images/undraw_yoga_i399.png',
      
    ),
    OnboardingContent(
      title: 'Track stress, sleep, and heart rate',
      description: 'NoStress analyzes your sleep and heart rate data to give you a personalized daily stress score.',
      imagePath: 'assets/images/undraw_organizing-data_uns9.png',
    ),
    OnboardingContent(
      title: 'Check in with yourself',
      description: 'Answer a short daily questionnaire. Your stress score adjusts to your emotional state, not just your physiological data.',
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

  void _onGetStartedPressed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
    // Naviga alla tua Home Screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomePage(), // Sostituisci con la tua HomeScreen
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingPages.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return OnboardingPage(content: onboardingPages[index]);
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingPages.length,
                      (index) => buildDot(index, context),
                    ),
                  ),
                  const SizedBox(height: 30),
                  OnboardButton(
                    text: _currentPage == onboardingPages.length - 1
                        ? 'Start'
                        : 'Next',
                    onPressed: () {
                      if (_currentPage == onboardingPages.length - 1) {
                        _onGetStartedPressed();
                      } else {
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
        color: _currentPage == index ? Theme.of(context).primaryColor : Colors.grey,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}