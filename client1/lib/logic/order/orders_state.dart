part of 'orders_cubit.dart';

@immutable
abstract class OrdersState {}

class OrdersInitial extends OrdersState {}

class GetAllOrdersLoadingState extends OrdersState {}

class GetAllOrdersSuccessState extends OrdersState {}

class GetAllOrdersErrorState extends OrdersState {
  final ErrorModel errorModel;

  GetAllOrdersErrorState(this.errorModel);
}

class ChangeDropdownValue extends OrdersState {}




class GetAllOrderDetailsLoadingState extends OrdersState {}

class GetAllOrderDetailsSuccessState extends OrdersState {}

class GetAllOrderDetailsErrorState extends OrdersState {
  final ErrorModel errorModel;

  GetAllOrderDetailsErrorState(this.errorModel);
}


class UpdateStatusLoadingState extends OrdersState {}

class UpdateStatusSuccessState extends OrdersState {}

class UpdateStatusErrorState extends OrdersState {
  final ErrorModel errorModel;

  UpdateStatusErrorState(this.errorModel);
}