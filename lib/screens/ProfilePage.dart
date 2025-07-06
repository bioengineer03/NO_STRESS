import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:no_stress/screens/HomePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  String? _userGender;
  final Color _mainColor = const Color(0xFF1E6F50);

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final sp = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = sp.getString('name') ?? '';
      _surnameController.text = sp.getString('surname') ?? '';
      _userNameController.text = sp.getString('user_name') ?? '';
      _dateController.text = sp.getString('date_of_birth') ?? '';
      _cityController.text = sp.getString('city') ?? '';
      _addressController.text = sp.getString('address') ?? '';
      _userGender = sp.getString('userGender') ?? 'Prefer Not to Say';
    });
  }

  Future<void> _selectDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1900),
    lastDate: DateTime.now(),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: _mainColor,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(foregroundColor: _mainColor),
          ),
          textTheme: TextTheme(
            titleLarge: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            titleMedium: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            titleSmall: GoogleFonts.poppins(
              fontSize: 16,
            ),
            bodyLarge: GoogleFonts.poppins(fontSize: 16),
            bodyMedium: GoogleFonts.poppins(fontSize: 14),
            bodySmall: GoogleFonts.poppins(fontSize: 12),
            labelLarge: GoogleFonts.poppins(),
            labelMedium: GoogleFonts.poppins(),
            labelSmall: GoogleFonts.poppins(),
          ),
        ),
        child: child!,
      );
    },
  );

  if (picked != null) {
    setState(() {
      _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
    });
  }
}


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final sp = await SharedPreferences.getInstance();
      await sp.setString('name', _nameController.text);
      await sp.setString('surname', _surnameController.text);
      await sp.setString('user_name', _userNameController.text);
      await sp.setString('date_of_birth', _dateController.text);
      await sp.setString('city', _cityController.text);
      await sp.setString('address', _addressController.text);
      await sp.setBool('profile_completed', true);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data successfully saved!'),
          backgroundColor: _mainColor,
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final imagePath = _userGender == 'Female'
        ? 'assets/images/undraw_female-avatar_7t6k.png'
        : _userGender == 'Male'
            ? 'assets/images/undraw_male-avatar_zkzx.png'
            : 'assets/images/white.png';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Profile Page',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: _mainColor,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: _mainColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(height: 12),
            Text(
              'Let\'s know you better',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
                color: _mainColor,
              ),
            ),
            const SizedBox(height: 30),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextFormField('Username', _userNameController, 'Enter your username'),
                  _buildTextFormField('Name', _nameController, 'Enter your name'),
                  _buildTextFormField('Surname', _surnameController, 'Enter your surname'),
                  _buildTextFormField('City', _cityController, 'Enter your city'),
                  _buildTextFormField('Address', _addressController, 'Enter your address'),
                  _buildDateField(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _mainColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Save',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextFormField(String label, TextEditingController controller, String hintText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: _mainColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _mainColor),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Date of Birth',
            style: GoogleFonts.poppins(
              color: _mainColor,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: _dateController,
            readOnly: true,
            onTap: () => _selectDate(context),
            style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
            decoration: InputDecoration(
              hintText: 'Select your date of birth',
              hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: _mainColor),
              ),
              suffixIcon: Icon(Icons.calendar_today, color: _mainColor, size: 20),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            ),
            validator: (value) => value == null || value.isEmpty ? 'Required field' : null,
          ),
        ],
      ),
    );
  }
}