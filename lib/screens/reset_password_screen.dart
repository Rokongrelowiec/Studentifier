import 'dart:io';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

import '../widgets/app_bar_widget.dart';

class ResetPasswordScreen extends StatelessWidget {
  static const routeName = '/reset-password-screen';

  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateResetPasswordScreen()
      : SafeArea(child: GenerateResetPasswordScreen());
}

class GenerateResetPasswordScreen extends StatefulWidget {
  GenerateResetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<GenerateResetPasswordScreen> createState() =>
      _GenerateResetPasswordScreenState();
}

class _GenerateResetPasswordScreenState
    extends State<GenerateResetPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  bool sendCode = true;
  bool password = true;
  Color iconColor = Colors.grey;
  final passwordFocusNode = FocusNode();
  final codeFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      appBar: AppBarWidget(
        title: AppLocalizations.of(context)!.reset_password,
        appBar: AppBar(),
        backFunction: () => Navigator.of(context).pop(),
      ),
      body: Stack(
        children: [
          Positioned(
            top: sizeHeight,
            left: -sizeHeight * 10,
            child: Container(
              width: sizeHeight * 20,
              height: sizeHeight * 20,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.centerLeft,
                    colors: [
                      Color.fromRGBO(255, 152, 20, 0.8),
                      Color.fromRGBO(238, 122, 40, 0.9),
                    ]),
                borderRadius: BorderRadius.circular(180),
              ),
            ),
          ),
          Positioned(
            top: sizeHeight * 20,
            right: sizeHeight,
            child: Container(
              width: sizeHeight * 13,
              height: sizeHeight * 13,
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
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.lock_reset_outlined,
                        size: sizeHeight * 30,
                        color: Theme.of(context).primaryColor,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
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
                              return AppLocalizations.of(context)!
                                  .enter_valid_email;
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp("[A-Za-z0-9]|[@~!\$%^&*_=+}{'\.?-]"))
                          ],
                          controller: emailController,
                          textInputAction: sendCode
                              ? TextInputAction.done
                              : TextInputAction.next,
                        ),
                      ),
                      sendCode
                          ? Container()
                          : Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: sizeHeight),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                obscureText: password,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: sizeHeight * 2.2),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.lock_outline_rounded,
                                      color: Theme.of(context).primaryColor,
                                      size: sizeHeight * 4,
                                    ),
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          password = !password;
                                        });
                                      },
                                      icon: password
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: iconColor,
                                              size: sizeHeight * 3.5,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: iconColor,
                                              size: sizeHeight * 3.5,
                                            ),
                                    ),
                                    labelText: AppLocalizations.of(context)!
                                        .new_password,
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
                                    errorStyle:
                                        TextStyle(fontSize: sizeHeight * 2)),
                                validator: (String? val) {
                                  if (val == null || val.length == 0) {
                                    return AppLocalizations.of(context)!
                                        .enter_pass;
                                  } else if (val.length < 6) {
                                    return AppLocalizations.of(context)!
                                        .enter_pass_min6;
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (_) {
                                  passwordFocusNode.unfocus();
                                  setState(() {
                                    FocusScope.of(context)
                                        .requestFocus(codeFocusNode);
                                  });
                                },
                                focusNode: passwordFocusNode,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      "[A-Za-z0-9]|[@~!\$%^&*_=+{}()'`\.?-]"))
                                ],
                                controller: passwordController,
                                textInputAction: TextInputAction.next,
                              ),
                            ),
                      sendCode
                          ? Container()
                          : Padding(
                              padding:
                                  EdgeInsets.symmetric(vertical: sizeHeight),
                              child: TextFormField(
                                keyboardType: TextInputType.multiline,
                                maxLines: 2,
                                maxLength: 60,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: sizeHeight * 2.2),
                                decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.numbers,
                                      color: Theme.of(context).primaryColor,
                                      size: sizeHeight * 4,
                                    ),
                                    labelText: AppLocalizations.of(context)!
                                        .recovery_code,
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
                                    errorStyle:
                                        TextStyle(fontSize: sizeHeight * 2)),
                                validator: (String? val) {
                                  if (val == null ||
                                      45 > val.length ||
                                      val.length > 65) {
                                    return AppLocalizations.of(context)!
                                        .invalid_value;
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(
                                      "[A-Za-z0-9]|[@~!\$%^&*_=+}{'\.?-]")),
                                ],
                                focusNode: codeFocusNode,
                                controller: codeController,
                                textInputAction: TextInputAction.done,
                              ),
                            ),
                      sendCode
                          ? SizedBox(
                              height: sizeHeight * 5,
                            )
                          : Container(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight * 2),
                        child: ElevatedButton(
                          onPressed: () async {
                            final isValidForm =
                                formKey.currentState!.validate();
                            if (isValidForm) {
                              String apiKey =
                                  await DefaultAssetBundle.of(context)
                                      .loadString('assets/api-key.txt');
                              bool positiveResponse = false;
                              if (sendCode) {
                                var requestBody = jsonEncode(
                                    {'email': '${emailController.text}'});
                                var response = await http.post(
                                  Uri.parse(
                                      'https://api.danielrum.in/api/v1/admin/forgotten_password/initialize'),
                                  headers: {
                                    'x-api-key': apiKey,
                                    'Content-Type': 'application/json'
                                  },
                                  body: requestBody,
                                );
                                if (response.statusCode == 200) {
                                  positiveResponse = true;
                                }
                              } else {
                                var bytes =
                                    utf8.encode("email:${emailController.text}"
                                        "|password:${passwordController.text}");
                                Digest sha = sha512.convert(bytes);
                                var requestBody = jsonEncode({
                                  'email': '${emailController.text}',
                                  'recovery_code': '${codeController.text}',
                                  'new_auth_hash': '$sha',
                                });
                                var response = await http.post(
                                  Uri.parse(
                                      'https://api.danielrum.in/api/v1/admin/forgotten_password/validate'),
                                  headers: {
                                    'x-api-key': apiKey,
                                    'Content-Type': 'application/json'
                                  },
                                  body: requestBody,
                                );
                                if (response.statusCode == 200) {
                                  positiveResponse = true;
                                }
                              }
                              String dialogMsg =
                                  AppLocalizations.of(context)!.req_failed;
                              IconData ic = Icons.sms_failed_outlined;
                              if (positiveResponse) {
                                dialogMsg = sendCode
                                    ? AppLocalizations.of(context)!
                                        .sent_recovery_code
                                    : AppLocalizations.of(context)!
                                        .password_changed;
                                ic = Icons.cloud_done_outlined;
                              }
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  backgroundColor: Theme.of(context)
                                      .drawerTheme
                                      .backgroundColor,
                                  icon: Icon(
                                    ic,
                                    size: sizeHeight * 20,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(60))),
                                  title: Text(
                                    dialogMsg,
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
                              Future.delayed(Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                                if (positiveResponse && sendCode) {
                                    setState(() {
                                      sendCode = false;
                                    });
                                } else {
                                  Navigator.of(context).pop();
                                }
                              });
                            }
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sendCode
                                    ? AppLocalizations.of(context)!.send_code
                                    : AppLocalizations.of(context)!
                                        .recover_account,
                                style: TextStyle(fontSize: sizeHeight * 2),
                              ),
                              Icon(
                                sendCode
                                    ? Icons.send
                                    : Icons.lock_open_outlined,
                                size: sizeHeight * 3,
                                color: Theme.of(context).iconTheme.color,
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              sendCode = !sendCode;
                            });
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                sendCode
                                    ? AppLocalizations.of(context)!
                                        .change_to_recover_code
                                    : AppLocalizations.of(context)!
                                        .change_to_send_code,
                                style: TextStyle(fontSize: sizeHeight * 2),
                              ),
                              Icon(
                                Icons.change_circle_outlined,
                                size: sizeHeight * 4,
                                color: Colors.orange,
                              ),
                            ],
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
