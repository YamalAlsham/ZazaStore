part of 'user_profile_cubit.dart';

@immutable
abstract class UserProfileState {}

class UserProfileInitial extends UserProfileState {}

class UserProfileLoadingState extends UserProfileState {}

class UserProfileSuccessState extends UserProfileState {}

class UserProfileErrorState extends UserProfileState {
  final ErrorModel errorModel;

  UserProfileErrorState(this.errorModel);
}

class GetUserDiscountsLoadingState extends UserProfileState {}

class GetUserDiscountsSuccessState extends UserProfileState {}

class GetUserDiscountsErrorState extends UserProfileState {
  final ErrorModel errorModel;

  GetUserDiscountsErrorState(this.errorModel);
}

class GetAllProductsForDiscountLoadingState extends UserProfileState {}

class GetAllProductsForDiscountSuccessState extends UserProfileState {}

class GetAllProductsForDiscountErrorState extends UserProfileState {
  final ErrorModel errorModel;

  GetAllProductsForDiscountErrorState(this.errorModel);
}


class AddUserDiscountsLoadingState extends UserProfileState {}

class AddUserDiscountsSuccessState extends UserProfileState {}

class AddUserDiscountsErrorState extends UserProfileState {
  final ErrorModel errorModel;

  AddUserDiscountsErrorState(this.errorModel);
}

class EditUserDiscountsLoadingState extends UserProfileState {}

class EditUserDiscountsSuccessState extends UserProfileState {}

class EditUserDiscountsErrorState extends UserProfileState {
  final ErrorModel errorModel;

  EditUserDiscountsErrorState(this.errorModel);
}

class DeleteUserDiscountsLoadingState extends UserProfileState {}

class DeleteUserDiscountsSuccessState extends UserProfileState {}

class DeleteUserDiscountsErrorState extends UserProfileState {
  final ErrorModel errorModel;

  DeleteUserDiscountsErrorState(this.errorModel);
}


class GetOrdersLoadingState extends UserProfileState {}

class GetOrdersSuccessState extends UserProfileState {}

class GetOrdersErrorState extends UserProfileState {
  final ErrorModel errorModel;

  GetOrdersErrorState(this.errorModel);
}

class GetAllOrderDetailsLoadingState extends UserProfileState {}

class GetAllOrderDetailsSuccessState extends UserProfileState {}

class GetAllOrderDetailsErrorState extends UserProfileState {
  final ErrorModel errorModel;

  GetAllOrderDetailsErrorState(this.errorModel);
}


class UpdateStatusLoadingState extends UserProfileState {}

class UpdateStatusSuccessState extends UserProfileState {}

class UpdateStatusErrorState extends UserProfileState {
  final ErrorModel errorModel;

  UpdateStatusErrorState(this.errorModel);
}



class ClearData extends UserProfileState {}