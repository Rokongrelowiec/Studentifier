import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './daily_report_screen.dart';
import './monthly_report_screen.dart';
import './orc_screen.dart';
import '../widgets/app_bar_widget.dart';
import '../widgets/side_drawer.dart';

import './license_screen.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home-screen';

  HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateHomeScreen()
      : SafeArea(child: GenerateHomeScreen());
}

class GenerateHomeScreen extends StatefulWidget {
  GenerateHomeScreen({Key? key}) : super(key: key);

  @override
  State<GenerateHomeScreen> createState() => _GenerateHomeScreenState();
}

class _GenerateHomeScreenState extends State<GenerateHomeScreen> {
  List navBarWidgets = [OCRScreen(), DailyReport(), MonthlyReport()];
  int activeIndex = 0;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBarWidget(
        title: 'Studentifier',
        appBar: AppBar(),
        isBackIcon: true,
        backIcon: Icons.menu,
        backFunction: () => scaffoldKey.currentState?.openDrawer(),
      ),
      body: navBarWidgets[activeIndex],
      drawer: SideDrawer(),
      bottomNavigationBar: Container(
        color: Theme.of(context).navigationBarTheme.backgroundColor,
        child: Padding(
          padding: Platform.isIOS
              ? const EdgeInsets.fromLTRB(5, 5, 5, 20)
              : const EdgeInsets.all(5),
          child: GNav(
            backgroundColor:
                Theme.of(context).navigationBarTheme.backgroundColor as Color,
            color: Colors.white,
            activeColor: Colors.white,
            tabBackgroundColor:
                Theme.of(context).navigationBarTheme.indicatorColor as Color,
            padding: EdgeInsets.symmetric(
                horizontal: sizeHeight * 1.15, vertical: sizeHeight * 2),
            gap: 8,
            onTabChange: (tabIndex) {
              setState(() {
                activeIndex = tabIndex;
              });
            },
            tabs: [
              GButton(
                icon: Icons.camera_alt,
                text: 'OCR',
              ),
              GButton(
                icon: Icons.find_in_page,
                text: AppLocalizations.of(context)!.daily_report,
              ),
              GButton(
                icon: Icons.calendar_month,
                text: AppLocalizations.of(context)!.monthly_report,
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.orangeAccent,
      //   onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(
      //       builder: (ctx) => LicenseScreen(license: "VIPET"))),
      //   child: Icon(Icons.arrow_forward),
      // ),
    );
  }
}
