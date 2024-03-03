part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class ChangePasswordVisibility extends AuthState {}

class AnimateTheButton extends AuthState {}

class OnHoverButton extends AuthState {}

class LoginLoadingState extends AuthState{}
class LoginSuccessState extends AuthState
{
  final LoginModel loginModel;

  LoginSuccessState(this.loginModel);
}
class LoginErrorState extends AuthState {}


class LogoutLoadingState extends AuthState {}

class LogoutSuccessState extends AuthState {}

class LogoutErrorState extends AuthState {
  final ErrorModel errorModel;

  LogoutErrorState(this.errorModel);
}