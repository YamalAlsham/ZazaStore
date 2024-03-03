
// Get All Products Unit

class ProductUnitForEditModel {

  int? productUnitId;
  int? productId;
  int? unitId;
  int? quantity;
  int? price;
  ProductUnitDescModel? productUnitDescModel;

  ProductUnitForEditModel.fromJson(Map<String, dynamic> json) {
    productUnitId = json['id'];
    productId = json['productId'];
    unitId = json['unitId'];
    quantity = json['quantity'];
    price = json['price'];
    productUnitDescModel = json['textContent'] != null ? ProductUnitDescModel.fromJson(json['textContent']) : null;
  }

}

class ProductUnitDescModel {

  String? productUnitDescDu;
  List<ProductUnitDescTranslationModel>? productUnitDescTranslationModel;

  ProductUnitDescModel.fromJson(Map<String, dynamic> json) {
    productUnitDescDu = json['originalText'];

    if (json['translations'] != null) {
      productUnitDescTranslationModel = [];
      json['translations'].forEach((element) {
        productUnitDescTranslationModel!.add(ProductUnitDescTranslationModel.fromJson(element));
      });
    }

  }

}

class ProductUnitDescTranslationModel {

  String? translation;

  ProductUnitDescTranslationModel.fromJson(Map<String, dynamic> json) {
    translation = json['translation'];
  }
}