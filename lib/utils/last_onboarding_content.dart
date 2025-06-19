import 'package:flutter/material.dart';
import 'package:no_stress/models/onboarding_content.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';

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
    return SingleChildScrollView(
      // Permette lo scroll se la tastiera copre i campi
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            content.imagePath,
            height:
                MediaQuery.of(context).size.height *
                0.3, // Immagine più piccola per fare spazio agli input
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 30),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 28,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize:16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 20),
          // Campo di input per il nome
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: TextField(
              controller: nameController,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 16, 18, 17),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFF1E6F50), width: 1.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFF1E6F50), width: 2.0),
                ),
                labelText: 'Nickname',
                labelStyle: GoogleFonts.poppins(color: const Color(0xFF1E6F50)),
                floatingLabelStyle: GoogleFonts.poppins(
                  color: Color(0xFF1E6F50),
                ),
                hintText: 'Enter your nickname',
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
          
          const SizedBox(height: 10),
          // Dropdown per il sesso
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: DropdownButtonFormField<String>(
              value: selectedGender,
              style: GoogleFonts.poppins(
                color: const Color.fromARGB(255, 16, 18, 17),
                fontSize: 16,
              ),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFF1E6F50), width: 1.7),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide(color: Color(0xFF1E6F50), width: 2.0),
                ),
                labelText: 'Gender',
                labelStyle: GoogleFonts.poppins(color: const Color(0xFF1E6F50)),
                floatingLabelStyle: GoogleFonts.poppins(
                  color: Color(0xFF1E6F50),
                ),
                hintText: 'Enter your nickname',
                hintStyle: GoogleFonts.poppins(color: Color(0xFF1E6F50)),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 20,
                ),
                prefixIcon: const Icon(Icons.wc),
              ),

              items:
                  const <String>[
                    'Male',
                    'Female',
                    'Prefer not to say',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
              onChanged: onGenderChanged,
            ),
          ),
        ],
      ),
    );
  }
}