class EditCatModel {
  int? id;
  String? image;
  TextContentModel? textContent;

  EditCatModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];
    textContent = json['textContent'] != null ? TextContentModel.fromJson(json['textContent']) : null;
  }
}

class TextContentModel {

  String? originalText;
  List<TranslationModel>? translations;

  TextContentModel.fromJson(Map<String, dynamic> json) {
    originalText = json['originalText'];
    if (json['translations'] != null) {
      translations = [];
      json['translations'].forEach((element) {
        translations!.add(TranslationModel.fromJson(element));
      });
    }
  }
}

class TranslationModel {

  String? translationName;

  TranslationModel.fromJson(Map<String, dynamic> json) {
    translationName = json['translation'];
  }

}



class EditedCatModel {

  EditedCatInfoModel? category;

  EditedCatModel.fromJson(Map<String, dynamic> json) {
    category = json['category'] != null ? EditedCatInfoModel.fromJson(json['category']) : null;
  }

}

class EditedCatInfoModel {

  int? id;

  EditedCatInfoModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
  }

}