class CategoryLeafModel {

  int? id;
  int? parentCategoryId;
  String? typeName;
  String? categoryParentName;
  int? totalNumber;

  int? productsNumber;

  List<ProductDataChildModel>? productsChildren;

  CategoryLeafModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentCategoryId = json['parentCategoryId'];
    typeName = json['type'];
    categoryParentName = json['translatedText'];
    totalNumber = json['count'];
    productsNumber = json['productsNumber'];

    if (json['translatedProducts'] != null) {
      productsChildren = [];
      json['translatedProducts'].forEach((element) {
        productsChildren!.add(ProductDataChildModel.fromJson(element));
      });
    }

  }
}



class ProductDataChildModel {

  int? productId;
  String? image;
  int? discount;
  int? discountId;
  String? productName;
  dynamic barCode;
  String? discountType;


  List<ProductUnitChildModel>? productUnitListModel;

  ProductDataChildModel.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    image = json['image'] ?? '';
    discount = json['discount'];
    discountId = json['discountId'] ?? 0;
    discountType = json['type'];
    productName = json['translatedText'];
    barCode = json['barCode'] ?? '';


    if (json['translatedProductUnits'] != null) {
      productUnitListModel = [];
      json['translatedProductUnits'].forEach((element) {
        productUnitListModel!.add(ProductUnitChildModel.fromJson(element));
      });
    }


  }
}

class ProductUnitChildModel {

  int? unitId;
  int? quantity;
  String? unitName;
  String? description;
  dynamic price;

  ProductUnitChildModel.fromJson(Map<String, dynamic> json) {
    unitId = json['unitId'];
    quantity = json['quantity'];
    price = json['price'];
    description = json['translatedText'];
    unitName = json['translatedUnitText'];
  }

}

