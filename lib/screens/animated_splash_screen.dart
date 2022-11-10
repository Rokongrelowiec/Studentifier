import 'dart:io';

import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart' as ASP;
import 'package:page_transition/page_transition.dart';

import './login_screen.dart';

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
    return Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFE0664A), Colors.orange]),
        ),
        child: ASP.AnimatedSplashScreen(
          backgroundColor: Colors.transparent,
          splashIconSize: 250,
          splash: Column(
            children: [
              Icon(
                Icons.layers,
                color: Colors.white,
                size: 90,
              ),
              Text("Studentifier", style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold
              ),)
            ],
          ),
          nextScreen: LoginScreen(),
          duration: 1500,
          splashTransition: ASP.SplashTransition.sizeTransition,
          pageTransitionType: PageTransitionType.rightToLeft,
        ),

    );
  }
}
