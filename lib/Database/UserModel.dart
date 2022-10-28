// ignore_for_file: non_constant_identifier_names

class UserModel {
  final int userID;
  final String userName;
  final String userEmail;
  final String userCity;
  final String userState;
  final String userPassword;

  UserModel(this.userID, this.userName, this.userEmail, this.userCity,
      this.userState, this.userPassword);
  @override
  String toString() {
    return 'dados:{userID:$userID, userName:$userName, userEmail:$userEmail, userCity:$userCity, userState:$userState, userPassword:$userPassword}';
  }

  UserModel.fromJson(Map<String, dynamic> json)
      : userID = json['userID'],
        userName = json['userName'],
        userEmail = json['userEmail'],
        userCity = json['userCity'],
        userState = json['userState'],
        userPassword = json['userPassword'];

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'userName': userName,
        'userEmail': userEmail,
        'userCity': userCity,
        'userState': userState,
        'userPassword': userPassword,
      };
}