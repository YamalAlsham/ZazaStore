import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/logic/product/create_product_cubit.dart';
import 'package:zaza_dashboard/logic/product/products_list_cubit.dart';
import 'package:zaza_dashboard/logic/sub/sub_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/edit_product_widgets.dart';
import 'package:zaza_dashboard/ui/widgets/products_widgets.dart';
import 'package:zaza_dashboard/ui/widgets/sub_widgets.dart';

class SubPage extends StatelessWidget {
  SubPage({Key? key}) : super(key: key);

  var catNameDuFocusNode = FocusNode();

  var catNameEnFocusNode = FocusNode();

  var catNameArFocusNode = FocusNode();

  final NumberPaginatorController paginationController =
      NumberPaginatorController();

  var formKeyCat = GlobalKey<FormState>();


  var formKeyDiscount = GlobalKey<FormState>();

  var formKeyTax = GlobalKey<FormState>();

  /*var proNameDuController = TextEditingController();

  var proNameEnController = TextEditingController();

  var proNameArController = TextEditingController();

  var proNameDuFocusNode = FocusNode();

  var proNameEnFocusNode = FocusNode();

  var proNameArFocusNode = FocusNode();

  var proPriceController = TextEditingController();

  var proQuantityController = TextEditingController();

  var proPriceFocusNode = FocusNode();

  var proQuantityFocusNode = FocusNode();*/

  //var formKeyPro = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = 800.0;
    final width = MediaQuery.of(context).size.width;
    print(categoryId);
    return BlocProvider(
      create: (BuildContext context) => SubCubit()
        ..getCategoryChildren(limit: limit, page: 0, id: categoryId),
      child: BlocListener<HomeCubit, HomeState>(
            listener: (context, state) {
              var cubit = SubCubit.get(context);
              if (state is DeleteOneCategorySuccessState) {


                if (cubit.categoryNodeModel!.categoriesChildren!.length == 1 && cubit.currentIndex > 0) {
                  cubit.currentIndex--;
                  print(cubit.paginationNumberSave);
                  print(cubit.currentIndex);
                }

                print('test${cubit.catPerCubitId}');
                cubit.typecub = '';
                cubit.getCategoryChildren(
                    limit: limit,
                    page: cubit.currentIndex,
                    id: cubit.catPerCubitId);
              }
              if (state is CreatePhotoSuccessState) {
                cubit.typecub = '';
                cubit.getCategoryChildren(
                    limit: limit,
                    page: cubit.currentIndex,
                    id: cubit.catPerCubitId);
              }
              if (state is EditedCategorySuccessState) {
                if (HomeCubit.get(context).webImage == null) {
                  cubit.typecub = '';
                  cubit.getCategoryChildren(
                      limit: limit,
                      page: cubit.currentIndex,
                      id: cubit.catPerCubitId);
                }
              }
              if (state is EditedPhotoCategorySuccessState) {
                cubit.typecub = '';
                cubit.getCategoryChildren(
                    limit: limit,
                    page: cubit.currentIndex,
                    id: cubit.catPerCubitId);
              }


              //////////////////////////////////////////////////////////////////
              // Create & Delete Discount

              if (state is CreateDiscountForProductSuccessState) {
                cubit.getCategoryChildren(limit: limit, page: cubit.currentIndex, id: categoryId);
              }


              if (state is DeleteDiscountForProductSuccessState) {
                cubit.getCategoryChildren(limit: limit, page: cubit.currentIndex, id: categoryId);
              }


              //////////////////////////////////////////////////////////////////
              // Edit Product

              // Edit Tax Product
              if (state is UpdateTaxForOneProductSuccessState) {
                print('subsubsubsub');
                cubit.getCategoryChildren(limit: limit, page: cubit.currentIndex, id: categoryId);
                GoRouter.of(context).pop();
              }

            },
            child: BlocConsumer<SubCubit, SubState>(
              listener: (context, state) {
                var cubit = SubCubit.get(context);
                if (state is GetChildrenErrorState) {
                  showToast(
                      text: state.errorModel.message!, state: ToastState.error);
                }
                if (state is DeleteOneProductFromSubSuccessState) {

                  showToast(text: 'Deleted Successfully', state: ToastState.success);
                  if (cubit.categoryLeafModel!.productsChildren!.length == 1 && cubit.currentIndex > 0) {
                    cubit.currentIndex--;
                    print(cubit.paginationNumberSave);
                    print(cubit.currentIndex);
                  }

                  cubit.getCategoryChildren(limit: limit, page: cubit.currentIndex, id: categoryId);

                }
              },
              builder: (context, state) {
                var cubit = SubCubit.get(context);
                return Scaffold(
                  drawer: drawerWeb(width, height, context),
                  appBar: appBarWeb(width, height, context),
                  body: cubit.typecub == 'unknown'
                      ? unknownWidget(context, width, height, cubit)
                      : cubit.typecub == 'node'
                          ? categoryNodeWidget(context, width, height, cubit)
                          : cubit.typecub == 'leaf'
                              ? categoryLeafWidget(context, width, height, cubit)
                              : SpinKitWeb(width),
                );
              },
            ),
          ),
    );
  }

  Widget unknownWidget(context, width, height, SubCubit cubit) {
    return ConditionalBuilder(
      condition: cubit.unknownChildModel != null,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.001),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Sub_Stack(height: height, width: width),
                ],
              ),
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
                          cubit.unknownChildModel!.categoryParentName!,
                          style: TextStyle(
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          'Number of Categories: 0',
                          style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Container(
                          width: width < 750 ? width * 0.14 : width * 0.12,
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
                                  cubit.catPerCubitId,
                                  context,
                                  width,
                                  height,
                                  catNameDuFocusNode,
                                  catNameEnFocusNode,
                                  catNameArFocusNode,
                                  formKeyCat,
                                  HomeCubit.get(context));
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
                        Container(
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
                              textStyle: TextStyle(),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              GoRouter.of(context)
                                  .go(
                                  '/create-product');
                            },
                            child: Text(
                              'Add New Product',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    Center(
                      child: Text(
                        'No Categories/Products found',
                        style: TextStyle(
                            fontSize: 35.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitWeb(width),
    );
  }

  Widget categoryNodeWidget(context, width, height, SubCubit cubit) {
    return ConditionalBuilder(
      condition: cubit.categoryNodeModel != null,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.001),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Sub_Stack(height: height, width: width),
                ],
              ),
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
                          cubit.categoryNodeModel!.categoryParentName!,
                          style: TextStyle(
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          'Number of Categories: ${cubit.categoryNodeModel!.totalNumber}',
                          style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Container(
                          width: width < 750 ? width * 0.14 : width * 0.12,
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
                                  cubit.catPerCubitId,
                                  context,
                                  width,
                                  height,
                                  catNameDuFocusNode,
                                  catNameEnFocusNode,
                                  catNameArFocusNode,
                                  formKeyCat,
                                  HomeCubit.get(context));
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
                    //Sub Categories
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 900,
                        mainAxisExtent: 160,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        String path =
                            '${url}${cubit.categoryNodeModel!.categoriesChildren![index].image}';
                        print(path);
                        return Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    categoryId = cubit.categoryNodeModel!
                                        .categoriesChildren![index].id;
                                    print('categoryId to move:${categoryId}');
                                    GoRouter.of(context).pushNamed('sub');
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  splashColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            topLeft: Radius.circular(50),
                                          ),
                                        ),
                                        child: Container(
                                          width: width * 0.18,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            const BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width*0.01,),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${cubit.categoryNodeModel!.categoriesChildren![index].itemsNumber} ITEMS',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 25.sp),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Container(
                                            width: width*0.1,
                                            child: Text(
                                              '${cubit
                                                  .categoryNodeModel!
                                                  .categoriesChildren![index]
                                                  .categoryName!}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 25.sp),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width*0.01,),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              HomeCubit.get(context)
                                                  .getEditCategoryData(
                                                  id: cubit
                                                      .categoryNodeModel!
                                                      .categoriesChildren![
                                                  index]
                                                      .id!);
                                              editCatDialog(
                                                cubit
                                                    .categoryNodeModel!
                                                    .categoriesChildren![index]
                                                    .id!,
                                                context,
                                                width,
                                                height,
                                                catNameDuFocusNode,
                                                catNameEnFocusNode,
                                                catNameArFocusNode,
                                                formKeyCat,
                                                HomeCubit.get(context),
                                              );
                                            },
                                            child: Container(
                                              width: width * 0.08,
                                              height: height * 0.04,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                color: Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: height * 0.015,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print(cubit
                                                  .categoryNodeModel!
                                                  .categoriesChildren![index]
                                                  .id!);
                                              awsDialogDeleteForOne(
                                                  context,
                                                  width,
                                                  HomeCubit.get(context),
                                                  cubit
                                                      .categoryNodeModel!
                                                      .categoriesChildren![
                                                  index]
                                                      .id!,0,null,null);
                                            },
                                            child: Container(
                                              width: width * 0.08,
                                              height: height * 0.04,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(15),
                                                color: Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 18.sp,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18.sp,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /*Positioned(
                                    right: width * 0.12,
                                    child: Container(
                                      width: width < 400 ? width * 0.16 : width * 0.1,
                                      height: height * 0.03,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
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
                                  ),*/
                          ],
                        );
                      },
                      itemCount:
                      cubit.categoryNodeModel!.categoriesChildren!.length,
                    ),

                    /*ListView.separated(
                      shrinkWrap: true,
                      separatorBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: height * 0.02,
                      ),
                      itemBuilder: (context, index) {
                        print(    cubit.categoryNodeModel!.categoriesChildren![index].typeName);
                        String path =
                            '${url}${cubit.categoryNodeModel!.categoriesChildren![index].image}';
                        return Stack(
                          children: [
                            Container(
                              height: height * 0.17,
                              decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: () {
                                    categoryId = cubit.categoryNodeModel!
                                        .categoriesChildren![index].id;
                                    print('categoryId to move:${categoryId}');
                                    GoRouter.of(context).pushNamed('sub');
                                  },
                                  borderRadius: BorderRadius.circular(50),
                                  splashColor: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        clipBehavior: Clip.hardEdge,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(50),
                                            topLeft: Radius.circular(50),
                                          ),
                                        ),
                                        child: Container(
                                          width: width * 0.18,
                                          height: double.infinity,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomLeft: Radius.circular(50),
                                              topLeft: Radius.circular(50),
                                            ),
                                            border: Border.all(
                                              width: 1,
                                              color: Colors.black,
                                            ),
                                            image: DecorationImage(
                                              image: NetworkImage(path),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width*0.01,),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${cubit.categoryNodeModel!.categoriesChildren![index].itemsNumber} ITEMS',
                                            style: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 30.sp),
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Container(
                                            width: width*0.3,
                                            child: Text(
                                              '${cubit
                                                  .categoryNodeModel!
                                                  .categoriesChildren![index]
                                                  .categoryName!}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                  fontSize: 30.sp),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width*0.03,),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              HomeCubit.get(context)
                                                  .getEditCategoryData(
                                                      id: cubit
                                                          .categoryNodeModel!
                                                          .categoriesChildren![
                                                              index]
                                                          .id!);
                                              editCatDialog(
                                                cubit
                                                    .categoryNodeModel!
                                                    .categoriesChildren![index]
                                                    .id!,
                                                context,
                                                width,
                                                height,
                                                catNameDuFocusNode,
                                                catNameEnFocusNode,
                                                catNameArFocusNode,
                                                formKeyCat,
                                                HomeCubit.get(context),
                                              );
                                            },
                                            child: Container(
                                              width: width * 0.12,
                                              height: height * 0.045,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                    size: 30.sp,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Edit',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: width * 0.015,
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              print(cubit
                                                  .categoryNodeModel!
                                                  .categoriesChildren![index]
                                                  .id!);
                                              awsDialogDeleteForOne(
                                                  context,
                                                  width,
                                                  HomeCubit.get(context),
                                                  cubit
                                                      .categoryNodeModel!
                                                      .categoriesChildren![
                                                          index]
                                                      .id!,0,null,null);
                                            },
                                            child: Container(
                                              width: width * 0.12,
                                              height: height * 0.045,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.red,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.white,
                                                    size: 30.sp,
                                                  ),
                                                  SizedBox(
                                                    width: width * 0.01,
                                                  ),
                                                  Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 25.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            /*Positioned(
                                    right: width * 0.12,
                                    child: Container(
                                      width: width < 400 ? width * 0.16 : width * 0.1,
                                      height: height * 0.03,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(12),
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
                                  ),*/
                          ],
                        );
                      },
                      itemCount:
                          cubit.categoryNodeModel!.categoriesChildren!.length,
                    ),*/
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              subPagination(context, width, height, cubit),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitWeb(width),
    );
  }

  Widget categoryLeafWidget(context, width, height, SubCubit cubit) {
    return ConditionalBuilder(
      condition: cubit.categoryLeafModel != null,
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: height * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
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
                  SizedBox(
                    width: width * 0.03,
                  ),
                  Product_Stack(height: height, width: width),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white),
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'All Products',
                          style: TextStyle(
                              fontSize: 45.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                        Text(
                          'Number of Products: ${cubit.categoryLeafModel!.totalNumber!}',
                          style: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey),
                        ),
                        Container(
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
                              textStyle: TextStyle(),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: () {
                              GoRouter.of(context)
                                  .pushReplacementNamed(
                                  'create-product');
                            },
                            child: Text(
                              'Add New Product',
                              style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.05,
                    ),
                    //Products
                    GridView.builder(
                      shrinkWrap: true,
                      gridDelegate:
                      SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 400,
                        mainAxisExtent: 420,
                        crossAxisSpacing: 15,
                        mainAxisSpacing: 15,
                      ),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        String path =
                            '${url}${cubit.categoryLeafModel!.productsChildren![index].image}';
                        print(path);
                        return Container(
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            children: [
                              Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        height: height * 0.18,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(15),
                                            color: Colors.white),
                                        child: Image.network(
                                          path,
                                          fit: BoxFit.contain,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Text(
                                        '#${cubit
                                            .categoryLeafModel!
                                            .productsChildren![index]
                                            .barCode!}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: Colors.yellow,
                                            fontSize: 18.sp),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                  (cubit
                                      .categoryLeafModel!
                                      .productsChildren![
                                  index]
                                      .discount !=
                                      0 && cubit.categoryLeafModel!
                                      .productsChildren![
                                  index]
                                      .discountType != 'discountSpecificUsers')
                                      ? GestureDetector(
                                    onTap: (){
                                      print('ssjjsdfsfsdf');
                                      print(cubit
                                          .categoryLeafModel!
                                          .productsChildren![
                                      index]
                                          .discountId!);
                                      print(cubit
                                          .categoryLeafModel!
                                          .productsChildren![
                                      index]
                                          .discount);
                                      awsDialogDeleteForOne(context, width, HomeCubit.get(context), cubit
                                          .categoryLeafModel!
                                          .productsChildren![
                                      index]
                                          .discountId!, 2, index ,cubit
                                          .categoryLeafModel!
                                          .productsChildren![
                                      index]
                                          .discount);
                                    },
                                        child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(
                                          horizontal:
                                          width * 0.005,
                                          vertical:
                                          height * 0.01),
                                    child: Container(
                                        width: width < 400
                                            ? width * 0.16
                                            : width * 0.07,
                                        height: height * 0.03,
                                        decoration: BoxDecoration(
                                          color: basicColor,
                                          borderRadius:
                                          BorderRadius
                                              .circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Discount: ${cubit.categoryLeafModel!.productsChildren![index].discount}%',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight
                                                    .w400,
                                                color:
                                                Colors.white,
                                                fontSize:
                                                width < 400
                                                    ? 5.sp
                                                    : 15.sp),
                                          ),
                                        ),
                                    ),
                                  ),
                                      )
                                      : Container()
                                ],
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  cubit
                                      .categoryLeafModel!
                                      .productsChildren![index]
                                      .productName!,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                      fontSize: 25.sp),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "${cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].unitName} (${cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].quantity})",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontSize: 21.sp),
                                  maxLines: 1,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.005,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0),
                                child: Text(
                                  "${cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].description}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Colors.grey,
                                      fontSize: 21.sp),
                                  maxLines: 2,
                                ),
                              ),
                              SizedBox(
                                height: height * 0.01,
                              ),
                              cubit
                                  .categoryLeafModel!
                                  .productsChildren![
                              index]
                                  .discount ==
                                  0
                                  ? Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 15.0),
                                child: Text(
                                  "${cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].price}\€",
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w600,
                                      color: Colors.red,
                                      fontSize: 25.sp),
                                  maxLines: 1,
                                ),
                              )
                                  : Padding(
                                padding:
                                const EdgeInsets.only(
                                    left: 15.0),
                                child: Row(
                                  children: [
                                    Text(
                                      "${cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].price}\€",
                                      style: TextStyle(
                                        color: Colors.redAccent,
                                        decoration:
                                        TextDecoration
                                            .lineThrough,
                                        fontWeight:
                                        FontWeight.w600,
                                        fontSize: 25.sp,
                                      ),
                                      maxLines: 1,
                                    ),
                                    SizedBox(width: width*0.01,),
                                    Text(
                                      "${(cubit.categoryLeafModel!.productsChildren![index].productUnitListModel![0].price) * (100 - cubit.categoryLeafModel!.productsChildren![index].discount!) / 100}\€",
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 25.sp,
                                        fontWeight:
                                        FontWeight.w600,
                                      ),
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: height * 0.03,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    /*SpeedDial(
                                      icon: Icons.edit,
                                      backgroundColor: Colors.red,
                                      overlayColor: Colors.black,
                                      overlayOpacity: 0.4,
                                      spacing: 12,
                                      buttonSize: Size(
                                          iconSmallSize,
                                          iconSmallSize),
                                      spaceBetweenChildren: 12,
                                      children: [
                                        SpeedDialChild(
                                            child: Icon(
                                                Icons.ad_units),
                                            label:
                                            'Edit Product Unit',
                                            onTap: () {
                                              productId = cubit
                                                  .categoryLeafModel!
                                                  .productsChildren![
                                              index]
                                                  .productId;
                                              productName = cubit
                                                  .categoryLeafModel!
                                                  .productsChildren![
                                              index]
                                                  .productName!;
                                              print(
                                                  'productId=${productId}');
                                              print(
                                                  'productName=${productName}');
                                              GoRouter.of(context)
                                                  .push(
                                                  '/edit-product-units');
                                            }),
                                        SpeedDialChild(
                                            child: Icon(Icons.edit),
                                            label:
                                            'Edit Name & Image',
                                            onTap: () {}),
                                        SpeedDialChild(
                                            child: Icon(
                                                Icons.discount),
                                            label: 'Edit Tax',
                                            onTap: () {

                                              HomeCubit.get(context).getTaxProductName(productId: cubit.categoryLeafModel!.productsChildren![index].productId!);

                                              editTaxForProductDialog(
                                                  productId: cubit
                                                      .categoryLeafModel!.productsChildren![
                                                  index]
                                                      .productId!,
                                                  context: context,
                                                  width: width,
                                                  height: height,
                                                  formKey:
                                                  formKeyTax,
                                                  cubit: HomeCubit.get(context));
                                            }),
                                      ],
                                    ),*/
                                    GestureDetector(
                                      onTap: () {
                                        awsDialogDeleteForOne(
                                            context,
                                            width,
                                            cubit,
                                            cubit
                                                .categoryLeafModel!.productsChildren![
                                            index]
                                                .productId!,
                                            1,null,null);
                                      },
                                      child: Container(
                                        width: iconSmallSize,
                                        height: iconSmallSize,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              100),
                                          color: Colors.red,
                                        ),
                                        child: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: iconSmallSize-26.0,
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        createDiscountDialog(
                                            productId: cubit
                                                .categoryLeafModel!.productsChildren![
                                            index]
                                                .productId!,
                                            context: context,
                                            width: width,
                                            height: height,
                                            formKey: formKeyDiscount,
                                            cubit: HomeCubit.get(
                                                context));
                                      },
                                      child: Container(
                                        width: iconSmallSize,
                                        height: iconSmallSize,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(
                                              100),
                                          color: Colors.red,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: Colors.white,
                                          size: iconSmallSize-26.0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                      itemCount: cubit.categoryLeafModel!.productsChildren!.length,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              productPagination(context, width, height, cubit),
              SizedBox(
                height: height * 0.01,
              ),
            ],
          ),
        ),
      ),
      fallback: (context) => SpinKitWeb(width),
    );
  }
}
