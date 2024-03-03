class ChoosingType {

  int? catId;
  String? typeName;
  int? totalNumber;

  ChoosingType.fromJson(Map<String, dynamic> json) {
    catId = json['id'];
    typeName = json['typeName'];
    totalNumber = json['count'];
  }
}