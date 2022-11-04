import 'package:flutter/material.dart';

import '../widgets/bottom_nav_bar.dart';
import '../widgets/side_drawer.dart';
import './first_tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Studentifier',
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1?.color),
            ),
            iconTheme: Theme.of(context).iconTheme,
          ),
          body: FirstTab(),
          drawer: SideDrawer(),
          bottomNavigationBar: BottomNavBar()),
    );
  }
}
