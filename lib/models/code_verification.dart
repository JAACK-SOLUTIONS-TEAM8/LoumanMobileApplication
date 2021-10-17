import 'package:louman_app/models/user.dart';

class CodeVerification {
  int responseType;
  User user;
  String verificationCode;

  CodeVerification(
      {required this.responseType,
      required this.user,
      required this.verificationCode});

  factory CodeVerification.fromJson(Map<String, dynamic> json) {
    return CodeVerification(
        responseType: json['responseType'],
        user: User.fromJson(json['user']),
        verificationCode: json['verificationCode']);
  }
}
