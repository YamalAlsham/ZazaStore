import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/auth/auth_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/logic/order/orders_cubit.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';

Widget drawerWeb(width, height, context) {
  return Drawer(
    child: Container(
      color: backgroundColor,
      child: Column(
        children: [
          Flexible(
            child: Container(
              height: height / 3.5,
              color: backgroundColor,
              child: Image.asset(
                'assets/Logo_Colored_512.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.03,
          ),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.home,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    HomeCubit.get(context).getCategories(limit: limit, page: 0);
                    categoryId = null;
                    GoRouter.of(context).go('/');
                    GoRouter.of(context).push('/');
                  },
                  tileColor: backgroundColor,
                  splashColor: const Color(0xFFC9C9C9),
                ),
              )),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.production_quantity_limits,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Products',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/products');
                    GoRouter.of(context).push('/products');
                  },
                  tileColor: backgroundColor,
                  splashColor: const Color(0xFFC9C9C9),
                ),
              )),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.people_alt,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Users',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/users');
                    GoRouter.of(context).push('/users');
                  },
                  tileColor: backgroundColor,
                  splashColor: const Color(0xFFC9C9C9),
                ),
              )),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.discount,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Taxes & Units',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/tax&unit');
                    GoRouter.of(context).push('/tax&unit');
                  },
                  tileColor: backgroundColor,
                  splashColor: const Color(0xFFC9C9C9),
                ),
              )),
          Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE6E6E6),
                  ),
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: ListTile(
                  leading: const Icon(
                    Icons.shopping_bag,
                    size: 22,
                    color: Colors.redAccent,
                  ),
                  title: Text(
                    'Orders',
                    style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600),
                  ),
                  onTap: () {
                    GoRouter.of(context).go('/orders');
                    GoRouter.of(context).push('/orders');
                  },
                  tileColor: backgroundColor,
                  splashColor: const Color(0xFFC9C9C9),
                ),
              )),
        ],
      ),
    ),
  );
}

PreferredSizeWidget appBarWeb(width, height, context) {
  return AppBar(
    backgroundColor: basicColor,
    actions: [
      TextButton(
        onPressed: () {
          AuthCubit.get(context).logout(context);
          print('hahha');
        },
        child: Row(
          children: [
            Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 25.sp),
            ),
            SizedBox(
              width: width / 120,
            ),
            Icon(
              Icons.logout,
              color: Colors.white60,
              size: 25.sp,
            )
          ],
        ),
      ),
    ],
  );
}

TextFormField def_TextFromField(
    {required TextInputType keyboardType,
    required TextEditingController controller,
      FocusNode? focusNode,
    GestureTapCallback? onTap,
    ValueChanged<String>? onChanged,
    ValueChanged<String>? onFieldSubmitted,
    FormFieldValidator? validator,
    TextDirection? textDirection = TextDirection.ltr,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool obscureText = false,
    int maxLines = 1,
    minLines = 1,
    String label = 'Tap here to write ',
    TextStyle labelStyle = const TextStyle(color: seconderyColor, fontSize: 14),
    Color cursorColor = Colors.red,
    Color borderFocusedColor = basicColor,
    Color borderNormalColor = basicColor,
    Color focusedBorderColor = Colors.black,
    Color fillColor = const Color(0xFFFCFCFC),
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    double br = 25.0}) {
  return TextFormField(
    textDirection: textDirection,
    onTap: onTap,
    keyboardType: keyboardType,
    controller: controller,
    validator: validator,
    focusNode: focusNode,
    obscureText: obscureText,
    readOnly: false,
    onFieldSubmitted: onFieldSubmitted,
    onChanged: onChanged,
    minLines: minLines,
    maxLines: obscureText ? 1 : maxLines,
    cursorColor: cursorColor,
    autovalidateMode: autovalidateMode,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      labelText: label,
      labelStyle: labelStyle,
      fillColor: fillColor,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: BorderSide(color: borderFocusedColor, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: BorderSide(
          color: borderNormalColor,
          width: 2.0,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: BorderSide(
          color: borderNormalColor,
          width: 1,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(br),
        borderSide: const BorderSide(
          color: Colors.red,
          width: 1.5,
        ),
      ),
    ),
  );
}

void showToast({
  required String text,
  required ToastState state,
}) =>
    Fluttertoast.showToast(
        webShowClose: true,
        msg: "$text",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM_RIGHT,
        timeInSecForIosWeb: 3,
        webPosition: "center",
        webBgColor: "${chooseToastColor(state)}",
        textColor: Colors.white,
        fontSize: 16.0);

enum ToastState { success, error, warning }

String chooseToastColor(ToastState state) {
  String color;
  switch (state) {
    case ToastState.success:
      color = "linear-gradient(to right,#A5D6A7, #81C784, #66BB6A)";
      break;
    case ToastState.error:
      color = "linear-gradient(to right, #dc1c13, #dc1c13)";
      break;
    case ToastState.warning:
      color = "linear-gradient(to right, #f7b436,#f7b436)";
      break;
  }
  return color;
}

//SPINKIT

Widget SpinKitWeb(width) {
  return SpinKitFadingCircle(
    color: basicColor,
    size: width * 0.022,
  );
}

Widget subTitle(String s, width) {
  return Text(
    s,
    style: TextStyle(
      fontSize: width * 0.018,
      fontWeight: FontWeight.bold,
    ),
  );
}

Widget clearDataButton(context, width, height, cubit, typeCall) {
  return Container(
    width: width < 600 ? width * 0.18 : width * 0.14,
    height: height * 0.05,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.blue,
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: basicColor,
        textStyle: const TextStyle(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: () {
        awsDialogDeleteForAll(context, width, cubit, typeCall);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Clear Selected Data',
            style: TextStyle(fontSize: width * 0.01, color: Colors.white),
          ),
          //SizedBox(width: width*0.01,),
          Icon(
            Icons.delete,
            color: Colors.white,
            size: width * 0.01,
          ),
        ],
      ),
    ),
  );
}

Future<Object?> awsDialogDeleteForOne(
    context, width,cubit, int idToDelete, int type, int? index,int? percent) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.3,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'Do you want to delete?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {

        if (type == 0){
          //delete cat
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteCategory(id: idToDelete));
        }
        if (type == 1) {
          // delete pro
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteProduct(id: idToDelete));
        }
        if (type == 2) {
          // delete discount
          print('delete discount');
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteDiscount(id: idToDelete,percent: percent));
        }
        if (type == 3) {
          // delete product unit
          print('delete product unit');
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteProductUnit(productUnitId: idToDelete));
        }
        if (type == 4) {
          // delete user
          print('delete user');
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteUser(userId: idToDelete));
        }
        if (type == 5) {
          // delete discount for user
          print('delete discount for user');
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteDiscountProductForUser(discountPrUsId: idToDelete,index: index!));
        }

      }).show();
}


Future<Object?> awsDialogDeleteForDiscount(
    context, width, HomeCubit cubit, int idToDelete, int percent) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.3,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'Do you want to delete?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {

          // delete discount
          EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
                  () => cubit.deleteDiscount(id: idToDelete,percent: percent));



      }).show();
}


Future<Object?> awsDialogDeleteForAll(context, width, cubit, typeCall) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.3,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'Do you want to delete?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        if (typeCall == 1) {
          if (cubit.selectedStudents.isNotEmpty) {
            cubit.deleteStudentsData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is no selected data to delete'),
              ),
            );
          }
        } else if (typeCall == 2) {
          if (cubit.selectedTeachers.isNotEmpty) {
            cubit.deleteTeachersData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is no selected data to delete'),
              ),
            );
          }
        } else if (typeCall == 3) {
          if (cubit.selectedClasses.isNotEmpty) {
            cubit.deleteClassesData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is no selected data to delete'),
              ),
            );
          }
        } else if (typeCall == 4) {
          if (cubit.selectedParents.isNotEmpty) {
            cubit.deleteParentsData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is no selected data to delete'),
              ),
            );
          }
        } else {
          if (cubit.selectedAdmins.isNotEmpty) {
            cubit.deleteAdminsData();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('There is no selected data to delete'),
              ),
            );
          }
        }
      }).show();
}

Widget TitleText({
  required String text,
}) {
  return Text(
    text,
    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45.sp,color: Colors.red),
  );
}


////////////////////////////////////////////////////////////////////////////////
// Creating categories and sub categories

Future<String?> createCatDialog(
        int? parentCatId,
        context,
        width,
        height,
        catNameDuFocusNode,
        catNameEnFocusNode,
        catNameArFocusNode,
        formKey,
        HomeCubit cubit) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Create Category",
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.02,
        ),
        content: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.01),
                child: Container(
                  height: height * 0.7,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            'Category Image',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              cubit.pickImage(
                                  ImageSource.gallery, context, width);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: primaryColor,
                              ),
                              padding: const EdgeInsets.all(8),
                              height: height * 0.22,
                              width: width * 0.22,
                              child: cubit.webImage != null
                                  ? Image.memory(
                                      cubit.webImage!,
                                fit: BoxFit.contain,
                                    )
                                  : DottedBorder(
                                      dashPattern: [6.7],
                                      borderType: BorderType.RRect,
                                      color: Colors.black,
                                      radius: const Radius.circular(15),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Icon(
                                              Icons.image_outlined,
                                              color: Colors.black,
                                              size: 50,
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Text(
                                              'Choose an Image',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20.sp),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        Text(
                          'Kategoriename',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(catNameEnFocusNode);
                          },
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.catNameDuController,
                          focusNode: catNameDuFocusNode,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Category Name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Text(
                          'Category name',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(catNameArFocusNode);
                          },
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.catNameEnController,
                          focusNode: catNameEnFocusNode,
                        ),
                        SizedBox(
                          height: height * 0.03,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'اسم التصنيف',
                              style: TextStyle(
                                  fontSize: 30.sp, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        Directionality(
                          textDirection: TextDirection.rtl,
                          child: def_TextFromField(
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            textDirection: TextDirection.rtl,
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller: cubit.catNameArController,
                            focusNode: catNameArFocusNode,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              cubit.clearControllers();
              GoRouter.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.createCat(
                    parentCategoryId: parentCatId,
                    catNameDu: cubit.catNameDuController.text,
                    catNameEn: cubit.catNameEnController.text,
                    catNameAr: cubit.catNameArController.text);
              }
            },
            child: Text(
              'Create',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

// Create Discount


Future<String?> createDiscountDialog({
    required int productId,
    required context,
    required width,
    required height,
    required formKey,
    required HomeCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: Text('Create Discount',style: TextStyle(color: basicColor,fontSize: 50.sp,fontWeight: FontWeight.bold),)
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.02,
        ),
        content: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.01),
                child: Container(
                  height: height * 0.14,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discount Percent',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.discountController,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Discount Percent';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              cubit.clearDiscount();
              GoRouter.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                cubit.createDis(productId: productId, percent: int.parse(cubit.discountController.text));
              }
            },
            child: Text(
              'Create',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );


////////////////////////////////////////////////////////////////////////////////
// Editing categories and sub categories

Future<String?> editCatDialog(
        int categoryId,
        context,
        width,
        height,
        catNameDuFocusNode,
        catNameEnFocusNode,
        catNameArFocusNode,
        formKey,
        HomeCubit cubit) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Edit Category",
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.02,
        ),
        content: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.02, vertical: height * 0.01),
                child: Container(
                  height: height * 0.7,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: ConditionalBuilder(
                      condition: cubit.editDataCatModel != null,
                      builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              'Category Image',
                              style: TextStyle(
                                  fontSize: 30.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(
                            height: height * 0.01,
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: GestureDetector(
                              onTap: () {
                                cubit.pickImage(
                                    ImageSource.gallery, context, width);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  color: primaryColor,
                                ),
                                padding: const EdgeInsets.all(8),
                                height: height * 0.22,
                                width: width * 0.22,
                                child: cubit.webImage != null
                                    ? Image.memory(
                                        cubit.webImage!,
                                  fit: BoxFit.contain,
                                      )
                                    : Image.network(
                                        '${url}${cubit.editDataCatModel!.image!}',
                                  fit: BoxFit.contain,
                                      ),
                              ),
                            ),
                          ),
                          Text(
                            'Kategoriename',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(catNameEnFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller: cubit.catNameDuController,
                            focusNode: catNameDuFocusNode,
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Category Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            'Category name',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(catNameArFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller: cubit.catNameEnController,
                            focusNode: catNameEnFocusNode,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'اسم التصنيف',
                                style: TextStyle(
                                    fontSize: 30.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          Directionality(
                            textDirection: TextDirection.rtl,
                            child: def_TextFromField(
                              br: 10,
                              borderFocusedColor: Colors.black,
                              borderNormalColor: Colors.grey,
                              textDirection: TextDirection.rtl,
                              fillColor: Colors.white,
                              keyboardType: TextInputType.text,
                              controller: cubit.catNameArController,
                              focusNode: catNameArFocusNode,
                            ),
                          ),
                        ],
                      ),
                      fallback: (context) => SpinKitWeb(width),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              cubit.clearControllers();
              GoRouter.of(context).pop();
            },
            child: Text(
              'Cancel',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
          SizedBox(
            width: width * 0.05,
          ),
          TextButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                EasyDebounce.debounce(
                    'my-debouncer',
                    Duration(milliseconds: 500),
                    () => cubit.editCat(
                        catNameDu: cubit.catNameDuController.text,
                        catNameEn: cubit.catNameEnController.text,
                        catNameAr: cubit.catNameArController.text,
                        categoryId: categoryId));
              }
            },
            child: Text(
              'Edit',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );


Future<Object?> awsDialogChangeStatusToApproved(context, width,cubit, int order_id) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.3,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      btnCancelText: 'Cancel',
      btnOkText: 'Ok',
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'Do you want to Accept Order?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        cubit.updateStatus(order_id: order_id, status: 'approved');
      }).show();
}

Future<Object?> awsDialogChangeStatusToRejected(context, width,cubit, int order_id) {
  return AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      borderSide: const BorderSide(
        color: Colors.yellow,
        width: 2,
      ),
      width: width * 0.3,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: false,
      dismissOnBackKeyPress: false,
      headerAnimationLoop: true,
      btnCancelText: 'Cancel',
      btnOkText: 'Ok',
      animType: AnimType.topSlide,
      title: 'Warning',
      desc: 'Do you want to Reject Order?',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        cubit.updateStatus(order_id: order_id, status: 'rejected');
      }).show();
}
