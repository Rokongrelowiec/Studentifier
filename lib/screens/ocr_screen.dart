import 'dart:io' as io;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './license_screen.dart';
import '../widgets/camera_view.dart';
import '../widgets/object_detector_painter.dart';

class OCRScreen extends StatefulWidget {
  @override
  State<OCRScreen> createState() => _OCRScreen();
}

class _OCRScreen extends State<OCRScreen> {
  late ObjectDetector _objectDetector;
  bool _canProcess = false;
  CustomPaint? _customPaint;
  Map licenses = {};
  bool allowAdding = true;
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _initializeDetector();
  }

  @override
  void dispose() {
    _canProcess = false;
    _objectDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    if (_permissionStatus == PermissionStatus.granted) {
      return CameraView(
        title: 'Object Detector',
        customPaint: _customPaint,
        onImage: (inputImage) {
          processImage(inputImage, context);
        },
        onScreenModeChanged: _initializeDetector,
        initialDirection: CameraLensDirection.back,
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.no_photography_outlined,
              color: Theme.of(context).primaryColor,
              size: sizeHeight * 20,
            ),
            Text(
              AppLocalizations.of(context)!.camera_permission_req,
              style: TextStyle(
                  color: Theme.of(context).textTheme.displayLarge?.color,
                  fontSize: sizeHeight * 3),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: sizeHeight * 2,
            ),
            ElevatedButton(
              onPressed: () async {
                if (_permissionStatus == PermissionStatus.denied) {
                  await _requestCameraPermission();
                } else {
                  await openAppSettings();
                }
              },
              child: Text(
                AppLocalizations.of(context)!.request_camera,
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: sizeHeight * 2),
              ),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    // debugPrint('Permission status: $status');
    setState(() {
      _permissionStatus = status;
    });
  }

  void _initializeDetector() async {
    final path = 'assets/object_labeler.tflite';
    final modelPath = await _getModel(path);
    final options = LocalObjectDetectorOptions(
      mode: DetectionMode.stream,
      modelPath: modelPath,
      classifyObjects: true,
      multipleObjects: true,
    );
    _objectDetector = ObjectDetector(options: options);

    _canProcess = true;
  }

  Future<void> processImage(InputImage inputImage, BuildContext context) async {
    if (!_canProcess) return;
    final objects = await _objectDetector.processImage(inputImage);
    List<DetectedObject> carRelatedObjects = <DetectedObject>[];
    for (DetectedObject detectedObject in objects) {
      for (Label label in detectedObject.labels) {
        if (label.text == "Car" || label.text == "License plate") {
          carRelatedObjects.add(detectedObject);
        } else {
          continue;
        }
      }
    }
    final painter = ObjectDetectorPainter(
        carRelatedObjects,
        inputImage.inputImageData!.imageRotation,
        inputImage.inputImageData!.size);
    _customPaint = CustomPaint(painter: painter);
    if (mounted) {
      setState(() {});
    }

    for (DetectedObject detectedObject in carRelatedObjects) {
      for (Label label in detectedObject.labels) {
        if ((label.text == 'Car' && label.confidence > 0.5) ||
            (label.text == 'License plate' && label.confidence > 0.5)) {
          final textDetector = GoogleMlKit.vision
              .textRecognizer(script: TextRecognitionScript.latin);
          final recognisedText = await textDetector.processImage(inputImage);
            String licensePlateText;
            bool checked = true;
            for (TextBlock block in recognisedText.blocks) {
              if (allowAdding) {
                licensePlateText = block.text;
                checked = true;
                if (!detectedObject.boundingBox.overlaps(block.boundingBox)) {
                  continue;
                }
                if (licensePlateText.length < 4 || licensePlateText.length > 8) {
                  continue;
                }
                for (int i = 0; i < licensePlateText.length; i++) {
                  if (licensePlateText[i].toUpperCase() !=
                      licensePlateText[i]) {
                    checked = false;
                    break;
                  }
                }
                if (checked) {
                  // debugPrint('licenses: $licenses');
                  if (licenses.containsKey(licensePlateText)) {
                    licenses[licensePlateText] += 1;
                  } else {
                    licenses[licensePlateText] = 1;
                  }
                  if (licenses[licensePlateText] > 3) {
                    allowAdding = false;
                    licenses = {};
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) =>
                            LicenseScreen(license: licensePlateText)));
                  }
                }
              }
            }
        }
      }
    }
  }

  Future<String> _getModel(String assetPath) async {
    if (io.Platform.isAndroid) {
      return 'flutter_assets/$assetPath';
    }
    final path = '${(await getApplicationSupportDirectory()).path}/$assetPath';
    await io.Directory(dirname(path)).create(recursive: true);
    final file = io.File(path);
    if (!await file.exists()) {
      final byteData = await rootBundle.load(assetPath);
      await file.writeAsBytes(byteData.buffer
          .asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
    }
    return file.path;
  }
}
