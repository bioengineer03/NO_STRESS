import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:circular_progress_stack/circular_progress_stack.dart';
import 'package:no_stress/screens/AuthorsInfoPage.dart';
import 'package:no_stress/screens/StressScoreBarChar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:no_stress/providers/data_provider.dart';
import 'package:no_stress/screens/LoginPage.dart';
import 'package:no_stress/screens/ProfilePage.dart';
import 'package:no_stress/screens/DailyCheckInPage.dart';
import 'package:no_stress/utils/emoji_helper.dart';
import 'package:no_stress/screens/HRVPage.dart';
import 'package:no_stress/screens/BpmPage.dart';
import 'package:statistics/statistics.dart';
import 'package:no_stress/screens/BreathingPage.dart';
//import 'package:no_stress/screens/MiniGamePage.dart';
import 'package:no_stress/screens/MemoryGamePage.dart';
//import 'package:no_stress/screens/StressPage.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true, // Centra il titolo
        elevation: 0, // Rimuove l'ombra
        backgroundColor: Colors.white,
        title: Text(
          'No Stress',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 30,
            color: Color(0xFF1E6F50),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.person), // Icona profilo
              title: Text(
                'Profile Page',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1E6F50),
                ),
                //style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50),fontStyle: GoogleFonts.poppins()),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout), // Icona logout
              title: Text(
                'Log Out',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1E6F50),
                ),
                //style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50)),
              ),
              onTap: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
                // La nostra idea è tenere memorizzati accesse refresh token per cui quando torna nella Login si sovrascrivono
                // Chiedere se effettivamente vengono sovrascritti, oppure se è meglio cancellarli e rifare la procedura effettiva di login
                final sp = await SharedPreferences.getInstance();
                await sp.remove('access');
                await sp.remove('refresh');
              },
            ),
            ListTile(
              leading: Icon(Icons.info), // Icona info
              title: Text(
                'Authors',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1E6F50),
                ),
                //style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AuthorsInfoPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.air),
              title: Text(
                'Breath',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1E6F50),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BreathingPage()),
                );
              },
            ),
            /*ListTile(
              leading: Icon(Icons.gamepad),
              title: Text(
                'RELAX',
                style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MiniGamePage()),
                );
              },
            ),
            */
            ListTile(
              leading: Icon(Icons.memory),
              title: Text(
                'Memory',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Color(0xFF1E6F50),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MemoryGamePage()),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top: 10,
            bottom: 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Riga in cui scriviamo "Ciao User"
                Row(
                  children: [
                    FutureBuilder(
                      future: SharedPreferences.getInstance(),
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          final sp = snapshot.data as SharedPreferences;
                          if (sp.getString('name') == null) {
                            return Text(
                              "Hello User",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Color(0xFF1E6F50),
                              ),
                            );
                          } else {
                            final name = sp.getString('name');
                            return Text(
                              "Hello $name",
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Color(0xFF1E6F50),
                              ),
                            );
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      }), // builder
                    ),
                  ],
                ),
                Consumer<DataProvider>(
                  builder: (context, provider, child) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                // InkWell widget is used to make the icons clickable
                                child: InkWell(
                                  onTap: () {
                                    // function that calls the provider function passing the date before the current date
                                    provider.subtractDay();
                                  },
                                  child: const Icon(Icons.navigate_before),
                                ),
                              ),
                              Text(
                                DateFormat(
                                  'EEE, d MMM',
                                ).format(provider.currentDate),
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  onTap: () {
                                    // function that calls the provider function passing the date after the current date
                                    provider.addDay();
                                  },
                                  child: const Icon(Icons.navigate_next),
                                ),
                              ),
                            ],
                          ),
                          if (provider.stressscore < 0)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  "I dati di questa giornata non sono disponibili",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          else
                            // Verifica che non abbiamo già le liste dei dati di HR e sleep caricati
                            provider.loading
                                ? Center(
                                  child: CircularProgressIndicator.adaptive(),
                                )
                                : Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SingleAnimatedStackCircularProgressBar(
                                            size: 200,
                                            progressStrokeWidth: 15,
                                            backStrokeWidth: 15,
                                            startAngle: 0,
                                            backColor: Color(0xffD7DEE7),
                                            barColor: Color(0xFF1E6F50),
                                            barValue:
                                                provider.stressscore.toDouble(),
                                          ),
                                          // Widget emoji sovrapposto al centro della barra circolare
                                          EmojiHelper.getEmojiForStressScore(
                                            provider.stressscore,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 15),
                                      Text(
                                        'Il tuo STRESS SCORE: ${provider.stressscore}',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        provider.stressscore < 25
                                            ? "Wow, come sei tranquillo!"
                                            : provider.stressscore > 25 &&
                                                provider.stressscore < 75
                                            ? "Comincia a rilassarti!"
                                            : "Troppa ansia, affrontiamola insieme",
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      // BOTTONE AGGIORNAMENTO STRESS SCORE
                                      if (provider.stressscore >= 0)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 24.0,
                                          ),
                                          child: Center(
                                            child: ElevatedButton.icon(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (context) =>
                                                            DailyCheckInPage(),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.edit_note,
                                                color: Colors.white,
                                              ),
                                              label: Text(
                                                'Aggiorna il tuo stress score',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(
                                                  0xFF1E6F50,
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 24,
                                                  vertical: 12,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                // INSERISCO LA CARD PER IL TREND DELLA HRV
                SizedBox(height: 20),
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    //final hrvTrend = dataProvider.hrvTrend;
                    final hrvList = dataProvider.hrvList;
                    final meanHRV =
                        hrvList.isNotEmpty
                            ? hrvList.map((b) => b.hrv).mean.toStringAsFixed(0)
                            : '--';
                    // Controllo se hrvList è vuota
                    if (hrvList.isEmpty) {
                      return Container(); // Non Visualizzo nulla
                    }
                    // Mostro la card con l'ultimo valore di HRV
                    return HealthStatCard(
                      title: 'HRV',
                      value: meanHRV != null ? '$meanHRV ms' : '--',
                      subtitle: 'Mean value',
                      icon: Icons.monitor_heart,
                      color: Color(0xFF1E6F50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HRVPage(hrvData: hrvList),
                          ),
                        );
                      },
                    );
                  }, // builder
                ),
                // INSERISCO LA CARD PER IL TREND DELLA BPM
                SizedBox(height: 20),
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    //final bpmTrend = dataProvider.hrvTrend;
                    final bpmList = dataProvider.bpmList;
                    final meanBPM =
                        bpmList.isNotEmpty
                            ? bpmList.map((b) => b.bpm).mean.toStringAsFixed(0)
                            : '--';
                    // Controllo se hrvList è vuota
                    if (bpmList.isEmpty) {
                      return Container();
                    }
                    // Mostro la card con l'ultimo valore di BPM
                    return HealthStatCard(
                      title: 'BPM',
                      value: meanBPM != null ? '$meanBPM' : '--',
                      subtitle: 'Mean value',
                      icon: Icons.monitor_heart,
                      color: Color(0xFF1E6F50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BPMPage(bpmData: bpmList),
                          ),
                        );
                      },
                    );
                  }, // builder
                ),

                /*
                // INSERISCO LA CARD PER IL TREND DELLo STRESS SCORE NELLA SETTIMANA
                SizedBox(height: 20),
                Consumer<DataProvider>(
                  builder: (context, dataProvider, child) {
                    //final bpmTrend = dataProvider.hrvTrend;
                    final weeklystressscore = dataProvider.weekStressscore;
                    final stressscoretoday = weeklystressscore.first;
                    final data = dataProvider.currentDate;
                    // Controllo se hrvList è vuota
                    if (weeklystressscore.isEmpty) {
                      return Container();
                    }
                    // Mostro la card con l'ultimo valore di BPM
                    return HealthStatCard(
                      title: 'Stress Score settimanale',
                      value: stressscoretoday != null ? '$stressscoretoday' : '--',
                      subtitle: 'Stress Score di oggi',
                      icon: Icons.monitor_heart,
                      color: Color(0xFF1E6F50),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StressScoreBarChart(stressScores: weeklystressscore, today: data),
                          ),
                        );
                      },
                    );
                  }, // builder
                ),
                */
              ], // children
            ),
          ),
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xFF1E6F50),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyCheckInPage()),
          );
        },
        label: Text(
          'Aggiorna il tuo stress score',
          style: TextStyle(color: Colors.white), // Scritta bianca
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      */
    );
  } //build
} //HomePage
