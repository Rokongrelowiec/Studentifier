import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/app_bar_widget.dart';

class ContactAdminScreen extends StatelessWidget {
  static const routeName = '/contact-admin-screen';

  const ContactAdminScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateContactAdminScreen()
      : SafeArea(child: GenerateContactAdminScreen());
}

class GenerateContactAdminScreen extends StatelessWidget {
  GenerateContactAdminScreen({Key? key}) : super(key: key);

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final String service =
        await rootBundle.loadString('assets/mail-service.txt');
    final List<String> serviceData = service.split('\n');
    final serviceId = serviceData[0],
        templateId = serviceData[1],
        userId = serviceData[2];
    final url = Uri.parse(serviceData[3]);

    await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'origin': 'http://localhost'
      },
      body: jsonEncode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': subject,
          'user_message': message,
        }
      }),
    );
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.send_email,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: -sizeHeight * 10,
            right: -sizeHeight * 10,
            child: Container(
              width: sizeHeight * 30,
              height: sizeHeight * 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromRGBO(255, 152, 20, 0.8),
                      Color.fromRGBO(238, 122, 78, 0.9),
                    ]),
                borderRadius: BorderRadius.circular(180),
              ),
            ),
          ),
          Positioned(
            top: sizeHeight * 35,
            right: -sizeHeight * 15,
            child: Container(
              width: sizeHeight * 30,
              height: sizeHeight * 30,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                    colors: [
                      Color.fromRGBO(255, 152, 20, 0.9),
                      Color.fromRGBO(255, 110, 40, 0.8)
                    ]),
                borderRadius: BorderRadius.circular(180),
              ),
            ),
          ),
          Positioned(
            top: sizeHeight * 75,
            right: sizeHeight * 35,
            child: Container(
              width: sizeHeight * 20,
              height: sizeHeight * 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.topLeft,
                    colors: [
                      Color.fromRGBO(255, 152, 20, 0.9),
                      Color.fromRGBO(255, 110, 40, 0.8)
                    ]),
                borderRadius: BorderRadius.circular(180),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.displayLarge?.color,
                              fontSize: sizeHeight * 2.2),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: sizeHeight * 4,
                              ),
                              labelText: AppLocalizations.of(context)!.sender_name,
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: sizeHeight * 2,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: sizeHeight * 2,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              errorStyle: TextStyle(fontSize: sizeHeight * 2)),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[A-Za-z]'),
                            ),
                          ],
                          validator: (String? val) {
                            if (val?.length == 0) {
                              return AppLocalizations.of(context)!.enter_name;
                            }
                            return null;
                          },
                          controller: nameController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.displayLarge?.color,
                              fontSize: sizeHeight * 2.2),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.email,
                                color: Theme.of(context).primaryColor,
                                size: sizeHeight * 4,
                              ),
                              labelText: AppLocalizations.of(context)!.email,
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: sizeHeight * 2,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: sizeHeight * 2,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              errorStyle: TextStyle(fontSize: sizeHeight * 2)),
                          validator: (String? val) {
                            if (val == null || val.length == 0) {
                              return AppLocalizations.of(context)!.enter_email;
                            } else if (!val.contains('@') ||
                                !val.contains('.') ||
                                val.length < 6 ||
                                val.startsWith('@') ||
                                val.startsWith('.')) {
                              return AppLocalizations.of(context)!.enter_valid_email;
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z0-9]|[@~!\$%^&*_=+}{'\.?-]"))
                          ],
                          controller: emailController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.displayLarge?.color,
                              fontSize: sizeHeight * 2.2),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.subject,
                                color: Theme.of(context).primaryColor,
                                size: sizeHeight * 4,
                              ),
                              labelText: AppLocalizations.of(context)!.subject,
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: sizeHeight * 2,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: sizeHeight * 2,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              errorStyle: TextStyle(fontSize: sizeHeight * 2)),
                          validator: (String? val) {
                            if (val?.length == 0) {
                              return AppLocalizations.of(context)!.enter_subject;
                            }
                            return null;
                          },
                          controller: subjectController,
                          textInputAction: TextInputAction.next,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        child: TextFormField(
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.displayLarge?.color,
                              fontSize: sizeHeight * 2.2),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.message,
                                color: Theme.of(context).primaryColor,
                                size: sizeHeight * 4,
                              ),
                              labelText: AppLocalizations.of(context)!.message,
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: sizeHeight * 2,
                              ),
                              hintStyle: TextStyle(color: Colors.grey),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: sizeHeight * 2,
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xFFE0E0E0), width: 2),
                              ),
                              errorStyle: TextStyle(fontSize: sizeHeight * 2)),
                          validator: (String? val) {
                            if (val?.length == 0) {
                              return AppLocalizations.of(context)!.enter_message;
                            }
                            return null;
                          },
                          controller: messageController,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 5,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final isValidForm = formKey.currentState!.validate();
                          if (isValidForm) {
                            sendEmail(
                              name: nameController.text,
                              email: emailController.text,
                              subject: subjectController.text,
                              message: messageController.text,
                            );
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                  backgroundColor: Theme.of(context)
                                      .drawerTheme
                                      .backgroundColor,
                                  icon: Icon(
                                    Icons.cloud_done_outlined,
                                    size: sizeHeight * 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(60))),
                                  title: Text(
                                    AppLocalizations.of(context)!.sent_successfully,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                      fontSize: sizeHeight * 3,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            );
                            Future.delayed(
                              Duration(seconds: 1),
                              () => Navigator.of(context)
                                  .popUntil((route) => route.isFirst),
                            );
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.send,
                          style: TextStyle(
                            fontSize: sizeHeight * 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
