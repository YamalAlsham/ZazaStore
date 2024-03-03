import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/models/error_model.dart';
import 'package:zaza_dashboard/models/login_model.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/network/remote/end_points.dart';


part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffix = Icons.visibility_off;

  void changePasswordVisibility()
  {
    isPassword = !isPassword;
    suffix = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibility());
  }



  bool isAnimated = false;

  bool isHovered =false;

  var transform;
  
  void onEntered(bool isHov){
    isHovered=isHov;
    final ht = Matrix4.identity()..scale(1.1);
    transform = isHovered? ht : Matrix4.identity();
    emit(OnHoverButton());
  }


  LoginModel? loginModel;

  void login({
    required String userName,
    required String password,
  }) {
    isAnimated = true;
    emit(LoginLoadingState());
    DioHelper.postData(
      url: 'auth/login/',
      data: {
        'userName': userName,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      isAnimated = false;
      emit(LoginSuccessState(loginModel!));
    }).catchError((error) {
      print(error.response.data);
      //loginModel = LoginModel.fromJson(error.response.data);
      isAnimated= false;
      emit(LoginErrorState());
      print(error.toString());
    });
  }

  ErrorModel? errorModel;

  Future<void> logout(context) async {

    emit(LogoutLoadingState());
    DioHelper.getData(
        url: 'auth/logout',
        token: token
    ).then((value) {
      print('value.data: ${value.data}');
      emit(LogoutSuccessState());
      token = null;
      refreshTokenSave = null;
      signOut(context);
    }).catchError((error) {
      errorModel = ErrorModel.fromJson(error.response.data);
      emit(LogoutErrorState(errorModel!));
      print(error.toString());
    });

  }

}
