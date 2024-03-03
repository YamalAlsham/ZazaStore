
class PhotoModelCat {
  String? message;

  PhotoModelCat.fromJson(Map<String, dynamic> json) {
    message = json['message'];
  }
}

class PhotoModelProduct {}