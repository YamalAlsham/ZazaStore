import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/create/createUser_model.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/user/user_list_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  static UserCubit get(context) => BlocProvider.of(context);

  ErrorModel? errorModel;


  // Create New User

  List<PhoneNumbers> phoneNumbers = [];

  String? num1;
  String? isoCode1;
  String? num2;
  String? isoCode2;
  String? num3;
  String? isoCode3;

  void addingPhoneNumber1 (number, isCode) {

    num1 = number;
    isoCode1 = isCode;

    emit(AddNewPhoneNumber());
  }

  void addingPhoneNumber2 (number, isCode) {

    num2 = number;
    isoCode2 = isCode;

    emit(AddNewPhoneNumber());
  }

  void addingPhoneNumber3 (number, isCode) {

    num3 = number;
    isoCode3 = isCode;

    emit(AddNewPhoneNumber());
  }

  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibility());
  }
  var resNameController = TextEditingController();

  var userNameController = TextEditingController();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();

  var passwordConfirmController = TextEditingController();

  void clearControllers () {

    resNameController.clear();

    userNameController.clear();

    emailController.clear();

    passwordController.clear();

    passwordConfirmController.clear();

    emit(ClearDataState());

  }

  //////////////////////////////////////////////////////////////////////////////

  // Create New User

  CreateUserModelError? createUserModelError;

  Future<void> registerUser({
    required String resName,
    required String username,
    required String email,
    required String password,

  }) async {

    emit(CreateUserLoadingState());

    DioHelper.postData(
        url: 'auth/signup',
        data: {
          "userName": username,
          "name": resName,
          "password": password,
          "email": email,
        },
        query: {
          'language' : 'en'
        },
        token: token
    ).then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.response.data);
      createUserModelError = CreateUserModelError.fromJson(error.response.data);
      emit(CreateUserErrorState(createUserModelError!));
      print(error.toString());
    });
  }


//////////////////////////////////////////////////////////////////////////////
// Users List Table
  final UsersColumns = [
    "Id",
    "Username",
    "Restaurant Name",
    "Email",
    "Created_at",
    "Details",
  ];

  int? sortColumnIndex;
  bool isAscending = false;

  UsersModel? usersModel;

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      usersModel!.usersList!.sort((user1, user2) => compareString(
          ascending,
          user1.userId!.toString(),
          user2.userId!.toString()));
    } else if (columnIndex == 1) {
      usersModel!.usersList!.sort(
              (user1, user2) => compareString(ascending, user1.username!, user2.username!));
    } else if (columnIndex == 2) {
      usersModel!.usersList!.sort((user1, user2) =>
          compareString(ascending, user1.resName!, user2.resName!));
    }

    this.sortColumnIndex = columnIndex;
    this.isAscending = ascending;
    emit(UsersSortingColumn());
  }

  int compareString(bool ascending, String value1, String value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);


// Get Users

  int? paginationNumberSave;

  int currentIndex = 0;

  void getUsersTableData({
    required int limit,
    required int paginationNumber,
    required String sort,
  }) async {

    usersModel = null;
    currentIndex = paginationNumber;

    emit(GetAllUsersLoadingState());
    DioHelper.getData(
        url: 'user',
        query: {
          'limit': limit,
          'page': paginationNumber+1,
          'sort': sort,
        },
        token: token
    ).then((value) async {

      print('value.data: ${value.data}');
      usersModel = UsersModel.fromJson(value.data);

      if (usersModel!.totalNumber! == 0) {
        paginationNumberSave = 1;
      } else {
        paginationNumberSave = (usersModel!.totalNumber! / limit).ceil();
      }
      emit(GetAllUsersSuccessState());

    }).catchError((error) {
      print('error.response.data: ${error.response.data}');
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(GetAllUsersErrorState(errorModel!));
      print(error.toString());
    });
  }

//////////////////////////
  // Delete a User

  Future<void> deleteUser({
    required int userId,
  }) async {
    emit(DeleteUserLoadingDataState());

    DioHelper.deleteData(
      url: 'user/${userId}',
      token: token,
    ).then((value) {
      emit(DeleteUserSuccessDataState());
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      print(error.response.data);
      print(error.toString());
      emit(DeleteUserErrorDataState(errorModel!));
    });
  }


}


class PhoneNumbers {
  final String number;
  final String isoCode;


  PhoneNumbers(this.number, this.isoCode);

  Map<String, dynamic>? toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['code'] = this.isoCode;
    return data;
  }
}