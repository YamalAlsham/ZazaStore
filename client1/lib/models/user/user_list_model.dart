class UsersModel {

  int? totalNumber;
  List<UserDataModel>? usersList;

  UsersModel.fromJson(Map<String, dynamic> json) {

    totalNumber = json['count'];

    if (json['users'] != null) {
      usersList = [];
      json['users'].forEach((element) {
        usersList!.add(UserDataModel.fromJson(element));
      });
    }

  }

}

class UserDataModel {

  int? userId;
  String? username;
  String? resName;
  String? email;
  String? created_at;

  UserDataModel.fromJson(Map<String, dynamic> json) {
    userId = json['id'];
    username = json['userName'];
    resName = json['name'];
    email = json['email'];
    created_at = json['createdAt'];
  }

}