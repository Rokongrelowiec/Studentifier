import 'dart:io' as io;
import 'dart:ui';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

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

  @override
  void initState() {
    super.initState();
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
    return CameraView(
      title: 'Object Detector',
      customPaint: _customPaint,
      onImage: (inputImage) {
        processImage(inputImage, context);
      },
      onScreenModeChanged: _initializeDetector,
      initialDirection: CameraLensDirection.back,
    );
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
    // List<DetectedObject> carRelatedObjects = objects;//<DetectedObject>[];
    List<DetectedObject> carRelatedObjects = <DetectedObject>[];
    for (DetectedObject detectedObject in objects) {
      for (Label label in detectedObject.labels) {
        if(label.text == "Car" || label.text == "License plate") {
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
        // print('${label.text} ${label.confidence}');
        if ((label.text == 'Car' && label.confidence > 0.85) || (label.text == 'License plate' && label.confidence > 0.85)) {
          final textDetector = GoogleMlKit.vision.textRecognizer(script: TextRecognitionScript.latin);
          final recognisedText = await textDetector.processImage(inputImage);
          setState(() {
            for (TextBlock block in recognisedText.blocks) {
              final String text = block.text;
              bool checked = true;
              if (text.length < 4) {
                continue;
              }
              for (int i = 0; i < text.length; i++) {
                if (text[i].toUpperCase() != text[i]) {
                  checked = false;
                  break;
                }
              }
              if (checked) {
                // print('licenses: $licenses');
                if (licenses.containsKey(text)) {
                  licenses[text] += 1;
                } else {
                  licenses[text] = 1;
                }
                if (licenses[text] > 4) {
                  licenses = {};
                  _canProcess = false;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => LicenseScreen(license: text)));
                }
              }
            }
          });
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
