
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/auth/auth_cubit.dart';
import 'package:zaza_dashboard/network/local/cash_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/login_widgets.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var userNameController = TextEditingController();

  var passwordController = TextEditingController();

  var userNameFocusNode = FocusNode();

  var passwordFocusNode = FocusNode();

  var formKeyLogin = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = 753.599975586;
    //final height = heightSize / 1.2500000000000000331740987392709;
    final width = MediaQuery.of(context).size.width;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        var cubit = AuthCubit.get(context);
        if (state is LoginSuccessState) {
          CacheHelper.saveData(
            key: 'refresh-token',
            value: state.loginModel.refreshToken,
          ).then(
                (value) {
              refreshTokenSave = state.loginModel.refreshToken;
            },
          );

          CacheHelper.saveData(
            key: 'token',
            value: state.loginModel.accessToken,
          ).then(
                (value) {
              token = state.loginModel.accessToken;
              GoRouter.of(context).pushReplacement('/');
            },
          );
          showToast(
            text: 'Logging Successfully',
            state: ToastState.success,
          );
        }
        if (state is LoginErrorState) {
          showToast(
            text: 'Invalid Email or Password',
            state: ToastState.error,
          );
        }

        if (state is LogoutSuccessState) {
          print('logout');
          signOut(context);
          showToast(text: 'Logout Successfully', state: ToastState.success);
        }
        if (state is LogoutErrorState) {

          showToast(text: state.errorModel.message!, state: ToastState.error);
        }

      },
      child: Scaffold(
        backgroundColor: primaryColor,
        appBar: null,
        body: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Wave(width,height),
                    Logo(width, height),
                  ],
                ),
                SizedBox(height: height*0.04,),
                WhiteContainer(
                    context,
                    width,
                    height,
                    userNameController,
                    passwordController,
                    userNameFocusNode,
                    passwordFocusNode,
                    formKeyLogin)
              ],
            ),
          ),

      ),
    );
  }
}
