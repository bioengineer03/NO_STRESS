import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:circular_progress_stack/circular_progress_stack.dart';
import 'package:no_stress/screens/AuthorsInfoPage.dart';
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
//import 'package:no_stress/screens/StressPage.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        centerTitle: true, // Centra il titolo
        elevation: 0, // Rimuove l'ombra
        title: Text(
          'NoStress',
          style: TextStyle(
            color: Color(0xFF1E6F50), // Scritta verde
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      drawer: Drawer(
        child:ListView(
          children:[
            ListTile(
              leading: Icon(Icons.person), // Icona profilo
              title: Text(
                'Pagina Profilo',
                style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50))
              ),
              onTap:(){
                Navigator.push(context,MaterialPageRoute(builder: (context) => ProfilePage()));
              }
            ),
            ListTile(
              leading: Icon(Icons.logout), // Icona logout
              title: Text(
                'Log Out',
                style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50))
              ),
              onTap:() async {
                Navigator.push(context,MaterialPageRoute(builder: (context) => LoginPage()));
                // La nostra idea è tenere memorizzati accesse refresh token per cui quando torna nella Login si sovrascrivono
                // Chiedere se effettivamente vengono sovrascritti, oppure se è meglio cancellarli e rifare la procedura effettiva di login
                final sp = await SharedPreferences.getInstance();
                await sp.remove('access');
                await sp.remove('refresh');
              }
            ),
            ListTile(
              leading: Icon(Icons.info), // Icona info
              title: Text(
                'Info',
                style: TextStyle(fontSize: 16, color: Color(0xFF1E6F50))
              ),
              onTap:(){
                Navigator.push(context,MaterialPageRoute(builder: (context) => AuthorsInfoPage()));
              }
            ),
          ]
        )),
      body:SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12.0,
            right: 12.0,
            top:10,
            bottom: 20,
          ),
          child:SingleChildScrollView(
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
                            "Hello, User",
                            style: TextStyle(fontSize: 36),
                          );
                        } else {
                          final name = sp.getString('name');
                          return Text(
                            "Hello, $name",
                            style: TextStyle(fontSize: 36),
                          );
                        }
                      } else {
                        return CircularProgressIndicator();
                      }
                    }), // builder
                  ),
                ]
              ),
              Consumer<DataProvider>(
                builder:(context, provider, child){
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
                                    print('HeartRates length: ${provider.heartRates.length}');
                                    print('Sleep length: ${provider.sleep.length}');
                                },
                                child: const Icon(Icons.navigate_before),
                              ),
                            ),
                            Text(
                              DateFormat('EEE, d MMM').format(provider.currentDate),
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
                        // Verifica che non abbiamo già le liste dei dati di HR e sleep caricati
                        provider.loading ? Center(child: CircularProgressIndicator.adaptive()) : 
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:[
                              Stack(
                                alignment: Alignment.center,
                                children:[
                                  SingleAnimatedStackCircularProgressBar(
                                    size: 200,
                                    progressStrokeWidth: 15,
                                    backStrokeWidth: 15,
                                    startAngle: 0,
                                    backColor: Color(0xffD7DEE7),
                                    barColor: Color(0xFF1E6F50),
                                    barValue: provider.stressscore.toDouble(),
                                  ),
                                  // Widget emoji sovrapposto al centro della barra circolare
                                  EmojiHelper.getEmojiForStressScore(provider.stressscore),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Text(
                                provider.stressscore < 25
                                    ? "Wow, come sei tranquillo!"
                                    : provider.stressscore > 25 &&
                                        provider.stressscore < 75
                                    ? "Comincia a rilassarti!"
                                    : "Troppa ansia, affrontiamola insieme",
                                style: const TextStyle(
                                  fontSize: 20,
                                  color: Colors.black45,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Il tuo STRESS SCORE: ${provider.stressscore}',
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 15),
                            ],
                          )
                        ),
                      ],
                    ),
                  );
                },
              ),

              // INSERISCO LA CARD PER IL TREND DELLA HRV
              SizedBox(height: 20),
              Consumer<DataProvider>(
                builder: (context, dataProvider, child) {
                  //final hrvTrend = dataProvider.hrvTrend;
                  final hrvList = dataProvider.hrvList;
                  final meanHRV = hrvList.isNotEmpty
                    ? hrvList.map((b) => b.hrv).mean.toStringAsFixed(0)
                    : '--';
                  // Controllo se hrvList è vuota
                  if (hrvList.isEmpty) {
                    return Center(child: Text('No HRV data available for this date.'));
                  }
                  // Mostro la card con l'ultimo valore di HRV
                  return HealthStatCard(
                    title: 'HRV',
                    value: meanHRV != null ? '$meanHRV ms' : '--',
                    subtitle: 'Mean value',
                    icon: Icons.monitor_heart,
                    color: Color(0xFF1E6F50),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => 
                      HRVPage(hrvData: hrvList),),);
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
                  final meanBPM = bpmList.isNotEmpty
                  ? bpmList.map((b) => b.bpm).mean.toStringAsFixed(0)
                  : '--';
                  // Controllo se hrvList è vuota
                  if (bpmList.isEmpty) {
                    return Center(child: Text('No BPM data available for this date.'));
                  } 
                  // Mostro la card con l'ultimo valore di BPM
                  return HealthStatCard(
                    title: 'BPM',
                    value: meanBPM != null ? '$meanBPM' : '--',
                    subtitle: 'Mean value',
                    icon: Icons.monitor_heart,
                    color: Color(0xFF1E6F50),
                    onTap: () {
                      Navigator.push(context,MaterialPageRoute(builder: (context) => 
                      BPMPage(bpmData: bpmList),),);
                    },
                  );
                }, // builder
              ),
            ], // children
          ),
        )
      ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Vai a NoStress',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyCheckInPage()),
          );
        },
        child: Icon(Icons.self_improvement),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  } //build
} //HomePage