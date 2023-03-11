import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import './student_details_screen.dart';
import '../models/admin_provider.dart';

class DailyReport extends StatefulWidget {
  DailyReport({Key? key}) : super(key: key);

  @override
  State<DailyReport> createState() => _DailyReportState();
}

class _DailyReportState extends State<DailyReport> {

  late List licenseAndHourList;
  late List studentIdList;
  late List nameSurnameList;
  late List countList;
  late List studentIdValidityList;

  void removeItem(String licencePlate) async {
    print('Removing $licencePlate');
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
    String year = (DateFormat.y().format(DateTime.now())).toString();
    dynamic requestBody =
        jsonEncode({'slice': '${month + year}', 'day': today});
    var response = await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    var data;
    var decodedResponse = jsonDecode(response.body);
    for (int i = 0; i < decodedResponse.length; i++) {
      print(decodedResponse[i]['rejestracja']);
      if (decodedResponse[i]['rejestracja'] == licencePlate) {
        data = decodedResponse[i];
        break;
      }
    }
    requestBody = jsonEncode({
      'slice': 'feb2023',
      'licenseplate': licencePlate,
      'dateOfArrival': today,
      'hourOfArrival': data['godzinaPrzyjazdu'],
    });
    // debugPrint(requestBody.toString());
    await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/delete'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
  }

  Future getData() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    licenseAndHourList = [];
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
    String year = (DateFormat.y().format(DateTime.now())).toString();
    dynamic requestBody =
        jsonEncode({'slice': '${month + year}', 'day': today});
    var response = await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/day'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    licenseAndHourList = jsonDecode(response.body);
    studentIdList = [];
    var responseDecoded;
    for (int i = 0; i < licenseAndHourList.length; i++) {
      requestBody =
          jsonEncode({'licenseplate': licenseAndHourList[i]['rejestracja']});
      response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      responseDecoded = jsonDecode(response.body)[0]['numer_albumu'];
      studentIdList.add(responseDecoded);
    }
    nameSurnameList = [];

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
    countList = [];
    for (int i = 0; i < licenseAndHourList.length; i++) {
      requestBody = jsonEncode({
        'scope': '${month + year}',
        'licenseplate': licenseAndHourList[i]['rejestracja']
      });
      response = await http.post(
        Uri.parse(
            'http://130.61.192.162:8069/api/v1/logs/entries/month/licenseplates/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      responseDecoded = jsonDecode(response.body);
      countList.add(responseDecoded[0]['count']);
    }
    studentIdValidityList = [];
    for (int i = 0; i < studentIdList.length; i++) {
      requestBody = jsonEncode({'numer_albumu': studentIdList[i]});
      response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/students/active/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      responseDecoded = jsonDecode(response.body);
      studentIdValidityList.add(responseDecoded[0]['data_waznosci']);
    }
    // debugPrint(licenseAndHourList.toString());
    // debugPrint(studentIdList.toString());
    // debugPrint(nameSurnameList.toString());
    // debugPrint(countList.toString());
    // debugPrint(studentIdValidityList.toString());
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
                    'Found: ${licenseAndHourList.length} elements!',
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
                          key: UniqueKey(),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => StudentDetails(
                                  studentId: studentIdList[index],
                                  licensePlate: licenseAndHourList[index]
                                      ['rejestracja'],
                                  firstName:
                                      nameSurnameList[index].keys.elementAt(0),
                                  lastName: nameSurnameList[index]
                                      .values
                                      .elementAt(0),
                                  numberOfVisits: countList[index],
                                  validityOfStudentId:
                                      studentIdValidityList[index],
                                ),
                              ),
                            );
                          },
                          leading: Text(
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
                              ? IconButton(
                                  onPressed: () {
                                    removeItem(licenseAndHourList[index]
                                        ['rejestracja']);
                                    final snackBar = SnackBar(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      content: Text(
                                        'Removed index: ${studentIdList[index]}',
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    setState(() {});
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
