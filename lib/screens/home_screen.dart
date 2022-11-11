import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/side_drawer.dart';
import './first_tab.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateHomeScreen()
      : SafeArea(child: GenerateHomeScreen());
}

class GenerateHomeScreen extends StatelessWidget {
  const GenerateHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isAdmin = (ModalRoute.of(context)?.settings.arguments ?? false) as bool;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Studentifier',
            style:
                TextStyle(color: Theme.of(context).textTheme.headline1?.color),
          ),
          iconTheme: Theme.of(context).iconTheme,
        ),
        body: SingleChildScrollView(
          child: FirstTab(),
        ),
        drawer: SideDrawer(isAdmin: isAdmin,),
        bottomNavigationBar: BottomNavBar());
  }
}
