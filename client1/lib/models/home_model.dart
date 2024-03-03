
import 'package:flutter/foundation.dart';

class HomeModel {

  int? totalNumber;
  List<MainCategory>? mainCategories;

  HomeModel.fromJson(Map<String, dynamic> json) {
    totalNumber = json['count'];

    if (json['categories'] != null) {
      mainCategories = [];
      json['categories'].forEach((element) {
        mainCategories!.add(MainCategory.fromJson(element));
      });
    }
  }

}

class MainCategory {

  int? id;
  String? type;
  int? itemsNumber;
  String? categoryName;
  String? imageCategory;

  MainCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    itemsNumber = json['productsNumber'];
    categoryName = json['translatedText'];
    imageCategory = json['image'];
  }

}