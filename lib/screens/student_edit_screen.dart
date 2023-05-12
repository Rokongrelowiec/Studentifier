import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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

class StudentEditGenerate extends StatefulWidget {
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

  @override
  State<StudentEditGenerate> createState() => _StudentEditGenerateState();
}

class _StudentEditGenerateState extends State<StudentEditGenerate> {
  final formKey = GlobalKey<FormState>();
  var maskFormatter = new MaskTextInputFormatter(mask: '##-##-####',
      filter: { "#": RegExp(r'[0-9]') });

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

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController numberOfVisitsController = TextEditingController();
  TextEditingController validityOfStudentIdController = TextEditingController();

  @override
  void initState() {
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    studentIdController.text = widget.studentId.toString();
    licensePlateController.text = widget.licensePlate;
    numberOfVisitsController.text = widget.numberOfVisits.toString();
    validityOfStudentIdController.text = widget.validityOfStudentId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;

    final regExp = RegExp(r'^(?:(?:31(\/|-|\.)(?:0?[13578]|1[02]))\1|(?:(?:29|'
    r'30)(\/|-|\.)(?:0?[13-9]|1[0-2])\2))(?:(?:1[6-9]|[2-9]\d)?\d{2})$|^(?:'
    r'29(\/|-|\.)0?2\3(?:(?:(?:1[6-9]|[2-9]\d)?(?:0[48]|[2468][048]|[13579]'
    r'[26])|(?:(?:16|[2468][048]|[3579][26])00))))$|^(?:0?[1-9]|1\d|2[0-8])'
    r'(\/|-|\.)(?:(?:0?[1-9])|(?:1[0-2]))\4(?:(?:1[6-9]|[2-9]\d)?\d{2})$');

    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.edit_student,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
        backIcon: Icons.cancel,
        actionsList: [
          Padding(
            padding: EdgeInsets.only(right: sizeHeight),
            child: IconButton(
              onPressed: () async {
                var date = DateFormat('dd-MM-yyyy').parse(validityOfStudentIdController.text);
                var formattedDate = DateFormat('yyyy-MM-dd').format(date);
                final isValidForm = formKey.currentState!.validate();
                if (isValidForm) {
                  String apiKey = await DefaultAssetBundle.of(context)
                      .loadString('assets/api-key.txt');
                  var requestBody = jsonEncode({
                    'numer_albumu': studentIdController.text,
                    'imie': setFirstUpperCase(firstNameController.text),
                    'nazwisko': setFirstUpperCase(lastNameController.text),
                    'data_waznosci': formattedDate,
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
                        labelText: AppLocalizations.of(context)!.first_name,
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
                          return AppLocalizations.of(context)!.too_short_val;
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
                        labelText: AppLocalizations.of(context)!.last_name,
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
                          return AppLocalizations.of(context)!.too_short_val;
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
                        labelText: AppLocalizations.of(context)!.index,
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
                          return AppLocalizations.of(context)!.too_short_val;
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
                        labelText: AppLocalizations.of(context)!.license_plate4,
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
                          return AppLocalizations.of(context)!.too_short_val;
                        }
                        if (value != null && value.length > 9) {
                          return AppLocalizations.of(context)!.too_long_val;
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
                        labelText: AppLocalizations.of(context)!.num_of_visits_month,
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
                          return AppLocalizations.of(context)!.too_short_val;
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
                      maxLength: 10,
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.credit_card_rounded,
                          size: sizeHeight * 5,
                          color: Colors.grey,
                        ),
                        labelText: AppLocalizations.of(context)!.student_id_val2,
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
                        maskFormatter
                      ],
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.length != 10) {
                          return AppLocalizations.of(context)!.enter_dd_mm_yyyy;
                        }
                        if (!regExp.hasMatch(value)) {
                          return AppLocalizations.of(context)!.enter_correct_date;
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
