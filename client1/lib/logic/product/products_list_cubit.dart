import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/product_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

part 'products_list_state.dart';

class ProductsListCubit extends Cubit<ProductsListState> {
  ProductsListCubit() : super(ProductsListInitial());

  static ProductsListCubit get(context)=>BlocProvider.of(context);

  /////////////////////////////
  //Get All Products

  ErrorModel? errorModel;

  ProductsModel? productsModel;

  int? paginationNumberSave;

  int currentIndex = 0;

  void getProducts({
    required int limit,
    required int page,
    required String sort,
    required String search,
  }) {
    emit(GetAllProductsLoadingState());

    productsModel = null;
    currentIndex = page;

    DioHelper.getData(
      url: 'product',
      query: {
        'limit': limit,
        'page': page + 1,
        'sort':sort,
        'search':search,
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      productsModel = ProductsModel.fromJson(value.data);

      if (productsModel!.totalNumber! == 0) {
        paginationNumberSave = 1;
      } else {
        paginationNumberSave = (productsModel!.totalNumber! / limit).ceil();
      }

      emit(GetAllProductsSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllProductsErrorState());
    });
  }

////////////////////////////////////////////////////////////
//Delete Product

  Future<void> deleteProduct({
    required int id,
  }) async {


    emit(DeleteOneProductLoadingState());

    DioHelper.deleteData(
      url: 'product/${id}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      emit(DeleteOneProductSuccessState());
    }).catchError((error) {
      print(error.response.data);
      print(error.toString());
      emit(DeleteOneProductErrorState());
    });
  }


}
