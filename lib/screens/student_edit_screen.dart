import 'dart:io';

import 'package:flutter/material.dart';

class StudentEdit extends StatelessWidget {
  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  // TODO change below type to DataTime
  String validityOfStudentId;

  StudentEdit(
      {required this.firstName,
      required this.lastName,
      required this.studentId,
      required this.licensePlate,
      required this.numberOfVisits,
      required this.validityOfStudentId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? StudentEditGenerate(
          firstName: firstName,
          lastName: lastName,
          studentId: studentId,
          licensePlate: licensePlate,
          numberOfVisits: numberOfVisits,
          validityOfStudentId: validityOfStudentId,
        )
      : SafeArea(
          child: StudentEditGenerate(
            firstName: firstName,
            lastName: lastName,
            studentId: studentId,
            licensePlate: licensePlate,
            numberOfVisits: numberOfVisits,
            validityOfStudentId: validityOfStudentId,
          ),
        );
}

class StudentEditGenerate extends StatelessWidget {
  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
  // TODO change below type to DataTime
  String validityOfStudentId;

  StudentEditGenerate(
      {required this.firstName,
      required this.lastName,
      required this.studentId,
      required this.licensePlate,
      required this.numberOfVisits,
      required this.validityOfStudentId,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController firstNameController = TextEditingController();
    firstNameController.text = firstName;
    TextEditingController lastNameController = TextEditingController();
    lastNameController.text = lastName;
    TextEditingController studentIdController = TextEditingController();
    studentIdController.text = studentId.toString();
    TextEditingController licensePlateController = TextEditingController();
    licensePlateController.text = licensePlate;
    TextEditingController numberOfVisitsController = TextEditingController();
    numberOfVisitsController.text = numberOfVisits.toString();
    TextEditingController validityOfStudentIdController =
        TextEditingController();
    validityOfStudentIdController.text = validityOfStudentId;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit student',
            style: TextStyle(
              color: Theme.of(context).textTheme.headline1?.color,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                // TODO Saving dateTime
                Navigator.of(context).pop({
                  'firstName': firstNameController.text,
                  'lastName': lastNameController.text,
                  'studentId': studentIdController.text,
                  'licensePlate': licensePlateController.text,
                  'numberOfVisits': numberOfVisitsController.text,
                  'validityOfStudentId': validityOfStudentIdController.text,
                });
              },
              icon: Icon(
                Icons.save,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
          ],
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(
              Icons.cancel,
              color: Theme.of(context).iconTheme.color,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      controller: firstNameController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "First name",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      controller: lastNameController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outlined,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "Last name",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      controller: studentIdController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.key,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "Student ID",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      controller: licensePlateController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.drive_eta,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "License plate",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      controller: numberOfVisitsController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.place,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "Number of visits",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  // TODO - StudentID
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 9),
                    child: TextFormField(
                      // TODO ADD date
                      controller: validityOfStudentIdController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.credit_card_rounded,
                          size: 30,
                          color: Colors.grey,
                        ),
                        labelText: "Validity of student ID",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.only(top: 15, bottom: 15),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      textInputAction: TextInputAction.next,
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
