class CategoryNodeModel {

  int? id;
  int? parentCategoryId;
  String? typeName;
  String? categoryParentName;
  int? totalNumber;
  List<CategoryChildrenModel>?categoriesChildren;

  CategoryNodeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentCategoryId = json['parentCategoryId'];
    typeName = json['typeName'];
    categoryParentName = json['translatedText'];
    totalNumber = json['count'];

    if (json['categories'] != null) {
      categoriesChildren = [];
      json['categories'].forEach((element) {
        categoriesChildren!.add(CategoryChildrenModel.fromJson(element));
      });
    }

  }
}


class CategoryChildrenModel {

  int? id;
  int? itemsNumber;
  int? parentCategoryId;
  String? typeName;
  String? categoryName;
  String? image;

  CategoryChildrenModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    itemsNumber = json['productsNumber'];
    parentCategoryId = json['parentCategoryId'];
    typeName = json['typeName'];
    categoryName = json['translatedText'];
    image = json['image'];
  }
}