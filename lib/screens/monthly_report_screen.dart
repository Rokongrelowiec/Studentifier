import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './student_details_screen.dart';
import '../models/admin_provider.dart';

class MonthlyReport extends StatefulWidget {
  MonthlyReport({Key? key}) : super(key: key);

  @override
  State<MonthlyReport> createState() => _MonthlyReportState();
}

class _MonthlyReportState extends State<MonthlyReport> {

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
    'Richard',
    'Susan',
    'Jessica',
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
    'Wilson',
    'Anderson',
  ];

  List licensePlates = [
    'DAN 13L',
    'S4L 4Z4R',
    'KLG1CA25',
    'OUP 9723',
    'PJY 7231',
    'KA WG123',
    'SW UI3X1',
    'PO W11F5',
    'JEB AK',
    'GD 43212',
    'JP2 GMD',
    'SAL 7231',
    'YRW 1623',
    'WEQ 54231',
    'WICIO <3',
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
    '10:23',
    '11:21',
  ];

  List studentIndexes = List.generate(15, (index) => index + 27980);
  List visitsCount = (List.generate(15, (index) => Random().nextInt(50) + 1));

  late int locationIndex;
  late int removedStudentIndex;
  late String removedLicensePlate;
  late String removedFirstName;
  late String removedLastName;
  late String removedScanTime;
  late int removedVisitsCount;

  void removeItem(index) {
    locationIndex = index; // identify index in lists - used in undoOperation
    removedStudentIndex = studentIndexes[index];
    removedLicensePlate = licensePlates[index];
    removedFirstName = firstNames[index];
    removedLastName = lastNames[index];
    removedScanTime = scanTime[index];
    removedVisitsCount = visitsCount[index];

    setState(() {
      studentIndexes.removeAt(index);
      licensePlates.removeAt(index);
      firstNames.removeAt(index);
      lastNames.removeAt(index);
      scanTime.removeAt(index);
      visitsCount.removeAt(index);
    });
  }

  void undoOperation() {
    setState(() {
      studentIndexes.insert(locationIndex, removedStudentIndex);
      licensePlates.insert(locationIndex, removedLicensePlate);
      firstNames.insert(locationIndex, removedFirstName);
      lastNames.insert(locationIndex, removedLastName);
      scanTime.insert(locationIndex, removedScanTime);
      visitsCount.insert(locationIndex, removedVisitsCount);
    });
  }

  @override
  void initState() {
    visitsCount.sort();
    visitsCount = List.from(visitsCount.reversed);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isAdmin = Provider.of<AdminProvider>(context).isAdmin;
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
            'Found: ${studentIndexes.length} elements!',
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
            itemCount: licensePlates.length,
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
                  ) ?? '';
                  if (newValues.isNotEmpty){
                    setState(() {
                      studentIndexes[index] = newValues['studentId'];
                      licensePlates[index] = newValues['licensePlate'];
                      firstNames[index] = newValues['firstName'];
                      lastNames[index] = newValues['lastName'];
                    });
                  }
                },
                leading: Text(
                  visitsCount[index].toString(),
                  style: TextStyle(
                      fontSize: 25,
                      color: Theme.of(context).textTheme.headline1?.color),
                ),
                title: Row(
                  children: [
                    Text(
                      'Index: ',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.headline1?.color,
                      ),
                    ),
                    Text(
                      studentIndexes[index].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.headline1?.color,
                      ),
                    ),
                  ],
                ),
                subtitle: Row(
                  children: [
                    Text(
                      'Name: ',
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                    ),
                    Container(
                      width: 180,
                      child: Text(
                        '${firstNames[index]} ${lastNames[index]}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).textTheme.headline1?.color,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: isAdmin
                    ? IconButton(
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
                      ) : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
