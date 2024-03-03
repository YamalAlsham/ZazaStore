import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/edit/editUnitPro_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/get_help/unitsNames_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

part 'edit_product_state.dart';

class EditProductCubit extends Cubit<EditProductState> {
  EditProductCubit() : super(EditProductInitial());

  static EditProductCubit get(context) => BlocProvider.of(context);

  int? unitId = 0;

  void changeDropDownUnits(value) {
    unitId = value;
    emit(ChangeUnitNameValue());
  }

  var productUnitPriceController = TextEditingController();

  var productUnitQuantityController = TextEditingController();

  var productUnitDescriptionGermanController = TextEditingController();

  var productUnitDescriptionEnglishController = TextEditingController();

  var productUnitDescriptionArabicController = TextEditingController();


  void clearControllers() {

    productUnitPriceController.clear();

    productUnitQuantityController.clear();

    productUnitDescriptionGermanController.clear();

    productUnitDescriptionEnglishController.clear();

    productUnitDescriptionArabicController.clear();

    unitId = null;

    emit(ClearData());
  }





  ErrorModel? errorModel;

  // Get Product Units

  List<ProductUnitForEditModel>? productUnitForEditListModel;

  Future getProductUnits({required int productId}) async {

    emit(GetAllProductUnitsInfoLoadingState());

    productUnitForEditListModel = [];

    DioHelper.getData(
      url: 'product-unit/findByProductId/${productId}',
      token: token,
    ).then((value) {

      productUnitForEditListModel = (value.data as List)
          .map((json) => ProductUnitForEditModel.fromJson(json))
          .toList();

      emit(GetAllProductUnitsInfoSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetAllProductUnitsInfoErrorState(errorModel!));
    });

  }

  // Update Quantity

  Future<void> editQuantityForUnit({
    required int quantity,
    required int productId,
    required int productUnitId,
  }) async {
    emit(UpdateQuantityProductUnitLoadingState());

    DioHelper.patchData(
        url: 'product/updateQuantity/${productId}',
        data: [
          {
            "id": productUnitId,
            "quantity": quantity
          }
        ],
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);
      print('value.data=${value.data}');
      emit(UpdateQuantityProductUnitSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      print(error.response.data);
      emit(UpdateQuantityProductUnitErrorState(errorModel!));
    });
  }



  // Update Complex Data

  Future<void> editComplexProductForUnit({
    required int unitId,
    required int productUnitId,
    required int price,
    required String unitDescDu,
    required String unitDescEn,
    required String unitDescAr,

  }) async {
    emit(UpdateComplexProductUnitLoadingState());

    DioHelper.patchData(
        url: 'product-unit/${productUnitId}',
        data: {
          "productUnit": [
            {
              "unitId": unitId,
              "price": price,
              "textContent": {
                "originalText": unitDescDu,
                "code": "de"
              },
              "translation": [
                {
                  "code": "en",
                  "translation": unitDescEn
                },
                {
                  "code": "ar",
                  "translation": unitDescAr
                }
              ]
            }
          ]
        },
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);
      emit(UpdateComplexProductUnitSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      print(error.response.data);
      emit(UpdateComplexProductUnitErrorState(errorModel!));
    });
  }


  ////////////////////////////////////////////////////////////////

  // Delete Product Unit

  Future<void> deleteProductUnit({
    required int productUnitId,
  }) async {
    emit(DeleteProductUnitLoadingState());

    DioHelper.deleteData(
      url: 'product-unit/${productUnitId}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      emit(DeleteProductUnitSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.response.data);
      print(error.toString());
      emit(DeleteProductUnitErrorState(errorModel!));
    });
  }

  // Create New Unit

  Future<void> createNewUnitForProduct({
    required int productId,
    required int unitId,
    required int price,
    required int quantity,
    required String unitDescDu,
    required String unitDescEn,
    required String unitDescAr,
  }) async {
    emit(CreateProductUnitLoadingState());

    DioHelper.postData(
        url: 'product-unit/${productId}',
        data: {
          "productUnit": [
            {
              "unitId": unitId,
              "price": price,
              "quantity": quantity,
              "textContent": {
                "originalText": unitDescDu,
                "code": "de"
              },
              "translation": [
                {
                  "code": "en",
                  "translation": unitDescEn
                },
                {
                  "code": "ar",
                  "translation": unitDescAr
                }
              ]
            }
          ]
        },
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
          print(value.data);
      int statusCode = value.statusCode!;
      print(statusCode);

      emit(CreateProductUnitSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(CreateProductUnitErrorState(errorModel!));
    });
  }


  // Get Units Names for products

  UnitsNamesModel? unitsNamesForProductModel;

  Future<void> getUnitsNames() async {
    emit(GetUnitsForProductLoadingState());

    unitsNamesForProductModel = null;

    DioHelper.getData(
      url: 'unit',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      unitsNamesForProductModel = UnitsNamesModel.fromJson(value.data);

      emit(GetUnitsForProductSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetUnitsForProductErrorState(errorModel!));
    });
  }

}
