import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/language_provider.dart';
import '../widgets/app_bar_widget.dart';

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
  List lecturersLicencePlates = [];
  final formKey = GlobalKey<FormState>();

  TextEditingController licensePlateController = TextEditingController();

  void removeItem(String licencePlate) async {
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var body = jsonEncode({
      "license_plate": licencePlate,
      'student_id': '-1',
      'is_lecturer': 'true',
    });
    await http.post(
      Uri.parse(
          'https://api.danielrum.in/api/v1/vehicles/licenseplates/delete'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: body,
    );

    late int idx;
    for (int i=0; i<lecturersLicencePlates.length; i++) {
        if (lecturersLicencePlates[i]['rejestracja'] == licencePlate) {
          idx = i;
        }
    }
    lecturersLicencePlates.removeAt(idx);
    setState(() {});
  }

  Future getData() async {
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var response = await http.get(
      Uri.parse(
          'https://api.danielrum.in/api/v1/vehicles/licenseplates/lecturers'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );
    setState(() {
      lecturersLicencePlates = jsonDecode(response.body)['vehicles'];
    });
  }

  void addLicensePlate() async {
    final isValidForm = formKey.currentState!.validate();
    if (isValidForm) {
      String apiKey =
          await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
      var requestBody = jsonEncode({
        'license_plate': licensePlateController.text.toUpperCase(),
        'student_id': '-1',
        'is_lecturer': 'true',
      });
      await http.post(
        Uri.parse(
            'https://api.danielrum.in/api/v1/vehicles/licenseplates/add/lecturer'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
        body: requestBody,
      );
      licensePlateController.text = '';
      Navigator.of(context).pop();
      getData();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    var addLicense = Provider.of<LocaleProvider>(context).currentLang == 'en'
        ? '${AppLocalizations.of(context)!.add} ${AppLocalizations.of(context)!.lecturer2} ${AppLocalizations.of(context)!.license_plate2}'
        : '${AppLocalizations.of(context)!.add} ${AppLocalizations.of(context)!.license_plate2} ${AppLocalizations.of(context)!.lecturer2}';
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.registered_license_plates,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
        actionsList: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    contentPadding: EdgeInsets.all(sizeHeight * 2),
                    buttonPadding: EdgeInsets.all(sizeHeight),
                    backgroundColor:
                        Theme.of(context).drawerTheme.backgroundColor,
                    title: Text(
                      addLicense,
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: sizeHeight * 2.5),
                    ),
                    content: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: TextFormField(
                        autofocus: true,
                        controller: licensePlateController,
                        style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: sizeHeight * 2.5,
                        ),
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.directions_car,
                              color: Theme.of(context).iconTheme.color,
                              size: sizeHeight * 4,
                            ),
                            labelText:
                                AppLocalizations.of(context)!.license_plate,
                            labelStyle: TextStyle(
                              fontSize: sizeHeight * 3,
                            ),
                            contentPadding: EdgeInsets.all(
                              sizeHeight * 2,
                            ),
                            border: OutlineInputBorder()),
                        onFieldSubmitted: (_) => addLicensePlate(),
                        validator: (value) {
                          if (value != null && value.length < 4) {
                            return AppLocalizations.of(context)!.too_short_val;
                          }
                          if (value != null && value.length > 8)
                            return AppLocalizations.of(context)!.too_long_val;
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
                        onPressed: () => addLicensePlate(),
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
                Icons.add,
                color: Theme.of(context).iconTheme.color,
                size: sizeHeight * 4.8,
              ),
            ),
          )
        ],
      ),
      body: RefreshIndicator(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: getData,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: sizeHeight * 2,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Text(
                  '${AppLocalizations.of(context)!.lecturers}: ${AppLocalizations.of(context)!.license_plates}',
                  style: TextStyle(
                    fontSize: sizeHeight * 4,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).textTheme.displayLarge?.color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: sizeHeight * 2,
              ),
              Text(
                '${AppLocalizations.of(context)!.found}: ${lecturersLicencePlates.length} ${AppLocalizations.of(context)!.elements}!',
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: sizeHeight * 3),
              ),
              SizedBox(
                height: sizeHeight * 5,
              ),
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: lecturersLicencePlates.length,
                itemBuilder: (ctx, index) => Card(
                  color: Theme.of(context).drawerTheme.backgroundColor,
                  child: ListTile(
                    key: ValueKey(lecturersLicencePlates[index]),
                    title: Text(
                      lecturersLicencePlates[index]['rejestracja'],
                      style: TextStyle(
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: sizeHeight * 3),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        removeItem(
                            lecturersLicencePlates[index]['rejestracja']);
                        final snackBar = SnackBar(
                          backgroundColor: Theme.of(context).primaryColor,
                          content: Text(
                            '${AppLocalizations.of(context)!.removed} ${AppLocalizations.of(context)!.license_plate}: ${lecturersLicencePlates[index]['rejestracja']}',
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                          // action: SnackBarAction(
                          //     label: 'Undo',
                          //     textColor: Colors.white,
                          //     onPressed: () => undoOperation()),
                        );
                        // ScaffoldMessenger.of(context)
                        //     .hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      },
                      icon: Icon(
                        Icons.delete,
                        color: Theme.of(context).iconTheme.color,
                        size: sizeHeight * 4,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      //   }
      // }),
    );
  }
}
