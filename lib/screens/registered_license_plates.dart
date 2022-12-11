import 'dart:io';

import 'package:flutter/material.dart';

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

class _GenerateRegisteredLicensePlatesState extends State<GenerateRegisteredLicensePlates> {

  late String removedLicensePlate;
  late int locationIndex;

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

  void removeItem(index){
    locationIndex = index;
    removedLicensePlate = registeredLicensePlates[index];

    setState(() {
      registeredLicensePlates.removeAt(index);
    });
  }

  void undoOperation(){
    setState(() {
      registeredLicensePlates.insert(locationIndex, removedLicensePlate);
    });
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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
            ),
            Text(
              // "Daily Report",
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
              'Found: ${registeredLicensePlates.length} elements!',
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
              itemCount: registeredLicensePlates.length,
              itemBuilder: (ctx, index) => Card(
                color: Theme.of(context).drawerTheme.backgroundColor,
                child: ListTile(
                  key: UniqueKey(),
                  title: Text(
                    registeredLicensePlates[index],
                    style: TextStyle(
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {
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
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
              child: TextFormField(
                controller: licensePlateController,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1?.color),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      print(licensePlateController.text);
                      setState(() {
                        registeredLicensePlates
                            .add(licensePlateController.text);
                      });
                      licensePlateController.text = '';
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
                      color: Theme.of(context).textTheme.headline1?.color),
                  hintStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFDD9246), width: 1),
                  ),
                ),
                textInputAction: TextInputAction.done,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
