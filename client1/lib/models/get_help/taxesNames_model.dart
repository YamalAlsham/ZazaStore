class TaxesNamesModel {

  List<TaxesDataModel>? taxesListModel;

  TaxesNamesModel.fromJson(Map<String, dynamic> json) {
    if (json['taxes'] != null) {
      taxesListModel = [];
      json['taxes'].forEach((element) {
        taxesListModel!.add(TaxesDataModel.fromJson(element));
      });
    }
  }

}

class TaxesDataModel {

  int? taxId;
  dynamic percent;
  String? taxName;

  TaxesDataModel.fromJson(Map<String, dynamic> json) {
    taxId = json['id'];
    percent = json['percent'];
    taxName = json['translatedText'];
  }


}