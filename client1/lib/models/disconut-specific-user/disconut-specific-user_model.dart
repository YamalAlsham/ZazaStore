import 'package:zaza_dashboard/models/edit/editCat_model.dart';

class DiscountSpecificUserModel {

  int? totalNumber;
  List<DiscountUserProductDataModel>? discountUserProductDataList;

  DiscountSpecificUserModel.fromJson(Map<String, dynamic> json) {

    totalNumber = json['count'];

    if (json['discountSpecificUser'] != null) {
      discountUserProductDataList = [];
      json['discountSpecificUser'].forEach((element) {
        discountUserProductDataList!.add(DiscountUserProductDataModel.fromJson(element));
      });
    }
  }

}

class DiscountUserProductDataModel {

  int? discountUsPrId;
  int? userId;
  int? percent;
  String? createdAt;

  ProductDiscountForUser? productDiscountForUser;

  DiscountUserProductDataModel.fromJson(Map<String, dynamic> json) {
    discountUsPrId = json['id'];
    userId = json['userId'];
    percent = json['percent'];
    createdAt = json['createdAt'];

    productDiscountForUser = json['product'] != null ? ProductDiscountForUser.fromJson(json['product']) : null;
  }

}

class ProductDiscountForUser {

  int? productId;
  String? image;

  TextContentModel? textContent;

  ProductDiscountForUser.fromJson(Map<String, dynamic> json) {
    productId = json['id'];
    image = json['image'];
    textContent = json['textContent'] != null ? TextContentModel.fromJson(json['textContent']) : null;
  }

}