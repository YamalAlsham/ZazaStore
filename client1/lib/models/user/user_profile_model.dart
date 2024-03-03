class UserProfileModel {

  int? user_id;
  String? userName;
  String? name;
  String? email;

  List<UserPhonesModel>? phonesList;

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    user_id = json['id'];
    userName = json['userName'];
    name = json['name'];
    email = json['email'];

    if (json['phones'] != null) {
      phonesList = [];
      json['phones'].forEach((element) {
        phonesList!.add(UserPhonesModel.fromJson(element));
      });
    }

  }

}

class UserPhonesModel {

  int? phone_id;
  String? number;
  String? number_code;

  UserPhonesModel({this.phone_id, this.number, this.number_code});

  UserPhonesModel.fromJson(Map<String, dynamic> json) {
    phone_id = json['id'];
    number = json['number'];
    number_code = json['code'];
  }

}