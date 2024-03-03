import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/logic/product/edit_product_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

List<String> ll = ['', ''];

Widget drop_edit_tax({
  required context,
  required double height,
  required double width,
  required HomeCubit cubit,
}) {
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration: drop_decoration(),
      isExpanded: false,
      hint: Text(
        'Choose Tax',
        style: TextStyle(fontSize: width / 110, color: Colors.black54),
      ),
      items: cubit.taxesNamesModel!.taxesListModel!
          .map((item) => DropdownMenuItem<int>(
                value: item.taxId,
                child: Text(
                  item.taxName!,
                  style: TextStyle(fontSize: width / 110, color: Colors.black),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Tax';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeEditedTaxId(value);
        //print(MarksCubit.get(context).selected_section);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData: drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}

Future<String?> editTaxForProductDialog(
        {required int productId,
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
            child: Text(
              'Update Tax',
              style: TextStyle(
                  color: basicColor,
                  fontSize: 50.sp,
                  fontWeight: FontWeight.bold),
            )),
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
                  height: height * 0.15,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: ConditionalBuilder(
                      condition: cubit.taxesNamesModel != null,
                      builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Tax Product Name:  ${cubit.getTaxProductModel!.taxNameForProductModel!.taxNameForProductModel!.taxName}',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          drop_edit_tax(
                              context: context,
                              height: height,
                              width: width,
                              cubit: cubit),
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
              cubit.taxesNamesModel = null;
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
                    () => cubit.editProductTax(productId: productId));
              }
            },
            child: Text(
              'Update',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

// Edit Simple Product

Future<String?> editSimpleProductDialog(
        {required int productId,
        required context,
        required width,
        required height,
        required barCodeFocusNode,
        required proNameDuFocusNode,
        required proNameEnFocusNode,
        required proNameArFocusNode,
        required formKey,
        required HomeCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Edit Product Info",
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
                  height: height * 0.8,
                  width: width * 0.55,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: ConditionalBuilder(
                      condition: cubit.getSimpleDataForProductModel != null,
                      builder: (context) => Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Product Image',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: GestureDetector(
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
                                        height: height * 0.22,
                                        width: width * 0.22,
                                        child: cubit.webImage != null
                                            ? Image.memory(
                                                cubit.webImage!,
                                          fit: BoxFit.contain,
                                              )
                                            : Image.network(
                                                '${url}${cubit.getSimpleDataForProductModel!.image!}',
                                          fit: BoxFit.contain,
                                              ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: width * 0.012,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Barcode',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Container(
                                    width: width * 0.2,
                                    child: def_TextFromField(
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(proNameDuFocusNode);
                                      },
                                      fillColor: Colors.white,
                                      keyboardType: TextInputType.text,
                                      controller: cubit.barcodeController,
                                      focusNode: barCodeFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
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
                            ],
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            'Product Name (German)',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(proNameEnFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller: cubit.proNameDuController,
                            focusNode: proNameDuFocusNode,
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Product Name';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            'Product Name (English)',
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
                                  .requestFocus(proNameArFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller: cubit.proNameEnController,
                            focusNode: proNameEnFocusNode,
                          ),
                          SizedBox(
                            height: height * 0.03,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'اسم المنتج',
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
                              controller: cubit.proNameArController,
                              focusNode: proNameArFocusNode,
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
              cubit.clearProductControllers();
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
                    () => cubit.editProductSimpleData(
                        productId: productId,
                        parentCategoryId: cubit
                            .getSimpleDataForProductModel!.parentCategoryId!,
                        barCode: cubit.barcodeController.text,
                        productNameDu: cubit.proNameDuController.text,
                        productNameEn: cubit.proNameEnController.text,
                        productNameAr: cubit.proNameArController.text));
              }
            },
            child: Text(
              'Update',
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

// Edit Complex

//Edit Quantity

Future<String?> editQuantityUnitProductDialog(
        {required int productId,
        required int quantity,
        required int productUnitId,
        required context,
        required width,
        required height,
        required formKey,
        required EditProductCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Edit Product Unit Quantity",
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
                  height: height * 0.2,
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
                          'Quantity',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.productUnitQuantityController,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Quantity';
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
                    () => cubit.editQuantityForUnit(
                        quantity:
                            int.parse(cubit.productUnitQuantityController.text),
                        productId: productId,
                        productUnitId: productUnitId));
              }
            },
            child: Text(
              'Update',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

// Edit Complex

// Edit Product Unit Info

Future<String?> editInfoUnitProductDialog(
        {required int productUnitId,
        required int unitId,
        required context,
        required width,
        required height,
        required priceFocusNode,
        required proUnitDescDuFocusNode,
        required proUnitDescEnFocusNode,
        required proUnitDescArFocusNode,
        required formKey,
        required EditProductCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Edit Product Unit Info",
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
                  height: height * 0.6,
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
                          'Price',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(proUnitDescDuFocusNode);
                          },
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.productUnitPriceController,
                          focusNode: priceFocusNode,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Price';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Unit Description (German)',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(proUnitDescEnFocusNode);
                          },
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller:
                              cubit.productUnitDescriptionGermanController,
                          focusNode: proUnitDescDuFocusNode,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Unit Description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Text(
                          'Unit Description (English)',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          onFieldSubmitted: (value) {
                            FocusScope.of(context)
                                .requestFocus(proUnitDescArFocusNode);
                          },
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller:
                              cubit.productUnitDescriptionEnglishController,
                          focusNode: proUnitDescEnFocusNode,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Unit Description';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: height * 0.025,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'وصف واحدة المنتج',
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
                            controller:
                                cubit.productUnitDescriptionArabicController,
                            focusNode: proUnitDescArFocusNode,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Unit Description';
                              }
                              return null;
                            },
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
              EasyDebounce.debounce(
                  'my-debouncer',
                  Duration(milliseconds: 500),
                  () => cubit.editComplexProductForUnit(
                      unitId: unitId,
                      productUnitId: productUnitId,
                      price: int.parse(cubit.productUnitPriceController.text),
                      unitDescDu:
                          cubit.productUnitDescriptionGermanController.text,
                      unitDescEn:
                          cubit.productUnitDescriptionEnglishController.text,
                      unitDescAr:
                          cubit.productUnitDescriptionArabicController.text));
            },
            child: Text(
              'Update',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

// Add New Product Unit

Future<String?> addNewProductUnitDialog(
        {required int productId,
        required context,
        required width,
        required height,
        required quantityFocusNode,
        required priceFocusNode,
        required proUnitDescDuFocusNode,
        required proUnitDescEnFocusNode,
        required proUnitDescArFocusNode,
        required formKey,
        required EditProductCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Add New Product Unit",
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
                  height: height * 0.55,
                  width: width * 0.45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Form(
                    key: formKey,
                    child: ConditionalBuilder(
                      condition: true,
                      builder:(context)=> Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: TextStyle(
                                        fontSize: 30.sp, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Container(
                                    width: width*0.12,
                                    child: def_TextFromField(
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context).requestFocus(priceFocusNode);
                                      },
                                      fillColor: Colors.white,
                                      keyboardType: TextInputType.text,
                                      controller: cubit.productUnitQuantityController,
                                      focusNode: quantityFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Price',
                                    style: TextStyle(
                                        fontSize: 30.sp, fontWeight: FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: height * 0.012,
                                  ),
                                  Container(
                                    width: width*0.12,
                                    child: def_TextFromField(
                                      onFieldSubmitted: (value) {
                                        FocusScope.of(context)
                                            .requestFocus(proUnitDescDuFocusNode);
                                      },
                                      fillColor: Colors.white,
                                      keyboardType: TextInputType.text,
                                      controller: cubit.productUnitPriceController,
                                      focusNode: priceFocusNode,
                                      br: 10,
                                      borderFocusedColor: Colors.black,
                                      borderNormalColor: Colors.grey,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Unit',
                                    style: TextStyle(
                                        fontSize: 30.sp, fontWeight: FontWeight.w600),
                                  ),

                                  Padding(
                                    padding: EdgeInsets.only(top: height*0.01),
                                      child: drop_add_new_unit(context: context, height: height, width: width, cubit: cubit)),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(
                            height: height * 0.03,
                          ),
                          Text(
                            'Unit Description (German)',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(proUnitDescEnFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller:
                                cubit.productUnitDescriptionGermanController,
                            focusNode: proUnitDescDuFocusNode,
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Unit Description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          Text(
                            'Unit Description (English)',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(proUnitDescArFocusNode);
                            },
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller:
                                cubit.productUnitDescriptionEnglishController,
                            focusNode: proUnitDescEnFocusNode,
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Unit Description';
                              }
                              return null;
                            },
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          Text(
                            'Unit Description (Arabic)',
                            style: TextStyle(
                                fontSize: 30.sp, fontWeight: FontWeight.w600),
                          ),
                          SizedBox(
                            height: height * 0.012,
                          ),
                          def_TextFromField(
                            fillColor: Colors.white,
                            keyboardType: TextInputType.text,
                            controller:
                                cubit.productUnitDescriptionArabicController,
                            focusNode: proUnitDescArFocusNode,
                            br: 10,
                            borderFocusedColor: Colors.black,
                            borderNormalColor: Colors.grey,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter Unit Description';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                      fallback: (context)=> SpinKitWeb(width),
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
                EasyDebounce.debounce('my-debouncer', Duration(milliseconds: 500),
              () => cubit.createNewUnitForProduct(
                    productId: productId,
                    unitId: cubit.unitId!,
                    price: int.parse(cubit.productUnitPriceController.text),
                    quantity:
                        int.parse(cubit.productUnitQuantityController.text),
                    unitDescDu:
                        cubit.productUnitDescriptionGermanController.text,
                    unitDescEn:
                        cubit.productUnitDescriptionEnglishController.text,
                    unitDescAr:
                        cubit.productUnitDescriptionArabicController.text));
              }
            },
            child: Text(
              'Add',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );



Widget drop_add_new_unit({
  required context,
  required double height,
  required double width,
  required EditProductCubit cubit,
}){
  return Container(
    width: width * 0.12,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Unit',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: cubit.unitsNamesForProductModel!.unitsListModel!
          .map((item) => DropdownMenuItem<int>(
        value: item.unitId,
        child: Text(
          item.unitName!,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Unit';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeDropDownUnits(value);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}
