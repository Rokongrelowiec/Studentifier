import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).navigationBarTheme.backgroundColor,
      child: Padding(
        padding: Platform.isIOS
            ? const EdgeInsets.fromLTRB(5, 5, 5, 17)
            : const EdgeInsets.all(5),
        child: GNav(
          backgroundColor:
              Theme.of(context).navigationBarTheme.backgroundColor as Color,
          color: Colors.white,
          activeColor: Colors.white,
          tabBackgroundColor:
              Theme.of(context).navigationBarTheme.indicatorColor as Color,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          gap: 8,
          onTabChange: (tabIndex) {
            print(tabIndex.toString());
          },
          tabs: [
            GButton(
              icon: Icons.camera,
              text: 'OCR',
            ),
            GButton(
              icon: Icons.find_in_page,
              text: 'Daily Report',
            ),
            GButton(
              icon: Icons.calendar_month,
              text: 'Monthly Report',
            ),
          ],
        ),
      ),
    );
  }
}
