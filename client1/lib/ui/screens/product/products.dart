import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/logic/product/products_list_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/edit_product_widgets.dart';
import 'package:zaza_dashboard/ui/widgets/products_widgets.dart';

class ProductScreen extends StatelessWidget {
  ProductScreen({Key? key}) : super(key: key);

  var formKeyDiscount = GlobalKey<FormState>();

  var formKeyTax = GlobalKey<FormState>();

  var formKeySimple = GlobalKey<FormState>();

  var barcodeFocusNode = FocusNode();

  var proNameDuFocusNode = FocusNode();

  var proNameEnFocusNode = FocusNode();

  var proNameArFocusNode = FocusNode();

  var searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (context) => ProductsListCubit()
        ..getProducts(limit: limit, page: 0, sort: 'newest', search: ''),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          var cubit = HomeCubit.get(context);
          if (state is CreateDiscountForProductSuccessState) {
            cubit.clearDiscount();
            GoRouter.of(context).pop();
            ProductsListCubit.get(context).getProducts(
                limit: limit,
                page: ProductsListCubit.get(context).currentIndex,
                sort: 'newest',
                search: '');
            showToast(
                text: 'Discount Created Successfully',
                state: ToastState.success);
          }

          if (state is CreateDiscountForProductErrorState) {
            showToast(text: 'Discount Create Error', state: ToastState.error);
          }

          if (state is DeleteDiscountForProductSuccessState) {
            ProductsListCubit.get(context).getProducts(
                limit: limit,
                page: ProductsListCubit.get(context).currentIndex,
                sort: 'newest',
                search: '');
            showToast(
                text: 'Discount Deleted Successfully',
                state: ToastState.success);
          }

          if (state is DeleteDiscountForProductErrorState) {
            showToast(text: 'Discount Delete Error', state: ToastState.error);
          }

          ////////////////////////////////////////////////////////////////////
          // Edit Product

          // Edit Tax Product
          if (state is GetTaxForOneProductSuccessState) {
            cubit.getTaxesNames();
          }

          if (state is UpdateTaxForOneProductSuccessState) {
            cubit.taxesNamesModel = null;
            print('productsproductsproducts');
            showToast(
                text: 'Tax Edited Successfully', state: ToastState.success);
            ProductsListCubit.get(context).getProducts(
                limit: limit,
                page: cubit.currentIndex,
                sort: 'newest',
                search: '');
            GoRouter.of(context).pop();
          }

          ///////////
          // Edit Name Product

          if (state is GetSimpleDataProductSuccessState) {
            print('Edit data come Success');
          }

          if (state is GetSimpleDataProductErrorState) {
            print('Edit data Error');
          }

          if (state is UpdateSimpleDataProductSuccessState) {
            if (cubit.webImage == null) {
              showToast(text: 'Edited Successfully', state: ToastState.success);
              ProductsListCubit.get(context).getProducts(
                  limit: limit,
                  page: ProductsListCubit.get(context).currentIndex,
                  sort: 'newest',
                  search: '');
              cubit.clearProductControllers();
              GoRouter.of(context).pop();
            } else {
              cubit.editImageProduct(id: state.editedProModel.product!.id!);
            }
          }

          if (state is UpdateSimpleDataProductErrorState) {
            showToast(text: 'Cannot Update', state: ToastState.error);
          }

          if (state is EditProductPhotoSuccessState) {
            showToast(text: 'Edited Successfully', state: ToastState.success);
            ProductsListCubit.get(context).getProducts(
                limit: limit,
                page: ProductsListCubit.get(context).currentIndex,
                sort: 'newest',
                search: '');
            cubit.clearProductControllers();
            GoRouter.of(context).pop();
          }

          if (state is EditProductPhotoErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }
        },
        child: BlocConsumer<ProductsListCubit, ProductsListState>(
          listener: (context, state) {
            var cubit = ProductsListCubit.get(context);

            if (state is GetAllProductsErrorState) {
              showToast(
                  text: 'Error in getting products', state: ToastState.error);
            }

            if (state is DeleteOneProductSuccessState) {
              if (cubit.productsModel!.productsListChildren!.length == 1 &&
                  cubit.currentIndex > 0) {
                cubit.currentIndex--;
                print(cubit.paginationNumberSave);
                print(cubit.currentIndex);
              }

              showToast(
                  text: 'Deleted Successfully', state: ToastState.success);
              cubit.getProducts(
                  limit: limit,
                  page: cubit.currentIndex,
                  sort: 'newest',
                  search: '');
            }
            if (state is DeleteOneProductErrorState) {
              showToast(text: 'Delete Failed', state: ToastState.error);
            }

            if (state is CreateDiscountForProductSuccessState) {
              showToast(
                  text: 'Discount Created Successfully',
                  state: ToastState.error);
            }
            if (state is CreateDiscountForProductErrorState) {
              showToast(
                  text: 'Cannot Create Discount', state: ToastState.error);
            }

            if (state is EditDataCategorySuccessState) {
              print('Edit data come Success');
            }

            if (state is EditDataCategoryErrorState) {
              print('Edit data Error');
            }

            /*if (state is EditedCategorySuccessState) {
          if (cubit.webImage == null) {
            showToast(text: 'Edited Successfully', state: ToastState.success);
            cubit.getCategories(limit: limit, page: cubit.currentIndex);
            cubit.clearControllers();
            Navigator.pop(context);
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
          Navigator.pop(context);
        }

        if (state is EditedPhotoCategoryErrorState) {
          showToast(
              text: state.editedPhotoModel.message!, state: ToastState.error);
        }*/
          },
          builder: (context, state) {
            var cubit = ProductsListCubit.get(context);
            return Scaffold(
              drawer: drawerWeb(width, height, context),
              appBar: appBarWeb(width, height, context),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Product_Stack(height: height, width: width),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Search:',style: TextStyle(color: basicColor,fontSize: 30.sp,fontWeight: FontWeight.bold),),
                              SizedBox(width: width*0.03,),
                              Container(
                                height: height * 0.08,
                                width: width * 0.25,
                                child: def_TextFromField(
                                  keyboardType: TextInputType.text,
                                  controller: searchController,
                                  br: 12,
                                  onChanged: (val) {
                                    cubit.getProducts(
                                        limit: limit,
                                        page: cubit.currentIndex,
                                        sort: 'newest',
                                        search: 'name:${val}');
                                  },
                                  label: 'Search By Product Name',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                      ConditionalBuilder(
                        condition: cubit.productsModel != null,
                        builder: (context) => Container(
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
                                    'Number of Products: ${cubit.productsModel!.totalNumber}',
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
                              //Products
                              GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400,
                                  mainAxisExtent: width > 800 ? 420 : 280,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                physics: BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  String path =
                                      '${url}${cubit.productsModel!.productsListChildren![index].image}';
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
                                                          BorderRadius.circular(
                                                              15),
                                                      color: Colors.white),
                                                  child: Image.network(
                                                    path,
                                                    fit: BoxFit.contain,
                                                    width: double.infinity,
                                                  ),
                                                ),
                                                Text(
                                                  '#${cubit.productsModel!.productsListChildren![index].barCode!}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.yellow,
                                                      fontSize: 18.sp),
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            (cubit
                                                        .productsModel!
                                                        .productsListChildren![
                                                            index]
                                                        .discount !=
                                                    0 && cubit.productsModel!
                                                .productsListChildren![
                                            index]
                                                    .discountType != 'discountSpecificUsers')
                                                ? GestureDetector(
                                                    onTap: () {
                                                      awsDialogDeleteForOne(
                                                          context,
                                                          width,
                                                          HomeCubit.get(
                                                              context),
                                                          cubit
                                                              .productsModel!
                                                              .productsListChildren![
                                                                  index]
                                                              .discountId!,
                                                          2,
                                                          index,
                                                        cubit
                                                            .productsModel!
                                                            .productsListChildren![
                                                        index]
                                                            .discount,);

                                                      //awsDialogDeleteForDiscount(context, width, cubit, idToDelete, percent)
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal:
                                                                  width * 0.005,
                                                              vertical: height *
                                                                  0.01),
                                                      child: Container(
                                                        width: width < 400
                                                            ? width * 0.16
                                                            : width * 0.07,
                                                        height: height * 0.03,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: basicColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Discount: ${cubit.productsModel!.productsListChildren![index].discount}%',
                                                            //"${cubit.categoryLeafModel!.productsChildren![index].tax/discount}\$",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white,
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
                                            '${cubit.productsModel!.productsListChildren![index].productName!}',
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
                                            "${cubit.productsModel!.productsListChildren![index].productUnitListModel![0].unitName} (${cubit.productsModel!.productsListChildren![index].productUnitListModel![0].quantity})",
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
                                            "${cubit.productsModel!.productsListChildren![index].productUnitListModel![0].description}",
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
                                                    .productsModel!
                                                    .productsListChildren![
                                                        index]
                                                    .discount ==
                                                0
                                            ? Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Text(
                                                  "${cubit.productsModel!.productsListChildren![index].productUnitListModel![0].price}\€",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.red,
                                                      fontSize: 25.sp),
                                                  maxLines: 1,
                                                ),
                                              )
                                            : Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0),
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: primaryColor,
                                                          width: 1,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: width * 0.01,
                                                    ),
                                                    Text(
                                                      "${(cubit.productsModel!.productsListChildren![index].productUnitListModel![0].price) * (100 - cubit.productsModel!.productsListChildren![index].discount!) / 100}\€",
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              SpeedDial(
                                                icon: Icons.edit,
                                                backgroundColor: Colors.red,
                                                overlayColor: Colors.black,
                                                overlayOpacity: 0.4,
                                                spacing: 12,
                                                buttonSize: Size(iconSmallSize,
                                                    iconSmallSize),
                                                spaceBetweenChildren: 12,
                                                children: [
                                                  SpeedDialChild(
                                                      child:
                                                          Icon(Icons.ad_units),
                                                      label:
                                                          'Edit Product Unit',
                                                      onTap: () {
                                                        productId = cubit
                                                            .productsModel!
                                                            .productsListChildren![
                                                                index]
                                                            .productId;
                                                        productName = cubit
                                                            .productsModel!
                                                            .productsListChildren![
                                                                index]
                                                            .productName!;
                                                        print(
                                                            'productId=${productId}');
                                                        print(
                                                            'productName=${productName}');
                                                        GoRouter.of(context)
                                                            .go(
                                                                '/products/edit-product-units/${productId}');
                                                      }),
                                                  SpeedDialChild(
                                                      child: Icon(Icons.edit),
                                                      label:
                                                          'Edit Name & Image',
                                                      onTap: () {
                                                        HomeCubit.get(context)
                                                            .getSimpleDataProductName(
                                                                productId: cubit
                                                                    .productsModel!
                                                                    .productsListChildren![
                                                                        index]
                                                                    .productId!);
                                                        editSimpleProductDialog(
                                                            productId: cubit
                                                                .productsModel!
                                                                .productsListChildren![
                                                                    index]
                                                                .productId!,
                                                            context: context,
                                                            width: width,
                                                            height: height,
                                                            barCodeFocusNode:
                                                                barcodeFocusNode,
                                                            proNameDuFocusNode:
                                                                proNameDuFocusNode,
                                                            proNameEnFocusNode:
                                                                proNameEnFocusNode,
                                                            proNameArFocusNode:
                                                                proNameArFocusNode,
                                                            formKey:
                                                                formKeySimple,
                                                            cubit:
                                                                HomeCubit.get(
                                                                    context));
                                                      }),
                                                  SpeedDialChild(
                                                      child:
                                                          Icon(Icons.discount),
                                                      label: 'Edit Tax',
                                                      onTap: () {
                                                        HomeCubit.get(context)
                                                            .getTaxProductName(
                                                                productId: cubit
                                                                    .productsModel!
                                                                    .productsListChildren![
                                                                        index]
                                                                    .productId!);

                                                        editTaxForProductDialog(
                                                            productId: cubit
                                                                .productsModel!
                                                                .productsListChildren![
                                                                    index]
                                                                .productId!,
                                                            context: context,
                                                            width: width,
                                                            height: height,
                                                            formKey: formKeyTax,
                                                            cubit:
                                                                HomeCubit.get(
                                                                    context));
                                                      }),
                                                ],
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  awsDialogDeleteForOne(
                                                      context,
                                                      width,
                                                      cubit,
                                                      cubit
                                                          .productsModel!
                                                          .productsListChildren![
                                                              index]
                                                          .productId!,
                                                      1,
                                                      null,
                                                      null);
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
                                                    size: iconSmallSize - 26.0,
                                                  ),
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  createDiscountDialog(
                                                      productId: cubit
                                                          .productsModel!
                                                          .productsListChildren![
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
                                                    size: iconSmallSize - 26.0,
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
                                itemCount: cubit.productsModel!
                                    .productsListChildren!.length,
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              productPagination(context, width, height, cubit),
                            ],
                          ),
                        ),
                        fallback: (context) => SpinKitWeb(width),
                      ),
                      SizedBox(
                        height: height * 0.01,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
