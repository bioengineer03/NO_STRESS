import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:no_stress/providers/data_provider.dart'; // Assicurati che il percorso sia corretto

class DailyCheckInPage extends StatefulWidget {
  const DailyCheckInPage({super.key});

  @override
  State<DailyCheckInPage> createState() => _DailyCheckInPageState();
}

class _DailyCheckInPageState extends State<DailyCheckInPage> {
  // Mappa delle domande e dei loro valori booleani iniziali
  final Map<String, bool?> _answers = {
    'Did you take a power nap (20–30 minutes) today?': null,
    'Did you get at least 30 minutes of moderate exercise today?': null,
    'Did you spend at least 5 minutes on deep breathing today? → Use the BREATH simulator 10 times.': null,
    'Did you have any positive social interactions (in person or virtual) today?':
        null,
    'Did you consume caffeine after 5:00 PM today?': null,
    'Did you drink at least one glass of water every 2 hours while you were awake today?':
        null,
  };

  @override
  Widget build(BuildContext context) {
    // Ottieni il DataProvider per accedere e modificare lo stress_score
    final dataProvider = Provider.of<DataProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Daily Check-in',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1E6F50),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E6F50)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Just answer a few questions to refresh your stress score:',
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _answers.keys.length,
                itemBuilder: (context, index) {
                  String question = _answers.keys.elementAt(index);
                  bool? answer = _answers[question];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            question,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xFF1E6F50),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question] = true;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      answer == true
                                          ? Color(0xFF1E6F50)
                                          : Colors.grey[300],
                                  foregroundColor:
                                      answer == true
                                          ? Colors.white
                                          : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'Yes',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question] = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      answer == false
                                          ? Colors.redAccent
                                          : Colors.grey[300],
                                  foregroundColor:
                                      answer == false
                                          ? Colors.white
                                          : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 30,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  'No',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Calcola l'impatto sul stress score
                double stressChange = 0.0;

                _answers.forEach((question, answer) {
                  if (question.contains('Did you take a power nap (20–30 minutes) today?')) {
                    stressChange += answer == true ? -1.0 : 0.5;
                  } else if (question.contains('Did you get at least 30 minutes of moderate exercise today?')) {
                    stressChange += answer == true ? -2.0 : 1.0;
                  } else if (question.contains('Did you spend at least 5 minutes on deep breathing today? → Use the BREATH simulator 10 times.')) {
                    stressChange += answer == true ? -1.5 : 1.0;
                  } else if (question.contains('Did you have any positive social interactions (in person or virtual) today?')) {
                    stressChange += answer == true ? -1.0 : 1.0;
                  } else if (question.contains('Did you consume caffeine after 5:00 PM today?')) {
                    stressChange += answer == true ? 1.5 : -0.5;
                  } else if (question.contains('Did you drink at least one glass of water every 2 hours while you were awake today?')) {
                    stressChange += answer == true ? -1.0 : 0.5;
                  }
                });

                // Aggiorna lo stress score tramite il DataProvider
                dataProvider.updateStressScore(stressChange);

                // Mostra un messaggio di conferma e torna alla pagina precedente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Updated stress score! Here’s the change:: $stressChange',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: Color(0xFF1E6F50),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(
                  0xFF1E6F50,
                ), // Colore verde come nell'app
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: Text(
                'Save my answers',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*extension on DataProvider {
  void updateStressScore(int stressChange) {}
}*/
