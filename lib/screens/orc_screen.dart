import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_tflite/flutter_tflite.dart';

import '../main.dart';
import '../widgets/custom_snack_bar_content.dart';

class FirstTab extends StatefulWidget {
  const FirstTab({Key? key}) : super(key: key);

  @override
  State<FirstTab> createState() => _FirstTabState();
}

class _FirstTabState extends State<FirstTab> {
  late CameraController cameraController;
  late CameraImage imgCamera;
  String result = "";

  @override
  void initState() {
    super.initState();
    loadModel();
    print('Model Loaded!');
    initCamera();
  }

  Future<List<dynamic>?> runModelOnStreamFrames() async {
    var recognitions = await Tflite.runModelOnFrame(
      bytesList: imgCamera.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: imgCamera.width,
      imageWidth: imgCamera.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 5,
      threshold: 0.1,
      asynch: true,
    );

    return recognitions;
    // result = "";
    //
    // recognitions?.forEach((response) {
    //   print(response);
    //   result += response['label'] +
    //       ' ' +
    //       (response['confidence'] as double).toStringAsFixed(2) +
    //       '\n\n';
    // });
    //
    // print(result);
    // setState(() {
    //   result;
    //   print(result);
    // });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/detect.tflite',
      labels: 'assets/labels.txt',
    );
  }

  initCamera() {
    cameraController = CameraController(cameras[0], ResolutionPreset.max);
    cameraController.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController.startImageStream((imageFromStream) => {
              imgCamera = imageFromStream,
              //TODO: fix issue connected to the line below
              // runModelOnStreamFrames(),
            });
      });
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // ScaffoldMessenger.of(context).showSnackBar(W
            //   SnackBar(
            //     content: CustomSnackBarContent('CameraAccessDenied'),
            //     behavior: SnackBarBehavior.floating,
            //     backgroundColor: Colors.transparent,
            //     elevation: 0,
            //   ),
            // );
            break;
          default:
            // ScaffoldMessenger.of(context).hideCurrentSnackBar();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(
            //     content: CustomSnackBarContent('Something went wrong...'),
            //     behavior: SnackBarBehavior.floating,
            //     backgroundColor: Colors.transparent,
            //     elevation: 0,
            //   ),
            // );
            break;
        }
      }
    });
  }

  @override
  void dispose() async {
    super.dispose();
    await Tflite.close();
    cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: CameraPreview(cameraController),
    );
  }
}
