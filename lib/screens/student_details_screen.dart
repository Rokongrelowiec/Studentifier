import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/admin_provider.dart';
import './student_edit_screen.dart';

class StudentDetails extends StatelessWidget {
  static const routeName = '/student-details';

  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  // TODO change below type to DateTime
  String validityOfStudentId;

  StudentDetails({
    Key? key,
    this.firstName = 'Dart',
    this.lastName = 'Json',
    required this.licensePlate,
    this.studentId = 0,
    this.numberOfVisits = 0,
    this.validityOfStudentId = '31-03-2023',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Platform.isIOS ? GenerateStudentDetails(firstName: firstName,
          lastName: lastName,
          studentId: studentId,
          licensePlate: licensePlate,
          numberOfVisits: numberOfVisits, validityOfStudentId: validityOfStudentId,) :
      SafeArea(child: GenerateStudentDetails(firstName: firstName,
          lastName: lastName,
          studentId: studentId,
          licensePlate: licensePlate,
          numberOfVisits: numberOfVisits, validityOfStudentId: validityOfStudentId,));
}


class GenerateStudentDetails extends StatefulWidget {
  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  // TODO change below type to DateTime
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
    final bool isAdmin = Provider
        .of<AdminProvider>(context)
        .isAdmin;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Student details',
            style: TextStyle(
              color: Theme
                  .of(context)
                  .textTheme
                  .headline1
                  ?.color,
            ),
          ),
          centerTitle: true,
          actions: isAdmin ? [
            IconButton(
              onPressed: () async {
                final editedValues = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        StudentEdit(
                          firstName: widget.firstName,
                          lastName: widget.lastName,
                          studentId: widget.studentId,
                          licensePlate: widget.licensePlate,
                          numberOfVisits: widget.numberOfVisits,
                          validityOfStudentId: widget.validityOfStudentId,
                        ),
                  ),
                ) ?? '';
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
                color: Theme
                    .of(context)
                    .iconTheme
                    .color,
              ),
            ),
          ] : null,
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop({
                'studentId': widget.studentId,
                'licensePlate': widget.licensePlate,
              });
            },
            icon: Icon(
              Icons.arrow_back_ios_rounded,
              color: Theme
                  .of(context)
                  .iconTheme
                  .color,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.withOpacity(0.9),
                      radius: 80,
                      child: Icon(
                        color: Colors.white,
                        Icons.person,
                        size: 100,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'First name',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.firstName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Last name',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.lastName,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Index',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.studentId.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'License plate',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.licensePlate,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Number of visits\n in last month',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.numberOfVisits.toString(),
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Validity of student ID',
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
                          ),
                        ),
                        Text(
                          widget.validityOfStudentId,
                          style: TextStyle(
                            fontSize: 20,
                            color: Theme
                                .of(context)
                                .textTheme
                                .headline1
                                ?.color,
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

