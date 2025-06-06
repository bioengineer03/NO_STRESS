import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:no_stress/screens/HomePage.dart'; // Importa la tua HomePage

class BreathingPage extends StatefulWidget {
  @override
  _BreathingPageState createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool isInhale = true;
  bool isRunning = true;
  Timer? _totalTimer;
  int _remainingTime = 20;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => isInhale = false);
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          setState(() => isInhale = true);
          _controller.forward();
        }
      });

    _animation = Tween<double>(begin: 100, end: 250).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _startSession();
    _controller.forward();
  }

  void _startSession() {
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime == 0) {
        _stopBreathing();
        _goToHomePage();
      }
    });
  }

  void _stopBreathing() {
    _controller.stop();
    _totalTimer?.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void _toggleBreathing() {
    setState(() {
      isRunning = !isRunning;
    });

    if (isRunning) {
      _controller.forward();
      _startSession();
    } else {
      _controller.stop();
      _totalTimer?.cancel();
    }
  }

  void _goToHomePage() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _totalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inhaleColor = Color(0xFF1E6F50);
    final Color exhaleColor = Color.fromARGB(255, 24, 151, 102);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isInhale ? 'Inspira' : 'Espira',
              style: GoogleFonts.poppins(
                  fontSize: 40,
                  color: isInhale ? inhaleColor : exhaleColor,
                ),
              ),
            const SizedBox(height: 30),
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: _animation.value,
                  height: _animation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF1E6F50),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Tempo rimasto: $_remainingTime s',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: isRunning ? _toggleBreathing : null,
              icon: const Icon(Icons.pause),
              label: Text(
                'Ferma',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
                ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E6F50),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
