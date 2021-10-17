import 'package:louman_app/models/code_verification.dart';

class VerificationResponse {
  CodeVerification status;
  int statusCode;
  VerificationResponse({required this.status, required this.statusCode});

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    return VerificationResponse(
        status: CodeVerification.fromJson(json['status']),
        statusCode: json['statusCode']);
  }
}
