
class CreateProModel {

  CreateProIdModel? product;

  CreateProModel.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? CreateProIdModel.fromJson(json['product']) : null;
  }

}


class CreateProIdModel {

  int? id;

  CreateProIdModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

}