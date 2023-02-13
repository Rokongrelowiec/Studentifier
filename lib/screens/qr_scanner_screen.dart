import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:studentifier/screens/added_data_screen.dart';

class QRScannerScreen extends StatelessWidget {
  String licensePlate;
  String scanTime;

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
  String licensePlate;
  String scanTime;

  GenerateQRScannerScreen(
      {Key? key, required this.licensePlate, required this.scanTime})
      : super(key: key);

  @override
  State<GenerateQRScannerScreen> createState() =>
      _GenerateQRScannerScreenState();
}

class _GenerateQRScannerScreenState extends State<GenerateQRScannerScreen> {
  final qrKey = GlobalKey(debugLabel: 'QR');
  String printedResult = 'Scan a code!';

  Barcode? barcode;
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller != null && mounted) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'QR Scanner',
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        iconTheme: Theme.of(context).iconTheme,
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
      (barcode) => setState(() {
        this.barcode = barcode;
        Map mapData = json.decode(barcode.code as String);
        if (mapData.containsKey('name') &&
            mapData.containsKey('surname') &&
            mapData.containsKey('studentId') &&
            mapData.containsKey('isPrivileged')) {
          printedResult = 'Done!';
          debugPrint('isPrivileged: ${mapData['isPrivileged']}');
          if (mapData['isPrivileged']) {
            sendLecturerData(mapData['isPrivileged'], widget.licensePlate);
          } else {
            sendStudentData(
                name: mapData['name'],
                surname: mapData['surname'],
                studentId: mapData['studentId'],
                isPrivileged: mapData['isPrivileged'],
                licensePlate: widget.licensePlate,
                scanTime: widget.scanTime);
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => AddedDataScreen(
                name: mapData['name'],
                surname: mapData['surname'],
                studentId: mapData['studentId'],
                licensePlate: widget.licensePlate,
                scanTime: widget.scanTime,
                isPrivileged: mapData['isPrivileged'],
              ),
            ),
          );
          controller.pauseCamera();
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
  var response = await http.post(
      Uri.parse(
          'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/add/lecturer'),
      headers: {'x-api-key': key},
      body: requestBody);
  debugPrint('Lecturer: ${response.statusCode}');
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
  var requestBody =
      jsonEncode({"studentId": studentId, "licenseplate": licensePlate});
  if (controlList[0]) {
    response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/add/student'),
        headers: {'x-api-key': key},
        body: requestBody);
    debugPrint('First: ${response.statusCode}');
    if (response.statusCode == 200) {
      controlList[0] = false;
    }
  }

  DateTime date = DateTime.parse(scanTime);
  var day = DateFormat('yyyy-MM-dd').format(date);
  var hour = '${DateFormat.Hms().format(date)}+00';
  requestBody = jsonEncode({
    'slice': 'FEB2023',
    'rejestracja': licensePlate,
    'godzinaPrzyjazdu': hour,
    'dzien': day
  });
  if (controlList[1]) {
    response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/logs/log/entry'),
        headers: {'x-api-key': key},
        body: requestBody);
    debugPrint('Second ${response.statusCode}');
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
    debugPrint('Third ${response.statusCode}');
    if (response.statusCode) {
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
      debugPrint('Fourth ${response.statusCode}');
      if (response.statusCode == 200) {
        controlList[3] = false;
      }
    }
  }
}
