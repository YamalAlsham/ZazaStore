import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/taxes%20&%20units/tax&unit_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/taxes_widgets.dart';

class TaxesUnits extends StatelessWidget {
  TaxesUnits({Key? key}) : super(key: key);

  //Tax
  var percentFocusNode = FocusNode();

  var taxNameDuFocusNode = FocusNode();

  var taxNameEnFocusNode = FocusNode();

  var taxNameArFocusNode = FocusNode();

  var taxFormKey = GlobalKey<FormState>();


  //Unit
  var unitNameDuFocusNode = FocusNode();

  var unitNameEnFocusNode = FocusNode();

  var unitNameArFocusNode = FocusNode();

  var unitFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (BuildContext context) => TaxUnitCubit(),
      child: BlocConsumer<TaxUnitCubit, TaxUnitState>(
        listener: (context, state) {
          var cubit = TaxUnitCubit.get(context);

          if (state is AddTaxSuccessState) {
            showToast(
                text: 'Tax Added Successfully', state: ToastState.success);
            cubit.taxClearControllers();
            cubit.getTaxes();
          }

          if (state is AddTaxErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          if (state is DeleteTaxSuccessState) {
            showToast(
                text: 'Tax Deleted Successfully', state: ToastState.success);
            cubit.getTaxes();
          }

          if (state is DeleteTaxErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          /*if (state is GetTaxSuccessState) {
            cubit.getUnits();
          }*/

          if (state is GetTaxErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          //////////////////////////////////////////////////////////////////////

          if (state is AddUnitSuccessState) {
            showToast(
                text: 'Unit Added Successfully', state: ToastState.success);
            cubit.unitClearControllers();
            cubit.getUnits();
          }

          if (state is AddUnitErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          if (state is DeleteUnitSuccessState) {
            showToast(
                text: 'Unit Deleted Successfully', state: ToastState.success);
            cubit.getUnits();
          }

          if (state is DeleteUnitErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          if (state is GetUnitErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }
        },
        builder: (context, state) {
          var cubit = TaxUnitCubit.get(context);
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBarWeb(width, height, context),
            drawer: drawerWeb(width, height, context),
            body: ConditionalBuilder(
              condition: cubit.taxesModel != null && cubit.unitsModel != null,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.03, vertical: height * 0.001),
                  child: Container(
                    color: backgroundColor,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleTax(height: height, width: width),
                        Row(
                          children: [
                            Container(
                              height: height * 0.38,
                              width: width * 0.48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.02),
                              child: Form(
                                key: taxFormKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Add New Tax',
                                          style: TextStyle(
                                              fontSize: 35.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                        Container(
                                          width: width < 600
                                              ? width * 0.14
                                              : width * 0.1,
                                          height: height * 0.05,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
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
                                              if (taxFormKey.currentState!
                                                  .validate()) {
                                                EasyDebounce.debounce(
                                                  'my-debouncer',
                                                  Duration(milliseconds: 500),
                                                  () => cubit.addTaxes(
                                                    percent: double.parse(cubit
                                                        .percentController
                                                        .text),
                                                    taxNameDu: cubit
                                                        .taxNameDuController
                                                        .text,
                                                    taxNameEn: cubit
                                                        .taxNameEnController
                                                        .text,
                                                    taxNameAr: cubit
                                                        .taxNameArController
                                                        .text,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Add Tax',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
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
                                              'Percent',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.01,
                                            ),
                                            Container(
                                              width: width * 0.14,
                                              child: def_TextFromField(
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          taxNameDuFocusNode);
                                                },
                                                fillColor: Colors.white,
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                keyboardType:
                                                    TextInputType.number,
                                                controller:
                                                    cubit.percentController,
                                                focusNode: percentFocusNode,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter percent';
                                                  }
                                                  if (double.tryParse(value) == null) {
                                                    return 'Please enter a valid number.';
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
                                              'Tax name (German)',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              width: width * 0.14,
                                              child: def_TextFromField(
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          taxNameEnFocusNode);
                                                },
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                fillColor: Colors.white,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    cubit.taxNameDuController,
                                                focusNode: taxNameDuFocusNode,
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Please enter Tax Name';
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
                                      height: height * 0.02,
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
                                              'Tax name (English)',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              width: width * 0.14,
                                              child: def_TextFromField(
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                          taxNameArFocusNode);
                                                },
                                                br: 10,
                                                borderFocusedColor:
                                                    Colors.black,
                                                borderNormalColor: Colors.grey,
                                                fillColor: Colors.white,
                                                keyboardType:
                                                    TextInputType.text,
                                                controller:
                                                    cubit.taxNameEnController,
                                                focusNode: taxNameEnFocusNode,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Tax name (Arabic)',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Container(
                                                width: width * 0.14,
                                                child: def_TextFromField(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  fillColor: Colors.white,
                                                  br: 10,
                                                  borderFocusedColor:
                                                      Colors.black,
                                                  borderNormalColor:
                                                      Colors.grey,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  controller:
                                                      cubit.taxNameArController,
                                                  focusNode: taxNameArFocusNode,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Container(
                              height: height * 0.38,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              padding: EdgeInsets.only(
                                left: width * 0.02,
                                top: height * 0.02,
                                bottom: height * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Taxes Info',
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.08,
                                  ),
                                  cubit.taxesModel!.taxesList!.isNotEmpty
                                      ? SizedBox(
                                          height: height * 0.18,
                                          child: ListView.separated(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.horizontal,
                                            physics: BouncingScrollPhysics(),
                                            itemBuilder: (context, index) =>
                                                Container(
                                              decoration: BoxDecoration(
                                                gradient:
                                                    LinearGradient(colors: [
                                                  Colors.red[900]!,
                                                  Colors.red[700]!,
                                                ]),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              width: width * 0.15,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${cubit
                                                        .taxesModel!
                                                        .taxesList![index]
                                                        .taxName!}',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Text(
                                                    '${cubit.taxesModel!.taxesList![index].taxPercent!}%',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 30.sp,
                                                        fontWeight:
                                                            FontWeight.w700),
                                                    maxLines: 1,
                                                  ),
                                                  SizedBox(
                                                    height: height * 0.01,
                                                  ),
                                                  Container(
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8)),
                                                      width: width * 0.06,
                                                      height: height * 0.04,
                                                      child: Material(
                                                        color:
                                                            Colors.transparent,
                                                        child: InkWell(
                                                          onTap: () {
                                                            cubit.deleteTaxes(
                                                                id: cubit
                                                                    .taxesModel!
                                                                    .taxesList![
                                                                        index]
                                                                    .id!);
                                                          },
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                          splashColor:
                                                              Colors.red,
                                                          child: Center(
                                                            child: Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                      20.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ],
                                              ),
                                            ),
                                            separatorBuilder:
                                                (BuildContext context,
                                                        int index) =>
                                                    SizedBox(
                                              width: width * 0.02,
                                            ),
                                            itemCount: cubit
                                                .taxesModel!.taxesList!.length,
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            'No Taxes Found',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                                fontSize: 30.sp),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        Row(
                          children: [
                            Container(
                              height: height * 0.38,
                              width: width * 0.48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.white,
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.02,
                                  vertical: height * 0.02),
                              child: Form(
                                key: unitFormKey,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Add New Unit',
                                          style: TextStyle(
                                              fontSize: 35.sp,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black),
                                        ),
                                        Container(
                                          width: width < 600
                                              ? width * 0.14
                                              : width * 0.1,
                                          height: height * 0.05,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
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
                                              if (unitFormKey.currentState!
                                                  .validate()) {
                                                EasyDebounce.debounce(
                                                  'my-debouncer',
                                                  Duration(milliseconds: 500),
                                                      () => cubit.addUnits(
                                                    unitNameDu: cubit
                                                        .unitNameDuController
                                                        .text,
                                                    unitNameEn: cubit
                                                        .unitNameEnController
                                                        .text,
                                                    unitNameAr: cubit
                                                        .unitNameArController
                                                        .text,
                                                  ),
                                                );
                                              }
                                            },
                                            child: Text(
                                              'Add Unit',
                                              style: TextStyle(
                                                  fontSize: 20.sp,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height*0.01,),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Unit name (German)',
                                          style: TextStyle(
                                              fontSize: 25.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: height * 0.012,
                                        ),
                                        Container(
                                          width: width*0.33,
                                          child: def_TextFromField(

                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(
                                                  unitNameEnFocusNode);
                                            },
                                            br: 10,
                                            borderFocusedColor:
                                            Colors.black,
                                            borderNormalColor: Colors.grey,
                                            fillColor: Colors.white,
                                            keyboardType:
                                            TextInputType.text,
                                            controller:
                                            cubit.unitNameDuController,
                                            focusNode: unitNameDuFocusNode,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please enter Unit Name';
                                              }
                                              return null;
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: height * 0.02,
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
                                              'Unit name (English)',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Container(
                                              width: width * 0.14,
                                              child: def_TextFromField(
                                                onFieldSubmitted: (value) {
                                                  FocusScope.of(context)
                                                      .requestFocus(
                                                      unitNameArFocusNode);
                                                },
                                                br: 10,
                                                borderFocusedColor:
                                                Colors.black,
                                                borderNormalColor: Colors.grey,
                                                fillColor: Colors.white,
                                                keyboardType:
                                                TextInputType.text,
                                                controller:
                                                cubit.unitNameEnController,
                                                focusNode: unitNameEnFocusNode,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Unit name (Arabic)',
                                              style: TextStyle(
                                                  fontSize: 25.sp,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: height * 0.012,
                                            ),
                                            Directionality(
                                              textDirection: TextDirection.rtl,
                                              child: Container(
                                                width: width * 0.14,
                                                child: def_TextFromField(
                                                  textDirection:
                                                  TextDirection.rtl,
                                                  fillColor: Colors.white,
                                                  br: 10,
                                                  borderFocusedColor:
                                                  Colors.black,
                                                  borderNormalColor:
                                                  Colors.grey,
                                                  keyboardType:
                                                  TextInputType.text,
                                                  controller:
                                                  cubit.unitNameArController,
                                                  focusNode: unitNameArFocusNode,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Container(
                              height: height * 0.38,
                              width: width * 0.45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white),
                              padding: EdgeInsets.only(
                                left: width * 0.02,
                                top: height * 0.02,
                                bottom: height * 0.02,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Units Info',
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: height * 0.08,
                                  ),
                                  cubit.unitsModel!.unitsList!.isNotEmpty
                                      ? SizedBox(
                                    height: height * 0.18,
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      physics: BouncingScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          Container(
                                            decoration: BoxDecoration(
                                              gradient:
                                              LinearGradient(colors: [
                                                Colors.red[900]!,
                                                Colors.red[700]!,
                                              ]),
                                              borderRadius:
                                              BorderRadius.circular(20),
                                            ),
                                            width: width * 0.15,
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  cubit
                                                      .unitsModel!
                                                      .unitsList![index]
                                                      .unitName!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp,
                                                      fontWeight:
                                                      FontWeight.w600),
                                                  maxLines: 1,
                                                ),

                                                SizedBox(
                                                  height: height * 0.03,
                                                ),
                                                Container(
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8)),
                                                    width: width * 0.06,
                                                    height: height * 0.04,
                                                    child: Material(
                                                      color:
                                                      Colors.transparent,
                                                      child: InkWell(
                                                        onTap: () {
                                                          cubit.deleteUnits(
                                                              id: cubit
                                                                  .unitsModel!
                                                                  .unitsList![
                                                              index]
                                                                  .id!);
                                                        },
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(8),
                                                        splashColor:
                                                        Colors.red,
                                                        child: Center(
                                                          child: Text(
                                                            'Delete',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                20.sp,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w400),
                                                          ),
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                      separatorBuilder:
                                          (BuildContext context,
                                          int index) =>
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                      itemCount: cubit
                                          .unitsModel!.unitsList!.length,
                                    ),
                                  )
                                      : Center(
                                    child: Text(
                                      'No Units Found',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                          fontSize: 30.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.03,
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
