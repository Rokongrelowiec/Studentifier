import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as  http;
import 'package:intl/intl.dart';

import './student_details_screen.dart';
import '../models/admin_provider.dart';

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

  Future getData() async {
    String apiKey =
    await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    String month = (DateFormat.MMM().format(DateTime.now())).toUpperCase();
    String year = (DateFormat.y().format(DateTime.now())).toString();
    var requestBody = jsonEncode({'scope': '${month + year}'});
    var response = await http.post(
      Uri.parse('http://130.61.192.162:8069/api/v1/logs/entries/month/licenseplates'),
      headers: {'x-api-key': apiKey},
      body: requestBody,
    );
    var decodedResponse = jsonDecode(response.body); // [{"rejestracja":"VIPER","count":4},{"rejestracja":"172TMJ","count":3},{"rejestracja":"D4N13L","count":1},{"rejestracja":"FJ75TQ","count":1},{"rejestracja":"P3RVP","count":1},{"rejestracja":"PO6543","count":1},{"rejestracja":"UTH2023","count":1},{"rejestracja":"JK75XV","count":1},{"rejestracja":"SSW1718","count":1}]
    countList = [];
    licencePlatesList = [];
    for (int i=0; i < decodedResponse.length; i++) {
      licencePlatesList.add(decodedResponse[i]['rejestracja']);
      countList.add(decodedResponse[i]['count']);
    }
    studentIdList = [];
    for (int i=0; i < licencePlatesList.length; i++) {
      requestBody = jsonEncode({"licenseplate":licencePlatesList[i]});
      response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/vehicles/licenseplates/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      decodedResponse = jsonDecode(response.body);
      studentIdList.add(decodedResponse[0]['numer_albumu']);
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
    studentIdValidityList = [];
    for (int i=0; i < studentIdList.length; i++) {
      requestBody = jsonEncode({'numer_albumu':studentIdList[i]});
      response = await http.post(
        Uri.parse('http://130.61.192.162:8069/api/v1/students/active/checkone'),
        headers: {'x-api-key': apiKey},
        body: requestBody,
      );
      decodedResponse = jsonDecode(response.body);
      studentIdValidityList.add(decodedResponse[0]['data_waznosci']);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    "Monthly Report",
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
                    'Found: ${licencePlatesList.length} elements!',
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
                                    firstName: nameSurnameList[index].keys.elementAt(0),
                                    lastName: nameSurnameList[index].values.elementAt(0),
                                    numberOfVisits: countList[index],
                                    validityOfStudentId: studentIdValidityList[index],
                                  ),
                                ),
                              );
                          setState(() {});
                        },
                        leading: Text(
                          countList[index].toString(),
                          style: TextStyle(
                              fontSize: 25,
                              color:
                                  Theme.of(context).textTheme.headline1?.color),
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
                        // trailing: isAdmin
                        //     ? IconButton(
                        //         onPressed: () {
                        //           removeItem(index);
                        //           final snackBar = SnackBar(
                        //             backgroundColor:
                        //                 Theme.of(context).primaryColor,
                        //             content: Text(
                        //               'Removed item number: ${index + 1}',
                        //             ),
                        //             // action: SnackBarAction(
                        //             //     label: 'Undo',
                        //             //     textColor: Colors.white,
                        //             //     onPressed: () => undoOperation()),
                        //           );
                        //           ScaffoldMessenger.of(context)
                        //               .hideCurrentSnackBar();
                        //           ScaffoldMessenger.of(context)
                        //               .showSnackBar(snackBar);
                        //         },
                        //         icon: Icon(
                        //           Icons.delete,
                        //           color: Theme.of(context).iconTheme.color,
                        //         ),
                        //       )
                        //     : null,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        });
  }
}
