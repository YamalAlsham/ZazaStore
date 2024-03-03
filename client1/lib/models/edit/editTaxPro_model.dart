
// Get Tax Name For Product

class GetTaxProductModel {

  TaxNameObjectForProductModel? taxNameForProductModel;

  GetTaxProductModel.fromJson(Map<String, dynamic> json) {
    taxNameForProductModel = json['tax'] != null ? TaxNameObjectForProductModel.fromJson(json['tax']) : null;
  }

}

class TaxNameObjectForProductModel {

  TaxNameForProductModel? taxNameForProductModel;

  TaxNameObjectForProductModel.fromJson(Map<String, dynamic> json) {
    taxNameForProductModel = json['textContent'] != null ? TaxNameForProductModel.fromJson(json['textContent']) : null;
  }

}

class TaxNameForProductModel {

  String? taxName;

  TaxNameForProductModel.fromJson(Map<String, dynamic> json) {
    taxName = json['originalText'];
  }

}


////////////////////////////////////////////////////////////////////////////////

