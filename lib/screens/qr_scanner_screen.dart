import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './added_data_screen.dart';
import './deny_screen.dart';
import '../widgets/app_bar_widget.dart';

class QRScannerScreen extends StatelessWidget {
  final String licensePlate;
  final String scanTime;

  QRScannerScreen(
      {Key? key, required this.licensePlate, required this.scanTime})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateQRScannerScreen(
          licensePlate: licensePlate,
          scanTime: scanTime,
        )
      : SafeArea(
          child: GenerateQRScannerScreen(
          licensePlate: licensePlate,
          scanTime: scanTime,
        ));
}

class GenerateQRScannerScreen extends StatefulWidget {
  final String licensePlate;
  final String scanTime;

  GenerateQRScannerScreen(
      {Key? key, required this.licensePlate, required this.scanTime})
      : super(key: key);

  @override
  State<GenerateQRScannerScreen> createState() =>
      _GenerateQRScannerScreenState();
}

class _GenerateQRScannerScreenState extends State<GenerateQRScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  var printedResult;

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    printedResult = AppLocalizations.of(context)!.scan_code;
    if (controller != null && mounted) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.qr_scanner,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          buildQrView(context),
          Positioned(
            bottom: 20,
            child: buildResult(),
          ),
        ],
      ),
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderColor: Theme.of(context).primaryColor,
          borderRadius: 10,
          borderLength: 20,
          borderWidth: 10,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen(
      (barcode) => setState(() async {
        this.barcode = barcode;
        Map mapData = json.decode(barcode.code as String);
        if (mapData.containsKey('imie') &&
            mapData.containsKey('nazwisko') &&
            mapData.containsKey('numer_indeksu') &&
            mapData.containsKey('isPrivileged')) {
          printedResult = AppLocalizations.of(context)!.done;
          bool moveToAddedDataScreen;
          controller.pauseCamera();
          if (mapData['isPrivileged']) {
            moveToAddedDataScreen = await sendLecturerData(
                mapData['isPrivileged'], widget.licensePlate);
          } else {
            moveToAddedDataScreen = await sendStudentData(
                name: mapData['imie'],
                surname: mapData['nazwisko'],
                studentId: mapData['numer_indeksu'],
                isPrivileged: mapData['isPrivileged'],
                licensePlate: widget.licensePlate,
                scanTime: widget.scanTime);
          }
          if (moveToAddedDataScreen) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => AddedDataScreen(
                  name: mapData['imie'],
                  surname: mapData['nazwisko'],
                  studentId: mapData['numer_indeksu'],
                  licensePlate: widget.licensePlate,
                  scanTime: widget.scanTime,
                  isPrivileged: mapData['isPrivileged'],
                ),
              ),
            );
          } else {
            Navigator.of(context).pushReplacementNamed(DenyScreen.routeName,
                arguments: AppLocalizations.of(context)!.parking_limit2);
          }
        }
      }),
    );
  }

  Widget buildResult() => Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: Text(
          printedResult,
          overflow: TextOverflow.ellipsis,
          maxLines: 3,
        ),
      );
}

sendLecturerData(bool isPrivileged, String licensePlate) async {
  String key = await rootBundle.loadString('assets/api-key.txt');
  var requestBody = jsonEncode({"licenseplate": licensePlate});
  await http.post(
      Uri.parse(
          'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/add/lecturer'),
      headers: {'x-api-key': key},
      body: requestBody);
  return true;
}

sendStudentData({
  required String name,
  required String surname,
  required int studentId,
  required bool isPrivileged,
  required String scanTime,
  required String licensePlate,
}) async {
  List controlList = [true, true, true, true];
  String key = await rootBundle.loadString('assets/api-key.txt');
  var response;

  // Check available spaces
  response = await http.get(
    Uri.parse('http://130.61.192.162:8069/api/v1/parking_spots'),
    headers: {'x-api-key': key},
  );
  var decodedResponse = jsonDecode(response.body);
  int parkingLimit = decodedResponse[0]['limit'];
  final String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
  String year = (DateFormat.y().format(DateTime.now())).toString();
  var requestBody = jsonEncode({'slice': '${month + year}', 'day': today});
  response = await http.post(
    Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
    headers: {'x-api-key': key},
    body: requestBody,
  );
  decodedResponse = jsonDecode(response.body);
  int occupiedPlaces = decodedResponse.length;

  if (occupiedPlaces >= parkingLimit) {
    return false;
  }

  requestBody =
      jsonEncode({"studentId": studentId, "licenseplate": licensePlate});
  if (controlList[0]) {
    response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/add/student'),
        headers: {'x-api-key': key},
        body: requestBody);
    // debugPrint('First: ${response.statusCode}');
    if (response.statusCode == 200) {
      controlList[0] = false;
    }
  }

  DateTime date = DateTime.parse(scanTime);
  var day = DateFormat('yyyy-MM-dd').format(date);
  var hour = '${DateFormat.Hms().format(date)}+00';
  month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
  year = (DateFormat.y().format(DateTime.now())).toString();
  requestBody = jsonEncode({
    'slice': '${month + year}',
    'rejestracja': licensePlate,
    'godzinaPrzyjazdu': hour,
    'dzien': day
  });
  if (controlList[1]) {
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/log/entry'),
        headers: {'x-api-key': key},
        body: requestBody);
    // debugPrint('Second ${response.statusCode}');
    if (response.statusCode == 200) {
      controlList[1] = false;
    }
  }

  requestBody = jsonEncode({'numer_albumu': studentId});
  if (controlList[2]) {
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/students/bystudentId'),
        headers: {'x-api-key': key},
        body: requestBody);
    // debugPrint('Third ${response.statusCode}');
    if (response.statusCode == 200) {
      controlList[2] = false;
    }
  }
  if (jsonDecode(response.body).isEmpty) {
    requestBody = jsonEncode(
        {'numer_albumu': studentId, 'imie': name, 'nazwisko': surname});
    if (controlList[3]) {
      response = await http.post(
          Uri.parse('http://130.61.192.162:8069/api/v1/students/add'),
          headers: {'x-api-key': key},
          body: requestBody);
      // debugPrint('Fourth ${response.statusCode}');
      if (response.statusCode == 200) {
        controlList[3] = false;
      }
    }
  }
  return true;
}
