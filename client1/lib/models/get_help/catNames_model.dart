class CategoriesNamesModel {

  int? categoryId;
  String? categoryName;

  CategoriesNamesModel.fromJson(Map<String, dynamic> json) {
    categoryId = json['id'];
    categoryName = json['translatedText'];
  }

}