class OrderDetailsModel {

  int? order_id;
  dynamic totalPrice;
  String? createdAt;
  String? status;

  List<ProductOrderModel>? productsOrderDetailsList;

  OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    order_id = json['id'];
    totalPrice = json['totalPrice'];
    createdAt = json['createdAt'];
    status = json['status'];

    if (json['products'] != null) {
      productsOrderDetailsList = [];
      json['products'].forEach((element) {
        productsOrderDetailsList!.add(ProductOrderModel.fromJson(element));
      });
    }

  }

}

class ProductOrderModel {

  String? image;
  String? barCode;
  String? productName;

  List<ProductUnitOrderModel>? productUnitsOrderDetailsList;

  ProductOrderModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    barCode = json['barCode'];
    productName = json['translatedProduct'];

    if (json['productUnit'] != null) {
      productUnitsOrderDetailsList = [];
      json['productUnit'].forEach((element) {
        productUnitsOrderDetailsList!.add(ProductUnitOrderModel.fromJson(element));
      });
    }

  }

}

class ProductUnitOrderModel {

  String? desc;
  UnitOrderModel? unitOrderModel;
  UnitDetailsOrderModel? unitDetailsOrderModel;

  ProductUnitOrderModel.fromJson(Map<String, dynamic> json) {
    desc = json['translatedProductUnit'];
    unitOrderModel = json['unit'] != null ? UnitOrderModel.fromJson(json['unit']) : null;
    unitDetailsOrderModel = json['productOrders'] != null ? UnitDetailsOrderModel.fromJson(json['productOrders']) : null;
  }

}

class UnitOrderModel {

  String? unitName;

  UnitOrderModel.fromJson(Map<String, dynamic> json) {
    unitName = json['translatedUnit'];
  }

}

class UnitDetailsOrderModel {

  int? amount;
  dynamic totalPrice;

  UnitDetailsOrderModel.fromJson(Map<String, dynamic> json) {
    amount = json['amount'];
    totalPrice = json['totalPrice'];
  }
}