import 'package:flutter/material.dart';

import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  if (prefs.getString('highScore') == null) {
    prefs.setString('highScore', '0');
  }
  print(prefs.getString('highScore'));

  runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizProvider>(create: (_) => QuizProvider()),
      ],
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Programming Hero',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const SplashScreen(),
        );
      }));
}
