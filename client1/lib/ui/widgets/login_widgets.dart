
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_dashboard/logic/auth/auth_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

//Wave
Widget Wave(width,height) {
  return ClipPath(
    clipper: OvalBottomBorderClipper(),
    child: Container(
      height: height * 0.43,
      width: double.infinity,
      color: basicColor,
    ),
  );
}



///////////////////////////////////////////////
//Logo
Widget Logo(width,height){
  return Positioned(
    bottom: height*0.001,
    child: Image.asset(
        'assets/Logo_White_512.png',
        width: width * 0.4,
        height: height*0.48,
      ),
  );
}

/////////////////////////////////////
//White Container

Widget WhiteContainer(context,width,height,userNameController,passwordController,userNameFocusNode,passwordFocusNode,formkey){

  return Container(
    height: height * 0.46,
    width: width<1000? width*0.8 : width * 0.4,
    padding: EdgeInsets.symmetric(
        horizontal: width * 0.055, vertical: height * 0.008),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 4),
          color: shadow.withOpacity(0.7),
          blurRadius: 5,
        )
      ],
    ),
    child: Form(
      key: formkey,
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          var cubit = AuthCubit.get(context);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login Here',
                style: TextStyle(color: seconderyColor,
                    fontSize: 45.sp,
                    fontWeight: FontWeight.bold
                ),

              ),
              SizedBox(
                height: height * 0.04,
              ),
              UserNameTextFormField(context, userNameController, userNameFocusNode, passwordFocusNode),
              SizedBox(
                height: height * 0.03,
              ),
              PasswordTextFormField(cubit, passwordController, passwordFocusNode),
              SizedBox(
                height: height * 0.04,
              ),
              Button(height, width, formkey, userNameController, passwordController, cubit),
            ],
          );
        },
      ),
    ),

  );

}

/////////////////////////////////////

Widget UserNameTextFormField(context,userNameController,userNameFocusNode,passwordFocusNode){
  return def_TextFromField(
      cursorColor: Colors.blueAccent,
      focusNode: userNameFocusNode,
      onFieldSubmitted: (val) {
        FocusScope.of(context)
            .requestFocus(passwordFocusNode);
      },
      keyboardType: TextInputType.emailAddress,
      controller: userNameController,
      autovalidateMode:
      AutovalidateMode.onUserInteraction,
      label: 'Enter Username',
      labelStyle: TextStyle(
        color: Colors.black87,
        fontSize: 20.sp,
      ),
      prefixIcon: Icon(
        Icons.person,
        color: basicColor,
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your Username';
        }
        return null;
      },
  );
}

Widget PasswordTextFormField(cubit,passwordController,passwordFocusNode){

  return def_TextFromField(
      cursorColor: Colors.blueAccent,
      focusNode: passwordFocusNode,
      keyboardType: TextInputType.emailAddress,
      controller: passwordController,
      obscureText: cubit.isPassword,
      autovalidateMode:
      AutovalidateMode.onUserInteraction,
      label: 'Enter Password',
    labelStyle: TextStyle(
      color: Colors.black87,
      fontSize: 20.sp,
    ),
      prefixIcon:  Icon(
        Icons.lock,
        color: basicColor,
      ),
      suffixIcon: IconButton(
        onPressed: () {
          cubit.changePasswordVisibility();
        },
        icon: Icon(
          cubit.suffix,
          color: basicColor,
        ),
      ),
      validator: (value) {
        if (value!.isEmpty) {
          return 'Please enter your Password';
        }
        return null;
      },

  );

}

Widget Button(height,width,formkey,userNameController,passwordController,AuthCubit cubit){

  return ConditionalBuilder(
      condition: !cubit.isAnimated,
      builder: (context) => MouseRegion(
        onEnter: (event)=>cubit.onEntered(true),
        onExit: (event)=>cubit.onEntered(false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          transform: cubit.transform,
          child: Container(
            height: height * 0.06,
            width: width<1000?width*0.28 : width * 0.14,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: primaryGradient,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                // highlightColor: Colors.orange.withOpacity(0.3),
                splashColor: Colors.red,
                borderRadius:
                BorderRadius.circular(30),
                onTap: ()  async {
                  if (formkey.currentState!
                      .validate()) {
                    cubit.login(
                        userName: userNameController.text,
                        password: passwordController.text);
                    //toast(text: 'Login Successfulyy');
                  }
                },
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    FittedBox(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: width * 0.01,
                    ),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20.sp,
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      fallback: (context) => SpinKitWeb(width)
  );
}