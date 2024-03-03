import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/product/create_product_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/products_widgets.dart';

class CreateProduct extends StatelessWidget {
  CreateProduct({Key? key}) : super(key: key);

  var barCodeFocusNode = FocusNode();

  var productNameGermanFocusNode = FocusNode();

  var productNameEnglishFocusNode = FocusNode();

  var productNameArabicFocusNode = FocusNode();

  var productUnitPriceFocusNode = FocusNode();

  var productUnitQuantityFocusNode = FocusNode();

  var productUnitDescGermanFocusNode = FocusNode();

  var productUnitDescEnglishFocusNode = FocusNode();

  var productUnitDescArabicFocusNode = FocusNode();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => CreateProductCubit()..getCategoriesNames(),
      child: BlocConsumer<CreateProductCubit, CreateProductState>(
        listener: (context, state) {
          var cubit = CreateProductCubit.get(context);
          if (state is CreatePhotoProSuccessState) {
            showToast(text: 'Added Successfully', state: ToastState.success);
            cubit.clearControllers();
            //Navigator.pop(context);
          }
          if (state is CreatePhotoProErrorState) {
            showToast(
                text: state.createPhotoModel.message!, state: ToastState.error);
          }

          if (state is CreateProductSuccessState) {
            cubit.createImage(id: state.createProModel.product!.id!);
          }
          if (state is CreateProductErrorState) {
            showToast(text: 'Unknown Error', state: ToastState.error);
          }

          ///////////////////////////////////////////////////////////////////////
          if (state is GetCatForProductsSuccessState) {
            cubit.getTaxesNames();
          }
          if (state is GetTaxForProductsSuccessState) {
            cubit.getUnitsNames();
          }
        },
        builder: (context, state) {
          var cubit = CreateProductCubit.get(context);
          return Scaffold(
            appBar: appBarWeb(width, height, context),
            drawer: drawerWeb(width, height, context),
            body: cubit.isLoading?SpinKitWeb(width):ConditionalBuilder(
              condition: cubit.unitsNamesModel != null,
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
                            TitleText(text: 'Create New Product'),
                            SizedBox(
                              width: width * 0.36,
                            ),
                            Icon(
                              Icons.production_quantity_limits,
                              color: basicColor,
                              size: 75.sp,
                            )
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
                          width: width * 0.9,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.025),
                          child: Form(
                            key: formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Product Name (German)',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Container(
                                                  height: height * 0.1,
                                                  width: width * 0.15,
                                                  child: def_TextFromField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: cubit
                                                        .productNameGermanController,
                                                    focusNode:
                                                        productNameGermanFocusNode,
                                                    br: 10,
                                                    borderFocusedColor:
                                                        Colors.black,
                                                    borderNormalColor:
                                                        Colors.grey,
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              productNameEnglishFocusNode);
                                                    },
                                                    label: 'Enter Product Name',
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter Product Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Product Name (English)',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Container(
                                                  height: height * 0.1,
                                                  width: width * 0.15,
                                                  child: def_TextFromField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: cubit
                                                        .productNameEnglishController,
                                                    focusNode:
                                                        productNameEnglishFocusNode,
                                                    br: 10,
                                                    borderFocusedColor:
                                                        Colors.black,
                                                    borderNormalColor:
                                                        Colors.grey,
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              productNameArabicFocusNode);
                                                    },
                                                    label: 'Enter Product Name',

                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter Product Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Product Name (Arabic)',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Container(
                                                  height: height * 0.1,
                                                  width: width * 0.15,
                                                  child: def_TextFromField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller: cubit
                                                        .productNameArabicController,
                                                    focusNode:
                                                        productNameArabicFocusNode,
                                                    br: 10,
                                                    borderFocusedColor:
                                                        Colors.black,
                                                    borderNormalColor:
                                                        Colors.grey,
                                                    onFieldSubmitted: (value) {
                                                      FocusScope.of(context)
                                                          .requestFocus(
                                                              barCodeFocusNode);
                                                    },
                                                    label: 'Enter Product Name',
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter Product Name';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Barcode',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Container(
                                                  height: height * 0.1,
                                                  width: width * 0.15,
                                                  child: def_TextFromField(
                                                    keyboardType:
                                                        TextInputType.text,
                                                    controller:
                                                        cubit.barCodeController,
                                                    focusNode: barCodeFocusNode,
                                                    br: 10,
                                                    borderFocusedColor:
                                                        Colors.black,
                                                    borderNormalColor:
                                                        Colors.grey,
                                                    label: 'Enter Barcode',
                                                    validator: (value) {
                                                      if (value!.isEmpty) {
                                                        return 'Please enter Barcode';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width * 0.03,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Category Name',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: height * 0.04),
                                                  child: drop_add_category(
                                                      context: context,
                                                      height: height,
                                                      width: width,
                                                      cubit: cubit),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              width: width * 0.01,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  'Tax Name',
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                                SizedBox(
                                                  height: height * 0.012,
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: height * 0.04),
                                                  child: drop_add_tax(
                                                      context: context,
                                                      height: height,
                                                      width: width,
                                                      cubit: cubit),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Center(
                                          child: Text(
                                            'Product Image',
                                            style: TextStyle(
                                                fontSize: 30.sp,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            cubit.pickImage(ImageSource.gallery,
                                                context, width);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                              color: primaryColor,
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            height: height * 0.32,
                                            width: width * 0.22,
                                            child: cubit.webImage != null
                                                ? Image.memory(
                                                    cubit.webImage!,
                                              fit: BoxFit.contain,
                                                  )
                                                : DottedBorder(
                                                    dashPattern: [6.7],
                                                    borderType:
                                                        BorderType.RRect,
                                                    color: Colors.black,
                                                    radius:
                                                        const Radius.circular(
                                                            15),
                                                    child: Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .image_outlined,
                                                            color: Colors.black,
                                                            size: 50,
                                                          ),
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                          Text(
                                                            'Choose an Image',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                                fontSize:
                                                                    20.sp),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Product Unit Data:',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 30.sp),
                                    ),
                                    SizedBox(
                                      width: width * 0.05,
                                    ),
                                    Container(
                                      width: width < 600
                                          ? width * 0.08
                                          : width * 0.06,
                                      height: height * 0.04,
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
                                          if (cubit.unitsIds.length > 0) {
                                            cubit.deleteOtherUnitsController();
                                          }
                                        },
                                        child: Text(
                                          'Remove',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Container(
                                      width: width < 600
                                          ? width * 0.08
                                          : width * 0.06,
                                      height: height * 0.04,
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
                                          cubit.addOtherUnitsController();
                                        },
                                        child: Text(
                                          'Add',
                                          style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.04,
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.only(
                                              bottom: height * 0.04),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Unit Name',
                                                style: TextStyle(
                                                    fontSize: 20.sp,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              SizedBox(
                                                height: height * 0.012,
                                              ),
                                              drop_add_unit(
                                                  context: context,
                                                  height: height,
                                                  width: width,
                                                  cubit: cubit),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Price',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              height: height * 0.1,
                                              width: width * 0.15,
                                              child: def_TextFromField(
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          productUnitQuantityFocusNode);
                                                },
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: cubit
                                                    .productUnitPriceController,
                                                focusNode:
                                                    productUnitPriceFocusNode,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                label: 'Enter Price',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter Price';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Quantity',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              height: height * 0.1,
                                              width: width * 0.15,
                                              child: def_TextFromField(
                                                keyboardType:
                                                    TextInputType.text,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          productUnitDescGermanFocusNode);
                                                },
                                                controller: cubit
                                                    .productUnitQuantityController,
                                                focusNode:
                                                    productUnitQuantityFocusNode,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                label: 'Enter Quantity',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter Quantity';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.04,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unit Description (German)',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              height: height * 0.1,
                                              width: width * 0.2,
                                              child: def_TextFromField(
                                                keyboardType:
                                                    TextInputType.text,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          productUnitDescEnglishFocusNode);
                                                },
                                                controller: cubit
                                                    .productUnitDescriptionGermanController,
                                                focusNode:
                                                    productUnitDescGermanFocusNode,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                label: 'Enter Unit Description',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter unit description';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unit Description (English)',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              height: height * 0.1,
                                              width: width * 0.2,
                                              child: def_TextFromField(
                                                keyboardType:
                                                    TextInputType.text,
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          productUnitDescArabicFocusNode);
                                                },
                                                controller: cubit
                                                    .productUnitDescriptionEnglishController,
                                                focusNode:
                                                    productUnitDescEnglishFocusNode,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,

                                                label: 'Enter Unit Description',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter unit description';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unit Description (Arabic)',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              height: height * 0.1,
                                              width: width * 0.2,
                                              child: def_TextFromField(
                                                keyboardType:
                                                    TextInputType.text,
                                                controller: cubit
                                                    .productUnitDescriptionArabicController,
                                                focusNode:
                                                    productUnitDescArabicFocusNode,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                label: 'Enter Unit Description',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter unit description';
                                                  }
                                                  return null;
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) => Column(
                                          children: [
                                            Divider(
                                              height: height * 0.05,
                                              thickness: 1.5,
                                              color: Colors.black,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      bottom: height * 0.04),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Unit Name',
                                                        style: TextStyle(
                                                            fontSize: 20.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                      ),
                                                      SizedBox(
                                                        height: height * 0.012,
                                                      ),
                                                      drop_add_unitwithindex(
                                                          context: context,
                                                          height: height,
                                                          width: width,
                                                          index: index,
                                                          cubit: cubit),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Price',
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.012,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.15,
                                                      child: def_TextFromField(
                                                        onFieldSubmitted:
                                                            (value) {
                                                          FocusScope.of(context)
                                                              .requestFocus(
                                                                  productUnitQuantityFocusNode);
                                                        },
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: cubit
                                                                .otherProductUnitPricesController[
                                                            index],
                                                        br: 10,
                                                        borderFocusedColor:
                                                            Colors.black,
                                                        borderNormalColor:
                                                            Colors.grey,
                                                        label: 'Enter Price',
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter Price';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Quantity',
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.012,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.15,
                                                      child: def_TextFromField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: cubit
                                                                .otherProductUnitQuantityController[
                                                            index],
                                                        br: 10,
                                                        borderFocusedColor:
                                                            Colors.black,
                                                        borderNormalColor:
                                                            Colors.grey,
                                                        label: 'Enter Quantity',
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter Quantity';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: height * 0.04,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Unit Description (German)',
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.012,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.2,
                                                      child: def_TextFromField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: cubit
                                                            .otherProductUnitDescriptionGermanController[index],
                                                        br: 10,
                                                        borderFocusedColor:
                                                            Colors.black,
                                                        borderNormalColor:
                                                            Colors.grey,
                                                        label:
                                                            'Enter Unit Description',
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter unit description';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Unit Description (English)',
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.012,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.2,
                                                      child: def_TextFromField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: cubit
                                                            .otherProductUnitDescriptionEnglishController[index],
                                                        br: 10,
                                                        borderFocusedColor:
                                                            Colors.black,
                                                        borderNormalColor:
                                                            Colors.grey,
                                                        label:
                                                            'Enter Unit Description',
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter unit description';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Unit Description (Arabic)',
                                                      style: TextStyle(
                                                          fontSize: 20.sp,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                    SizedBox(
                                                      height: height * 0.012,
                                                    ),
                                                    Container(
                                                      height: height * 0.1,
                                                      width: width * 0.2,
                                                      child: def_TextFromField(
                                                        keyboardType:
                                                            TextInputType.text,
                                                        controller: cubit
                                                                .otherProductUnitDescriptionArabicController[
                                                            index],
                                                        br: 10,
                                                        borderFocusedColor:
                                                            Colors.black,
                                                        borderNormalColor:
                                                            Colors.grey,
                                                        label:
                                                            'Enter Unit Description',
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'Please enter unit description';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                    separatorBuilder:
                                        (BuildContext context, int index) =>
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                    itemCount: cubit.unitsIds.length),
                                SizedBox(
                                  height: height * 0.05,
                                ),
                                Center(
                                  child: Container(
                                    width: width < 600
                                        ? width * 0.16
                                        : width * 0.14,
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
                                          cubit.addAllUnits();

                                          cubit.createPro(
                                              barCode:
                                                  cubit.barCodeController.text,
                                              proNameDu: cubit
                                                  .productNameGermanController
                                                  .text,
                                              proNameEn: cubit
                                                  .productNameEnglishController
                                                  .text,
                                              proNameAr: cubit
                                                  .productNameArabicController
                                                  .text);
                                        }
                                      },
                                      child: Text(
                                        'Create New Product',
                                        style: TextStyle(
                                            fontSize: 20.sp,
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
      ),
    );
  }
}
