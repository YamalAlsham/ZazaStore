import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/product/edit_product_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/edit_product_widgets.dart';

class EditProductUnits extends StatelessWidget {
  EditProductUnits({Key? key}) : super(key: key);

  var productUnitPriceFocusNode = FocusNode();

  var productUnitQuantityFocusNode = FocusNode();

  var productUnitDescGermanFocusNode = FocusNode();

  var productUnitDescEnglishFocusNode = FocusNode();

  var productUnitDescArabicFocusNode = FocusNode();

  var formKeyQuantity = GlobalKey<FormState>();

  var formKeyComplex = GlobalKey<FormState>();

  var formKeyComplexCreate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) =>
          EditProductCubit()..getProductUnits(productId: productId),
      child: BlocConsumer<EditProductCubit, EditProductState>(
        listener: (context, state) {
          var cubit = EditProductCubit.get(context);



          if (state is GetAllProductUnitsInfoSuccessState) {
            cubit.getUnitsNames();
            print('data come successfully');
          }
          if (state is GetAllProductUnitsInfoErrorState) {
            showToast(text: 'Error Data coming', state: ToastState.error);
          }
          /////////////////////////////////////////////////
          if (state is GetUnitsForProductSuccessState) {
            print('data come successfully');
          }
          if (state is GetUnitsForProductErrorState) {
            showToast(text: 'Error Data coming', state: ToastState.error);
          }
          /////////////////////////////////////////////////
          if (state is UpdateQuantityProductUnitSuccessState) {
            showToast(
                text: 'Quantity updated Successfully',
                state: ToastState.success);
            cubit.getProductUnits(productId: productId);
            cubit.clearControllers();
            GoRouter.of(context).pop();
          }
          if (state is UpdateQuantityProductUnitErrorState) {
            showToast(text: 'Cannot update quantity', state: ToastState.error);
          }

          ////////////////////////////////////////////////
          if (state is UpdateComplexProductUnitSuccessState) {
            showToast(
                text: 'Quantity updated Successfully',
                state: ToastState.success);
            cubit.getProductUnits(productId: productId);
            cubit.clearControllers();
            GoRouter.of(context).pop();
          }
          if (state is UpdateComplexProductUnitErrorState) {
            showToast(
                text: 'Cannot update product unit info',
                state: ToastState.error);
          }
          /////////////////////////////////////////////////////
          if (state is CreateProductUnitSuccessState) {
            showToast(
                text: 'Product Unit Created Successfully',
                state: ToastState.success);
            cubit.getProductUnits(productId: productId);
            cubit.clearControllers();
            GoRouter.of(context).pop();
          }
          if (state is CreateProductUnitErrorState) {
            showToast(
                text: 'Cannot create product unit', state: ToastState.error);
          }
          ////////////////////////////////////////////////////////////
          if (state is DeleteProductUnitSuccessState) {
            showToast(
                text: 'Product Unit Deleted Successfully',
                state: ToastState.success);
            cubit.getProductUnits(productId: productId);
          }
          if (state is DeleteProductUnitErrorState) {
            showToast(
                text: 'Cannot delete product unit', state: ToastState.error);
          }
        },
        builder: (context, state) {
          var cubit = EditProductCubit.get(context);
          return Scaffold(
            drawer: drawerWeb(width, height, context),
            appBar: appBarWeb(width, height, context),
            body: ConditionalBuilder(
              condition: cubit.productUnitForEditListModel!.isNotEmpty,
              builder: (context) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          TitleText(text: 'Edit Product Unit'),
                          Container(
                            width: width * 0.14,
                            height: height * 0.05,
                            child: ElevatedButton(
                              onPressed: () {
                                addNewProductUnitDialog(
                                    productId: productId,
                                    context: context,
                                    width: width,
                                    height: height,
                                    quantityFocusNode:
                                        productUnitQuantityFocusNode,
                                    priceFocusNode: productUnitPriceFocusNode,
                                    proUnitDescDuFocusNode:
                                        productUnitDescGermanFocusNode,
                                    proUnitDescEnFocusNode:
                                        productUnitDescEnglishFocusNode,
                                    proUnitDescArFocusNode:
                                        productUnitDescArabicFocusNode,
                                    formKey: formKeyComplexCreate,
                                    cubit: cubit);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                textStyle: const TextStyle(),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                'Create New Unit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 22.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.065,
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(),
                        itemCount: cubit.productUnitForEditListModel!.length,
                        separatorBuilder: (BuildContext context, int index) =>
                            SizedBox(
                          height: height * 0.02,
                        ),
                        itemBuilder: (context, index) => Container(
                          height: height * 0.28,
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.04),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                color: Colors.red.withOpacity(0.3),
                                blurRadius: 5,
                              )
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${productName}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30.sp,
                                        color: basicColor,
                                        letterSpacing: 1.5),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(
                                    height: height * 0.02,
                                  ),
                                  Text(
                                    'Quantity: ${cubit.productUnitForEditListModel![index].quantity}',
                                    style: TextStyle(
                                        fontSize: 30.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.grey),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    'Price: ${cubit.productUnitForEditListModel![index].price}\€',
                                    style: TextStyle(
                                      fontSize: 30.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  Text(
                                    'Unit Description: ${cubit.productUnitForEditListModel![index].productUnitDescModel!.productUnitDescDu}',
                                    style: TextStyle(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    textAlign: TextAlign.start,
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      awsDialogDeleteForOne(
                                          context,
                                          width,
                                          cubit,
                                          cubit
                                              .productUnitForEditListModel![
                                                  index]
                                              .productUnitId!,
                                          3,
                                          null,null);
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      textStyle: const TextStyle(),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20.sp),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          cubit.productUnitQuantityController
                                                  .text =
                                              cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .quantity!
                                                  .toString();

                                          editQuantityUnitProductDialog(
                                              productId: productId,
                                              productUnitId: cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .productUnitId!,
                                              quantity: cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .quantity!,
                                              context: context,
                                              width: width,
                                              height: height,
                                              formKey: formKeyQuantity,
                                              cubit: cubit);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: basicColor,
                                          textStyle: const TextStyle(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Edit Quantity',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width * 0.03,
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          cubit.productUnitPriceController
                                                  .text =
                                              cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .price!
                                                  .toString();
                                          cubit.productUnitDescriptionGermanController
                                                  .text =
                                              cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .productUnitDescModel!
                                                  .productUnitDescDu!;
                                          cubit.productUnitDescriptionEnglishController
                                                  .text =
                                              cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .productUnitDescModel!
                                                  .productUnitDescTranslationModel![
                                                      0]
                                                  .translation!;
                                          cubit.productUnitDescriptionArabicController
                                                  .text =
                                              cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .productUnitDescModel!
                                                  .productUnitDescTranslationModel![
                                                      1]
                                                  .translation!;

                                          editInfoUnitProductDialog(
                                              productUnitId: cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .productUnitId!,
                                              unitId: cubit
                                                  .productUnitForEditListModel![
                                                      index]
                                                  .unitId!,
                                              context: context,
                                              width: width,
                                              height: height,
                                              priceFocusNode:
                                                  productUnitPriceFocusNode,
                                              proUnitDescDuFocusNode:
                                                  productUnitDescGermanFocusNode,
                                              proUnitDescEnFocusNode:
                                                  productUnitDescEnglishFocusNode,
                                              proUnitDescArFocusNode:
                                                  productUnitDescArabicFocusNode,
                                              formKey: formKeyComplex,
                                              cubit: cubit);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: basicColor,
                                          textStyle: const TextStyle(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          'Edit Product Unit',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
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
