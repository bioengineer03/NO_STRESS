import 'package:flutter/material.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Onboarding extends StatefulWidget {
  // È un widget stateful perché mantiene lo stato dei campi del form e dello SharedPreferences.
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  // Variabili e controller: usati per gestire e validare i campi del form.
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _loadSavedData();
    // Chiama _loadSavedData() per precompilare i campi 
    //se l’utente ha già inserito qualcosa in passato.
  }

  Future<void> _loadSavedData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = sp.getString('nome') ?? '';
      _surnameController.text = sp.getString('cognome') ?? '';
      _dateController.text = sp.getString('data_di_nascita') ?? '';
      _selectedGender = sp.getString('sesso');
    });
  }
  
  //Mostra un DatePicker Flutter. 
  //Se l’utente seleziona una data, la inserisce nel campo dateController.
  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  // Valida i campi del form
  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('name', _nameController.text);
      await sp.setString('surname', _surnameController.text);
      await sp.setString('gender', _selectedGender!);
      await sp.setString('dob', _dateController.text);
      await sp.setBool('onboarding_completed', true);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data saved successfully!')),
      );

      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  Future<void> _setOnboardingCompleted() async {
  final sp = await SharedPreferences.getInstance();
  await sp.setBool('onboarding_completed', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // SafeArea widget to avoid system UI overlaps
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: [
                    // import the logo image from assets folder (make sure to add the folder in pubspec.yaml)
                    Image.asset(
                      'assets/images/logo.png',
                      scale: 4,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text(
                      'Conosciamoci!',
                      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children:[
                          TextFormField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Name',
                              hintText: 'Enter your name',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _surnameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            labelText: 'Surname',
                            hintText: 'Enter your surname',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your surname';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(labelText: 'Sex', border: OutlineInputBorder()),
                            value: _selectedGender,
                            items: ['M', 'F', 'Other'].map((gender){
                              return DropdownMenuItem<String>(
                                value: gender,
                                child: Text(gender),
                              );
                            }).toList(),
                            onChanged: (value) => setState(() => _selectedGender = value),
                            validator: (value) => value == null ? 'Choose gender' : null,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            controller: _dateController,
                            readOnly: true,
                            decoration: InputDecoration(labelText: 'Date of birth', border: OutlineInputBorder()),
                            onTap: () => _selectDate(context),
                            validator: (value) => value == null || value.isEmpty ? 'Pick a date' : null,
                          ),
                          SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: _submitForm,
                            child: Text('Save'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),        
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: TextButton(
                onPressed: () async {
                  await _setOnboardingCompleted();
                  Navigator.pushReplacement(
                    // ignore: use_build_context_synchronously
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
                child: Text(
                  'Skip',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}