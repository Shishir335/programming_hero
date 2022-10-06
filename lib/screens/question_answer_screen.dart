import 'package:flutter/material.dart';
import 'package:programming_hero/app_config.dart';
import 'package:programming_hero/provider/quiz_provider.dart';
import 'package:provider/provider.dart';

class QuestionAnswerScreen extends StatefulWidget {
  const QuestionAnswerScreen({Key? key}) : super(key: key);

  @override
  State<QuestionAnswerScreen> createState() => _QuestionAnswerScreenState();
}

class _QuestionAnswerScreenState extends State<QuestionAnswerScreen> {
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
                          Text('Question: ',
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          Text('Score: ',
                              style: TextStyle(
                                  color: backgroundColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ]),
                  ),
                )
              ]),
      );
    });
  }
}
