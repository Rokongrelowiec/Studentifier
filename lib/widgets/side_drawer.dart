import 'dart:io' show File, Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:studentifier/l10n/l10n.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';
import '../providers/admin_provider.dart';
import '../providers/avatar_provider.dart';
import '../screens/about_the_app_screen.dart';
import '../screens/chart_screen.dart';
import '../screens/registered_license_plates.dart';
import '../screens/login_screen.dart';
import '../screens/parking_limit_screen.dart';

class SideDrawer extends StatefulWidget {
  SideDrawer({Key? key}) : super(key: key);

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  File? image;

  Future<void> pickImage(ImageSource source) async {
    try {
      final XFile? image = await ImagePicker().pickImage(source: source);
      if (image != null) {
        Provider.of<AvatarProvider>(context, listen: false)
            .saveImagePath(image.path);
      }
    } on PlatformException {}
  }

  showImageSource() {
    if (Platform.isIOS) {
      return showCupertinoModalPopup(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: Text(
                AppLocalizations.of(context)!.gallery,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              onPressed: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            CupertinoActionSheetAction(
              child: Text(
                AppLocalizations.of(context)!.camera,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.025,
                ),
              ),
              onPressed: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.height * 0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
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
              leading: Icon(
                Icons.image,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
              title: Text(
                AppLocalizations.of(context)!.gallery,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              onTap: () {
                pickImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.camera_alt,
                size: MediaQuery.of(context).size.height * 0.04,
              ),
              title: Text(
                AppLocalizations.of(context)!.camera,
                style: TextStyle(
                  fontSize: MediaQuery.of(context).size.height * 0.02,
                ),
              ),
              onTap: () {
                pickImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            Divider(thickness: 1, color: Colors.grey),
            ListTile(
              leading: Icon(
                Icons.close,
                size: MediaQuery.of(context).size.height * 0.04,
                color: Color.fromRGBO(255, 55, 55, 1),
              ),
              title: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(
                    color: Color.fromRGBO(255, 55, 55, 1),
                    fontSize: MediaQuery.of(context).size.height * 0.02,
                    fontWeight: FontWeight.bold),
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
    final isAdmin = Provider.of<AdminProvider>(context).adminPermission;
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    final avatarProv = Provider.of<AvatarProvider>(context);
    final avatarImgPath = avatarProv.avatarImgPath;

    if (avatarImgPath == null) {
      avatarProv.loadImagePath();
    }

    Widget loadAvatarImg(avatarImgPath) {
      File file = File(avatarImgPath);
      if (file.existsSync()) {
        return ClipOval(
          child: Image.file(
            File(avatarImgPath),
            width: sizeHeight * 25,
            height: sizeHeight * 25,
            fit: BoxFit.cover,
          ),
        );
      } else {
        return Icon(
          Icons.tag_faces_outlined,
          size: sizeHeight * 8,
          color: Colors.white,
        );
      }
    }

    _title(String val) {
      switch (val) {
        case 'en':
          return Text(
            'English',
            style: TextStyle(fontSize: sizeHeight * 2),
          );
        case 'pl':
          return Text(
            'Polski',
            style: TextStyle(fontSize: sizeHeight * 2),
          );
        default:
          return Text(
            'English',
            style: TextStyle(fontSize: sizeHeight * 2),
          );
      }
    }

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
                  ? sizeHeight * 25
                  : sizeHeight * 35,
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
                        child: (avatarImgPath != null && isAdmin)
                            ? loadAvatarImg(avatarImgPath)
                            : Icon(
                                Icons.tag_faces_outlined,
                                size: sizeHeight * 8,
                                color: Colors.white,
                              ),
                        radius: sizeHeight * 6,
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
                          height: sizeHeight * 1.6,
                        ),
                        Text(AppLocalizations.of(context)!.hi,
                            style: TextStyle(
                                fontSize: sizeHeight * 3,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color)),
                        SizedBox(
                          height: sizeHeight * 2,
                        ),
                        Container(
                          width: sizeHeight * 14,
                          child: Text(
                              isAdmin
                                  ? "admin!"
                                  : '${AppLocalizations.of(context)!.guest}!',
                              style: TextStyle(
                                  fontSize: sizeHeight * 3,
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color,
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis)),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  isAdmin
                      ? Padding(
                          padding: EdgeInsets.only(right: sizeHeight),
                          child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  backgroundColor: Theme.of(context)
                                      .drawerTheme
                                      .backgroundColor,
                                  title: Text(
                                    AppLocalizations.of(context)!.sing_out,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color,
                                        fontSize: sizeHeight * 3),
                                  ),
                                  content: Text(
                                    AppLocalizations.of(context)!.sing_out_msg,
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color,
                                        fontSize: sizeHeight * 2.5),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                      child: Text(
                                        AppLocalizations.of(context)!.cancel,
                                        style:
                                            TextStyle(fontSize: sizeHeight * 2),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Provider.of<AdminProvider>(context,
                                                listen: false)
                                            .changePermission(false);
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        'OK',
                                        style:
                                            TextStyle(fontSize: sizeHeight * 2),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.power_settings_new_outlined,
                              size: sizeHeight * 4,
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Divider(
              thickness: sizeHeight / 8,
              color: Colors.grey,
            ),
            Column(
              children: [
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.mode,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: sizeHeight * 2),
                  ),
                  trailing: Consumer<ThemeProvider>(
                      builder: (context, provider, child) {
                    return DropdownButton(
                      dropdownColor:
                          Theme.of(context).drawerTheme.backgroundColor,
                      value: provider.currentTheme,
                      icon: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: sizeHeight * 4,
                      ),
                      elevation: 16,
                      style: TextStyle(color: Colors.orange.withOpacity(0.7)),
                      underline: Container(
                        height: 1,
                        color: Colors.orangeAccent,
                      ),
                      onChanged: (String? value) {
                        provider.changeTheme(value ?? 'system');
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text(
                            AppLocalizations.of(context)!.light,
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                          value: 'light',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            AppLocalizations.of(context)!.dark,
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                          value: 'dark',
                        ),
                        DropdownMenuItem(
                          child: Text(
                            AppLocalizations.of(context)!.system,
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                          value: 'system',
                        ),
                      ],
                    );
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeHeight),
                  child: Divider(
                    thickness: sizeHeight * 0.1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  title: Text(
                    AppLocalizations.of(context)!.language,
                    style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: sizeHeight * 2),
                  ),
                  trailing: Consumer<LocaleProvider>(
                      builder: (context, provider, child) {
                    var lang =
                        provider.isSystemLang ? 'system' : provider.currentLang;
                    return DropdownButton(
                        dropdownColor:
                            Theme.of(context).drawerTheme.backgroundColor,
                        value: lang,
                        icon: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: sizeHeight * 4,
                        ),
                        elevation: 16,
                        style: TextStyle(color: Colors.orange.withOpacity(0.7)),
                        underline: Container(
                          height: 1,
                          color: Colors.orangeAccent,
                        ),
                        onChanged: (String? val) {
                          provider.changeLang(val ?? 'system');
                        },
                        items: [
                          ...L10n.all.map((e) => DropdownMenuItem(
                                value: e.toString(),
                                child: _title(e.languageCode),
                              )),
                          DropdownMenuItem(
                            value: 'system',
                            child: Text(
                              AppLocalizations.of(context)!.system,
                              style: TextStyle(fontSize: sizeHeight * 2),
                            ),
                          )
                        ]);
                  }),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: sizeHeight),
                  child: Divider(
                    thickness: sizeHeight * 0.1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.ssid_chart,
                    size: sizeHeight * 3.5,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.chart,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: sizeHeight * 2,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(ChartScreen.routeName);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: sizeHeight * 0.1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    Icons.text_snippet,
                    color: Theme.of(context).iconTheme.color,
                    size: sizeHeight * 3.5,
                  ),
                  title: Text(
                    AppLocalizations.of(context)!.about_the_app,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: sizeHeight * 2,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed(AboutApp.routeName);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: sizeHeight * 0.1,
                    color: Colors.black,
                  ),
                ),
                ListTile(
                  trailing: Icon(
                    isAdmin ? Icons.drive_eta : Icons.settings,
                    size: sizeHeight * 3.5,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    isAdmin
                        ? AppLocalizations.of(context)!
                            .registered_license_plates
                        : AppLocalizations.of(context)!.settings,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.displayLarge?.color,
                      fontSize: sizeHeight * 2,
                    ),
                  ),
                  onTap: () {
                    if (!isAdmin)
                      Navigator.of(context).pushNamed(LoginScreen.routeName);
                    else
                      Navigator.of(context)
                          .pushNamed(RegisteredLicensePlates.routeName);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Divider(
                    thickness: sizeHeight * 0.1,
                    color: Colors.black,
                  ),
                ),
                isAdmin
                    ? ListTile(
                        trailing: Icon(
                          Icons.local_parking,
                          size: sizeHeight * 3.5,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.parking_limit,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                            fontSize: sizeHeight * 2,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .pushNamed(ParkingLimitScreen.routeName);
                        },
                      )
                    : Container(),
                isAdmin
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: sizeHeight * 0.1,
                          color: Colors.black,
                        ),
                      )
                    : Container(),
                isAdmin
                    ? ListTile(
                        trailing: Icon(
                          Icons.code,
                          size: sizeHeight * 3.5,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        title: Text(
                          AppLocalizations.of(context)!.source_code,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
                            fontSize: sizeHeight * 2,
                          ),
                        ),
                        onTap: () async {
                          final Uri url = Uri.parse(
                              "https://github.com/Rokongrelowiec/Studentifier");
                          if (!await launchUrl(url))
                            throw 'Could not launch $url';
                        },
                      )
                    : Container(),
                isAdmin
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Divider(
                          thickness: sizeHeight * 0.1,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
          ],
        ),
      ),
    );
  }
}
