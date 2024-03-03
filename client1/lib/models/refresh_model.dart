class RefreshModel {

  String? accessToken;
  String? refreshToken;

  RefreshModel.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    refreshToken = json['refreshToken'];
  }

}