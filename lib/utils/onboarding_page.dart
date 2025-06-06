import 'package:flutter/material.dart';
import 'package:no_stress/models/onboarding_content.dart';
// import 'package:your_app_name/utils/app_styles.dart'; // Per stili globali

class OnboardingPage extends StatelessWidget {
  final OnboardingContent content;

  const OnboardingPage({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            content.imagePath,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          const SizedBox(height: 40),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              // style: AppStyles.onboardingTitleStyle, // Esempio con stili globali
            ),
          ),
          const SizedBox(height: 20),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
              // style: AppStyles.onboardingDescriptionStyle,
            ),
          ),
        ],
      ),
    );
  }
}