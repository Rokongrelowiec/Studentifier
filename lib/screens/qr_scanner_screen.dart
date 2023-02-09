import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
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
            mapData.containsKey('isPrivileged')
        ) {
          printedResult = 'Done!';
          // TODO Request to DB
          sendData();
          Future.delayed(
            Duration(seconds: 1),
            () => Navigator.of(context).pushReplacement(
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

sendData() async {

}
