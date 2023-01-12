import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import './home_screen.dart';

class LicenseScreen extends StatefulWidget {
  String license;

  LicenseScreen({Key? key, required this.license}) : super(key: key);

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  late String foundLicense;

  removeAdditionalSymbols(String text) {
    foundLicense = '';
    for (int i = 0; i < text.length; i++) {
      if (text[i].contains(RegExp('[A-Za-z0-9]'))) {
        foundLicense += text[i];
      }
    }
  }

  @override
  void initState() {
    removeAdditionalSymbols(widget.license);
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateLicenseScreen(
          license: foundLicense,
        )
      : SafeArea(
          child: GenerateLicenseScreen(
            license: foundLicense,
          ),
        );
}

class GenerateLicenseScreen extends StatefulWidget {
  String license;

  GenerateLicenseScreen({Key? key, required this.license}) : super(key: key);

  @override
  State<GenerateLicenseScreen> createState() => _GenerateLicenseScreenState();
}

class _GenerateLicenseScreenState extends State<GenerateLicenseScreen> {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'License Plate',
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      backgroundColor:
                          Theme.of(context).drawerTheme.backgroundColor,
                      title: Text(
                        'Edit scanned license plate:',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                        ),
                      ),
                      content: Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          autofocus: true,
                          controller: controller,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.headline1?.color,
                          ),
                          decoration: InputDecoration(
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 3),
                                child: Icon(Icons.type_specimen),
                              ),
                              labelText: 'License plate',
                              border: OutlineInputBorder()),
                          validator: (value) {
                            if (value != null && value.length < 4) {
                              return 'Too short value';
                            }
                            if (value != null && value.length > 8)
                              return 'Too long value';
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
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => editLicense(),
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit,
                  color: Theme.of(context).iconTheme.color,
                )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                image: AssetImage('assets/images/ocr_logo.jpg'),
                height: 300,
                width: 300,
              ),
              Text(
                'Found license plate:',
                style: TextStyle(
                  fontSize: 22,
                  color: Theme.of(context).textTheme.headline1?.color,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                widget.license,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline1?.color,
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  'Accept',
                ),
              ),
              SizedBox(
                height: 20,
              ),
              TextButton(
                onPressed: () async {
                  await FlutterPhoneDirectCaller.callNumber('+48730724858');
                  // await launchUrlString('tel:+48-123-456-789');
                },
                child: Text('Call to the caretaker'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
