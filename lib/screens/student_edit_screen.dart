import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_bar_widget.dart';

class StudentEdit extends StatelessWidget {
  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
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
  final formKey = GlobalKey<FormState>();

  String firstName;
  String lastName;
  int studentId;
  String licensePlate;
  int numberOfVisits;
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

  setFirstUpperCase(String text) {
    final res = text.substring(0, 1).toUpperCase() + text.substring(1);
    return res;
  }

  setAllUpperCase(String text) {
    String res = '';
    for (int i = 0; i < text.length; i++) {
      res += text[i].toUpperCase();
    }
    return res;
  }

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

    final sizeHeight = MediaQuery.of(context).size.height * 0.01;

    return Scaffold(
      appBar: AppBarWidget(
        title: 'Edit student',
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
        backIcon: Icons.cancel,
        actionsList: [
          Padding(
            padding: EdgeInsets.only(right: sizeHeight),
            child: IconButton(
              onPressed: () async {
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm) {
                  String apiKey = await DefaultAssetBundle.of(context)
                      .loadString('assets/api-key.txt');
                  var requestBody = jsonEncode({
                    'numer_albumu': studentIdController.text,
                    'imie': setFirstUpperCase(firstNameController.text),
                    'nazwisko': setFirstUpperCase(lastNameController.text),
                    'data_waznosci': validityOfStudentIdController.text
                  });
                  await http.post(
                    Uri.parse(
                        'http://130.61.192.162:8069/api/v1/students/update/bystudentId'),
                    headers: {'x-api-key': apiKey},
                    body: requestBody,
                  );
                  Navigator.of(context).pop({
                    'firstName': setFirstUpperCase(firstNameController.text),
                    'lastName': setFirstUpperCase(lastNameController.text),
                    'studentId': studentIdController.text,
                    'licensePlate': setAllUpperCase(licensePlateController.text),
                    'numberOfVisits': numberOfVisitsController.text,
                    'validityOfStudentId': validityOfStudentIdController.text,
                  });
                }
              },
              icon: Icon(
                Icons.save,
                color: Theme.of(context).iconTheme.color,
                size: sizeHeight * 4,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          key: formKey,
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
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      controller: firstNameController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: sizeHeight * 2.4
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "First name",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.3,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                      ],
                      validator: (value) {
                        if (value != null && value.length < 1) {
                          return 'Too short value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      controller: lastNameController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: sizeHeight * 2.4
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.person_outlined,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "Last name",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 2.3,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[A-Za-z]")),
                      ],
                      validator: (value) {
                        if (value != null && value.length < 2) {
                          return 'Too short value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      enabled: false,
                      controller: studentIdController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                        fontSize: sizeHeight * 2.4,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.key,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "Student ID",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.3,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      validator: (value) {
                        if (value != null && value.length < 1) {
                          return 'Too short value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      enabled: false,
                      controller: licensePlateController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                      fontSize: sizeHeight * 2.4,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.drive_eta,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "License plate",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.3
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp("[A-Za-z0-9]")),
                      ],
                      validator: (value) {
                        if (value != null && value.length < 4) {
                          return 'Too short value';
                        }
                        if (value != null && value.length > 9) {
                          return 'Too long value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      controller: numberOfVisitsController,
                      keyboardType: TextInputType.number,
                      enabled: false,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 2.4,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.place,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "Number of visits",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.3,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                      ],
                      validator: (value) {
                        if (value != null && value.length < 1) {
                          return 'Too short value';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: sizeHeight),
                    child: TextFormField(
                      controller: validityOfStudentIdController,
                      style: TextStyle(
                          color: Theme.of(context).textTheme.headline1?.color,
                          fontSize: sizeHeight * 2.4,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.credit_card_rounded,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: "Validity of ID",
                        labelStyle: TextStyle(
                            color:
                                Theme.of(context).textTheme.headline1?.color,
                            fontSize: sizeHeight * 2.3,
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: sizeHeight),
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFE0E0E0), width: 2),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFDD9246), width: 1),
                        ),
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[0-9\-]")),
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        // TODO: better validation
                        if (value == null || value.length != 10) {
                          return 'Please type date using DD-MM-YYYY format';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
