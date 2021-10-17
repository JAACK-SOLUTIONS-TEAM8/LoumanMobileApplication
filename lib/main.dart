import 'dart:io';
import 'package:flutter/material.dart';
import 'package:louman_app/pages/edit_profile.dart';
import 'package:louman_app/pages/home.dart';
import 'package:louman_app/pages/login.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class CircularIndicator extends StatelessWidget {
  const CircularIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Louman',
        initialRoute: "/",
          routes: {
          "/": (context) => const Login(title: "Employee Login Page"),
          "/home": (context) => const MyHomePage(title: "Employee Home Page"),
          "/editprofile": (context) =>
              const EditEmployeeProfile(title: "Edit Employee Profile"),
        },
        theme: ThemeData(
          primaryColor: Colors.blue.shade300,
        ));
  }
}
