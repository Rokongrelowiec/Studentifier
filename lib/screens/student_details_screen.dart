import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../providers/admin_provider.dart';
import './student_edit_screen.dart';
import '../widgets/app_bar_widget.dart';

class StudentDetails extends StatelessWidget {
  static const routeName = '/student-details';

  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  String validityOfStudentId;

  StudentDetails({
    Key? key,
    this.firstName = '',
    this.lastName = '',
    this.licensePlate = '',
    this.studentId = 0,
    this.numberOfVisits = 0,
    this.validityOfStudentId = '31-03-2023',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateStudentDetails(
          firstName: firstName,
          lastName: lastName,
          studentId: studentId,
          licensePlate: licensePlate,
          numberOfVisits: numberOfVisits,
          validityOfStudentId: validityOfStudentId,
        )
      : SafeArea(
          child: GenerateStudentDetails(
            firstName: firstName,
            lastName: lastName,
            studentId: studentId,
            licensePlate: licensePlate,
            numberOfVisits: numberOfVisits,
            validityOfStudentId: validityOfStudentId,
          ),
        );
}

class GenerateStudentDetails extends StatefulWidget {
  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  String validityOfStudentId;

  GenerateStudentDetails({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.licensePlate,
    required this.studentId,
    required this.numberOfVisits,
    required this.validityOfStudentId,
  }) : super(key: key);

  @override
  State<GenerateStudentDetails> createState() => _GenerateStudentDetailsState();
}

class _GenerateStudentDetailsState extends State<GenerateStudentDetails> {
  @override
  Widget build(BuildContext context) {
    final bool isAdmin = Provider.of<AdminProvider>(context).isAdmin;
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.student_details,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop({
          'studentId': widget.studentId,
          'licensePlate': widget.licensePlate,
          'firstName': widget.firstName,
          'lastName': widget.lastName,
        }),
        actionsList: isAdmin
            ? [
                Padding(
                  padding: EdgeInsets.only(right: sizeHeight),
                  child: IconButton(
                    onPressed: () async {
                      final editedValues = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => StudentEdit(
                                firstName: widget.firstName,
                                lastName: widget.lastName,
                                studentId: widget.studentId,
                                licensePlate: widget.licensePlate,
                                numberOfVisits: widget.numberOfVisits,
                                validityOfStudentId: widget.validityOfStudentId,
                              ),
                            ),
                          ) ??
                          '';
                      if (editedValues.isNotEmpty) {
                        setState(() {
                          widget.firstName = editedValues['firstName'];
                          widget.lastName = editedValues['lastName'];
                          widget.studentId = int.parse(editedValues['studentId']);
                          widget.licensePlate = editedValues['licensePlate'];
                          widget.numberOfVisits =
                              int.parse(editedValues['numberOfVisits']);
                          widget.validityOfStudentId =
                              editedValues['validityOfStudentId'];
                        });
                      }
                    },
                    icon: Icon(
                      Icons.edit,
                      size: sizeHeight * 4,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  ),
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: sizeHeight),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.9),
                    radius: sizeHeight * 10,
                    child: Icon(
                      color: Colors.white,
                      Icons.person,
                      size: sizeHeight * 12.5,
                    ),
                  ),
                ),
                SizedBox(
                  height: sizeHeight * 2,
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.first_name,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.firstName,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.last_name,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.lastName,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      AppLocalizations.of(context)!.index,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.studentId.toString(),
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.license_plate4,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.licensePlate,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.num_of_visits_month,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.numberOfVisits.toString(),
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 2,
                  color: Colors.grey,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.student_id_val,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                      Text(
                        widget.validityOfStudentId,
                        style: TextStyle(
                          fontSize: sizeHeight * 2.5,
                          color: Theme.of(context).textTheme.displayLarge?.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
