import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_hero/app_config.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:programming_hero/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
this is the most important screen of the app
most of the fuctionalities are here

the questions will be shown for 10 mins. if the user faild to
answer a question within 10 sec the app will show the 
correnct ans and move on to next question
*/

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  // this fuction fill start the 10 sec timer
  void startTimer() async {
    print(1);
    final provider = Provider.of<QuizProvider>(context, listen: false);

    Timer.periodic(const Duration(seconds: 1), (t) {
      print(2);

      if (provider.timer < 1) {
        t.cancel();
        print(3);
        // this portion is to show the correct ans if user
        // fails to answer a question in given time
        if (provider.selectedQuestionIndex < provider.questions.length - 1) {
          provider.changeAnswerIndex(provider.answers.indexWhere((element) {
            return element.label ==
                provider.questions[provider.selectedQuestionIndex]
                    ['correctAnswer'];
          }));
          Future.delayed(const Duration(seconds: 2), () {
            provider.increaseIndex();
            provider.resetAnswer();
            provider.chnageAnswerSet();
            provider.chnageCancelTimer(false);

            provider.resetTimer();
            startTimer();
          });
        } else {
          t.cancel();
          dialog(context, provider);
        }
      } else if (provider.cancelTImer) {
        // if time runs out this will stop the timer
        print(4);

        t.cancel();
      } else {
        print(5);
        // this is to decrease the timer

        provider.chnageTimer();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // initializing timer
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(builder: (context, provider, _) {
      return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
          backgroundColor: backgroundColor,
          body: provider.questions.isEmpty
              ? Center(child: progressIndicator(Colors.white, 60))
              : Column(children: [
                  SizedBox(height: MediaQuery.of(context).viewPadding.top),
                  Container(
                    height: 60,
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Stack(alignment: Alignment.center, children: [
                        // question number
                        Positioned(
                          left: 0,
                          child: Text(
                              'Question: ' +
                                  (provider.selectedQuestionIndex + 1)
                                      .toString() +
                                  '/' +
                                  provider.questions.length.toString(),
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                        // counter
                        Text(provider.timer.toString(),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                        // score
                        Positioned(
                          right: 0,
                          child: Text('Score: ' + provider.score.toString(),
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // question portion
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(children: [
                          Text(
                              provider.questions[provider.selectedQuestionIndex]
                                          ['score']
                                      .toString() +
                                  ' Point',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: backgroundColor)),
                          const SizedBox(height: 20),
                          if (provider.questions[provider.selectedQuestionIndex]
                                      ['questionImageUrl'] !=
                                  null &&
                              provider.questions[provider.selectedQuestionIndex]
                                      ['questionImageUrl'] !=
                                  'null')
                            Expanded(
                              child: SizedBox(
                                  child: Image.network(
                                      provider.questions[
                                              provider.selectedQuestionIndex]
                                          ['questionImageUrl'],
                                      fit: BoxFit.cover)),
                            ),
                          const SizedBox(height: 20),
                          Text(
                              provider.questions[provider.selectedQuestionIndex]
                                  ['question'],
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: backgroundColor)),
                        ]),
                      ),
                    ),
                  )),

                  // answer set
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: ListView.separated(
                            itemCount: provider.answers.length,
                            separatorBuilder: (context, index) {
                              return const SizedBox(height: 20);
                            },
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () async {
                                  // in this portion on tapping in the answer
                                  // if the answer is correct it will be green and the score will be added
                                  // in the score board. else the selected ans will be red and
                                  // the correct and will show as green.

                                  // this will not let user to double click in an answer
                                  if (provider.answersIndex == null) {
                                    // this is a flag to control the timer
                                    provider.chnageCancelTimer(true);

                                    // changing selected answer
                                    provider.changeAnswerIndex(index);

                                    // getting the correct and if the ans is wrong
                                    if (provider.answers[provider.answersIndex!]
                                            .label ==
                                        provider.questions[
                                                provider.selectedQuestionIndex]
                                            ['correctAnswer']) {
                                      // adding score
                                      provider.addScore(provider.questions[
                                              provider.selectedQuestionIndex]
                                          ['score']);
                                    }

                                    // this delay is to show the correct ans and wrong ans

                                    Future.delayed(const Duration(seconds: 2),
                                        () {
                                      if (provider.selectedQuestionIndex <
                                          provider.questions.length - 1) {
                                        provider.increaseIndex();
                                        provider.resetAnswer();
                                        provider.chnageAnswerSet();
                                        provider.chnageCancelTimer(false);

                                        provider.resetTimer();
                                        startTimer();
                                      } else {
                                        // this dialogue will show at the end of the gaem when the question
                                        // will be over. this will show score and take back to main menu screen.
                                        dialog(context, provider);
                                      }
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        // handeling the border color of correct and wrong ans tile
                                        color: provider.answersIndex == null
                                            ? Colors.transparent
                                            : (provider.answers[index].label ==
                                                    provider.questions[provider
                                                            .selectedQuestionIndex]
                                                        ['correctAnswer'])
                                                ? Colors.green
                                                : (provider.answersIndex ==
                                                            index &&
                                                        provider.answers[index]
                                                                .label !=
                                                            provider.questions[
                                                                    provider
                                                                        .selectedQuestionIndex]
                                                                [
                                                                'correctAnswer'])
                                                    ? Colors.red
                                                    : Colors.transparent,
                                        width: 5,
                                      )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Center(
                                        child: Text(
                                            provider.answers[index].answer!,
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: backgroundColor))),
                                  ),
                                ),
                              );
                            },
                          ))),
                ]),
        ),
      );
    });
  }

// this is the end banner that will show the score
  Future<dynamic> dialog(BuildContext context, QuizProvider provider) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(appName),
            content: Text('Your score is: ' + provider.score.toString()),
            actions: [
              TextButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    // resetting index and score

                    int score = int.parse(prefs.getString('highScore')!);

                    if (provider.score > score) {
                      // setting the heigh score
                      prefs.setString(
                          'highScore', (score + provider.score).toString());
                    }

                    // resetting all the value
                    provider.resetScore();
                    provider.resetIndex();
                    provider.resetAnswer();
                    provider.resetTimer();
                    provider.chnageCancelTimer(false);

                    // navigating to main screen if question are over

                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return const MainMenuScreen();
                    }), (route) => false);
                  },
                  child: const Text('Ok'))
            ],
          );
        });
  }

  save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  get() async {
    final prefs = await SharedPreferences.getInstance();
    return int.parse(prefs.getString('highScore')!);
  }
}
