import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/theme_provider.dart';

class SideDrawer extends StatelessWidget {
  SideDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (ctx, orientation) => Drawer(
        elevation: 0,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              height: orientation == Orientation.portrait
                  ? MediaQuery.of(context).size.height * 0.25
                  : MediaQuery.of(context).size.height * 0.35,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.orangeAccent,
                      radius: 50,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 14,
                        ),
                        Text('Witaj!',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color)),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: 100,
                          child: Text('Salazar Drumin',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis)),
                        ),
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
            Divider(
              thickness: 1,
              color: Colors.grey,
            ),
            Column(
              children: [
                ListTile(
                  title: Text(
                    'Select Mode',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  trailing: Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                    return DropdownButton(
                      dropdownColor: Theme.of(context).drawerTheme.backgroundColor,
                      value: provider.currentTheme,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      elevation: 16,
                      style: TextStyle(color: Colors.orange.withOpacity(0.7)),
                      underline: Container(
                        height: 1,
                        color: Colors.orangeAccent,
                      ),
                      onChanged: (String? value) {
                        provider.changeTheme(value ?? 'system');
                        Navigator.of(context).pop();
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text('Light'),
                          value: 'light',
                        ),
                        DropdownMenuItem(
                          child: Text('Dark'),
                          value: 'dark',
                        ),
                        DropdownMenuItem(
                          child: Text('System'),
                          value: 'system',
                        ),
                      ],
                    );
                  }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.analytics,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'Statistics',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () {
                    print('Clicked Statistics');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.settings,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () {
                    print('Clicked Settings');
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
