import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/user_widgets.dart';

class AddUsers extends StatelessWidget {
  AddUsers({Key? key}) : super(key: key);

  var resNameFocusNode = FocusNode();

  var userNameFocusNode = FocusNode();

  var emailFocusNode = FocusNode();

  var passwordFocusNode = FocusNode();

  var passwordConfirmFocusNode = FocusNode();

  var phoneNumberFocusNode = FocusNode();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        var cubit = UserCubit.get(context);
        if (state is CreateUserSuccessState) {
          showToast(text: 'User Created Successfully', state: ToastState.success);
          cubit.clearControllers();
          cubit.getUsersTableData(limit: limitUsers, paginationNumber: cubit.currentIndex, sort: 'oldest');

        }

        if (state is CreateUserErrorState) {

          if (cubit.createUserModelError!.message is String) {
            showToast(text: state.createUserModelError.message, state: ToastState.error);
          }
          else {
            showToast(text: state.createUserModelError.message[0], state: ToastState.error);
          }

        }
      },
      builder: (context, state) {
        var cubit = UserCubit.get(context);
        return Scaffold(
          appBar: appBarWeb(width, height, context),
          drawer: drawerWeb(width, height, context),
          body: ConditionalBuilder(
            condition: state is! CreateUserLoadingState,
            builder: (context) => GestureDetector(
              onTap: () {
                FocusManager.instance.primaryFocus?.unfocus();
              },
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.1, vertical: height * 0.04),
                  color: backgroundColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () {
                              GoRouter.of(context).pop();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,
                              size: 40.sp,
                              color: Colors.red,
                            ),
                          ),
                          SizedBox(width: width*0.01,),
                          AddUsersTitle(height: height, width: width),
                          SizedBox(
                            width: width * 0.36,
                          ),
                          Lottie.asset(
                            'assets/animations/adduser.json',
                            height: height * 0.14,
                            width: width * 0.08,
                            fit: BoxFit.fill,
                            animate: true,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.03,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        width: width * 0.6,
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.03,
                            vertical: height * 0.025),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Restaurant Name',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    width: width * 0.5,
                                    child: def_TextFromField(
                                      keyboardType: TextInputType.text,
                                      controller: cubit.resNameController,
                                      focusNode: resNameFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(userNameFocusNode);
                                      },
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      label: 'Enter Restaurant Name',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Restaurant Name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Username',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    width: width * 0.5,
                                    child: def_TextFromField(
                                      keyboardType: TextInputType.text,
                                      controller: cubit.userNameController,
                                      focusNode: userNameFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(emailFocusNode);
                                      },
                                      prefixIcon: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                      ),
                                      label: 'Enter Username',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter Username';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    width: width * 0.5,
                                    child: def_TextFromField(
                                      keyboardType: TextInputType.text,
                                      controller: cubit.emailController,
                                      focusNode: emailFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(passwordFocusNode);
                                      },
                                      prefixIcon: const Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      label: 'Enter Email',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter email';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Password',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    width: width * 0.5,
                                    child: def_TextFromField(
                                      keyboardType: TextInputType.text,
                                      controller: cubit.passwordController,
                                      focusNode: passwordFocusNode,
                                      br: 10,
                                      obscureText: cubit.isPassword,
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          cubit.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          cubit.suffix,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(
                                            passwordConfirmFocusNode);
                                      },
                                      label: 'Enter password',
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Confirm password',
                                    style: TextStyle(
                                        fontSize: 18.sp, color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.015,
                                  ),
                                  Container(
                                    height: height * 0.1,
                                    width: width * 0.5,
                                    child: def_TextFromField(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          cubit.changePasswordVisibility();
                                        },
                                        icon: Icon(
                                          cubit.suffix,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      prefixIcon: const Icon(
                                        Icons.lock,
                                        color: Colors.grey,
                                      ),
                                      obscureText: cubit.isPassword,
                                      keyboardType: TextInputType.text,
                                      controller:
                                          cubit.passwordConfirmController,
                                      focusNode: passwordConfirmFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
                                      label: 'Confirm password',
                                      validator: (value) {
                                        if (value !=
                                            cubit.passwordController.text) {
                                          return "Password doesn't match";
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Center(
                                child: Container(
                                  width: width < 600
                                      ? width * 0.14
                                      : width * 0.12,
                                  height: height * 0.05,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: basicColor,
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: basicColor,
                                      textStyle: const TextStyle(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        cubit.registerUser(
                                            resName:
                                                cubit.resNameController.text,
                                            username:
                                                cubit.userNameController.text,
                                            email: cubit.emailController.text,
                                            password: cubit
                                                .passwordController.text);
                                      }
                                    },
                                    child: Text(
                                      'Create New User',
                                      style: TextStyle(
                                          fontSize: 19.sp,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: height * 0.04,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            fallback: (context) => SpinKitWeb(width),
          ),
        );
      },
    );
  }
}
