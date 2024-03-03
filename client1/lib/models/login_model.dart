class LoginModel {

  String? accessToken;
  String? refreshToken;
  User? user;

  LoginModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

}

class User {

  int? id;
  String? userName;
  String? name;
  String? email;

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userName = json['userName'];
    name = json['name'];
    email = json['email'];
  }

}