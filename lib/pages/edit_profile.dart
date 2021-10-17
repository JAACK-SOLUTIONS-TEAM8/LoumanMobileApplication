import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:louman_app/constants/constants.dart';
import 'package:louman_app/models/employee.dart';
import 'package:louman_app/models/employee_response.dart';
import 'package:louman_app/pages/alter_dialog.dart';
import 'package:louman_app/pages/appbar_widget.dart';
import 'package:louman_app/pages/button_widget.dart';
import 'package:louman_app/pages/profile_widget.dart';
import 'package:louman_app/pages/textfield_widget.dart';
import 'package:http/http.dart' as http;

class EditEmployeeProfile extends StatefulWidget {
  final String title;
  const EditEmployeeProfile({Key? key, required this.title}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditEmployeeProfile();
}

class _EditEmployeeProfile extends State<EditEmployeeProfile> {
  TextEditingController initialController = TextEditingController();
  TextEditingController surNameController = TextEditingController();
  TextEditingController emailCodeController = TextEditingController();
  TextEditingController cellPhoneController = TextEditingController();
  Employee? employeeData;
  String? _image;
  String? selectedFileName;
  File? selectedFile;
  EmployeeResponse? employeeResponse;
  bool isLoading = false;
  String requestDomain = Platform.isAndroid ? Constants.domainEmulator : Constants.domainBrowser;

  Future<void> _getEmployee(int? employeeUserId) async {
    var url = Uri.parse(requestDomain + '/api/Employee/User/$employeeUserId');
    var response =
        await http.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      print(response.body);
      employeeResponse = EmployeeResponse.fromJson(jsonDecode(response.body));
     

      CustomeAlert.showMyDialog(
                                        context,
                                        "Update Employee",
                                        "Employee Info Updated Successfully").then((value)async{
                                          setState(() {
          isLoading = false;
    });
      Navigator.pushNamed(context, "/home",
          arguments: employeeResponse!.employee);

                                        });
    } else {}
  }

  Future<void> _updateEmployee() async {
    var url = Uri.parse(requestDomain + '/api/Employee/Update');
    setState(() {
          isLoading = true;
    });
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        "Access-Control-Allow-Origin": "*"
      },
      body: jsonEncode(<String, dynamic>{
        "initials": employeeData!.initials,
        "surname": employeeData!.surname,
        "cellPhone": employeeData!.cellNumber,
        "image": "data:image/jpeg;base64,"+ employeeData!.image,
        "document": "data:application/pdf;base64,"+employeeData!.document!,
        "userId":employeeData!.userId,
        "email":employeeData!.email
      }),
    );

    if (response.statusCode == 200) {
      await _getEmployee(employeeData!.userId);
    }
  }

  Future getImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(image != null)
    {
          final stringImage = base64Encode(await image.readAsBytes());
    setState(() {
      _image = stringImage;
      employeeData!.image = stringImage;
    });

    }
  }

  Future selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      // final fileBytes= result.files.single.bytes;
      final file = File(result.files.single.path!);
      print(result.files.single.name);
      employeeData!.document = base64Encode(await file.readAsBytes());

      setState(() {
        selectedFileName = result.files.single.name;
        selectedFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    employeeData = ModalRoute.of(context)!.settings.arguments as Employee;

    return Scaffold(
      appBar: buildAppBar(context),
      body: !isLoading? ListView(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              physics: const BouncingScrollPhysics(),
              children: [
                ProfileWidget(
                    image: _image == null ? employeeData!.image : _image!,
                    onClicked: getImage,
                    isEdit: true),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                    lable: "Name",
                    text: employeeData!.initials,
                    onChanged: (name) {
                      employeeData!.initials = name;
                    }),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                    lable: "Surname",
                    text: employeeData!.surname,
                    onChanged: (surname) {
                      employeeData!.surname = surname;
                    }),
                const SizedBox(
                  height: 15,
                ),
                TextFieldWidget(
                    lable: "Phone",
                    text: employeeData!.cellNumber,
                    onChanged: (phone) {
                      employeeData!.cellNumber = phone;
                    }),
                const SizedBox(
                  height: 15,
                ),
                Text(selectedFileName ?? "No file Selected"),
                const SizedBox(
                  height: 15,
                ),
                Center(child: buildDocumentButton()),
                const SizedBox(
                  height: 15,
                ),
                Center(child: buildUpdateButton()),
              ],
            ): const Center(child: CircularProgressIndicator())
          //,
    );
  }

  Widget buildDocumentButton() => ButtonWidget(
        text: 'Upload Document Profile',
        onClicked: selectFile,
      );

  Widget buildUpdateButton() => ButtonWidget(
        text: 'Update Employee',
        onClicked: _updateEmployee,
      );
}
