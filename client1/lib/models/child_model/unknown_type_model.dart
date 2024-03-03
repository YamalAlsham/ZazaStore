class UnknownChildModel {

  int? id;
  int? itemsNumber;
  int? parentCategoryId;
  String? typeName;
  String? categoryParentName;

  UnknownChildModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsNumber = json['productsNumber'];
    parentCategoryId = json['parentCategoryId'];
    typeName = json['typeName'];
    categoryParentName = json['translatedText'];
  }

}