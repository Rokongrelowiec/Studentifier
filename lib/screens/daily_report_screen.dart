import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/admin_provider.dart';
import './student_details_screen.dart';

class DailyReport extends StatefulWidget {
  DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {
  List firstNames = [
    'James',
    'Robert',
    'Mary',
    'Patricia',
    'John',
    'Jennifer',
    'Michael',
    'Linda',
    'David',
    'Elizabeth',
    'William',
    'Barbara',
    'Richard'
  ];

  List lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzales',
  ];

  List licensePlates = [
    'SW UI3X1',
    'PO W11F5',
    'JEB AK',
    'GD 43212',
    'DAN 13L',
    'S4L 4Z4R',
    'KLG1CA25',
    'OUP 9723',
    'PJY 7231',
    'KA WG123',
    'JP2 GMD',
    'SAL 7231',
    'YRW 1623',
  ];

  List scanTime = [
    '07:21',
    '07:43',
    '07:56',
    '08:01',
    '08:12',
    '08:22',
    '08:39',
    '08:42',
    '08:56',
    '09:00',
    '09:28',
    '09:44',
    '10:04',
  ];

  List studentIndexes = List.generate(13, (index) => index + 27980);

  late int locationIndex; //index of list
  late int removedStudentIndex;

  late String removedLicensePlate;
  late String removedFirstName;
  late String removedLastName;
  late String removedScanTime;

  List licenseAndHourList = [];
  List studentIdList = [];
  List nameSurnameList = [];
  int records = 0;

  void removeItem(index) {
    locationIndex = index; // identify index in lists - used in undoOperation
    removedStudentIndex = studentIndexes[index];
    removedLicensePlate = licensePlates[index];
    removedFirstName = firstNames[index];
    removedLastName = lastNames[index];
    removedScanTime = scanTime[index];

    setState(() {
      studentIndexes.removeAt(index);
      licensePlates.removeAt(index);
      firstNames.removeAt(index);
      lastNames.removeAt(index);
      scanTime.removeAt(index);
    });
  }

  void undoOperation() {
    setState(() {
      studentIndexes.insert(locationIndex, removedStudentIndex);
      licensePlates.insert(locationIndex, removedLicensePlate);
      firstNames.insert(locationIndex, removedFirstName);
      lastNames.insert(locationIndex, removedLastName);
      scanTime.insert(locationIndex, removedScanTime);
    });
  }

  Future getData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // final today = '2023-02-08';
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    dynamic requestBody = jsonEncode({'slice': 'FEB2023', 'day': today});
    var response = await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    licenseAndHourList = jsonDecode(response
        .body); // [{"rejestracja":"F6N9Z4Y","godzinaPrzyjazdu":"06:44:00+00"},{"dataPrzyjazdu":"2023-01-02","count":6}]

    for (int i = 0; i < licenseAndHourList.length; i++) {
      requestBody =
          jsonEncode({'licenseplate': licenseAndHourList[i]['rejestracja']});
      response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      requestBody = jsonDecode(response.body)[0]['numer_albumu'];
      studentIdList.add(requestBody);
    }

    for (int i = 0; i < studentIdList.length; i++) {
      requestBody = jsonEncode({'numer_albumu': studentIdList[i]});
      response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/students/bystudentId'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      String name = jsonDecode(response.body)[0]['imie'],
          surname = jsonDecode(response.body)[0]['nazwisko'];
      nameSurnameList.add({name: surname});
    }

    print(
        licenseAndHourList); // [{rejestracja: ABC123, godzinaPrzyjazdu: 17:14:35+00}, {rejestracja: DEF456, godzinaPrzyjazdu: 17:22:38+00}]
    print(studentIdList); // [27980, 27988]
    print(nameSurnameList); // [{Marek: Las}, {Rober: Kubica}]
    records = licenseAndHourList.length;
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AdminProvider>(context).isAdmin;

    return FutureBuilder(
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
                    "Daily Report",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Text(
                    'License Plates',
                    style: TextStyle(
                      fontSize: 22,
                      color: Theme.of(context).textTheme.headline1?.color,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    // 'Found: ${licenseAndHourList.length} elements!',
                    'Found: $records elements!',
                    // 'Found: ${0} elements!',
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
                    itemCount: licenseAndHourList.length,
                    itemBuilder: (ctx, index) => Card(
                      color: Theme.of(context).drawerTheme.backgroundColor,
                      child: ListTile(
                          onTap: () async {
                            final newValues = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => StudentDetails(
                                      studentId: studentIndexes[index],
                                      licensePlate: licensePlates[index],
                                      firstName: firstNames[index],
                                      lastName: lastNames[index],
                                    ),
                                  ),
                                ) ??
                                '';
                            if (newValues.isNotEmpty) {
                              setState(() {
                                studentIndexes[index] = newValues['studentId'];
                                licensePlates[index] =
                                    newValues['licensePlate'];
                                firstNames[index] = newValues['firstName'];
                                lastNames[index] = newValues['lastName'];
                              });
                            }
                          },
                          leading: Text(
                            // scanTime[index],
                            licenseAndHourList[index]['godzinaPrzyjazdu']
                                .substring(
                                    0,
                                    licenseAndHourList[index]
                                                ['godzinaPrzyjazdu']
                                            .length -
                                        6),
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.color),
                          ),
                          title: Row(
                            children: [
                              Text(
                                'Index: ',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                              Text(
                                // studentIndexes[index].toString(),
                                studentIdList[index].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .textTheme
                                      .headline1
                                      ?.color,
                                ),
                              ),
                            ],
                          ),
                          subtitle: Row(
                            children: [
                              Text(
                                'Name: ',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color),
                              ),
                              Container(
                                width: 180,
                                child: Text(
                                  '${nameSurnameList[index].keys.elementAt(0)} ${nameSurnameList[index].values.elementAt(0)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
                                        ?.color,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          trailing: isAdmin
                              //TODO removing
                              ? IconButton(
                                  onPressed: () {
                                    removeItem(index);
                                    final snackBar = SnackBar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
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
                                  ))
                              : null),
                    ),
                  )
                ],
              ),
            );
          }
        });
  }
}
