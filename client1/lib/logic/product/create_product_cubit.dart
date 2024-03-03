import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/create/createPro_model.dart';
import 'package:zaza_dashboard/models/create/photo_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/get_help/catNames_model.dart';
import 'package:zaza_dashboard/models/get_help/taxesNames_model.dart';
import 'package:zaza_dashboard/models/get_help/unitsNames_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

part 'create_product_state.dart';

class CreateProductCubit extends Cubit<CreateProductState> {
  CreateProductCubit() : super(CreateProductInitial());

  static CreateProductCubit get(context) => BlocProvider.of(context);

  var barCodeController = TextEditingController();

  var productNameGermanController = TextEditingController();

  var productNameEnglishController = TextEditingController();

  var productNameArabicController = TextEditingController();

  ///////////////////////////////////

  var productUnitPriceController = TextEditingController();

  var productUnitQuantityController = TextEditingController();

  var productUnitDescriptionGermanController = TextEditingController();

  var productUnitDescriptionEnglishController = TextEditingController();

  var productUnitDescriptionArabicController = TextEditingController();

  ////////////////////////

  List<TextEditingController> otherProductUnitPricesController = [];

  List<TextEditingController> otherProductUnitQuantityController = [];

  List<TextEditingController> otherProductUnitDescriptionGermanController = [];

  List<TextEditingController> otherProductUnitDescriptionEnglishController = [];

  List<TextEditingController> otherProductUnitDescriptionArabicController = [];

  void clearControllers() {
    barCodeController.clear();

    productNameGermanController.clear();

    productNameEnglishController.clear();

    productNameArabicController.clear();
//////////////////
    productUnitPriceController.clear();

    productUnitQuantityController.clear();

    productUnitDescriptionGermanController.clear();

    productUnitDescriptionEnglishController.clear();

    productUnitDescriptionArabicController.clear();

///////////////////
    otherProductUnitPricesController.clear();

    otherProductUnitQuantityController.clear();

    otherProductUnitDescriptionGermanController.clear();

    otherProductUnitDescriptionEnglishController.clear();

    otherProductUnitDescriptionArabicController.clear();

    /////////////////////////////////

    units.clear();
    unitsIds.clear();

    webImage = null;

    emit(ClearDataState());
  }

  //List<ProductUnit>? productUnit;

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

  bool isLoading = false;

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

      String filename = 'image_${DateTime.now().millisecondsSinceEpoch}';
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
        emit(CreatePhotoProSuccessState());
        isLoading = false;
      }).catchError((error) {
        photoModelCat = PhotoModelCat.fromJson(error.response.data);
        emit(CreatePhotoProErrorState(photoModelCat!));
        print(error.toString());
      });
    } else {
      String filename = 'image_${DateTime.now().millisecondsSinceEpoch}';
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
        emit(CreatePhotoProSuccessState());
      }).catchError((error) {
        photoModelCat = PhotoModelCat.fromJson(error.response.data);
        emit(CreatePhotoProErrorState(photoModelCat!));
        print(error.toString());
      });
    }
  }

////////////////////////////////////////////////////////////////////////////////

  ErrorModel? errorModel;

  // Get Categories Names for products

  List<CategoriesNamesModel>? categoriesNamesListModel;

  Future<void> getCategoriesNames() async {
    emit(GetCatForProductsLoadingState());

    categoriesNamesListModel = [];

    DioHelper.getData(
      url: 'category/acceptProducts',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      categoriesNamesListModel = (value.data as List)
          .map((json) => CategoriesNamesModel.fromJson(json))
          .toList();

      emit(GetCatForProductsSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetCatForProductsErrorState(errorModel!));
    });
  }

  // Get Taxes Names for products

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

  // Get Units Names for products

  UnitsNamesModel? unitsNamesModel;

  Future<void> getUnitsNames() async {
    emit(GetUnitForProductsLoadingState());

    unitsNamesModel = null;

    DioHelper.getData(
      url: 'unit',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      unitsNamesModel = UnitsNamesModel.fromJson(value.data);

      emit(GetUnitForProductsSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetUnitForProductsErrorState(errorModel!));
    });
  }

//////////////////////////////////////////////////////////////
// Create Product

  void addOtherUnitsController() {
    otherProductUnitPricesController.add(TextEditingController());
    otherProductUnitQuantityController.add(TextEditingController());
    otherProductUnitDescriptionGermanController.add(TextEditingController());
    otherProductUnitDescriptionEnglishController.add(TextEditingController());
    otherProductUnitDescriptionArabicController.add(TextEditingController());
    unitsIds.add(0);

    emit(AddOtherUnitsState());

    for (int i = 0; i < otherProductUnitPricesController.length; i++) {
      //prints the name of each family member

      print('unitId=${unitsIds[i]}');
    }

    print(otherProductUnitPricesController);
    print(otherProductUnitQuantityController);
    print(otherProductUnitDescriptionGermanController);
    print(otherProductUnitDescriptionEnglishController);
    print(otherProductUnitDescriptionArabicController);
  }

  void deleteOtherUnitsController() {
    otherProductUnitPricesController.removeLast();
    otherProductUnitQuantityController.removeLast();
    otherProductUnitDescriptionGermanController.removeLast();
    otherProductUnitDescriptionEnglishController.removeLast();
    otherProductUnitDescriptionArabicController.removeLast();
    unitsIds.removeLast();
    emit(RemoveOtherUnitsState());

    for (int i = 0; i < otherProductUnitPricesController.length; i++) {
      //prints the name of each family member
      print('unitId=${unitsIds[i]}');
    }
  }

  List<Unit> units = [];

  void addOneUnit(
    dynamic unitId,
    dynamic price,
    dynamic quantity,
    dynamic descGerman,
    dynamic descEnglish,
    dynamic descArabic,
  ) {
    units.add(
        Unit(unitId, price, quantity, descGerman, descEnglish, descArabic));
  }

  void deleteOneUnit() {
    units.removeLast();
  }

  void addAllUnits() {
    addOneUnit(
        unitId,
        productUnitPriceController.text,
        productUnitQuantityController.text,
        productUnitDescriptionGermanController.text,
        productUnitDescriptionEnglishController.text,
        productNameArabicController.text);

    for (int i=0;i<unitsIds.length;i++) {

      addOneUnit(
          unitsIds[i],
          otherProductUnitPricesController[i].text,
          otherProductUnitQuantityController[i].text,
          otherProductUnitDescriptionGermanController[i].text,
          otherProductUnitDescriptionEnglishController[i].text,
          otherProductUnitDescriptionArabicController[i].text);
    }

  }

  ////////////////////////////////
  int? taxId;

  void changeTaxIdDropDown(value) {
    taxId = value;
    emit(ChangeTaxIdDropDown());
  }

  int? categoryId;

  void changeCategoryIdDropDown(value) {
    categoryId = value;
    emit(ChangeCategoryIdDropDown());
  }

  int? unitId;

  void changeUnitIdDropDown(value) {
    unitId = value;
    emit(ChangeUnitIdDropDown());
  }

  List<int> unitsIds = [];

  void changeUnitIdDropDownWithIndex(value, index) {
    unitsIds[index] = value;
    emit(ChangeUnitIdDropDown());
  }

  //////////////////////////////////////////////////////////////////////////
  CreateProModel? createProModel;

  Future<void> createPro({
    required String barCode,
    required String proNameDu,
    required String proNameEn,
    required String proNameAr,
  }) async {
    emit(CreateProductLoadingState());
    isLoading = true;
    DioHelper.postData(
            url: 'product',
            data: {
              "product": {
                "barCode": barCode,
                "taxId": taxId,
                "parentCategoryId": categoryId
              },
              "textContent": {"originalText": proNameDu, "code": "de"},
              "translation": [
                {"code": "en", "translation": proNameEn},
                {"code": "ar", "translation": proNameAr}
              ],
              "productUnit": units,
            },
            query: {
              'language': languageCode,
            },
            token: token)
        .then((value) {
      int statusCode = value.statusCode!;
      print(statusCode);
      createProModel = CreateProModel.fromJson(value.data);

      print(createProModel!.product!.id);

      emit(CreateProductSuccessState(createProModel!));
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(CreateProductErrorState(errorModel!));
    });
  }
}

class Unit {
  final dynamic unitId;
  final dynamic price;
  final dynamic quantity;
  final dynamic descGerman;
  final dynamic descEnglish;
  final dynamic descArabic;

  Unit(this.unitId, this.price, this.quantity, this.descGerman,
      this.descEnglish, this.descArabic);

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['unitId'] = this.unitId;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['textContent'] = {"originalText": this.descGerman, "code": "de"};
    data['translation'] = [
      {"code": "en", "translation": this.descEnglish},
      {"code": "ar", "translation": this.descArabic}
    ];
    return data;
  }
}
