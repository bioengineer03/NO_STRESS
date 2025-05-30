import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:no_stress/providers/data_provider.dart';
import 'package:no_stress/screens/SplashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (context) => DataProvider(),
    child: MaterialApp(
      home: SplashScreen()
    ),);
    /* Equivalent version with MultiProvider
    return MaterialApp(
      home: MultiProvider(
        providers: [
          Provider<DataProvider>(create: (_) => DataProvider()),
        ],
        child: HomePage()),
    );
    */ 
  }
}


