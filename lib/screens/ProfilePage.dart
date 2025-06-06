import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:no_stress/screens/OnBoardingPage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = '';
  String _surname = '';
  String _gender = '';
  String _dob = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _name = sp.getString('name') ?? 'N/D';
      _surname = sp.getString('surname') ?? 'N/D';
      _gender = sp.getString('gender') ?? 'N/D';
      _dob = sp.getString('dob') ?? 'N/D';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilo personale')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _infoBox('Nome', _name),
              _infoBox('Cognome', _surname),
              _infoBox('Sesso', _gender),
              _infoBox('Data di nascita', _dob),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  // Collegalo all’onboarding se vuoi permettere modifica
                  Navigator.push(context,
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1E6F50),
                  foregroundColor: const Color.fromARGB(255, 255, 255, 255),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
                child: const Text('Modifica Profilo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBox(String label, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      width: double.infinity,
      decoration: BoxDecoration(
        color:Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
