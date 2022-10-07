import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

// all the basic app information is here. these will be used during farther development

const backgroundColor = Color(0xFF010133);

const appName = 'Programming Hero';

const appIcon = 'assets/icons/Logo.png';

const url = 'https://herosapp.nyc3.digitaloceanspaces.com/quiz.json';

Widget progressIndicator(Color color, double size) {
  return LoadingAnimationWidget.staggeredDotsWave(color: color, size: size);
}
