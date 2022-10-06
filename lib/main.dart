import 'package:flutter/material.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'screens/splash_screen.dart';

void main() {
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
