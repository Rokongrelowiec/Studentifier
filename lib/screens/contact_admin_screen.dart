import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
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
    required String subject,
    required String message,
  }) async {
    String? encodeQueryParameters(Map<String, String> params) {
      return params.entries
          .map((MapEntry<String, String> e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
    }

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hey@danielrum.in',
      query: encodeQueryParameters({
        'subject': '${subjectController.text} - Sender: ${nameController.text}',
        'body': '${messageController.text}',
      }),
    );
    await launchUrl(emailLaunchUri);
  }

  final TextEditingController nameController = TextEditingController();
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
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
                              fontSize: sizeHeight * 2.2),
                          decoration: InputDecoration(
                              prefixIcon: Icon(
                                Icons.person,
                                color: Theme.of(context).primaryColor,
                                size: sizeHeight * 4,
                              ),
                              labelText:
                                  AppLocalizations.of(context)!.sender_name,
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
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
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
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp('[A-Za-z0-9]| '),
                            ),
                          ],
                          validator: (String? val) {
                            if (val?.length == 0) {
                              return AppLocalizations.of(context)!
                                  .enter_subject;
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
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
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
                              return AppLocalizations.of(context)!
                                  .enter_message;
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Theme.of(context).primaryColor,
                              content: Text(
                                AppLocalizations.of(context)!.open_mail_client,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .displayLarge
                                      ?.color,
                                  fontSize: sizeHeight * 2,
                                ),
                              ),
                            ));
                            sendEmail(
                              name: nameController.text,
                              subject: subjectController.text,
                              message: messageController.text,
                            );
                            Future.delayed(
                              Duration(seconds: 1),
                              () => Navigator.of(context)
                                  .popUntil((route) => route.isFirst),
                            );
                          }
                        },
                        child: Text(
                          AppLocalizations.of(context)!.write_msg,
                          style: TextStyle(
                            fontSize: sizeHeight * 3,
                            color:
                                Theme.of(context).textTheme.displayLarge?.color,
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
