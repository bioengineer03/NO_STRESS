import 'package:flutter/material.dart';
import 'package:no_stress/models/onboarding_content.dart';

class LastOnboardingPageContent extends StatelessWidget {
  final OnboardingContent content;
  final TextEditingController nameController;
  final String? selectedGender;
  final ValueChanged<String?> onGenderChanged;

  const LastOnboardingPageContent({
    Key? key,
    required this.content,
    required this.nameController,
    required this.selectedGender,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView( // Permette lo scroll se la tastiera copre i campi
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            content.imagePath,
            height: MediaQuery.of(context).size.height * 0.3, // Immagine più piccola per fare spazio agli input
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 40),
          // Campo di input per il nome
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Your Nickname',
              hintText: 'Es: Bob ',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              prefixIcon: const Icon(Icons.person),
            ),
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 20),
          // Dropdown per il sesso
          DropdownButtonFormField<String>(
            value: selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFF1E6F50), width: 1.7),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
                borderSide: BorderSide(color: Color(0xFF1E6F50), width: 2.0),
              ),
              prefixIcon: const Icon(Icons.wc),
            ),
            hint: const Text('Select your gender'),
            items: const <String>['Male', 'Female', 'Prefer not to say']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onGenderChanged,
          ),
        ],
      ),
    );
  }
}