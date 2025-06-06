import 'package:flutter/material.dart';
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
    'Sei andato a camminare oggi?': null,
    'Hai fatto un riposino?': null,
    'Hai bevuto abbastanza acqua?': null,
    'Hai avuto un momento di relax?': null,
    'Hai dormito bene la notte scorsa?': null,
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
        title: const Text(
          'Check-in Quotidiano',
          style: TextStyle(
            color: Color(0xFF1E6F50),
            fontWeight: FontWeight.bold,
            fontSize: 20,
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
            const Text(
              'Rispondi alle seguenti domande per aggiornare il tuo stress score:',
              style: TextStyle(fontSize: 18, color: Colors.black87),
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
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
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
                                  backgroundColor: answer == true ? Color(0xFF1E6F50) : Colors.grey[300],
                                  foregroundColor: answer == true ? Colors.white : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                child: const Text('Sì', style: TextStyle(fontSize: 16)),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    _answers[question] = false;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: answer == false ? Colors.redAccent : Colors.grey[300],
                                  foregroundColor: answer == false ? Colors.white : Colors.black87,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                ),
                                child: const Text('No', style: TextStyle(fontSize: 16)),
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
                int stressChange = 0;
                _answers.forEach((question, answer) {
                  if (answer == true) {
                    stressChange -= 10; // Ogni "Sì" riduce lo stress
                  } else if (answer == false) {
                    stressChange += 5; // Ogni "No" aumenta leggermente lo stress
                  }
                });

                // Aggiorna lo stress score tramite il DataProvider
                dataProvider.updateStressScore(stressChange);

                // Mostra un messaggio di conferma e torna alla pagina precedente
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Stress score aggiornato! Variazione: $stressChange'),
                    backgroundColor: Color(0xFF1E6F50),
                  ),
                );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF1E6F50), // Colore verde come nell'app
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'Salva Risposte',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
