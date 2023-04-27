import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './home_screen.dart';
import '../widgets/app_bar_widget.dart';

class DenyScreen extends StatelessWidget {
  static const routeName = '/deny-screen';

  const DenyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String desc = ModalRoute.of(context)!.settings.arguments as String;
    if (Platform.isIOS) {
      return GenerateDenyScreen(description: desc);
    } else {
      return SafeArea(
        child: GenerateDenyScreen(
          description: desc,
        ),
      );
    }
  }
}

class GenerateDenyScreen extends StatelessWidget {
  final String description;

  GenerateDenyScreen({Key? key, required this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.denied_entry,
        appBar: AppBar(),
        backFunction: () =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                child: Text(
                  AppLocalizations.of(context)!.denied_entry,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color,
                    fontSize: sizeHeight * 5,
                  ),
                ),
              ),
              Image(
                image: AssetImage(
                  'assets/images/no_car.png',
                ),
                height: sizeHeight * 40,
                width: sizeHeight * 40,
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: sizeHeight * 2, horizontal: sizeHeight),
                child: Text(
                  '${AppLocalizations.of(context)!.rejection_reason} '
                  '$description',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color,
                    fontSize: sizeHeight * 4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: sizeHeight, horizontal: sizeHeight * 2),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2)),
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber('+48730724858');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.call_caretaker,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.headline1?.color,
                        ),
                      ),
                      Icon(
                        Icons.phone,
                        color: Theme.of(context).iconTheme.color,
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: sizeHeight, horizontal: sizeHeight * 2),
                child: ElevatedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Theme.of(context).primaryColor, width: 2)),
                  onPressed: () => Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routeName),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.home_screen_return,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                        ),
                      ),
                      Icon(Icons.keyboard_return_outlined)
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
