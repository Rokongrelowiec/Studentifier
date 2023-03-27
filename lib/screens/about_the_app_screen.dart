import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        title: AppLocalizations.of(context)!.about_the_app,
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
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                 AppLocalizations.of(context)!.app_description1,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.7,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                    AppLocalizations.of(context)!.app_description2,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.4,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.how_works,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                      fontSize: sizeHeight * 2.8,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.app_description3,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.app_description4,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.app_description5,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.app_description6,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.6,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.app_description7,
                  style: TextStyle(
                      fontSize: sizeHeight * 2.4,
                      color: Theme.of(context).textTheme.headline1?.color),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: sizeHeight, bottom: sizeHeight + 5),
                child: Text(
                  AppLocalizations.of(context)!.simple_right,
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
