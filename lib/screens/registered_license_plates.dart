import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class RegisteredLicensePlates extends StatelessWidget {
  static const routeName = '/registered-license-plates';

  const RegisteredLicensePlates({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateRegisteredLicensePlates()
      : SafeArea(
          child: GenerateRegisteredLicensePlates(),
        );
}

class GenerateRegisteredLicensePlates extends StatefulWidget {
  const GenerateRegisteredLicensePlates({Key? key}) : super(key: key);

  @override
  State<GenerateRegisteredLicensePlates> createState() =>
      _GenerateRegisteredLicensePlatesState();
}

class _GenerateRegisteredLicensePlatesState
    extends State<GenerateRegisteredLicensePlates> {
  late String removedLicensePlate;
  late int locationIndex;
  List lecturersLicencePlates = [];
  final formKey = GlobalKey<FormState>();

  List registeredLicensePlates = [
    'OSPF 1415',
    'DNS 12X2',
    'ACL 6542',
    'VLAN W189',
    'SQL 54TO',
    'PHP 1154M',
    'JS 4FGB',
    'CPP 63BV',
    'DART 4312',
    'JAVA 11WEQ',
    'JSON OO22',
    'VIM 58XC',
  ];

  TextEditingController licensePlateController = TextEditingController();

  void removeItem(index) {
    locationIndex = index;
    removedLicensePlate = registeredLicensePlates[index];

    setState(() {
      registeredLicensePlates.removeAt(index);
    });
  }

  void undoOperation() {
    setState(() {
      registeredLicensePlates.insert(locationIndex, removedLicensePlate);
    });
  }

  Future getData() async {
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var response = await http.get(
      Uri.parse(
          'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/lecturers'),
      headers: {'x-api-key': apiKey},
    );
    lecturersLicencePlates = jsonDecode(response.body)['vehicles'];
    // debugPrint('$lecturersLicencePlates'); // [{id: 11, numer_albumu: null, rejestracja: LR33TEE, wykladowca: true}, {id: 17, numer_albumu: null, rejestracja: ABC123, wykladowca: true}]
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registered license plates',
          style: TextStyle(color: Theme.of(context).textTheme.headline1?.color),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
        ),
      ),
      body: FutureBuilder(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Center(child: CircularProgressIndicator()),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Sorry\nCould not fetch the data',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Lecturers license plates',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1?.color,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Found: ${lecturersLicencePlates.length} elements!',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1?.color,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: lecturersLicencePlates.length,
                      itemBuilder: (ctx, index) => Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: ListTile(
                          key: UniqueKey(),
                          title: Text(
                            lecturersLicencePlates[index]['rejestracja'],
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
                            ),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              // TODO - remove lecturer license plate and undo operation!
                              removeItem(index);
                              final snackBar = SnackBar(
                                backgroundColor: Theme.of(context).primaryColor,
                                content: Text(
                                  'Removed item number: ${index + 1}',
                                ),
                                action: SnackBarAction(
                                    label: 'Undo',
                                    textColor: Colors.white,
                                    onPressed: () => undoOperation()),
                              );
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Form(
                        key: formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: TextFormField(
                          controller: licensePlateController,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1?.color),
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              onPressed: () async {
                                final isValidForm =
                                    formKey.currentState!.validate();
                                if (isValidForm) {
                                  String apiKey =
                                      await DefaultAssetBundle.of(context)
                                          .loadString('assets/api-key.txt');
                                  var requestBody = jsonEncode({
                                    'licenseplate': licensePlateController.text
                                        .toUpperCase()
                                  });
                                  await http.post(
                                    Uri.parse(
                                        'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/add/lecturer'),
                                    headers: {'x-api-key': apiKey},
                                    body: requestBody,
                                  );
                                  lecturersLicencePlates.add({
                                    'rejestracja': licensePlateController.text
                                        .toUpperCase()
                                  });
                                  licensePlateController.text = '';
                                  setState(() {
                                    lecturersLicencePlates;
                                  });
                                }
                              },
                              icon: Icon(
                                Icons.check,
                                color: Theme.of(context).iconTheme.color,
                              ),
                            ),
                            icon: Icon(
                              Icons.drive_eta_sharp,
                              size: 30,
                              color: Colors.grey,
                            ),
                            labelText: "License plate",
                            labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding:
                                EdgeInsets.only(top: 15, bottom: 15),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFE0E0E0), width: 2),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xFFDD9246), width: 1),
                            ),
                          ),
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
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
