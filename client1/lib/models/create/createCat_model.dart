class CreateCatModel {
  int? id;

  CreateCatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }
}