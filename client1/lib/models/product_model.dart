class ProductsModel {

  int? totalNumber;
  List<ProductDataModel>? productsListChildren;

  ProductsModel.fromJson(Map<String, dynamic> json) {
    totalNumber = json['count'];

    if (json['translatedProducts'] != null) {
      productsListChildren = [];
      json['translatedProducts'].forEach((element) {
        productsListChildren!.add(ProductDataModel.fromJson(element));
      });
    }
  }
}


class ProductDataModel {

  int? productId;
  String? image;
  int? discount;
  int? discountId;
  String? productName;
  dynamic barCode;
  String? discountType;


  List<ProductUnitModel>? productUnitListModel;

  ProductDataModel.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    image = json['image'];
    discount = json['discount'];
    discountId = json['discountId'];
    productName = json['translatedText'];
    discountType = json['type'];
    barCode = json['barCode'] ?? '';


    if (json['translatedProductUnits'] != null) {
      productUnitListModel = [];
      json['translatedProductUnits'].forEach((element) {
        productUnitListModel!.add(ProductUnitModel.fromJson(element));
      });
    }


  }
}

class ProductUnitModel {

  int? unitId;
  int? quantity;
  String? unitName;
  String? description;
  dynamic price;

  ProductUnitModel.fromJson(Map<String, dynamic> json) {
    unitId = json['unitId'];
    quantity = json['quantity'];
    price = json['price'];
    description = json['translatedText'];
    unitName = json['translatedUnitText'];
  }

}