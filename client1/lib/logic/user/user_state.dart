part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class AddNewPhoneNumber extends UserState{}

class ChangePasswordVisibility extends UserState{}

class ClearDataState extends UserState{}

class CreateUserLoadingState extends UserState{}

class CreateUserSuccessState extends UserState {}
class CreateUserErrorState extends UserState
{
  final CreateUserModelError createUserModelError;

  CreateUserErrorState(this.createUserModelError);
}


///////////////////////////////////////////////////////////////////////////////
// User List

class UsersSortingColumn extends UserState {}


class GetAllUsersLoadingState extends UserState{}

class GetAllUsersSuccessState extends UserState {}
class GetAllUsersErrorState extends UserState
{
  final ErrorModel errorModel;

  GetAllUsersErrorState(this.errorModel);
}

/////////////////////////////////////////////
// Delete User

class DeleteUserLoadingDataState extends UserState {}

class DeleteUserSuccessDataState extends UserState {}

class DeleteUserErrorDataState extends UserState {
  final ErrorModel errorModel;

  DeleteUserErrorDataState(this.errorModel);

}
