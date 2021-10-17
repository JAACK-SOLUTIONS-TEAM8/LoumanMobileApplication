import 'package:louman_app/models/employee.dart';

class EmployeeResponse {
  Employee employee;
  int statusCode;

  EmployeeResponse({required this.employee, required this.statusCode});

  factory EmployeeResponse.fromJson(Map<String, dynamic> json) {
    return EmployeeResponse(
        employee: Employee.fromJson(json['employee']),
        statusCode: json['statusCode']);
  }
}
