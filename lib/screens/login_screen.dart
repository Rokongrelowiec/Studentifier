import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:studentifier/screens/contact_admin_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import './home_screen.dart';
import './reset_password_screen.dart';
import '../providers/admin_provider.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login-screen';

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Platform.isIOS
      ? GenerateLoginScreen()
      : SafeArea(child: GenerateLoginScreen());
}

class GenerateLoginScreen extends StatefulWidget {
  GenerateLoginScreen({Key? key}) : super(key: key);

  @override
  State<GenerateLoginScreen> createState() => _GenerateLoginScreenState();
}

class _GenerateLoginScreenState extends State<GenerateLoginScreen> {
  bool password = true;
  Color iconColor = Colors.grey;
  final formKey = GlobalKey<FormState>();
  bool invalidRequest = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final sizeHeight = MediaQuery.of(context).size.height * 0.01;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -sizeHeight * 8,
              right: -sizeHeight * 12,
              child: Container(
                height: sizeHeight * 35,
                width: sizeHeight * 35,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color.fromRGBO(255, 152, 20, 0.9),
                          Color.fromRGBO(255, 110, 40, 0.8)
                        ]),
                    borderRadius: BorderRadius.circular(180)),
              ),
            ),
            Positioned(
              top: -sizeHeight * 7.5,
              left: -sizeHeight * 3,
              child: Container(
                height: sizeHeight * 35,
                width: sizeHeight * 35,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        end: Alignment.topLeft,
                        colors: [
                          Color.fromRGBO(255, 152, 20, 0.9),
                          Color.fromRGBO(255, 110, 40, 0.8)
                        ]),
                    borderRadius: BorderRadius.circular(180)),
              ),
            ),
            Container(
              height: size.height,
              width: size.width,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: Platform.isIOS
                            ? EdgeInsets.only(
                                top: sizeHeight * 6, left: sizeHeight * 2)
                            : EdgeInsets.only(
                                top: sizeHeight, left: sizeHeight * 2),
                        child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                            size: sizeHeight * 4,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            left: sizeHeight * 4, top: sizeHeight * 2),
                        child: Text(
                          "Administrator",
                          style: TextStyle(
                              fontSize: size.height * 0.04,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: sizeHeight * 4),
                        child: Text(
                          AppLocalizations.of(context)!.login,
                          style: TextStyle(
                              fontSize: sizeHeight * 4,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.fromLTRB(sizeHeight * 5,
                              sizeHeight * 8, sizeHeight * 7, 0),
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .displayLarge
                                    ?.color,
                                fontSize: sizeHeight * 2.2,
                              ),
                              decoration: InputDecoration(
                                  prefixIcon: Padding(
                                    padding: EdgeInsets.only(right: sizeHeight),
                                    child: Icon(
                                      Icons.email_outlined,
                                      color: Theme.of(context).primaryColor,
                                      size: sizeHeight * 4,
                                    ),
                                  ),
                                  labelText:
                                      AppLocalizations.of(context)!.email,
                                  labelStyle: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .displayLarge
                                          ?.color,
                                      fontSize: sizeHeight * 2),
                                  hintStyle: TextStyle(color: Colors.grey),
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: sizeHeight * 2),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFE0E0E0), width: 2),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xFFDD9246), width: 1),
                                  ),
                                  errorStyle:
                                      TextStyle(fontSize: sizeHeight * 2)),
                              onChanged: (String? newVal) {
                                if (invalidRequest) {
                                  invalidRequest = false;
                                }
                              },
                              validator: (String? val) {
                                if (invalidRequest) {
                                  return AppLocalizations.of(context)!
                                      .invalid_email_pass;
                                }
                                if (val == null || val.length == 0) {
                                  return AppLocalizations.of(context)!
                                      .enter_email;
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
                              textInputAction: TextInputAction.next,
                            ),
                          )),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                            sizeHeight * 5, sizeHeight, sizeHeight * 7, 0),
                        child: Container(
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            obscureText: password,
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.color,
                              fontSize: sizeHeight * 2.2,
                            ),
                            decoration: InputDecoration(
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
                                prefixIcon: Padding(
                                  padding: EdgeInsets.only(right: sizeHeight),
                                  child: Icon(
                                    Icons.lock_outline_rounded,
                                    color: Theme.of(context).primaryColor,
                                    size: sizeHeight * 4,
                                  ),
                                ),
                                labelText:
                                    AppLocalizations.of(context)!.password,
                                labelStyle: TextStyle(
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color,
                                    fontSize: sizeHeight * 2),
                                hintStyle: TextStyle(color: Colors.grey),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: sizeHeight * 2),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFE0E0E0), width: 2),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xFFDD9246), width: 1),
                                ),
                                errorStyle:
                                    TextStyle(fontSize: sizeHeight * 2)),
                            onChanged: (String? newVal) {
                              if (invalidRequest) {
                                invalidRequest = false;
                              }
                            },
                            validator: (String? val) {
                              if (invalidRequest) {
                                return AppLocalizations.of(context)!
                                    .invalid_email_pass;
                              }
                              if (val?.length == 0) {
                                return AppLocalizations.of(context)!.enter_pass;
                              } else if (val != null && val.length < 6) {
                                return AppLocalizations.of(context)!
                                    .enter_pass_min6;
                              }
                              return null;
                            },
                            controller: passwordController,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Spacer(),
                          Padding(
                            padding: EdgeInsets.only(
                                right: sizeHeight * 6, top: sizeHeight * 3),
                            child: TextButton(
                              onPressed: () => Navigator.of(context)
                                  .pushNamed(ResetPasswordScreen.routeName),
                              child: Text(
                                AppLocalizations.of(context)!.forgot_pass,
                                style: TextStyle(
                                    fontSize: sizeHeight * 2,
                                    color: Color(0xFFDD9746),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: sizeHeight * 4),
                          child: Container(
                            height: sizeHeight * 6,
                            width: sizeHeight * 19,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              onPressed: () async {
                                final isValidForm =
                                    formKey.currentState!.validate();
                                if (isValidForm) {
                                  String email = emailController.text;
                                  String pass = passwordController.text;
                                  var bytes = utf8
                                      .encode("email:$email|password:$pass");
                                  Digest sha = sha512.convert(bytes);
                                  var requestBody =
                                      jsonEncode({"password_hash": sha.toString()});
                                  String key = await rootBundle
                                      .loadString('assets/api-key.txt');
                                  var response = await http.post(
                                      Uri.parse(
                                          'https://api.danielrum.in/api/v1/admin/login'),
                                      headers: {
                                        'x-api-key': key,
                                        'Content-Type': 'application/json',
                                      },
                                      body: requestBody);
                                  if (response.statusCode == 200) {
                                    Provider.of<AdminProvider>(context,
                                            listen: false)
                                        .changePermission(true);
                                    Navigator.of(context)
                                        .pushNamedAndRemoveUntil(
                                            HomeScreen.routeName,
                                            (route) => false);
                                  } else {
                                    setState(() {
                                      invalidRequest = true;
                                    });
                                  }
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)!.login_btn,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: sizeHeight * 3),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight * 6,
                      ),
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.not_have_account,
                          style: TextStyle(
                              fontSize: sizeHeight * 3,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: sizeHeight,
                      ),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed(ContactAdminScreen.routeName);
                          },
                          child: Text(
                            AppLocalizations.of(context)!.admin_contact,
                            style: TextStyle(
                              fontSize: sizeHeight * 3,
                              color: Color(0xFFDD9246),
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
