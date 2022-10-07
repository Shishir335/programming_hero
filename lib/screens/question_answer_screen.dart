import 'dart:async';

import 'package:flutter/material.dart';
import 'package:programming_hero/app_config.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:programming_hero/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
  Timer? _timer;

  save(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  get() async {
    final prefs = await SharedPreferences.getInstance();
    return int.parse(prefs.getString('highScore')!);
  }

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);

    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      print(provider.selectedQuestionIndex);
      if (provider.selectedQuestionIndex < provider.questions.length - 1) {
        provider.increaseIndex();
        provider.chnageAnswerSet();
      }
    });

    // _timer = Timer.periodic((const Duration(seconds: 5)), (timer) {
    //   print(provider.selectedQuestionIndex);
    //   print(provider.questions.length);

    //   if (_timer!.tick < provider.questions.length) {
    //     if (provider.selectedQuestionIndex == provider.questions.length - 1) {
    //       showDialog(
    //           context: context,
    //           builder: (context) {
    //             return AlertDialog(
    //               title: const Text(appName),
    //               content: Text('Your score is: ' + provider.score.toString()),
    //               actions: [
    //                 TextButton(
    //                     onPressed: () {
    //                       get().then((value) {
    //                         if (provider.score > value) {
    //                           // setting the heigh score
    //                           save('highScore',
    //                               (value + provider.score).toString());
    //                         }
    //                       });
    //                       provider.resetScore();
    //                       provider.resetIndex();
    //                       provider.resetAnswer();
    //                       Navigator.of(context).pushAndRemoveUntil(
    //                           MaterialPageRoute(builder: (context) {
    //                         return const MainMenuScreen();
    //                       }), (route) => false);
    //                     },
    //                     child: const Text('Ok'))
    //               ],
    //             );
    //           });
    //     } else {
    //       Future.delayed(const Duration(seconds: 3), () {
    //         provider.increaseIndex();
    //       });
    //     }
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(builder: (context, provider, _) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: provider.questions.isEmpty
            ? Center(child: progressIndicator(Colors.white, 60))
            : Column(children: [
                SizedBox(height: MediaQuery.of(context).viewPadding.top),
                Container(
                  height: 50,
                  width: double.infinity,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              'Question: ' +
                                  (provider.selectedQuestionIndex + 1)
                                      .toString() +
                                  '/' +
                                  provider.questions.length.toString(),
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('Score: ' + provider.score.toString(),
                              style: const TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ]),
                  ),
                ),
                const SizedBox(height: 20),
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
                                final prefs =
                                    await SharedPreferences.getInstance();

                                if (provider.answersIndex == null) {
                                  _timer!.cancel();
                                  // changing answer value
                                  provider.changeAnswerIndex(index);

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

                                  // Navigate to main screen

                                  Future.delayed(const Duration(seconds: 2),
                                      () {
                                    if (provider.selectedQuestionIndex ==
                                        (provider.questions.length - 1)) {
                                      showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) {
                                            return AlertDialog(
                                              title: const Text(appName),
                                              content: Text('Your score is: ' +
                                                  provider.score.toString()),
                                              actions: [
                                                TextButton(
                                                    onPressed: () {
                                                      // resetting index and score

                                                      int score = int.parse(
                                                          prefs.getString(
                                                              'highScore')!);

                                                      if (provider.score >
                                                          score) {
                                                        // setting the heigh score
                                                        prefs.setString(
                                                            'highScore',
                                                            (score +
                                                                    provider
                                                                        .score)
                                                                .toString());
                                                      }

                                                      provider.resetScore();
                                                      provider.resetIndex();
                                                      provider.resetAnswer();

                                                      // navigating to main screen if question are over

                                                      Navigator.of(context)
                                                          .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) {
                                                        return const MainMenuScreen();
                                                      }), (route) => false);
                                                    },
                                                    child: const Text('Ok'))
                                              ],
                                            );
                                          });
                                    } else {
                                      // changing question
                                      provider.increaseIndex();

                                      // changing answer set
                                      provider.chnageAnswerSet();
                                      provider.resetAnswer();
                                    }

                                    if (provider.selectedQuestionIndex <
                                        provider.questions.length - 1) {
                                      _timer = Timer.periodic(
                                          const Duration(seconds: 10), (timer) {
                                        print(provider.selectedQuestionIndex);
                                        provider.increaseIndex();
                                        provider.chnageAnswerSet();
                                      });
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
                                                              ['correctAnswer'])
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
      );
    });
  }
}
