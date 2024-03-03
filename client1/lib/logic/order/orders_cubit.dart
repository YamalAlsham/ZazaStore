import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/order/order_details_model.dart';
import 'package:zaza_dashboard/models/order/orders_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';


part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  OrdersCubit() : super(OrdersInitial());

  static OrdersCubit get(context) => BlocProvider.of(context);

  // Get Orders

  ErrorModel? errorModel;

  GeneralOrdersModel? generalAllOrdersModel;

  int? paginationNumberSave;

  int currentIndex = 0;

  Future<void> getOrders({required int limit, required int page,required String sort,required String status }) async {

    emit(GetAllOrdersLoadingState());

    generalAllOrdersModel = null;
    currentIndex = page;

    DioHelper.getData(
      url: 'order/',
      query: {
        'limit':limit,
        'page':page + 1,
        'sort': sort,
        if (status != 'all')
          'status':status,
      },
      token: token,
    ).then((value) {
      print(value.data);
      generalAllOrdersModel = GeneralOrdersModel.fromJson(value.data);

      if (generalAllOrdersModel!.ordersList!.length! == 0) {
        paginationNumberSave = 1;
      } else {
        paginationNumberSave = (generalAllOrdersModel!.totalOrders! / limit).ceil();
      }

      print(paginationNumberSave);

      emit(GetAllOrdersSuccessState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(GetAllOrdersErrorState(errorModel!));
    });
  }

  String status = 'all';

  void changeDropdownValue(String val) {
    status = val;
    print(status);
    getOrders(limit: limitOrders, page: 0, sort: 'newest', status: status);
    emit(ChangeDropdownValue());
  }


  // Get Order Details

  OrderDetailsModel? orderDetailsModel;

  Future<void> getOrderDetails({required int order_id}) async {

    emit(GetAllOrderDetailsLoadingState());

    orderDetailsModel = null;

    DioHelper.getData(
      url: 'order/${order_id}',
      query: {
        'language':languageCode,
      },
      token: token,
    ).then((value) {
      print(value.data);
      orderDetailsModel = OrderDetailsModel.fromJson(value.data);
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
      orderDetailsModel!.status = status;
    }).catchError((error) {
      print(error.response.data);
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.toString());
      emit(UpdateStatusErrorState(errorModel!));
    });
  }


}
