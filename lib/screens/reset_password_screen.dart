import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  var maskFormatter = new MaskTextInputFormatter(mask: '###-###',
      filter: { "#": RegExp(r'[0-9]') });

  @override
  void initState() {
    super.initState();
    // codeController.addListener(() {
    //   final text = codeController.text;
    //   if (text.length == 3 && !text.contains('-')) {
    //     codeController.text = text + '-';
    //     codeController.selection = TextSelection.fromPosition(
    //         TextPosition(offset: codeController.text.length));
    //   }
    // });
  }

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
            top: sizeHeight * 25,
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
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight),
                        child: Icon(
                          Icons.lock_reset_outlined,
                          size: sizeHeight * 30,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: sizeHeight),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.headline1?.color,
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
                                    .headline1
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
                                        .headline1
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
                                          .headline1
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
                                keyboardType: TextInputType.number,
                                maxLength: 7,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .headline1
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
                                          .headline1
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
                                  if (val == null || val.length != 7) {
                                    return AppLocalizations.of(context)!
                                        .invalid_value;
                                  }
                                  return null;
                                },
                                inputFormatters: [
                                  maskFormatter
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
                          onPressed: () {},
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(sendCode
                                  ? AppLocalizations.of(context)!.send_code
                                  : AppLocalizations.of(context)!
                                      .recover_account),
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
