class User {
  int userId;
  int userTypeId;
  int? addressId;
  String idNumber;
  String initials;
  String surname;
  String cellNumber;
  String email;
  String userName;
  String password;
  String userType;

  User(
      {required this.userId,
      required this.userTypeId,
      required this.addressId,
      required this.idNumber,
      required this.initials,
      required this.surname,
      required this.cellNumber,
      required this.email,
      required this.userName,
      required this.password,
      required this.userType});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        userTypeId: json['userTypeId'],
        addressId: json['addressId'],
        idNumber: json['idNumber'],
        initials: json['initials'],
        surname: json['surname'],
        cellNumber: json['cellNumber'],
        email: json['email'],
        userName: json['userName'],
        password: json['password'],
        userType: json['userType']);
  }

  static Map<String, dynamic> toJson(User user) => {
        'userId': user.userId,
        'userTypeId': user.userTypeId,
        'addressId': user.addressId,
        'idNumber': user.idNumber,
        'initials': user.initials,
        'surname': user.surname,
        'cellNumber': user.cellNumber,
        'email': user.email,
        'userName': user.userName,
        'password': user.password,
        'userType': user.userType,
      };
}
