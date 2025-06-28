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
  bool isRunning = true; // Indica se l'animazione e il timer sono attivi
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

    _startSession(); // Avvia la sessione all'inizio
    _controller.forward(); // Avvia l'animazione
  }

  // Avvia/Riprende il timer della sessione
  void _startSession() {
    // Cancella il timer esistente prima di crearne uno nuovo per evitare duplicati
    _totalTimer?.cancel();
    _totalTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime == 0) {
        _stopBreathing(goToHome: true); // Ferma e vai alla HomePage
      }
    });
  }

  // Ferma l'animazione e il timer. Opzionalmente naviga alla HomePage.
  void _stopBreathing({bool goToHome = false}) {
    _controller.stop();
    _totalTimer?.cancel();
    setState(() {
      isRunning = false; // Imposta lo stato a "fermo"
    });
    if (goToHome) {
      _goToHomePage();
    }
  }

  // Mette in pausa o riprende l'animazione e il timer
  void _toggleBreathing() {
    setState(() {
      isRunning = !isRunning; // Inverte lo stato running
    });

    if (isRunning) {
      _controller.forward(); // Riprende l'animazione
      _startSession(); // Riprende il timer
    } else {
      _controller.stop(); // Ferma l'animazione
      _totalTimer?.cancel(); // Ferma il timer
    }
  }

  // Naviga alla HomePage e sostituisce la pagina corrente
  void _goToHomePage() {
    // Assicurati che _totalTimer sia annullato prima di navigare via
    _totalTimer?.cancel();
    _controller.dispose(); // Libera anche il controller
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  // Gestisce il pulsante "Indietro" dell'AppBar
  void _onBackPressed() {
    _stopBreathing(); // Ferma l'esercizio quando si torna indietro
    Navigator.of(context).pop(); // Torna alla schermata precedente
  }

  @override
  void dispose() {
    _controller.dispose();
    _totalTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color inhaleColor = const Color.from(alpha: 1, red: 0.118, green: 0.435, blue: 0.314); // Colore per l'inspirazione
    final Color exhaleColor = const Color.fromARGB(255, 24, 151, 102);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar( // Aggiungi l'AppBar per il pulsante indietro
        backgroundColor: Colors.white, // O il colore che preferisci
        elevation: 0, // Nessuna ombra sotto l'AppBar
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Freccia indietro
          onPressed: _onBackPressed, // Chiama la funzione per tornare indietro
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isInhale ? 'Inhale' : 'Exhale',
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
                    color: const Color(0xFF1E6F50),
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Text(
              'Time remaining: $_remainingTime s',
              style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.black,
                ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _toggleBreathing, // Ora gestisce sia pausa che riprendi
              icon: Icon(isRunning ? Icons.pause : Icons.play_arrow, color: Colors.white,), // Icona cambia in base allo stato
               
              label: Text(
                isRunning ? 'Pause' : 'Resume', // Testo cambia in base allo stato
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F50),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            if (!isRunning && _remainingTime > 0) // Mostra il pulsante "Termina sessione" solo se in pausa e non è finito il tempo
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: ElevatedButton(
                  onPressed: () => _stopBreathing(goToHome: true), // Ferma e vai alla HomePage
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[700], // Un colore diverso per "termina"
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'End session',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}