import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/create/createCat_model.dart';
import 'package:zaza_dashboard/models/create/createPro_model.dart';
import 'package:zaza_dashboard/models/edit/editCat_model.dart';
import 'package:zaza_dashboard/models/edit/editTaxPro_model.dart';
import 'package:zaza_dashboard/models/edit/edit_simple_pro_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/get_help/catNames_model.dart';
import 'package:zaza_dashboard/models/get_help/taxesNames_model.dart';
import 'package:zaza_dashboard/models/get_help/unitsNames_model.dart';
import 'package:zaza_dashboard/models/home_model.dart';
import 'package:zaza_dashboard/models/create/photo_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

import 'home_states.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(init_Home());

  static HomeCubit get(context) => BlocProvider.of(context);

  Uint8List? webImage;

  Future pickImage(ImageSource source, context, width) async {
    try {
      final XImage = await ImagePicker().pickImage(source: source);
      if (XImage == null) return;

      //For Web
      webImage = await XImage.readAsBytes();
    } on PlatformException {
      print('Failed to pick image');
    }
    emit(PickImage());
  }

  PhotoModelCat? photoModelCat;

  Future<void> createImage({
    required int id,
  }) async {
    emit(CreatePhotoLoadingState());

    if (webImage == null) {
      print('No image selected');

      String assetImage = 'assets/default-placeholder.png';
      ByteData byteData = await rootBundle.load(assetImage);
      Uint8List bytes = byteData.buffer.asUint8List();

      webImage = bytes;

      String filename = 'image_${DateTime
          .now()
          .millisecondsSinceEpoch}';
      print(filename);
      DioHelper.postDataImage(
        url: 'category/image',
        data: FormData.fromMap({
          'categoryId': id,
          'image': await MultipartFile.fromBytes(
            webImage!,
            filename: filename,
            contentType: MediaType('image', 'png'),
          ),
        }),
        token: token,
      ).then((value) {
        emit(CreatePhotoSuccessState());
      }).catchError((error) {
        photoModelCat = PhotoModelCat.fromJson(error.response.data);
        emit(CreatePhotoErrorState(photoModelCat!));
        print(error.toString());
      });
    } else {
      String filename = 'image_${DateTime
          .now()
          .millisecondsSinceEpoch}';
      print(filename);
      DioHelper.postDataImage(
        url: 'category/image',
        data: FormData.fromMap({
          'categoryId': id,
          'image': await MultipartFile.fromBytes(
            webImage!,
            filename: filename,
            contentType: MediaType('image', 'png'),
          ),
        }),
        token: token,
      ).then((value) {
        emit(CreatePhotoSuccessState());
      }).catchError((error) {
        photoModelCat = PhotoModelCat.fromJson(error.response.data);
        emit(CreatePhotoErrorState(photoModelCat!));
        print(error.toString());
      });
    }
  }

  var catNameDuController = TextEditingController();

  var catNameEnController = TextEditingController();

  var catNameArController = TextEditingController();

  void clearControllers() {

    catNameDuController.clear();

    catNameEnController.clear();

    catNameArController.clear();

    webImage = null;

    emit(ClearDataState());
  }

  //Create a category

  CreateCatModel? createCatModel;

  Future<void> createCat({
    int? parentCategoryId,
    required String catNameDu,
    required String catNameEn,
    required String catNameAr,
  }) async {
    emit(CreateCatLoadingState());

    DioHelper.postData(
        url: 'category',
        data: {
          'parentCategoryId': parentCategoryId,
          "textContent": {"originalText": catNameDu, "code": "de"},
          "translation": [
            {"code": "en", "translation": catNameEn},
            {"code": "ar", "translation": catNameAr}
          ]
        },
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);
      createCatModel = CreateCatModel.fromJson(value.data);

      print(createCatModel!.id);

      emit(CreateCatSuccessState(createCatModel!));
    }).catchError((error) {
      print(error.toString());
      emit(CreateCatErrorState());
    });
  }

/////////////////////////////
  //Get main Categories

  HomeModel? mainCatsModel;

  int? paginationNumberSave;

  int currentIndex = 0;

  void getCategories({
    required int limit,
    required int page,
  }) {
    emit(GetMainCategoriesLoadingState());

    mainCatsModel = null;
    currentIndex = page;

    DioHelper.getData(
      url: 'category',
      query: {
        'limit': limit,
        'page': page + 1,
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      mainCatsModel = HomeModel.fromJson(value.data);

      if (mainCatsModel!.totalNumber! == 0) {
        paginationNumberSave = 1;
      } else {
        paginationNumberSave = (mainCatsModel!.totalNumber! / limit).ceil();
      }

      emit(GetMainCategoriesSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetMainCategoriesErrorState());
    });
  }

////////////////////////////////////////////////////////////
//Delete Category

  Future<void> deleteCategory({
    required int id,
  }) async {
    emit(DeleteOneCategoryLoadingState());

    DioHelper.deleteData(
      url: 'category/${id}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      emit(DeleteOneCategorySuccessState());
    }).catchError((error) {
      print(error.response.data);
      print(error.toString());
      emit(DeleteOneCategoryErrorState());
    });
  }

//////////////////////////////////////////////////////////////////////////////
// EDIT

  EditCatModel? editDataCatModel;

  Future<void> getEditCategoryData({required int id}) async {
    emit(EditDataCategoryLoadingState());

    DioHelper.getData(
      url: 'category/${id}/findWithRelation',
      token: token,
    ).then((value) {
      editDataCatModel = EditCatModel.fromJson(value.data);

      catNameDuController.text = editDataCatModel!.textContent!.originalText!;

      catNameEnController.text =
      editDataCatModel!.textContent!.translations![0].translationName!;

      catNameArController.text =
      editDataCatModel!.textContent!.translations![1].translationName!;

      emit(EditDataCategorySuccessState());
    }).catchError((error) {
      print(error.response.data);
      print(error.toString());
      emit(EditDataCategoryErrorState());
    });
  }


  PhotoModelCat? editPhotoModelCat;

  Future<void> editImage({
    required int id,
  }) async {
    emit(EditedPhotoCategoryLoadingState());

    String filename = 'image_${DateTime
        .now()
        .millisecondsSinceEpoch}';
    print(filename);
    DioHelper.postDataImage(
      url: 'category/image',
      data: FormData.fromMap({
        'categoryId': id,
        'image': await MultipartFile.fromBytes(
          webImage!,
          filename: filename,
          contentType: MediaType('image', 'png'),
        ),
      }),
      token: token,
    ).then((value) {
      emit(EditedPhotoCategorySuccessState());
    }).catchError((error) {
      photoModelCat = PhotoModelCat.fromJson(error.response.data);
      emit(EditedPhotoCategoryErrorState(photoModelCat!));
      print(error.toString());
    });
  }


  EditedCatModel? editedCatModel;

  Future<void> editCat({
    required String catNameDu,
    required String catNameEn,
    required String catNameAr,
    required int categoryId,
  }) async {
    emit(EditedCategoryLoadingState());

    DioHelper.patchData(
        url: 'category/${categoryId}',
        data: {
          "textContent": {"originalText": catNameDu, "code": "de"},
          "translation": [
            {"code": "en", "translation": catNameEn},
            {"code": "ar", "translation": catNameAr}
          ]
        },
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);
      editedCatModel = EditedCatModel.fromJson(value.data);

      print(editedCatModel!.category!.id);

      emit(EditedCategorySuccessState(editedCatModel!));
    }).catchError((error) {
      print(error.toString());
      print(error.response.data);
      emit(EditedCategoryErrorState());
    });
  }

//////////////////////////////////////////////////////////////////////////////

// Create Discount


  TextEditingController discountController = TextEditingController();

  void clearDiscount() {

    discountController.clear();
  }



  Future<void> createDis({
    required int productId,
    required int percent,
  }) async {
    emit(CreateDiscountForProductLoadingState());

    DioHelper.postData(
        url: 'discount',
        data: {
          "createDiscountDtoList": [
            {
              "productId": productId,
              "percent": percent
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

      emit(CreateDiscountForProductSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateDiscountForProductErrorState());
    });
  }

  // Delete Discount

  Future<void> deleteDiscount({
    required int id,
    required int percent,
  }) async {
    emit(DeleteDiscountForProductLoadingState());

    print(id);
    print(percent);

    DioHelper.deleteData(
      url: 'discount/${id}',
      query: {
        'language': languageCode,
      },
      data: {
        "percent": percent
      },
      token: token,
    ).then((value) {

      emit(DeleteDiscountForProductSuccessState());
    }).catchError((error) {
      print(error.response.data);
      print(error.toString());
      emit(DeleteDiscountForProductErrorState());
    });
  }

  //////////////////////////////////////////////////////////////////////////////

  ErrorModel? errorModel;

  // Get All Taxes to Edit

  TaxesNamesModel? taxesNamesModel;

  Future<void> getTaxesNames() async {
    emit(GetTaxForProductsLoadingState());

    taxesNamesModel = null;

    DioHelper.getData(
      url: 'tax',
      query: {
        'code': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      taxesNamesModel = TaxesNamesModel.fromJson(value.data);

      emit(GetTaxForProductsSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetTaxForProductsErrorState(errorModel!));
    });
  }


  // Get Tax Product

  GetTaxProductModel? getTaxProductModel;

  Future<void> getTaxProductName({required int productId}) async {
    emit(GetTaxForOneProductLoadingState());

    getTaxProductModel = null;

    DioHelper.getData(
      url: 'product/findOneWithTaxRelationsForUpdating/${productId}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      getTaxProductModel = GetTaxProductModel.fromJson(value.data);

      emit(GetTaxForOneProductSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetTaxForOneProductErrorState(errorModel!));
    });
  }



  // Edit Tax for product

  int editedTaxId = 0;

  void changeEditedTaxId (value) {

    editedTaxId = value;
    print(editedTaxId);
    emit(ChangeEditedTaxId());

  }


  Future<void> editProductTax({
    required int productId,
  }) async {
    emit(UpdateTaxForOneProductLoadingState());


    DioHelper.patchData(
        url: 'product/updateTax/${productId}',
        data: {
          "taxId": editedTaxId
        },
        query: {
          'language': languageCode,
        },
        token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);

      emit(UpdateTaxForOneProductSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      print(error.response.data);
      emit(UpdateTaxForOneProductErrorState(errorModel!));
    });
  }

  //////////////////////////////////////////////////////////////////////////////

  var barcodeController = TextEditingController();

  var proNameDuController = TextEditingController();

  var proNameEnController = TextEditingController();

  var proNameArController = TextEditingController();

  void clearProductControllers() {

    barcodeController.clear();

    proNameDuController.clear();

    proNameEnController.clear();

    proNameArController.clear();

    webImage = null;

    emit(ClearDataState());
  }

  // Edit Product Names & Image & barcode

  // Get Simple Product Info

  GetSimpleDataForProductModel? getSimpleDataForProductModel;

  Future<void> getSimpleDataProductName({required int productId}) async {
    emit(GetSimpleDataProductLoadingState());

    getSimpleDataForProductModel = null;

    DioHelper.getData(
      url: 'product/findOneWithSimpleRelationsForUpdating/${productId}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      getSimpleDataForProductModel = GetSimpleDataForProductModel.fromJson(value.data);


      barcodeController.text = getSimpleDataForProductModel!.barCode!;

      proNameDuController.text = getSimpleDataForProductModel!.getProductNamesModel!.productNameGerman!;

      proNameEnController.text =
          getSimpleDataForProductModel!.getProductNamesModel!.getProductTranslationModel![0].translationProductName!;

      proNameArController.text =
      getSimpleDataForProductModel!.getProductNamesModel!.getProductTranslationModel![1].translationProductName!;


      emit(GetSimpleDataProductSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetSimpleDataProductErrorState(errorModel!));
    });
  }

// Edit Simple Product

  EditedProModel? editedProModel;

  Future<void> editProductSimpleData({
    required int productId,
    required int parentCategoryId,

    required String barCode,
    required String productNameDu,
    required String productNameEn,
    required String productNameAr,

  }) async {
    emit(UpdateSimpleDataProductLoadingState());

    DioHelper.patchData(
        url: 'product/simpleUpdate/${productId}',
        data: {
          "product": {
            "barCode": barCode,
            "parentCategoryId": parentCategoryId,
          },
          "textContent": {
            "originalText": productNameDu,
            "code": "de"
          },
          "translation": [
            {
              "code": "en",
              "translation": productNameEn,
            },
            {
              "code": "ar",
              "translation": productNameAr
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

      editedProModel = EditedProModel.fromJson(value.data);

      print(editedProModel!.product!.id);

      emit(UpdateSimpleDataProductSuccessState(editedProModel!));
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      print(error.response.data);
      emit(UpdateSimpleDataProductErrorState(errorModel!));
    });
  }

  // Edit Image for product

  PhotoModelCat? editPhotoModelPro;

  Future<void> editImageProduct({
    required int id,
  }) async {
    emit(EditProductPhotoLoadingState());

    String filename = 'image_${DateTime
        .now()
        .millisecondsSinceEpoch}';
    print(filename);
    DioHelper.postDataImage(
      url: 'product/image',
      data: FormData.fromMap({
        'id': id,
        'image': await MultipartFile.fromBytes(
          webImage!,
          filename: filename,
          contentType: MediaType('image', 'png'),
        ),
      }),
      token: token,
    ).then((value) {
      emit(EditProductPhotoSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(EditProductPhotoErrorState(errorModel!));
      print(error.toString());
    });
  }


}

////////////////////////////////////////////////////////////////////////////////


