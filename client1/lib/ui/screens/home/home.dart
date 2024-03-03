import 'package:cached_network_image/cached_network_image.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/auth/auth_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/home_widgets.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  var catNameDuFocusNode = FocusNode();

  var catNameEnFocusNode = FocusNode();

  var catNameArFocusNode = FocusNode();

  final NumberPaginatorController paginationController =
      NumberPaginatorController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is CreatePhotoSuccessState) {
            showToast(text: 'Added Successfully', state: ToastState.success);
            cubit.getCategories(limit: limit, page: cubit.currentIndex);
            cubit.clearControllers();
            GoRouter.of(context).pop();
          }
          if (state is CreatePhotoErrorState) {
            showToast(
                text: state.createPhotoModel.message!, state: ToastState.error);
          }

          if (state is CreateCatSuccessState) {
            cubit.createImage(id: state.createCatModel.id!);
          }
          if (state is CreateCatErrorState) {
            showToast(text: 'Unknown Error', state: ToastState.error);
          }

          if (state is DeleteOneCategorySuccessState) {

            showToast(text: 'Deleted Successfully', state: ToastState.success);
            cubit.getCategories(limit: limit, page: cubit.currentIndex);
          }

          if (state is DeleteOneCategoryErrorState) {
            showToast(text: 'Delete Failed', state: ToastState.error);
          }

          if (state is EditDataCategorySuccessState) {
            print('Edit data come Success');
          }

          if (state is EditDataCategoryErrorState) {
            print('Edit data Error');
          }

          if (state is EditedCategorySuccessState) {
            if (cubit.webImage == null) {
              showToast(text: 'Edited Successfully', state: ToastState.success);
              cubit.getCategories(limit: limit, page: cubit.currentIndex);
              cubit.clearControllers();
              GoRouter.of(context).pop();
            } else {
              cubit.editImage(id: state.editedCatModel.category!.id!);
            }
          }

          if (state is EditedCategoryErrorState) {
            showToast(text: 'Cannot Update', state: ToastState.error);
          }

          if (state is EditedPhotoCategorySuccessState) {
            showToast(text: 'Edited Successfully', state: ToastState.success);
            cubit.getCategories(limit: limit, page: cubit.currentIndex);
            cubit.clearControllers();
            GoRouter.of(context).pop();
          }

          if (state is EditedPhotoCategoryErrorState) {
            showToast(
                text: state.editedPhotoModel.message!, state: ToastState.error);
          }
          ////////////////////////////////////////////////////////////////////////
          // Create and Delete Discount

          if (state is CreateDiscountForProductSuccessState) {
            cubit.clearDiscount();
            GoRouter.of(context).pop();
            showToast(
                text: 'Discount Created Successfully',
                state: ToastState.success);
          }

          if (state is CreateDiscountForProductErrorState) {
            showToast(text: 'Discount Create Error', state: ToastState.error);
          }

          if (state is DeleteDiscountForProductSuccessState) {
            showToast(text: 'Discount Deleted Successfully', state: ToastState.success);
          }

          if (state is DeleteDiscountForProductErrorState) {
            showToast(text: 'Discount Delete Error', state: ToastState.error);
          }

          ////////////////////////////////////////////////////////////////////////
          // Edit Product

          if (state is GetTaxForOneProductSuccessState) {
            cubit.getTaxesNames();
          }

          if (state is UpdateTaxForOneProductSuccessState) {
            cubit.taxesNamesModel = null;
            print('subsubsubsub');
            showToast(text: 'Tax Edited Successfully', state: ToastState.success);
          }

        },
        builder: (context, state) {
          return Scaffold(
            drawer: drawerWeb(width, height, context),
            appBar: appBarWeb(width, height, context),
            body: ConditionalBuilder(
              condition: cubit.mainCatsModel != null,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.001),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Welcome_Stack(height: height, width: width),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white),
                        padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04, vertical: height * 0.02),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Main Categories',
                                  style: TextStyle(
                                      fontSize: 45.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black),
                                ),
                                Text(
                                  'Number of Categories: ${cubit.mainCatsModel!.totalNumber}',
                                  style: TextStyle(
                                      fontSize: 25.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey),
                                ),
                                Container(
                                  width:
                                      width < 750 ? width * 0.14 : width * 0.12,
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
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () {
                                      createCatDialog(
                                          null,
                                          context,
                                          width,
                                          height,
                                          catNameDuFocusNode,
                                          catNameEnFocusNode,
                                          catNameArFocusNode,
                                          formKey,
                                          cubit);
                                    },
                                    child: Text(
                                      'Add New Category',
                                      style: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: height * 0.05,
                            ),
                            //Main Categories
                            cubit.mainCatsModel!.mainCategories!.isNotEmpty
                                ? GridView.builder(
                                    shrinkWrap: true,
                                    gridDelegate:
                                         SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: 400,
                                      mainAxisExtent: width > 800 ? 320 : 260,
                                      crossAxisSpacing: 15,
                                      mainAxisSpacing: 15,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      String path =
                                          '${url}${cubit.mainCatsModel!.mainCategories![index].imageCategory!}';
                                      print(path);
                                      return Container(
                                        decoration: BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: backgroundColor,
                                            textStyle: const TextStyle(),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                          ),
                                          onPressed: () {
                                            categoryId = cubit.mainCatsModel!
                                                .mainCategories![index].id;

                                            GoRouter.of(context).pushNamed('sub');
                                            /*
                                            GoRouter.of(context).go(Uri(
                                              path: '/sub',
                                              queryParameters: {'id': '${categoryId}'},
                                            ).toString(),);*/
                                            //context.push('sub');
                                            //context.pushNamed('sub');
                                            //context.replace('sub');
                                            //Navigator.of(context).pushNamed('sub');
                                            //Navigator.of(context).pushReplacementNamed('sub');
                                          },
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Stack(
                                                alignment: Alignment.topRight,
                                                children: [
                                                  Container(
                                                    height: height * 0.18,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                15),
                                                        color: Colors.white),
                                                    child: Center(
                                                      child: CachedNetworkImage(
                                                        imageUrl:
                                                        '${path}',
                                                        fit: BoxFit.contain,
                                                        placeholder: (context, url) =>
                                                            SpinKitWeb(width),
                                                        errorWidget: (context, url, error) =>
                                                            Icon(Icons.error),
                                                      ),
                                                    ),
                                                  ),
                                                  /*Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width * 0.005,
                                                  vertical: height * 0.01),
                                              child: Container(
                                                width: width < 400
                                                    ? width * 0.16
                                                    : width * 0.07,
                                                height: height * 0.03,
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  borderRadius: BorderRadius.circular(
                                                      12),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    '2 CATEGORIES',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        color: Colors.white,
                                                        fontSize: width < 400
                                                            ? width * 0.004
                                                            : width * 0.007),
                                                  ),
                                                ),
                                              ),
                                            )*/
                                                ],
                                              ),
                                              SizedBox(
                                                height: height * 0.01,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                  '${cubit.mainCatsModel!.mainCategories![index].categoryName}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      color: Colors.black,
                                                      fontSize: 25.sp
                                                  ),
                                                  maxLines: 2,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                  '${cubit.mainCatsModel!.mainCategories![index].itemsNumber} Items',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      color: Colors.grey,
                                                      fontSize: 25.sp,
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              SizedBox(
                                                height: height * 0.03,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      cubit.getEditCategoryData(
                                                          id: cubit
                                                              .mainCatsModel!
                                                              .mainCategories![
                                                                  index]
                                                              .id!);
                                                      editCatDialog(
                                                          cubit
                                                              .mainCatsModel!
                                                              .mainCategories![
                                                                  index]
                                                              .id!,
                                                          context,
                                                          width,
                                                          height,
                                                          catNameDuFocusNode,
                                                          catNameEnFocusNode,
                                                          catNameArFocusNode,
                                                          formKey,
                                                          cubit);
                                                    },
                                                    child: Container(
                                                      width: iconSmallSize,
                                                      height: iconSmallSize,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                        color: Colors.red,
                                                      ),
                                                      child: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                        size: iconSmallSize-26.0,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.03,
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      awsDialogDeleteForOne(
                                                          context,
                                                          width,
                                                          HomeCubit.get(context),
                                                          cubit
                                                              .mainCatsModel!
                                                              .mainCategories![
                                                                  index]
                                                              .id!,0,null,null);
                                                    },
                                                    child: Container(
                                                      width: iconSmallSize,
                                                      height: iconSmallSize,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            100.r),
                                                        color: Colors.red,
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: iconSmallSize-26.0,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                    itemCount: cubit
                                        .mainCatsModel!.mainCategories!.length,
                                  )
                                : Center(
                                    child: Text(
                                      'No Categories found',
                                      style: TextStyle(
                                          fontSize: 35.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),

                            SizedBox(
                              height: height * 0.05,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      cubit.mainCatsModel!.mainCategories!.isNotEmpty
                          ? mainPagination(context, width, height, cubit)
                          : Container(),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
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
