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

  void removeItem(String licencePlate, String arrivalHour) async {
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    final String day = selectedDate.day.toString();
    final String month = DateFormat.MMM().format(selectedDate).toLowerCase();
    final String year = DateFormat.y().format(selectedDate);
    var response = await http.get(
      Uri.parse(
          'https://api.danielrum.in/api/v1/logs/entries/$day/$month/$year'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );
    var data;
    var decodedResponse = jsonDecode(response.body);
    for (int i = 0; i < decodedResponse.length; i++) {
      if (decodedResponse[i]['rejestracja'] == licencePlate &&
          decodedResponse[i]['godzinaPrzyjazdu'] == arrivalHour) {
        data = decodedResponse[i];
        break;
      }
    }
    String dateOfArrival = DateFormat('yyyy-MM-dd').format(selectedDate);
    var requestBody = jsonEncode({
      'license_plate': data['rejestracja'],
      "date_of_arrival": dateOfArrival,
      "hour_of_arrival": data['godzinaPrzyjazdu']
    });
    await http.post(
      Uri.parse('https://api.danielrum.in/api/v1/logs/entries/delete'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
      body: requestBody,
    );
    setState(() {});
  }

  Future getData() async {
    licenseAndHourList = [];
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    final String today = selectedDate.day.toString();
    final String month = DateFormat.MMM().format(selectedDate).toLowerCase();
    final String year = selectedDate.year.toString();
    var response = await http.get(
      Uri.parse(
          'https://api.danielrum.in/api/v1/logs/entries/$today/$month/$year'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );
    licenseAndHourList = jsonDecode(response.body);
    studentIdList = [];
    var responseDecoded;
    for (int i = 0; i < licenseAndHourList.length; i++) {
      response = await http.get(
        Uri.parse(
            'https://api.danielrum.in/api/v1/vehicles/licenseplates/${licenseAndHourList[i]["rejestracja"]}'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );
      responseDecoded = jsonDecode(response.body)['numer_albumu'];
      studentIdList.add(responseDecoded);
    }
    nameSurnameList = [];

    for (int i = 0; i < studentIdList.length; i++) {
      response = await http.get(
        Uri.parse(
            'https://api.danielrum.in/api/v1/students/${studentIdList[i]}'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );
      String name = jsonDecode(response.body)['imie'],
          surname = jsonDecode(response.body)['nazwisko'];
      nameSurnameList.add({name: surname});
    }
    countList = [];
    for (int i = 0; i < licenseAndHourList.length; i++) {
      response = await http.get(
        Uri.parse(
            'https://api.danielrum.in/api/v1/logs/entires/$month/$year/licenseplates/${licenseAndHourList[i]["rejestracja"]}'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );
      responseDecoded = jsonDecode(response.body);
      countList.add(responseDecoded[0]['count']);
    }
    studentIdValidityList = [];
    for (int i = 0; i < studentIdList.length; i++) {
      response = await http.get(
        Uri.parse(
            'https://api.danielrum.in/api/v1/students/active/${studentIdList[i]}'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );
      responseDecoded = jsonDecode(response.body);
      studentIdValidityList.add(responseDecoded['data_waznosci']);
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
                          color:
                              Theme.of(context).textTheme.displayLarge?.color,
                          fontSize: sizeHeight * 2),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selected_date,
                          style: TextStyle(
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
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
                              setState(() {});
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
                                      removeItem(
                                          licenseAndHourList[index]
                                              ['rejestracja'],
                                          licenseAndHourList[index]
                                              ['godzinaPrzyjazdu']);
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
