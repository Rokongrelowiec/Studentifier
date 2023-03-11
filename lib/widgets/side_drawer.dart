import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../screens/about_the_app_screen.dart';
import '../screens/chart_screen.dart';
import '../screens/registered_license_plates.dart';
import '../models/admin_provider.dart';
import '../screens/login_screen.dart';
import '../models/theme_provider.dart';

class SideDrawer extends StatefulWidget {

  SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  File? image;

  Future pickImage(ImageSource source) async {
    // TODO Save image -> DB
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      // final imagePermanent = await saveImagePermanently(image.path);

      setState(() {
        this.image = imageTemporary;
        // this.image = imagePermanent;
      });
    } on PlatformException catch (e) {
      // debugPrint('Failed to pick image: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = Path.basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  showImageSource() {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Camera'),
              onPressed: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      );
    } else {
      return showModalBottomSheet(
        context: context,
        builder: (ctx) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.image),
              title: Text('Gallery'),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.camera),
              title: Text('Camera'),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: Icon(Icons.close),
              title: Text(
                'Cancel',
                style: TextStyle(color: Color.fromRGBO(255, 55, 55, 1)),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AdminProvider>(context).isAdmin;
    return OrientationBuilder(
      builder: (ctx, orientation) => Drawer(
        elevation: 0,
        child: ListView(
          padding: Platform.isIOS
              ? EdgeInsets.only(top: 50)
              : EdgeInsets.only(top: 20),
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
                    child: InkWell(
                      onTap: isAdmin ? showImageSource : null,
                      child: CircleAvatar(
                        backgroundColor: Colors.orangeAccent,
                        child: image != null
                            ? ClipOval(
                                child: Image.file(
                                  image!,
                                  width: 200,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.tag_faces_outlined,
                                size: 60,
                                color: Colors.white,
                              ),
                        radius: 50,
                      ),
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
                        Text('Hi',
                            style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color)),
                        SizedBox(
                          height: 22,
                        ),
                        Container(
                          width: 100,
                          child: Text(isAdmin ? 'admin!' : 'there!',
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
                  isAdmin
                      ? IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => AlertDialog(
                                backgroundColor: Theme.of(context)
                                    .drawerTheme
                                    .backgroundColor,
                                title: Text(
                                  'Sing out',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                  ),
                                ),
                                content: Text(
                                  'Are you sure you want to sign out?',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Provider.of<AdminProvider>(context, listen: false).changePermission(false);
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.power_settings_new_outlined),
                        )
                      : Container(),
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
                    'Select mode',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  trailing: Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                    return DropdownButton(
                      dropdownColor:
                          Theme.of(context).drawerTheme.backgroundColor,
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
                    Icons.ssid_chart,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'Chart',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(ChartScreen.routeName);
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
                    Icons.text_snippet,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'About the app',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(AboutApp.routeName);
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
                    isAdmin ? Icons.drive_eta : Icons.settings,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    isAdmin ? 'Registered license plates' : 'Setting',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () {
                    if (!isAdmin)
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    else
                      Navigator.of(context).pushNamed(RegisteredLicensePlates.routeName);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ),

                isAdmin ? ListTile(
                  trailing: Icon(
                    Icons.code,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    'Source code',
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  onTap: () async {
                    final Uri url = Uri.parse("https://github.com/Rokongrelowiec/Studentifier");
                    if (!await launchUrl(url))
                      throw 'Could not launch $url';
                  },
                ) : Container(),
                isAdmin ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ) : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
