import 'package:flutter/material.dart';
import 'package:programming_hero/api/api_services.dart';
import 'package:programming_hero/app_config.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'question_answer_screen.dart';

/*
  this is the main menu section where user can see their all time heigh score from database
  and also there is a start button to enter the quiz game
*/

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

    // initially i am loading the question to save some time here.
    //this is the api section
    //fetching data from api

    _apiService.questions().then((value) {
      final provider = Provider.of<QuizProvider>(context, listen: false);
      provider.changeQuestions(value['questions']);
      provider.chnageAnswerSet();
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
              // here is the icon
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

              // heighscore portion
              const Text('Highscore',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20)),
              const SizedBox(height: 5),
              FutureBuilder(
                  future: getScore(),
                  builder: (context, AsyncSnapshot snapshot) {
                    return Text(
                        (snapshot.hasData ? snapshot.data : '0') + ' Points',
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20));
                  }),
              const SizedBox(height: 40),

              // button to enter to the game

              InkWell(
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    return const QuestionAnswerScreen();
                  }), (route) => false);
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

  // getting scroe by this fuction
  getScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('highScore');
  }
}
