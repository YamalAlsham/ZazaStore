import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/disconut-specific-user/disconut-specific-user_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/order/order_details_model.dart';
import 'package:zaza_dashboard/models/order/orders_model.dart';
import 'package:zaza_dashboard/models/product_model.dart';
import 'package:zaza_dashboard/models/user/user_profile_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';


part 'user_profile_state.dart';

class UserProfileCubit extends Cubit<UserProfileState> {
  UserProfileCubit() : super(UserProfileInitial());

  static UserProfileCubit get(context) => BlocProvider.of(context);

  ErrorModel? errorModel;

  UserProfileModel? userProfileModel;

  Future<void> getUserProfile({required int user_id}) async {

    generalOrdersModel = null;
    userProfileModel = null;
    discountSpecificUserModel = null;

    emit(UserProfileLoadingState());

    DioHelper.getData(
      url: 'user/${user_id}',
      query: {
        'language': languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      userProfileModel = UserProfileModel.fromJson(value.data);

      emit(UserProfileSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(UserProfileErrorState(errorModel!));
    });
  }

  // Get Discounts Specific User

  DiscountSpecificUserModel? discountSpecificUserModel;

  Future<void> getDiscountProductsForUser({required user_id}) async {

    emit(GetUserDiscountsLoadingState());

    DioHelper.getData(
      url: 'discount-specific-user/user/${user_id}',
      token: token,
    ).then((value) {
      print(value.data);
      discountSpecificUserModel = DiscountSpecificUserModel.fromJson(value.data);
      emit(GetUserDiscountsSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetUserDiscountsErrorState(errorModel!));
    });
  }


  //////////////////////////////////////////////////////////////////////////////

  var editDiscountForUserController = TextEditingController();
  var addDiscountForUserController = TextEditingController();

  void clear () {
    editDiscountForUserController.clear();
    addDiscountForUserController.clear();
    emit(ClearData());
  }

  //////////////////////////////////////////////////////////////////////////////
  // Edit Discount

  Future<void> editDiscountProductForUser({required int discountPrUsId, required int percent,required int index}) async {

    emit(EditUserDiscountsLoadingState());
    print(discountPrUsId);
    print(percent);

    DioHelper.patchData(
      url: 'discount-specific-user/$discountPrUsId',
      data: {
        "percent": percent
      },
      token: token,
    ).then((value) {
      print(value.data);
      emit(EditUserDiscountsSuccessState());
      discountSpecificUserModel!.discountUserProductDataList![index].percent = percent;
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(EditUserDiscountsErrorState(errorModel!));
    });
  }

  // Delete Discount

  Future<void> deleteDiscountProductForUser({required discountPrUsId,required int index}) async {

    emit(DeleteUserDiscountsLoadingState());

    DioHelper.deleteData(
      url: 'discount-specific-user/${discountPrUsId}',
      token: token,
    ).then((value) {
      print(value.data);
      discountSpecificUserModel!.discountUserProductDataList!.removeAt(index);
      emit(DeleteUserDiscountsSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(DeleteUserDiscountsErrorState(errorModel!));
    });
  }

  // Get Products

  /////////////////////////////
  //Get All Products

  ProductsModel? productsForDiscountModel;

  int? paginationNumberSave;

  int currentIndex = 0;

  void getProducts({
    required int limit,
    required int page,
    required String sort,
    required String search,
  }) {
    emit(GetAllProductsForDiscountLoadingState());

    productsForDiscountModel = null;
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
      productsForDiscountModel = ProductsModel.fromJson(value.data);

      if (productsForDiscountModel!.totalNumber! == 0) {
        paginationNumberSave = 1;
      } else {
        paginationNumberSave = (productsForDiscountModel!.totalNumber! / limit).ceil();
      }

      emit(GetAllProductsForDiscountSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllProductsForDiscountErrorState(errorModel!));
    });
  }


  // Add Discount

  Future<void> addDiscountProductForUser({required int userId, required int percent, required int productId,}) async {

    emit(AddUserDiscountsLoadingState());

    print(userId);
    print(percent);
    print(productId);

    DioHelper.postData(
      url: 'discount-specific-user/${userId}',
      data: {
        "createDiscountDtoList": [
          {
            "percent": percent,
            "productId": productId
          }
        ]
      },
      token: token,
    ).then((value) {
      print(value.data);
      emit(AddUserDiscountsSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(AddUserDiscountsErrorState(errorModel!));
    });
  }


  //////////////////////////////

  // Get Orders

  GeneralOrdersModel? generalOrdersModel;

  Future<void> getOrders({required int limit, required int page,required String sort,required user_id}) async {

    emit(GetOrdersLoadingState());

    print(user_id);
    print(limit);
    print(page);
    print(sort);


    DioHelper.getData(
      url: 'order/user/${user_id}',
      query: {
        'limit':limit,
        'page':page + 1,
        'sort': sort,
      },
      token: token,
    ).then((value) {
      print(value.data);
      generalOrdersModel = GeneralOrdersModel.fromJson(value.data);
      emit(GetOrdersSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetOrdersErrorState(errorModel!));
    });
  }


  //////////////////////////////////////////////////////////////////

  // Get Order Details

  OrderDetailsModel? orderDetailsForUserModel;

  Future<void> getOrderDetailsForUser({required int order_id}) async {

    emit(GetAllOrderDetailsLoadingState());

    orderDetailsForUserModel = null;

    DioHelper.getData(
      url: 'order/${order_id}',
      query: {
        'language':languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      orderDetailsForUserModel = OrderDetailsModel.fromJson(value.data);
      emit(GetAllOrderDetailsSuccessState());
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetAllOrderDetailsErrorState(errorModel!));
    });
  }

  // Update Status

  Future<void> updateStatus({required int order_id, required String status}) async {

    emit(UpdateStatusLoadingState());

    DioHelper.patchData(
      url: 'order/${order_id}',
      data: {
        "status": status
      },
      query: {
        'language':languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      emit(UpdateStatusSuccessState());
      orderDetailsForUserModel!.status = status;
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(UpdateStatusErrorState(errorModel!));
    });
  }




}
