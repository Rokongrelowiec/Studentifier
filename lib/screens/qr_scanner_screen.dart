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
      (barcode) async { setState(() => this.barcode = barcode);
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
      }
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
  var requestBody = jsonEncode({
    "license_plate": licensePlate,
    "student_id": "-1",
    "is_lecturer": "true",
  });
  await http.post(
      Uri.parse(
          'https://api.danielrum.in/api/v1/vehicles/licenseplates/add/lecturer'),
      headers: {
        'x-api-key': key,
        'Content-Type': 'application/json',
      },
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
  List controlList = [true, true, true];
  String key = await rootBundle.loadString('assets/api-key.txt');
  var response;

  response = await http.get(
    Uri.parse('https://api.danielrum.in/api/v1/parking_spots'),
    headers: {
      'x-api-key': key,
      'Content-Type': 'application/json',
    },
  );
  var decodedResponse = jsonDecode(response.body);
  int parkingLimit = decodedResponse['limit'];

  String today = DateTime.now().day.toString();
  String month = DateFormat.MMM().format(DateTime.now()).toLowerCase();
  String year = DateTime.now().year.toString();
  response = await http.get(
    Uri.parse(
        'https://api.danielrum.in/api/v1/logs/entries/$today/$month/$year'),
    headers: {
      'x-api-key': key,
      'Content-Type': 'application/json',
    },
  );
  decodedResponse = jsonDecode(response.body);
  int occupiedPlaces = decodedResponse.length;

  if (occupiedPlaces >= parkingLimit) {
    return false;
  }

  var requestBody = jsonEncode({
    "license_plate": licensePlate,
    "student_id": studentId,
    "is_lecturer": "false",
  });
  if (controlList[0]) {
    response = await http.post(
        Uri.parse(
            'https://api.danielrum.in/api/v1/vehicles/licenseplates/add/student'),
        headers: {
          'x-api-key': key,
          'Content-Type': 'application/json',
        },
        body: requestBody);
    if (response.statusCode == 200) {
      controlList[0] = false;
    }
  }

  DateTime date = DateTime.parse(scanTime);
  var day = DateFormat('yyyy-MM-dd').format(date);
  var hour = '${DateFormat.Hms().format(date)}+00';
  requestBody = jsonEncode({
    'license_plate': licensePlate,
    'date_of_arrival': day,
    'hour_of_arrival': hour,
  });
  if (controlList[1]) {
    response = await http.post(
        Uri.parse('https://api.danielrum.in/api/v1/logs/log/entry'),
        headers: {
          'x-api-key': key,
          'Content-Type': 'application/json',
        },
        body: requestBody);
    if (response.statusCode == 200) {
      controlList[1] = false;
    }
  }

  if (controlList[2]) {
    response = await http.get(
      Uri.parse('https://api.danielrum.in/api/v1/students/$studentId'),
      headers: {
        'x-api-key': key,
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode == 200) {
      controlList[2] = false;
    }
  }
  return true;
}
