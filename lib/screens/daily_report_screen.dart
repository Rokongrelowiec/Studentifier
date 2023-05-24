import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './student_details_screen.dart';
import '../providers/admin_provider.dart';

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
  DateTime selectedDate = DateTime.now();

  void removeItem(String licencePlate) async {
    // debugPrint('Removing $licencePlate');
    final today = DateFormat('yyyy-MM-dd').format(selectedDate);
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
      // debugPrint(decodedResponse[i]['rejestracja'].toString());
      if (decodedResponse[i]['rejestracja'] == licencePlate) {
        data = decodedResponse[i];
        break;
      }
    }
    requestBody = jsonEncode({
      'slice': '${month.toLowerCase()}$year',
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
    final today = DateFormat('yyyy-MM-dd').format(selectedDate);
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
    final dateFormat = DateFormat('dd-MM-yyyy');
    for (int i = 0; i < studentIdValidityList.length; i++) {
      studentIdValidityList[i] =
          (dateFormat.format(DateTime.parse(studentIdValidityList[i])))
              .toString();
    }
    // debugPrint(licenseAndHourList.toString());
    // debugPrint(studentIdList.toString());
    // debugPrint(nameSurnameList.toString());
    // debugPrint(countList.toString());
    // debugPrint(studentIdValidityList.toString());
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AdminProvider>(context).adminPermission;
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Padding(
              padding: EdgeInsets.only(top: sizeHeight * 2),
              child: Center(
                  child: SizedBox(
                      width: sizeHeight * 25,
                      height: sizeHeight * 25,
                      child: CircularProgressIndicator())),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.fetch_failed,
                style: TextStyle(
                    color: Theme.of(context).textTheme.displayLarge?.color,
                    fontSize: sizeHeight * 4,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            );
          } else {
            return RefreshIndicator(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              onRefresh: getData,
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: sizeHeight * 1.15,
                    ),
                    Text(
                      AppLocalizations.of(context)!.daily_report,
                      style: TextStyle(
                        fontSize: sizeHeight * 4,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(
                      AppLocalizations.of(context)!.license_plates,
                      style: TextStyle(
                        fontSize: sizeHeight * 3,
                        color: Theme.of(context).textTheme.displayLarge?.color,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.found}: ${licenseAndHourList.length} ${AppLocalizations.of(context)!.elements}!',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: sizeHeight * 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selected_date,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.displayLarge?.color,
                            fontSize: sizeHeight * 2,
                          ),
                        ),
                        TextButton(
                          onPressed: () async {
                            DateTime? newDate = await showDatePicker(
                              context: context,
                              initialDate: selectedDate,
                              firstDate: DateTime(2023, 02),
                              lastDate: DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                              ),
                            );
                            if (newDate == null) {
                              return;
                            } else {
                              setState(() {
                                selectedDate = newDate;
                              });
                            }
                          },
                          child: Text(
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                            style: TextStyle(
                              fontSize: sizeHeight * 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: licenseAndHourList.length,
                      itemBuilder: (ctx, index) => Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: ListTile(
                            key: ValueKey(licenseAndHourList[index]),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => StudentDetails(
                                    studentId: studentIdList[index],
                                    licensePlate: licenseAndHourList[index]
                                        ['rejestracja'],
                                    firstName: nameSurnameList[index]
                                        .keys
                                        .elementAt(0),
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
                                fontSize: sizeHeight * 3,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.index}: ',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: sizeHeight * 2,
                                  ),
                                ),
                                Text(
                                  studentIdList[index].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  '${AppLocalizations.of(context)!.scan_name}: ',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                      fontSize: sizeHeight * 2),
                                ),
                                Container(
                                  width: sizeHeight * 14,
                                  child: Text(
                                    '${nameSurnameList[index].keys.elementAt(0)} ${nameSurnameList[index].values.elementAt(0)}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                      fontSize: sizeHeight * 2,
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
                                          'Removed index: ${studentIdList[index]}; '
                                          'Hour: ${(licenseAndHourList[index]['godzinaPrzyjazdu']).toString().substring(0, 5)}',
                                          style: TextStyle(
                                              fontSize: sizeHeight * 2),
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
              ),
            );
          }
        });
  }
}
