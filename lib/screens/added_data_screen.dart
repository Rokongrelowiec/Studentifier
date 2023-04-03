// import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './home_screen.dart';
import '../widgets/app_bar_widget.dart';

class AddedDataScreen extends StatelessWidget {
  final String? name;
  final String? surname;
  final int? studentId;
  final String licensePlate;
  final String scanTime;
  final bool isPrivileged;

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
  final String? name;
  final String? surname;
  final int? studentId;
  final String licensePlate;
  final String scanTime;
  final bool isPrivileged;

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
  // static const maxSeconds = 10;
  // int seconds = maxSeconds;
  // Timer? timer;
  // bool isPlaying = false;
  final controller = ConfettiController();

  // void startTimer() {
  //   timer = Timer.periodic(Duration(seconds: 1), (_) {
  //     setState(() {
  //       seconds--;
  //     });
  //     if (seconds < -5) {
  //       controller.stop();
  //       Navigator.of(context).pushNamedAndRemoveUntil(
  //               HomeScreen.routeName, (route) => false);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    controller.play();
    // startTimer();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Scaffold(
          appBar: AppBarWidget(
            title: AppLocalizations.of(context)!.summary,
            appBar: AppBar(),
            backFunction: () => Navigator.of(context).pushNamedAndRemoveUntil(
                HomeScreen.routeName, (route) => false),
          ),
          body: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: sizeHeight * 85),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.open_gate,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 4),
                    ),
                    Text(
                      AppLocalizations.of(context)!.scan_succeeded,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 3.5),
                    ),
                    // comment Text widget below -> self data validation
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: sizeHeight),
                      child: Text(
                        '${AppLocalizations.of(context)!.your_data}: ${widget.name} ${widget.surname} ${widget.studentId},\n'
                        '${widget.scanTime}, ${widget.licensePlate}, ${widget.isPrivileged}',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 3,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    // buildTimer(),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            HomeScreen.routeName, (route) => false);
                      },
                      icon: Icon(
                        Icons.check_circle_outline_outlined,
                        color: Theme.of(context).primaryColor,
                      ),
                      iconSize: sizeHeight * 25,
                    ),
                    Text(
                      AppLocalizations.of(context)!.summary_icon,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 3),
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

// buildTimer() => SizedBox(
//       width: 200,
//       height: 200,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           CircularProgressIndicator(
//             value: seconds / maxSeconds,
//             valueColor:
//                 AlwaysStoppedAnimation(Theme.of(context).iconTheme.color),
//             strokeWidth: 12,
//             backgroundColor: Theme.of(context).primaryColor,
//           ),
//           Center(
//             child: buildTime(),
//           ),
//         ],
//       ),
//     );

// Widget buildTime() {
//   if (seconds <= 0) {
//     controller.play();
//     return Column(
//       children: [
//         Icon(Icons.done,
//             color: Theme.of(context).iconTheme.color, size: 80),
//         ElevatedButton(onPressed: (){
//           Navigator.of(context).pushNamedAndRemoveUntil(
//               HomeScreen.routeName, (route) => false);
//         }, child: Text('Return'))
//       ],
//     );
//   } else {
//     return Text(
//       '$seconds',
//       style: TextStyle(
//         fontWeight: FontWeight.bold,
//         color: Theme.of(context).textTheme.headline1?.color,
//         fontSize: 80,
//       ),
//     );
//   }
// }
}
