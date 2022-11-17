import 'dart:io';

import 'package:flutter/material.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About the App',
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  'Studentifier',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'The Studentifier App was created to provide better'
                  ' verification of incoming cars.',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'Also this app can help lecturers to find free parking spaces.',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(10, 30, 10, 20),
                child: Text(
                  'How it works?',
                  style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'The application scans the license plate of the oncoming car'
                  ' and verify it.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'After approval - the application checks if this license plate'
                  ' belongs to lecturer.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'If belongs - open a gate, but if not - ask for student ID'
                      ' card.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'If student is approved then the gate will open and his data'
                  ' will be added into Data Base.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  'But if not verified - then student has access to call to'
                  ' the care taker.',
                  style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: Text(
                  'Simple, right?',
                  style: TextStyle(
                      fontSize: 20,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
