import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import './first_tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List iconsList = [Icons.dark_mode, Icons.settings, Icons.analytics];

  List namesList = ['Mode', 'Settings', 'Statistics'];

  List iconsNavBar = [Icons.camera, Icons.find_in_page, Icons.calendar_month];

  List navBarNames = ['OCR', 'DailyReport', 'MonthlyReport'];

  String? username = 'Salazar';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Studentifier'),
        ),
        body: FirstTab(),
        drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  color: Theme.of(context).backgroundColor,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.orangeAccent,
                          radius: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Witaj',
                                style: TextStyle(fontSize: 20),
                              ),
                              Spacer(),
                              Text(
                                username == null ? '' : '$username!',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              Spacer(),
                            ],
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.power_settings_new_outlined),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: iconsList.length,
                    itemBuilder: (ctx, index) => Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          child: ListTile(
                            leading: Icon(iconsList[index]),
                            title: Text(namesList[index]),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: GNav(
              backgroundColor: Colors.black,
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: Colors.grey.shade800,
              padding: EdgeInsets.all(16),
              gap: 8,
              onTabChange: (tabIndex){
                print(tabIndex.toString());
              },
              tabs: [
                GButton(icon:  iconsNavBar[0], text: navBarNames[0],),
                GButton(icon:  iconsNavBar[1], text: navBarNames[1],),
                GButton(icon:  iconsNavBar[2], text: navBarNames[2],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
