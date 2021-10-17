class Employee {
  int userId;
  int userTypeId;
  int? addressId;
  int teamId;
  String idNumber;
  String? teamName;
  String initials;
  String surname;
  String cellNumber;
  String email;
  String userName;
  String password;
  String image;
  String? document;
  int employeeId;
  DateTime? commenceDate;
  DateTime? terminationDate;
  String? terminationReason;

  Employee(
      {required this.userId,
      required this.userTypeId,
      required this.addressId,
      required this.teamId,
      required this.idNumber,
      required this.teamName,
      required this.initials,
      required this.surname,
      required this.cellNumber,
      required this.email,
      required this.userName,
      required this.password,
      required this.image,
      required this.document,
      required this.employeeId,
      required this.commenceDate,
      required this.terminationDate,
      required this.terminationReason,});

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
        userId: json['userId'],
        userTypeId: json['userTypeId'],
        addressId: json['addressId'],
        teamId: json['teamId'],
        idNumber: json['idNumber'],
        teamName: json['teamName'],
        initials: json['initials'],
        surname: json['surname'],
        cellNumber: json['cellNumber'],
        email: json['email'],
        userName: json['userName'],
        password: json['password'],
        image: json['image'].toString().split(",")[1],
        document: json['document'].toString().split(",")[1],
        employeeId: json['employeeId'],
        commenceDate: DateTime.parse(json['commenceDate'] ?? ""),
        terminationDate: DateTime.parse(json['commenceDate'] ?? ""),
        terminationReason: json['terminationReason']);
  }
}
