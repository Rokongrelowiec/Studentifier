import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../models/theme_provider.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  File? image;

  Future pickImage(ImageSource source) async {
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
      debugPrint('Failed to pick image: $e');
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
            CupertinoActionSheetAction(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color.fromRGBO(255, 55, 55, 1)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              isDefaultAction: true,
            ),
          ],
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
    return OrientationBuilder(
      builder: (ctx, orientation) => Drawer(
        elevation: 0,
        child: ListView(
          padding: Platform.isIOS ? EdgeInsets.only(top: 30) : EdgeInsets.zero,
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
                      onTap: showImageSource,
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
