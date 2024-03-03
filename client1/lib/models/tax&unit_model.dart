class TaxesModel {

  List<TaxData>? taxesList;

  TaxesModel.fromJson(Map<String, dynamic> json) {
    if (json['taxes'] != null) {
      taxesList = [];
      json['taxes'].forEach((element) {
        taxesList!.add(TaxData.fromJson(element));
      });
    }
  }

}


class TaxData {

  int? id;
  dynamic taxPercent;
  String? taxName;

  TaxData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    taxPercent = json['percent'];
    taxName = json['translatedText'];
  }

}



class UnitsModel {

  List<UnitData>? unitsList;

  UnitsModel.fromJson(Map<String, dynamic> json) {
    if (json['units'] != null) {
      unitsList = [];
      json['units'].forEach((element) {
        unitsList!.add(UnitData.fromJson(element));
      });
    }
  }

}


class UnitData {

  int? id;
  String? unitName;

  UnitData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unitName = json['translatedText'];
  }

}