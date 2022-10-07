import 'package:flutter/cupertino.dart';

import '../models/answer_set.dart';

class QuizProvider with ChangeNotifier {
  List<dynamic> _questions = [];
  List<dynamic> get questions => _questions;

  changeQuestions(dynamic value) {
    _questions.clear();
    _questions = value;
    notifyListeners();
  }

  int _selectedQuestionIndex = 0;
  int get selectedQuestionIndex => _selectedQuestionIndex;

  increaseIndex() {
    _selectedQuestionIndex++;
    notifyListeners();
  }

  resetIndex() {
    _selectedQuestionIndex = 0;
    notifyListeners();
  }

  int _score = 0;
  int get score => _score;

  addScore(int value) {
    _score = _score + value;
    notifyListeners();
  }

  resetScore() {
    _score = 0;
    notifyListeners();
  }

  List<AnswerSet> _answers = [];
  List<AnswerSet> get answers => _answers;

  chnageAnswerSet() {
    if (_questions.isNotEmpty) {
      Map<String, dynamic> answersMap =
          _questions[selectedQuestionIndex]['answers'];

      answers.clear();
      for (String key in answersMap.keys) {
        answers.add(AnswerSet(label: key, answer: answersMap[key]));
      }

      answers.shuffle();
    }
  }

  int? _answersIndex;
  int? get answersIndex => _answersIndex;

  changeAnswerIndex(int value) {
    _answersIndex = value;
    notifyListeners();
  }

  resetAnswer() {
    _answersIndex = null;
    notifyListeners();
  }

  String? _correctAns;
  String? get correctAns => _correctAns;

  chnageCorrectAns(String value) {
    _correctAns = value;
    notifyListeners();
  }

  resetCorrectAns() {
    _correctAns = null;
    notifyListeners();
  }
}
