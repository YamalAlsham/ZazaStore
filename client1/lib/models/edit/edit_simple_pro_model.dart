// Get Product Names & Image & Barcode For Product

class GetSimpleDataForProductModel {

  String? image;
  String? barCode;
  int? parentCategoryId;
  GetProductNamesModel? getProductNamesModel;

  GetSimpleDataForProductModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    barCode = json['barCode'];
    parentCategoryId = json['parentCategoryId'];
    getProductNamesModel = json['textContent'] != null ? GetProductNamesModel.fromJson(json['textContent']) : null;
  }

}


class GetProductNamesModel {

  String? productNameGerman;
  List<GetProductTranslationModel>? getProductTranslationModel;

  GetProductNamesModel.fromJson(Map<String, dynamic> json) {
    productNameGerman = json['originalText'];

    if (json['translations'] != null) {
      getProductTranslationModel = [];
      json['translations'].forEach((element) {
        getProductTranslationModel!.add(GetProductTranslationModel.fromJson(element));
      });
    }

  }

}

class GetProductTranslationModel {

  String? translationProductName;

  GetProductTranslationModel.fromJson(Map<String, dynamic> json) {
    translationProductName = json['translation'];
  }

}

////////////////////////////////////////////////////////////////////////////////

// Response Product Id after updating names for updating image

class EditedProModel {

  EditedProInfoModel? product;

  EditedProModel.fromJson(Map<String, dynamic> json) {
    product = json['product'] != null ? EditedProInfoModel.fromJson(json['product']) : null;
  }

}

class EditedProInfoModel {

  int? id;

  EditedProInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

}