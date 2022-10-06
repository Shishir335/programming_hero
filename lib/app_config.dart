import 'package:flutter/cupertino.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

const backgroundColor = Color(0xFF010133);

const appName = 'Programming Hero';

const appIcon = 'assets/icons/Logo.png';

Widget progressIndicator(Color color, double size) {
  return LoadingAnimationWidget.staggeredDotsWave(color: color, size: size);
}
