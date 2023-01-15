import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

import './home_screen.dart';

class AddedDataScreen extends StatelessWidget {
  String name;
  String surname;
  int studentId;
  String licensePlate;
  String scanTime;
  bool isPrivileged;

  AddedDataScreen({
    Key? key,
    required this.name,
    required this.surname,
    required this.studentId,
    required this.licensePlate,
    required this.scanTime,
    required this.isPrivileged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateAddedDataScreen(
          name: name,
          surname: surname,
          studentId: studentId,
          licensePlate: licensePlate,
          scanTime: scanTime,
      isPrivileged: isPrivileged,
        )
      : SafeArea(
          child: GenerateAddedDataScreen(
            name: name,
            surname: surname,
            studentId: studentId,
            licensePlate: licensePlate,
            scanTime: scanTime,
              isPrivileged: isPrivileged,
          ),
        );
}

class GenerateAddedDataScreen extends StatefulWidget {
  String name;
  String surname;
  int studentId;
  String licensePlate;
  String scanTime;
  bool isPrivileged;

  GenerateAddedDataScreen({
    Key? key,
    required this.name,
    required this.surname,
    required this.studentId,
    required this.licensePlate,
    required this.scanTime,
    required this.isPrivileged,
  }) : super(key: key);

  @override
  State<GenerateAddedDataScreen> createState() =>
      _GenerateAddedDataScreenState();
}

class _GenerateAddedDataScreenState extends State<GenerateAddedDataScreen> {
  static const maxSeconds = 10;
  int seconds = maxSeconds;
  Timer? timer;
  bool isPlaying = false;
  final controller = ConfettiController();

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      setState(() {
        seconds--;
      });
      if (seconds < -5) {
        controller.stop();
        Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    startTimer();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              'Summary',
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color),
            ),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  HomeScreen.routeName, (route) => false),
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.9),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'The gate has been opened!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: 28),
                    ),
                    Text(
                      'Thank you for scan!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: 25),
                    ),
                    // TODO comment Text widget below -> self data validation
                    // Text(
                    //   'Your data: ${widget.name}, ${widget.surname}, ${widget.studentId},\n'
                    //       '${widget.scanTime}, ${widget.licensePlate}, ${widget.isPrivileged}',
                    //   style: TextStyle(
                    //     color: Theme.of(context).textTheme.headline1?.color,
                    //   ),
                    // ),
                    buildTimer(),
                    Text(
                      'Soon you will return to the home screen',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: 22),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ConfettiWidget(
          confettiController: controller,
          blastDirection: pi / 2,
          numberOfParticles: 10,
        ),
      ],
    );
  }

  buildTimer() => SizedBox(
        width: 200,
        height: 200,
        child: Stack(
          fit: StackFit.expand,
          children: [
            CircularProgressIndicator(
              value: seconds / maxSeconds,
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).iconTheme.color),
              strokeWidth: 12,
              backgroundColor: Theme.of(context).primaryColor,
            ),
            Center(
              child: buildTime(),
            ),
          ],
        ),
      );

  Widget buildTime() {
    if (seconds <= 0) {
      controller.play();
      return Icon(Icons.done,
          color: Theme.of(context).iconTheme.color, size: 80);
    } else {
      return Text(
        '$seconds',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Theme.of(context).textTheme.headline1?.color,
          fontSize: 80,
        ),
      );
    }
  }
}
