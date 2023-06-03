import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';

import './student_details_screen.dart';

class MonthlyReport extends StatefulWidget {
  MonthlyReport({Key? key}) : super(key: key);

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {
  late List countList;
  late List studentIdList;
  late List nameSurnameList;
  late List licencePlatesList;
  late List studentIdValidityList;
  DateTime selectedDate = DateTime.now();

  Future getData() async {
    String apiKey =
        await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    final String month = DateFormat.MMM().format(selectedDate).toLowerCase();
    final String year = selectedDate.year.toString();
    var response = await http.get(
      Uri.parse(
          'https://api.danielrum.in/api/v1/logs/entires/$month/$year/licenseplates'),
      headers: {
        'x-api-key': apiKey,
        'Content-Type': 'application/json',
      },
    );
    var decodedResponse = jsonDecode(response.body);
    countList = [];
    licencePlatesList = [];
    for (int i = 0; i < decodedResponse.length; i++) {
      licencePlatesList.add(decodedResponse[i]['rejestracja']);
      countList.add(decodedResponse[i]['count']);
    }
    studentIdList = [];
    for (int i = 0; i < licencePlatesList.length; i++) {
      response = await http.get(
        Uri.parse(
            'https://api.danielrum.in/api/v1/vehicles/licenseplates/${licencePlatesList[i]}'),
        headers: {
          'x-api-key': apiKey,
          'Content-Type': 'application/json',
        },
      );
      decodedResponse = jsonDecode(response.body);
      studentIdList.add(decodedResponse['numer_albumu']);
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
      decodedResponse = jsonDecode(response.body);
      studentIdValidityList.add(decodedResponse['data_waznosci']);
    }
    final dateFormat = DateFormat('dd-MM-yyyy');
    for (int i = 0; i < studentIdValidityList.length; i++) {
      studentIdValidityList[i] =
          (dateFormat.format(DateTime.parse(studentIdValidityList[i])))
              .toString();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                      AppLocalizations.of(context)!.monthly_report,
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
                      '${AppLocalizations.of(context)!.found}: ${licencePlatesList.length} ${AppLocalizations.of(context)!.elements}!',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.displayLarge?.color,
                        fontSize: sizeHeight * 2,
                      ),
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
                            DateTime? newDate = await showMonthPicker(
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
                            '${DateFormat.yM().format(selectedDate)}',
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
                      itemCount: licencePlatesList.length,
                      itemBuilder: (ctx, index) => Card(
                        color: Theme.of(context).drawerTheme.backgroundColor,
                        child: ListTile(
                          key: UniqueKey(),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => StudentDetails(
                                  studentId: studentIdList[index],
                                  licensePlate: licencePlatesList[index],
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
                            setState(() {});
                          },
                          leading: Text(
                            countList[index].toString(),
                            style: TextStyle(
                                fontSize: sizeHeight * 3,
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color),
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
                                  fontSize: sizeHeight * 2,
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
                                  fontSize: sizeHeight * 2,
                                ),
                              ),
                              Container(
                                width: sizeHeight * 25,
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
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        });
  }
}
