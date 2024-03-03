import 'package:zaza_dashboard/models/login_model.dart';

class GeneralOrdersModel {

  int? totalOrders;
  List<GeneralOrderData>? ordersList;

  GeneralOrdersModel.fromJson(Map<String, dynamic> json) {

    totalOrders = json['count'];

    if (json['orders'] != null) {
      ordersList = [];
      json['orders'].forEach((element) {
        ordersList!.add(GeneralOrderData.fromJson(element));
      });
    }

  }

}

class GeneralOrderData {

  int? order_id;
  dynamic totalPrice;
  String? createdAt;
  String? status;
  User? user;

  GeneralOrderData.fromJson(Map<String, dynamic> json) {
    order_id = json['id'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    status = json['status'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

}

