import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/products_widgets.dart';
import 'package:zaza_dashboard/ui/widgets/user_widgets.dart';

class DiscountSpecificUser extends StatelessWidget {
  DiscountSpecificUser({Key? key}) : super(key: key);

  var searchController = TextEditingController();


  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocProvider.value(
      value: UserProfileCubit()
        ..getProducts(limit: limit, page: 0, sort: 'newest', search: ''),
      child: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          var cubit = UserProfileCubit.get(context);
          if (state is AddUserDiscountsSuccessState) {
            cubit.clear();
            GoRouter.of(context).pop();
            cubit.getProducts(limit: limit, page: cubit.currentIndex, sort: 'newest', search: searchController.text);
            //cubit.getDiscountProductsForUser(user_id: userIdToUser);
          }

          if (state is AddUserDiscountsErrorState) {
            showToast(text: 'Discount Create Error', state: ToastState.error);
          }

          if (state is GetAllProductsForDiscountSuccessState) {
            print('data come true');
          }

          if (state is GetAllProductsForDiscountErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }
        },
        builder: (context, state) {
          var cubit = UserProfileCubit.get(context);
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
                    SizedBox(
                      height: height * 0.03,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                            Specific_Discount_Stack(
                                height: height, width: width),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Search:',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600,fontSize: 28.sp),),
                            SizedBox(width: width*0.02,),
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
                      height: height * 0.02,
                    ),
                    ConditionalBuilder(
                      condition: cubit.productsForDiscountModel != null,
                      builder: (context) => Column(
                        children: [
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
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      'Search For Products And Add Discount To User',
                                      style: TextStyle(
                                          fontSize: 22.sp,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.grey),
                                    ),
                                    Text(
                                      'Number of Products: ${cubit.productsForDiscountModel!.totalNumber}',
                                      style: TextStyle(
                                          fontSize: 25.sp,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey),
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
                                        '${url}${cubit.productsForDiscountModel!.productsListChildren![index].image}';
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
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    height: height * 0.18,
                                                    width: double.infinity,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color: Colors.white),
                                                    child: Image.network(
                                                      path,
                                                      fit: BoxFit.contain,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                  Text(
                                                    '#${cubit.productsForDiscountModel!.productsListChildren![index].barCode!}',
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
                                                  .productsForDiscountModel!
                                                  .productsListChildren![
                                              index]
                                                  .discount !=
                                                  0 && cubit.productsForDiscountModel!
                                        .productsListChildren![
                                    index]
                                        .discountType != 'discountSpecificUsers')
                                                  ? Positioned(
                                                      right: 0.0,
                                                      top: 0.0,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    width *
                                                                        0.005,
                                                                vertical:
                                                                    height *
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
                                                                    .circular(
                                                                        12),
                                                          ),
                                                          child: Center(
                                                            child: Text(
                                                              'Discount: ${cubit.productsForDiscountModel!.productsListChildren![index].discount}%',
                                                              //"${cubit.categoryLeafModel!.productsChildren![index].tax/discount}\$",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: width <
                                                                          400
                                                                      ? 5.sp
                                                                      : 15.sp),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ) : Container(),
                                            ],
                                          ),
                                          SizedBox(
                                            height: height * 0.01,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Text(
                                              '${cubit.productsForDiscountModel!.productsListChildren![index].productName!}',
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
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Text(
                                              "${cubit.productsForDiscountModel!.productsListChildren![index].productUnitListModel![0].unitName} (${cubit.productsForDiscountModel!.productsListChildren![index].productUnitListModel![0].quantity})",
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
                                            padding: const EdgeInsets.only(
                                                left: 15.0),
                                            child: Text(
                                              "${cubit.productsForDiscountModel!.productsListChildren![index].productUnitListModel![0].description}",
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
                                                      .productsForDiscountModel!
                                                      .productsListChildren![
                                                          index]
                                                      .discount ==
                                                  0
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0),
                                                  child: Text(
                                                    "${cubit.productsForDiscountModel!.productsListChildren![index].productUnitListModel![0].price}\€",
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
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
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
                                                        "${(cubit.productsForDiscountModel!.productsListChildren![index].productUnitListModel![0].price) * (100 - cubit.productsForDiscountModel!.productsListChildren![index].discount!) / 100}\€",
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
                                          Center(
                                            child: Container(
                                              width: width * 0.1,
                                              height: height * 0.038,
                                              decoration: BoxDecoration(
                                                color: basicColor,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: basicColor,
                                                  textStyle: const TextStyle(),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  createDiscountForUserDialog(userId: userIdToUser, product_id: cubit.productsForDiscountModel!.productsListChildren![index].productId!, context: context, width: width, height: height, formKey: formKey, cubit: cubit);
                                                },
                                                child: Center(
                                                  child: Text(
                                                    'Add Discount',
                                                    style: TextStyle(
                                                      fontSize: 19.sp,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                  itemCount: cubit.productsForDiscountModel!
                                      .productsListChildren!.length,
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
                      fallback: (context) => SpinKitWeb(width),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
