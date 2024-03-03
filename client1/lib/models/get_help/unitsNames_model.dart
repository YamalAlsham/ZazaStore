class UnitsNamesModel {

  List<UnitsDataModel>? unitsListModel;

  UnitsNamesModel.fromJson(Map<String, dynamic> json) {
    if (json['units'] != null) {
      unitsListModel = [];
      json['units'].forEach((element) {
        unitsListModel!.add(UnitsDataModel.fromJson(element));
      });
    }
  }

}

class UnitsDataModel {

  int? unitId;
  String? unitName;

  UnitsDataModel.fromJson(Map<String, dynamic> json) {
    unitId = json['id'];
    unitName = json['translatedText'];
  }


}