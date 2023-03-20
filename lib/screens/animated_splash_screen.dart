import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart' as ASS;
import 'package:page_transition/page_transition.dart';

import './home_screen.dart';

class AnimatedSplashScreen extends StatelessWidget {
  AnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateAnimatedSplashScreen()
      : SafeArea(child: GenerateAnimatedSplashScreen());
}

class GenerateAnimatedSplashScreen extends StatelessWidget {
  const GenerateAnimatedSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.yellow, Colors.deepOrangeAccent]),
      ),
      child: ASS.AnimatedSplashScreen(
        backgroundColor: Colors.transparent,
        splashIconSize: sizeHeight * 31,
        splash: Column(
          children: [
            Icon(
              Icons.select_all_rounded,
              color: Colors.white,
              size: sizeHeight * 12.5,
            ),
            Text(
              "Studentifier",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: sizeHeight * 5,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
        nextScreen: HomeScreen(),
        duration: 500,
        splashTransition: ASS.SplashTransition.sizeTransition,
        pageTransitionType: PageTransitionType.rightToLeft,
      ),
    );
  }
}
