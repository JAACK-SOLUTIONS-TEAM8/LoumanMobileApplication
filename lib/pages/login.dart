import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:louman_app/constants/constants.dart';
import 'package:http/http.dart' as http;
import 'package:louman_app/models/employee_response.dart';
import 'package:louman_app/models/login_model.dart';
import 'package:louman_app/models/login_response.dart';
import 'package:louman_app/models/user.dart';
import 'package:louman_app/models/user_code.dart';
import 'package:louman_app/models/verification_response.dart';

import 'alter_dialog.dart';

class Login extends StatefulWidget {
  final String title;
  const Login({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController verificationCodeController = TextEditingController();

  bool isLoading = false;



  bool isAuthenticated = false;
  LoginResponse? loginResponse;
  VerificationResponse? codeVerification;
  EmployeeResponse? employeeResponse;
  String requestDomain =Platform.isAndroid?Constants.domainEmulator: Constants.domainBrowser;
  Future<void> login(LoginModel loginModel) async {
    var url = Uri.parse(requestDomain + "/api/Auth/Login");
    setState(() {
      isLoading = true;
    });
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin": "*"
      },
      body: jsonEncode(<String, String>{
        "userName": loginModel.userName,
        "password": loginModel.password
      }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      loginResponse = LoginResponse.fromJson(jsonDecode(response.body));

      if (loginResponse!.statusCode == 200) {
        setState(() {
          isAuthenticated = true;
          isLoading = false;
        });
        await CustomeAlert.showMyDialog(context, "Validation",
            "User authenticated ,Verification code sent to you on you email")
            .then((value) => {
               setState(() {
        isLoading = false;
      })
            });
      } else {
         CustomeAlert.showMyDialog(
            context, "Validation", "Incorrect code")
            .then((value) => {
               setState(() {
        isLoading = false;
      })
            });
      }
    }
  }

  Future<void> _getEmployee(int? employeeUserId) async {
    var url = Uri.parse(requestDomain + '/api/Employee/User/$employeeUserId');
    setState(() {
     isLoading=true;
    });
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print(response.body);
      employeeResponse = EmployeeResponse.fromJson(jsonDecode(response.body));
      setState(() {
        isLoading = false;
      });
      Navigator.pushNamed(context, "/home",
          arguments: employeeResponse!.employee);
    } else {}
  }

  Future<void> verifyCode(UserCode userCode) async {
    var url = Uri.parse(requestDomain + "/api/Auth/VerifyCode");
    setState(() {
          isLoading = true;
    });
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin": "*"
      },
      body: jsonEncode(
        <String, dynamic>{
          "user": User.toJson(userCode.user),
          "code": userCode.code
        },
      ),
    );

    if (response.statusCode == 200) {
      print(response.body);
      var verificationResponse =
          VerificationResponse.fromJson(jsonDecode(response.body));
      if (verificationResponse.statusCode == 200) {
         CustomeAlert.showMyDialog(
            context, "Verification", "User is verified").then((value)async {
          await _getEmployee(verificationResponse.status.user.userId);
          setState(() {
            isLoading=false;
          });
            });
       
      } else if (verificationResponse.statusCode == 401) {
         CustomeAlert.showMyDialog(
            context, "Verification", "Incorrect Verification Code")
            .then((value) => {
               setState(() {
        isLoading = false;
      })
            });
      } else {
        await CustomeAlert.showMyDialog(
            context, "Verification", "Code Expires").then((value) => {
               setState(() {
        isLoading = false;
      })
            });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
            appBar: AppBar(
              title: Text(widget.title),
            ),
            body: !isLoading? Padding(
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(10),
                        child: const Text(
                          'Louman',
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        )),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: TextField(
                        enabled: !isAuthenticated,
                        showCursor: true,
                        controller: userNameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'User Name',
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: TextField(
                        obscureText: true,
                        enabled: !isAuthenticated,
                        controller: passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Password',
                        ),
                      ),
                    ),
                    Container(
                        height: 50,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: MaterialButton(
                          color: Colors.blue,
                          child: const Text('Login'),
                          onPressed: !isAuthenticated
                              ? () async {
                                  if (userNameController.text.isEmpty) {
                                    await CustomeAlert.showMyDialog(
                                        context,
                                        "Validation",
                                        "User name must be provided");
                                    return;
                                  } else if (passwordController.text.isEmpty) {
                                    await CustomeAlert.showMyDialog(
                                        context,
                                        "Validation",
                                        "Password must be provided");
                                    return;
                                  }
                                  await login(LoginModel(
                                      userName: userNameController.text,
                                      password: passwordController.text));
                                }
                              : null,
                        )),
                    Visibility(
                        visible: true,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: TextField(
                                enabled: isAuthenticated,
                                obscureText: true,
                                controller: verificationCodeController,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Verification Code',
                                ),
                              ),
                            ),
                            Container(
                                height: 50,
                                width: 100,
                                padding:
                                    const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                child: MaterialButton(
                                  color: Colors.blue,
                                  child: const Text('Confirm'),
                                  onPressed: isAuthenticated
                                      ? () async {
                                          await verifyCode(UserCode(
                                              user: loginResponse!.user,
                                              code: verificationCodeController
                                                  .text));
                                          print(
                                              verificationCodeController.text);
                                        }
                                      : null,
                                )),
                          ],
                        )),
                  ],
                )): const Center(child: CircularProgressIndicator()));
  }
}
