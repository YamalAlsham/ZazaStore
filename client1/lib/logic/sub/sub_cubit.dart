import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/child_model/category_child_model.dart';
import 'package:zaza_dashboard/models/child_model/choosing_type_model.dart';
import 'package:zaza_dashboard/models/child_model/product_child_model.dart';
import 'package:zaza_dashboard/models/child_model/unknown_type_model.dart';
import 'package:zaza_dashboard/models/create/createCat_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/create/photo_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:http_parser/http_parser.dart';

part 'sub_state.dart';

class SubCubit extends Cubit<SubState> {
  SubCubit() : super(SubInitial());

  static SubCubit get(context)=>BlocProvider.of(context);



/////////////////////////////

  //Helpers

  int catPerCubitId = 0;

  String typecub = '';

  //Get Children

  ChoosingType? choosingType;

  UnknownChildModel? unknownChildModel;

  CategoryNodeModel? categoryNodeModel;

  CategoryLeafModel? categoryLeafModel;

  int? paginationNumberSave;

  int currentIndex = 0;

  ErrorModel? errorModel;

  Future<void> getCategoryChildren({
    required int limit,
    required int page,
    required int id,
  }) async {
    emit(GetChildrenLoadingState());

    typecub = '';
    currentIndex = page;

    DioHelper.getData(
      url: 'category/${id}',
      query: {
        'limit': limit,
        'page': page+1,
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);

      choosingType = ChoosingType.fromJson(value.data);

      catPerCubitId = choosingType!.catId!;

      typecub = choosingType!.typeName!;

      if (typecub=='unknown'){
        print('haha');
        paginationNumberSave = 1;
      }
      else {
        paginationNumberSave = (choosingType!.totalNumber! / limit).ceil();
      }

      emit(ChooseTypeState());


      if (choosingType!.typeName == 'unknown') {

        unknownChildModel = UnknownChildModel.fromJson(value.data);

        print('${unknownChildModel!.id}');

      }
      else if (choosingType!.typeName == 'node') {

          categoryNodeModel = CategoryNodeModel.fromJson(value.data);

          print('${categoryNodeModel!.id}');

      }
      else if (choosingType!.typeName == 'leaf') {

        categoryLeafModel = CategoryLeafModel.fromJson(value.data);

        print('${categoryLeafModel!.id}');

      }

      emit(GetChildrenSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetChildrenErrorState(errorModel!));
    });
  }



  ////////////////////////////////////////////////////////////
//Delete Product

  Future<void> deleteProduct({
    required int id,
  }) async {


    emit(DeleteOneProductFromSubLoadingState());

    DioHelper.deleteData(
      url: 'product/${id}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      emit(DeleteOneProductFromSubSuccessState());
    }).catchError((error) {
      print(error.response.data);
      print(error.toString());
      emit(DeleteOneProductFromSubErrorState());
    });
  }


}
