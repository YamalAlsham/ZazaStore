import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/tax&unit_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

part 'tax&unit_state.dart';

class TaxUnitCubit extends Cubit<TaxUnitState> {
  TaxUnitCubit() : super(TaxUnitInitial()) {
    getTaxes();
    getUnits();
  }

  static TaxUnitCubit get(context)=>BlocProvider.of(context);


  ////////////////////////////////////////////////////////////////////////////
  // Tax

  var percentController = TextEditingController();

  var taxNameDuController = TextEditingController();

  var taxNameEnController = TextEditingController();

  var taxNameArController = TextEditingController();


  void taxClearControllers () {

    percentController.clear();

    taxNameDuController.clear();

    taxNameEnController.clear();

    taxNameArController.clear();

    emit(ClearDataTaxState());

  }

  ErrorModel? taxErrorModel;

  TaxesModel? taxesModel;

  Future getTaxes()async{
    emit(GetTaxLoadingState());

    taxesModel = null;

    await DioHelper.getData(
      url: 'tax',
      query: {
        'code' : 'de'
      },
      token: token
    ).then((value){

      taxesModel = TaxesModel.fromJson(value.data);

      emit(GetTaxSuccessState());
    }).catchError((error){
      print('Error : ${error.response.data}');
      taxErrorModel = ErrorModel.fromJson(error.response.data);
      emit(GetTaxErrorState(taxErrorModel!));
    });
  }



  Future addTaxes({
    required double percent,
    required String taxNameDu,
     String? taxNameEn,
     String? taxNameAr,
  })async{
    emit(AddTaxLoadingState());
    await DioHelper.postData(
        url: 'tax',
        data: {
          "tax": {
            "percent": percent
          },
          "textContent":{
            "originalText": taxNameDu,
            "code": "de"
          },
          "translation": [
            {
              "code": "en",
              "translation": taxNameEn
            },
            {
              "code": "ar",
              "translation": taxNameAr
            }
          ]
        },
        token: token
    ).then((value){
      emit(AddTaxSuccessState());
    }).catchError((error){
      print(error.response.data);
      taxErrorModel = ErrorModel.fromJson(error.response.data);
      emit(AddTaxErrorState(taxErrorModel!));
    });
  }



  Future deleteTaxes({
    required int id
  })async{
    emit(DeleteTaxLoadingState());
    await DioHelper.deleteData(
        url: 'tax/${id}',
        token: token
    ).then((value){
      emit(DeleteTaxSuccessState());
    }).catchError((error){
      print(error.response.data);
      taxErrorModel = ErrorModel.fromJson(error.response.data);
      emit(DeleteTaxErrorState(taxErrorModel!));
    });
  }

  /////////////////////////////////////////////////////////////////////////////

//Unit


  var unitNameDuController = TextEditingController();

  var unitNameEnController = TextEditingController();

  var unitNameArController = TextEditingController();


  void unitClearControllers () {

    unitNameDuController.clear();

    unitNameEnController.clear();

    unitNameArController.clear();

    emit(ClearDataUnitState());

  }

  ErrorModel? unitErrorModel;

  UnitsModel? unitsModel;

  Future getUnits()async{
    emit(GetUnitLoadingState());

    unitsModel = null;

    await DioHelper.getData(
        url: 'unit',
        query: {
          'language' : languageCode
        },
        token: token
    ).then((value){

      unitsModel = UnitsModel.fromJson(value.data);

      emit(GetUnitSuccessState());
    }).catchError((error){
      print('Error : ${error.response.data}');
      unitErrorModel = ErrorModel.fromJson(error.response.data);
      emit(GetUnitErrorState(unitErrorModel!));
    });
  }



  Future addUnits({
    required String unitNameDu,
    String? unitNameEn,
    String? unitNameAr,
  })async{
    emit(AddUnitLoadingState());
    await DioHelper.postData(
        url: 'unit',
        data: {
          "textContent":{
            "originalText": unitNameDu,
            "code": "de"
          },
          "translation": [
            {
              "code": "en",
              "translation": unitNameEn
            },
            {
              "code": "ar",
              "translation": unitNameAr
            }
          ]
        },
        token: token
    ).then((value){
      emit(AddUnitSuccessState());
    }).catchError((error){
      print(error.response.data);
      unitErrorModel = ErrorModel.fromJson(error.response.data);
      emit(AddUnitErrorState(unitErrorModel!));
    });
  }



  Future deleteUnits({
    required int id
  })async{
    emit(DeleteUnitLoadingState());
    await DioHelper.deleteData(
        url: 'unit/${id}',
        token: token
    ).then((value){
      emit(DeleteUnitSuccessState());
    }).catchError((error){
      print(error.response.data);
      unitErrorModel = ErrorModel.fromJson(error.response.data);
      emit(DeleteUnitErrorState(unitErrorModel!));
    });
  }


















}
