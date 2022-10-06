import 'package:flutter/cupertino.dart';

class QuizProvider with ChangeNotifier {
  List<dynamic> _questions = [];
  List<dynamic> get questions => _questions;

  changeQuestions(dynamic value) {
    _questions.clear();
    _questions = value;
  }

  notify() {
    notifyListeners();
  }
}
