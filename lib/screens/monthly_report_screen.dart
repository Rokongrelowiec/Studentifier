import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as  http;

import './student_details_screen.dart';
import '../models/admin_provider.dart';

class MonthlyReport extends StatefulWidget {
  MonthlyReport({Key? key}) : super(key: key);

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {

  // List firstNames = [
  //   'James',
  //   'Robert',
  //   'Mary',
  //   'Patricia',
  //   'John',
  //   'Jennifer',
  //   'Michael',
  //   'Linda',
  //   'David',
  //   'Elizabeth',
  //   'William',
  //   'Barbara',
  //   'Richard',
  //   'Susan',
  //   'Jessica',
  // ];
  //
  // List lastNames = [
  //   'Smith',
  //   'Johnson',
  //   'Williams',
  //   'Brown',
  //   'Jones',
  //   'Garcia',
  //   'Miller',
  //   'Davis',
  //   'Rodriguez',
  //   'Martinez',
  //   'Hernandez',
  //   'Lopez',
  //   'Gonzales',
  //   'Wilson',
  //   'Anderson',
  // ];
  //
  // List licensePlates = [
  //   'DAN 13L',
  //   'S4L 4Z4R',
  //   'KLG1CA25',
  //   'OUP 9723',
  //   'PJY 7231',
  //   'KA WG123',
  //   'SW UI3X1',
  //   'PO W11F5',
  //   'JEB AK',
  //   'GD 43212',
  //   'JP2 GMD',
  //   'SAL 7231',
  //   'YRW 1623',
  //   'WEQ 54231',
  //   'WICIO <3',
  // ];
  //
  // List scanTime = [
  //   '07:21',
  //   '07:43',
  //   '07:56',
  //   '08:01',
  //   '08:12',
  //   '08:22',
  //   '08:39',
  //   '08:42',
  //   '08:56',
  //   '09:00',
  //   '09:28',
  //   '09:44',
  //   '10:04',
  //   '10:23',
  //   '11:21',
  // ];
  //
  // List studentIndexes = List.generate(15, (index) => index + 27980);
  // List visitsCount = (List.generate(15, (index) => Random().nextInt(50) + 1));
  //
  // late int locationIndex;
  // late int removedStudentIndex;
  // late String removedLicensePlate;
  // late String removedFirstName;
  // late String removedLastName;
  // late String removedScanTime;
  // late int removedVisitsCount;

  late List countList;
  late List studentIdList;
  late List nameSurnameList;
  late List licencePlatesList;
  late List studentIdValidityList;

  // void removeItem(index) {
  //   locationIndex = index; // identify index in lists - used in undoOperation
  //   removedStudentIndex = studentIndexes[index];
  //   removedLicensePlate = licensePlates[index];
  //   removedFirstName = firstNames[index];
  //   removedLastName = lastNames[index];
  //   removedScanTime = scanTime[index];
  //   removedVisitsCount = visitsCount[index];
  //
  //   setState(() {
  //     studentIndexes.removeAt(index);
  //     licensePlates.removeAt(index);
  //     firstNames.removeAt(index);
  //     lastNames.removeAt(index);
  //     scanTime.removeAt(index);
  //     visitsCount.removeAt(index);
  //   });
  // }

  // void undoOperation() {
  //   setState(() {
  //     studentIndexes.insert(locationIndex, removedStudentIndex);
  //     licensePlates.insert(locationIndex, removedLicensePlate);
  //     firstNames.insert(locationIndex, removedFirstName);
  //     lastNames.insert(locationIndex, removedLastName);
  //     scanTime.insert(locationIndex, removedScanTime);
  //     visitsCount.insert(locationIndex, removedVisitsCount);
  //   });
  // }

  // @override
  // void initState() {
  //   visitsCount.sort();
  //   visitsCount = List.from(visitsCount.reversed);
  //   super.initState();
  // }

  Future getData() async {
    String apiKey =
    await DefaultAssetBundle.of(context).loadString('assets/api-key.txt');
    var requestBody = jsonEncode({'scope': 'FEB2023'});
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
                          final newValues = await Navigator.of(context).push(
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
                              ) ??
                              '';
                          setState(() {});
                          // if (newValues.isNotEmpty) {
                          //   setState(() {
                          //     studentIndexes[index] = newValues['studentId'];
                          //     licensePlates[index] = newValues['licensePlate'];
                          //     firstNames[index] = newValues['firstName'];
                          //     lastNames[index] = newValues['lastName'];
                          //   });
                          // }
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
