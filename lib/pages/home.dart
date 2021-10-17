import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:louman_app/models/employee.dart';
import 'package:louman_app/pages/appbar_widget.dart';
import 'package:louman_app/pages/button_widget.dart';
import 'package:louman_app/pages/profile_widget.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import 'alter_dialog.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Employee? emloyeeData;
  bool isLoggedIn = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    isLoggedIn = true;
    emloyeeData = ModalRoute.of(context)!.settings.arguments as Employee;

    return Scaffold(
      appBar: buildAppBar(context),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            image: emloyeeData!.image,
            isEdit: false,
            onClicked: () async {
              //navigate to edit profile with employeeData
              Navigator.pushNamed(context, "/editprofile",
                  arguments: emloyeeData);
            },
          ),
          const SizedBox(height: 24),
          Center(
            child: buildName(emloyeeData!),
          ),
          const SizedBox(height: 24),
          Center(child: buildDownloadButton(emloyeeData!)),
          const SizedBox(height: 40),
          Center(child: buildEditButton()),
        ],
      ),
    );
  }

  Widget buildName(Employee employee) => Column(
        children: [
          Text(
            '${emloyeeData!.initials} ${emloyeeData!.surname}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 10),
          Text(
            employee.email,
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Center(
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Team Name :",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee.teamName==null?"No Team":employee.teamName!,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Phone Number :",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      employee.cellNumber,
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Commence Date :",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      DateFormat('yyyy-MM-dd').format(employee.commenceDate!),
                      style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.w100,
                          fontSize: 15),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
      );

  Widget buildEditButton() => ButtonWidget(
        text: 'Edit Profile',
        onClicked: () {
          Navigator.pushNamed(context, "/editprofile",
          arguments: emloyeeData);
        },
      );

  Widget buildDownloadButton(Employee employee) => ButtonWidget(
        text: 'Download Employee Document',
        onClicked: () async {
          if (employee.document == null || employee.document == "") {
            await CustomeAlert.showMyDialog(
                context, "Validation", "No Document to download");
          } else {
            Uint8List bytes = base64Decode(employee.document!);

            String documentPath = "";
            if (Platform.isIOS) {
              Directory appDocDir = await getTemporaryDirectory();
              documentPath =
                  '${appDocDir.path}/${employee.initials}_${employee.surname}.pdf';
            } else if (Platform.isWindows) {
              Directory? appDocDir = await getDownloadsDirectory();
              documentPath =
                  '${appDocDir!.path}/${employee.initials}_${employee.surname}.pdf';
            } else if (Platform.isAndroid) {
              Directory? appDocDir = await getExternalStorageDirectory();
              //Directory appDocDir = await getApplicationDocumentsDirectory();

              documentPath =
                  '${appDocDir!.path}/${employee.initials}_${employee.surname}.pdf';
            }

            print(documentPath);
            File file = File(documentPath);
            file.writeAsBytes(bytes).then((value) async => {
                  await CustomeAlert.showMyDialog(context, "Successs",
                      "Document Downloaded to directory :=>$documentPath")
                });
          }
        },
      );

  Widget buildAbout(Employee employee) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              employee.teamName!,
              style: const TextStyle(fontSize: 16, height: 1.4),
            ),
          ],
        ),
      );
}
