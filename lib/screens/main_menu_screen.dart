import 'package:flutter/material.dart';
import 'package:programming_hero/api/api_services.dart';
import 'package:programming_hero/app_config.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:provider/provider.dart';

import 'question_answer_screen.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({Key? key}) : super(key: key);

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();

    _apiService.questions().then((value) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      provider.changeQuestions(value['questions']);
      provider.notify();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width / 1.5,
                child: Image.asset(appIcon),
              ),
              const Text('Quiz',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 34)),
              const SizedBox(height: 30),
              const Text('Highscore',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 5),
              const Text('500 Points',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 40),
              InkWell(
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) {
                    return const QuestionAnswerScreen();
                  }));
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.white),
                  child: const Center(
                    child: Text('Start',
                        style: TextStyle(
                            color: backgroundColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 24)),
                  ),
                ),
              )
            ]),
      ),
    );
  }
}
