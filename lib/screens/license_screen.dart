import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './added_data_screen.dart';
import './home_screen.dart';
import './qr_scanner_screen.dart';
import './deny_screen.dart';
import '../widgets/app_bar_widget.dart';

class LicenseScreen extends StatefulWidget {
  String license;

  LicenseScreen({Key? key, required this.license}) : super(key: key);

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  late String foundLicense;
  late String scanTime;

  removeAdditionalSymbols(String text) {
    foundLicense = '';
    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp('[A-Za-z0-9]'))) {
        foundLicense += text[i];
      }
    }
  }

  setScanTime() {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    scanTime = dateFormat.format(DateTime.now());
  }

  @override
  void initState() {
    removeAdditionalSymbols(widget.license);
    setScanTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS
          ? GenerateLicenseScreen(
        license: foundLicense,
        scanTime: scanTime,
      )
          : SafeArea(
        child: GenerateLicenseScreen(
          license: foundLicense,
          scanTime: scanTime,
        ),
      );
}

class GenerateLicenseScreen extends StatefulWidget {
  String license;
  String scanTime;

  GenerateLicenseScreen(
      {Key? key, required this.license, required this.scanTime})
      : super(key: key);

  @override
  State<GenerateLicenseScreen> createState() => _GenerateLicenseScreenState();
}

class _GenerateLicenseScreenState extends State<GenerateLicenseScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = new TextEditingController();
    controller.text = widget.license;

    editLicense() {
      if (3 > controller.text.length || controller.text.length > 9) {
        return null;
      } else {
        setState(() {
          String tmpController = '';
          for (int i = 0; i < controller.text.length; i++) {
            tmpController += controller.text[i].toUpperCase();
          }
          widget.license = tmpController;
          Navigator.of(context).pop();
        });
      }
    }

    final sizeHeight = MediaQuery
        .of(context)
        .size
        .height * 0.01;

    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.license_plate3,
        appBar: AppBar(),
        backFunction: () =>
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName),
        actionsList: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        AlertDialog(
                          contentPadding: EdgeInsets.all(sizeHeight * 2),
                          buttonPadding: EdgeInsets.all(sizeHeight),
                          backgroundColor:
                          Theme
                              .of(context)
                              .drawerTheme
                              .backgroundColor,
                          title: Text(
                            '${AppLocalizations.of(context)!
                                .edit} ${AppLocalizations.of(context)!
                                .scanned} ${AppLocalizations.of(context)!
                                .license_plate2}',
                            style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: sizeHeight * 2.5),
                          ),
                          content: Form(
                            key: formKey,
                            autovalidateMode: AutovalidateMode
                                .onUserInteraction,
                            child: TextFormField(
                              autofocus: true,
                              controller: controller,
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: sizeHeight * 2.5,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.edit_note,
                                    color: Theme
                                        .of(context)
                                        .iconTheme
                                        .color,
                                    size: sizeHeight * 5,
                                  ),
                                  labelText: AppLocalizations.of(context)!
                                      .license_plate3
                                      .toLowerCase(),
                                  labelStyle: TextStyle(
                                    fontSize: sizeHeight * 3,
                                  ),
                                  contentPadding: EdgeInsets.all(
                                    sizeHeight * 2,
                                  ),
                                  border: OutlineInputBorder()),
                              validator: (value) {
                                if (value != null && value.length < 4) {
                                  return AppLocalizations.of(context)!
                                      .too_long_val;
                                }
                                if (value != null && value.length > 8)
                                  return AppLocalizations.of(context)!
                                      .too_long_val;
                                return null;
                              },
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[A-Za-z0-9]")),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                controller.text = widget.license;
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                AppLocalizations.of(context)!.cancel,
                                style: TextStyle(
                                  fontSize: sizeHeight * 2,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                final isValidForm =
                                formKey.currentState!.validate();
                                if (isValidForm) {
                                  editLicense();
                                }
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: sizeHeight * 2,
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme
                      .of(context)
                      .iconTheme
                      .color,
                  size: sizeHeight * 4,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              height: sizeHeight,
            ),
            Image(
              image: AssetImage(
                  Theme
                      .of(context)
                      .scaffoldBackgroundColor == Colors.grey[900]
                      ? 'assets/images/ocr_white.png'
                      : 'assets/images/ocr_black.png'),
              height: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.6,
            ),
            SizedBox(
              height: sizeHeight * 0.5,
            ),
            Text(
              '${AppLocalizations.of(context)!.found} ${AppLocalizations.of(
                  context)!.license_plate2}:',
              style: TextStyle(
                fontSize: sizeHeight * 3,
                color: Theme
                    .of(context)
                    .textTheme
                    .headline1
                    ?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: sizeHeight,
            ),
            Text(
              widget.license,
              style: TextStyle(
                fontSize: sizeHeight * 4,
                fontWeight: FontWeight.bold,
                color: Theme
                    .of(context)
                    .textTheme
                    .headline1
                    ?.color,
              ),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
              child: Text(
                AppLocalizations.of(context)!.text_below_license_plate,
                style: TextStyle(
                  fontSize: sizeHeight * 2.5,
                  color: Theme
                      .of(context)
                      .textTheme
                      .headline1
                      ?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: ElevatedButton(
                onPressed: () async {
                  // if exists -> added_data_screen!
                  // if not -> code below
                  String apiKey = await DefaultAssetBundle.of(context)
                      .loadString('assets/api-key.txt');
                  var requestBody =
                  jsonEncode({'licenseplate': '${widget.license}'});
                  var response = await http.post(
                      Uri.parse(
                          'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
                      headers: {'x-api-key': apiKey},
                      body: requestBody);
                  var decodedResponse = jsonDecode(response.body);
                  // debugPrint(decodedResponse.toString());
                  if (decodedResponse.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          AlertDialog(
                            backgroundColor:
                            Theme
                                .of(context)
                                .drawerTheme
                                .backgroundColor,
                            contentPadding: EdgeInsets.all(sizeHeight * 2),
                            buttonPadding: EdgeInsets.all(sizeHeight),
                            title: Text(
                              '${AppLocalizations.of(context)!
                                  .license_plate4} ${AppLocalizations.of(
                                  context)!.not_exist_in_db}',
                              style: TextStyle(
                                  color:
                                  Theme
                                      .of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                  fontSize: sizeHeight * 3),
                            ),
                            content: Text(
                              AppLocalizations.of(context)!.what_wanna_do,
                              style: TextStyle(
                                color: Theme
                                    .of(context)
                                    .textTheme
                                    .headline1
                                    ?.color,
                                fontSize: sizeHeight * 3,
                              ),
                            ),
                            actions: <Widget>[
                              OutlinedButton(
                                onPressed: () async {
                                  await FlutterPhoneDirectCaller.callNumber(
                                      '+48730724858');
                                },
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Theme
                                          .of(context)
                                          .primaryColor),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .call_caretaker,
                                      style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline1
                                            ?.color,
                                        fontSize: sizeHeight * 2.5,
                                      ),
                                    ),
                                    Icon(
                                      Icons.call,
                                      color: Theme
                                          .of(context)
                                          .iconTheme
                                          .color,
                                      size: sizeHeight * 4,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            QRScannerScreen(
                                                licensePlate: widget.license,
                                                scanTime: widget.scanTime),
                                      ),
                                    ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.scan_qr,
                                      style: TextStyle(
                                        color: Theme
                                            .of(context)
                                            .textTheme
                                            .headline1
                                            ?.color,
                                        fontSize: sizeHeight * 2.5,
                                      ),
                                    ),
                                    Icon(
                                      Icons.qr_code,
                                      color: Theme
                                          .of(context)
                                          .iconTheme
                                          .color,
                                      size: sizeHeight * 4,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                    );
                  } else {
                    if (decodedResponse[0]['wykladowca']) {
                      // debugPrint('LECTURER');
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) =>
                              AddedDataScreen(
                                name: null,
                                surname: null,
                                studentId: null,
                                licensePlate: widget.license.toString(),
                                scanTime: widget.scanTime,
                                isPrivileged: true,
                              ),
                        ),
                      );
                    } else {
                      // debugPrint('STUDENT');
                      var studentId = decodedResponse[0]['numer_albumu'];
                      var requestBody = jsonEncode({'numer_albumu': studentId});
                      response = await http.post(
                          Uri.parse(
                              'http://130.61.192.162:8069/api/v1/students/bystudentId'),
                          headers: {'x-api-key': apiKey},
                          body: requestBody);

                      decodedResponse = jsonDecode(response.body);
                      debugPrint(decodedResponse.toString());
                      String studentName = decodedResponse[0]['imie'],
                          studentSurname = decodedResponse[0]['nazwisko'];
                      DateTime cardValidity =
                      DateTime.parse(decodedResponse[0]['data_waznosci']);

                      // Check available spaces
                      response = await http.get(
                        Uri.parse('http://130.61.192.162:8069/api/v1/parking_spots'),
                        headers: {'x-api-key': apiKey},
                      );
                      decodedResponse = jsonDecode(response.body);
                      int parkingLimit = decodedResponse[0]['limit'];
                      final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
                      final String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
                      final String year = (DateFormat.y().format(DateTime.now())).toString();
                      requestBody = jsonEncode({'slice': '${month + year}', 'day': today});
                      response = await http.post(
                        Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
                        headers: {'x-api-key': apiKey},
                        body: requestBody,
                      );
                      decodedResponse = jsonDecode(response.body);
                      // debugPrint(decodedResponse.toString());
                      int occupiedPlaces = decodedResponse.length;
                      // debugPrint(occupiedPlaces.toString());
                      // debugPrint(parkingLimit.toString());

                      if (occupiedPlaces >= parkingLimit) {
                        Navigator.of(context)
                            .pushReplacementNamed(
                            DenyScreen.routeName, arguments: AppLocalizations
                            .of(context)!.parking_limit2);
                      }
                      else {
                        // Check validity of student ID
                        // response = await http.post(
                        //   Uri.parse(
                        //       'http://130.61.192.162:8069/api/v1/students/active/checkone'),
                        //   headers: {'x-api-key': apiKey},
                        //   body: requestBody,
                        // );
                        // decodedResponse = jsonDecode(response.body);
                        // DateTime cardValidity =
                        // DateTime.parse(decodedResponse[0]['data_waznosci']);

                        if (cardValidity
                            .difference(DateTime.now())
                            .inDays >= 0) {
                          DateTime date = DateTime.parse('${widget.scanTime}');
                          // debugPrint(date.toString());
                          var day = DateFormat('yyyy-MM-dd').format(date);
                          var hour = '${DateFormat.Hms().format(date)}+00';

                          // Send to DB!
                          String month = (DateFormat.MMM().format(
                              DateTime.now()))
                              .toUpperCase();
                          String year =
                          (DateFormat.y().format(DateTime.now())).toString();
                          requestBody = jsonEncode({
                            'slice': '${month + year}',
                            'rejestracja': '${widget.license}',
                            'godzinaPrzyjazdu': hour,
                            'dzien': day
                          });
                          // debugPrint(requestBody);
                          response = await http.post(
                              Uri.parse(
                                'http://130.61.192.162:8069/api/v1/logs/log/entry',
                              ),
                              headers: {'x-api-key': apiKey},
                              body: requestBody);
                          if (response.statusCode == 200) {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (_) =>
                                    AddedDataScreen(
                                      name: studentName,
                                      surname: studentSurname,
                                      studentId: studentId,
                                      licensePlate: widget.license.toString(),
                                      scanTime: widget.scanTime,
                                      isPrivileged: false,
                                    ),
                              ),
                            );
                          }
                        } else {
                          Navigator.of(context)
                              .pushReplacementNamed(
                              DenyScreen.routeName, arguments: AppLocalizations
                              .of(context)!.invalid_id);
                        }

                      }
                    }
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.accept,
                  style: TextStyle(fontSize: sizeHeight * 2.5),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 15),
              child: TextButton(
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber('+48730724858');
                },
                child: Text(
                  AppLocalizations.of(context)!.call_caretaker,
                  style: TextStyle(
                    fontSize: sizeHeight * 2.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
