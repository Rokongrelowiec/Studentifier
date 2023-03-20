import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/app_bar_widget.dart';

class AboutApp extends StatelessWidget {
  static const routeName = '/about-app';

  const AboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateAboutApp()
      : SafeArea(
          child: GenerateAboutApp(),
        );
}

class GenerateAboutApp extends StatelessWidget {
  const GenerateAboutApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: 'About the App',
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: sizeHeight),
                child: Text(
                  'Studentifier',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: sizeHeight * 7,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'The Studentifier App was created to provide better'
                  ' verification of incoming cars.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.7,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'Also this app can help lecturers to find free parking spaces.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.4,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: sizeHeight * 2),
                child: Text(
                  'How it works?',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: sizeHeight * 2.8,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'The application scans the license plate of the oncoming car'
                  ' and verify it.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'After approval - the application checks if this license plate'
                  ' belongs to lecturer.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'If belongs - open a gate, but if not - ask for student ID'
                  ' card.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'If student is approved then the gate will open and his data'
                  ' will be added into Data Base.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: sizeHeight * 2),
                child: Text(
                  'But if not verified - then student has access to call to'
                  ' the care taker.',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.4,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sizeHeight),
                child: Text(
                  'Simple, right?',
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color,
                      fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
