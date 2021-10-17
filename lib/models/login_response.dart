import 'package:louman_app/models/user.dart';

class LoginResponse {
  User user;
  int statusCode;

  LoginResponse({required this.user, required this.statusCode});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
        user: json['user'] != null
            ? User.fromJson(json['user'])
            : User(
                userId: 0,
                userTypeId: 0,
                addressId: 0,
                idNumber: '0',
                initials: "initials",
                surname: 'surname',
                cellNumber: 'cellNumber',
                email: 'email',
                userName: 'userName',
                password: 'password',
                userType: 'userType',
              ),
        statusCode: json['statusCode']);
  }
}
