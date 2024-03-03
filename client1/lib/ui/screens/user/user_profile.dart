import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/orders_widgets.dart';
import 'package:zaza_dashboard/ui/widgets/user_widgets.dart';

class UserProfile extends StatelessWidget {
  UserProfile({Key? key}) : super(key: key);

  var formKeyDiscount = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider.value(
  value: UserProfileCubit()..getUserProfile(user_id: userIdToUser),
  child: BlocConsumer<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        var cubit = UserProfileCubit.get(context);

        if (state is UserProfileErrorState) {
          showToast(text: 'Profile not found', state: ToastState.error);
        }

        if (state is UserProfileSuccessState) {
          cubit.getDiscountProductsForUser(user_id: userIdToUser);
        }
        if (state is GetUserDiscountsSuccessState) {
          cubit.getOrders(
              limit: limitOrders, page: 0, sort: 'newest', user_id: userIdToUser);
        }

        if (state is DeleteUserDiscountsSuccessState) {
          showToast(text: 'Deleted Successfully', state: ToastState.success);
        }
        if (state is DeleteUserDiscountsErrorState) {
          showToast(text: state.errorModel.message!, state: ToastState.error);
        }

        if (state is EditUserDiscountsSuccessState) {
          showToast(text: 'Edited Successfully', state: ToastState.success);
          GoRouter.of(context).pop();
        }
        if (state is EditUserDiscountsErrorState) {
          showToast(text: state.errorModel.message!, state: ToastState.error);
        }
      },
      builder: (context, state) {
        var cubit = UserProfileCubit.get(context);
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: appBarWeb(width, height, context),
          drawer: drawerWeb(width, height, context),
          body: ConditionalBuilder(
            condition: cubit.generalOrdersModel != null,
            builder: (context) => SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04, vertical: height * 0.01),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              width: width * 0.01,
                            ),
                            User_Stack(height: height, width: width),
                          ],
                        ),
                        Icon(
                          Icons.person,
                          size: 60.sp,
                          color: basicColor,
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            height: height * 0.38,
                            width: width * 0.44,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: primaryColor,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 3),
                                  color: Colors.redAccent.withOpacity(0.2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                                vertical: height * 0.001),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 28.sp,
                                    ),
                                    SizedBox(
                                      width: width * 0.01,
                                    ),
                                    Text(
                                      'User Information',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 32.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: height * 0.01,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Restaurant Name: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.sp),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '${cubit.userProfileModel!.name}',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23.sp),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.035,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Username: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.sp),
                                            ),
                                            Text(
                                              '${cubit.userProfileModel!.userName}',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23.sp),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: height * 0.035,
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Email: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 22.sp),
                                            ),
                                            Text(
                                              '${cubit.userProfileModel!.email}',
                                              style: TextStyle(
                                                  color: Colors.redAccent,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 23.sp),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Phone Numbers',
                                          style: TextStyle(
                                              fontSize: 24.sp,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        SizedBox(
                                          height: height * 0.01,
                                        ),
                                        Container(
                                            width: width * 0.15,
                                            height: height*0.14,
                                            decoration: BoxDecoration(
                                              color: backgroundColor,
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              border: Border.all(
                                                color: basicColor,
                                                width: 1,
                                              ),
                                            ),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: width * 0.012,
                                                vertical: height * 0.016),
                                            child: Center(
                                              child: ListView.separated(
                                                shrinkWrap: true,
                                                  itemBuilder: (context,
                                                          index) =>
                                                      Row(
                                                        children: [
                                                          Text(
                                                            '${cubit.userProfileModel!.phonesList![index].number_code}  ',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 20.sp,
                                                                color:
                                                                    basicColor),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 1,
                                                          ),
                                                          SizedBox(
                                                              width:
                                                                  width * 0.07,
                                                              child: Text(
                                                                '${cubit.userProfileModel!.phonesList![index].number}',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontSize:
                                                                        18.sp,
                                                                    color: Colors
                                                                        .grey),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 1,
                                                              )),
                                                        ],
                                                      ),
                                                  physics:
                                                      NeverScrollableScrollPhysics(),
                                                  separatorBuilder:
                                                      (BuildContext context,
                                                              int index) =>
                                                          SizedBox(
                                                            height:
                                                                height * 0.01,
                                                          ),
                                                  itemCount: cubit
                                                      .userProfileModel!
                                                      .phonesList!
                                                      .length),
                                            )),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            )),
                        Container(
                          height: height * 0.38,
                          width: width * 0.44,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: primaryColor,
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: const Offset(0, 3),
                                color: Colors.redAccent.withOpacity(0.2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: width * 0.02,
                              vertical: height * 0.01),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.discount,
                                        color: Colors.grey,
                                        size: 28.sp,
                                      ),
                                      SizedBox(
                                        width: width * 0.01,
                                      ),
                                      Text(
                                        'Discounts For User',
                                        style: TextStyle(
                                            fontSize: 32.sp,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.grey),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: width * 0.1,
                                    height: height * 0.038,
                                    decoration: BoxDecoration(
                                      color: basicColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: basicColor,
                                        textStyle: const TextStyle(),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () {
                                        GoRouter.of(context).go('/users/user-profile/${userIdToUser}/discount-specific-user');
                                      },
                                      child: Center(
                                        child: Text(
                                          'Add Discount',
                                          style: TextStyle(
                                            fontSize: 19.sp,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: height * 0.02,
                              ),
                              cubit.discountSpecificUserModel!
                                      .discountUserProductDataList!.isNotEmpty
                                  ? Expanded(
                                      child: ListView.separated(
                                          physics: BouncingScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            String path =
                                                '${url}${cubit.discountSpecificUserModel!.discountUserProductDataList![index].productDiscountForUser!.image}';
                                            return Stack(
                                              children: [
                                                Container(
                                                  width: width * 0.18,
                                                  decoration: BoxDecoration(
                                                    color: backgroundColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: height * 0.16,
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color:
                                                                Colors.white),
                                                        child: Image.network(
                                                          path,
                                                          fit: BoxFit.contain,
                                                          width:
                                                              double.infinity,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0),
                                                        child: Text(
                                                          '${cubit.discountSpecificUserModel!.discountUserProductDataList![index].productDiscountForUser!.textContent!.originalText}',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20.sp),
                                                          maxLines: 2,
                                                        ),
                                                      ),
                                                      /*cubit
                                                .productsModel!
                                                .productsListChildren![
                                            index]
                                                .discount ==
                                                0
                                                ? Padding(
                                              padding:
                                              const EdgeInsets.only(
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
                                              padding:
                                              const EdgeInsets.only(
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
                                            ),*/
                                                      Container(
                                                        width: width * 0.074,
                                                        height: height * 0.032,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: basicColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(8),
                                                        ),
                                                        child: ElevatedButton(
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                basicColor,
                                                            textStyle:
                                                                const TextStyle(),
                                                            shape:
                                                                RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            cubit.editDiscountForUserController
                                                                    .text =
                                                                cubit
                                                                    .discountSpecificUserModel!
                                                                    .discountUserProductDataList![
                                                                        index]
                                                                    .percent!
                                                                    .toString();
                                                            editDiscountForUserDialog(
                                                                discountPrUsId: cubit
                                                                    .discountSpecificUserModel!
                                                                    .discountUserProductDataList![
                                                                        index]
                                                                    .discountUsPrId!,
                                                                context:
                                                                    context,
                                                                width: width,
                                                                height: height,
                                                                index: index,
                                                                formKey:
                                                                    formKeyDiscount,
                                                                cubit: cubit);
                                                          },
                                                          child: Center(
                                                            child: Text(
                                                              'Edit Discount',
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                  right: 0.0,
                                                  top: 0.0,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      awsDialogDeleteForOne(
                                                          context,
                                                          width,
                                                          cubit,
                                                          cubit
                                                              .discountSpecificUserModel!
                                                              .discountUserProductDataList![
                                                                  index]
                                                              .discountUsPrId!,
                                                          5,
                                                          index,
                                                          null);
                                                    },
                                                    child: Container(
                                                      width: iconSmallSize,
                                                      height: iconSmallSize,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(100),
                                                        color: Colors.red,
                                                      ),
                                                      child: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                        size: iconSmallSize -
                                                            26.0,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Positioned(
                                                  left: 0.0,
                                                  top: 0.0,
                                                  child: Container(
                                                    width: iconSmallSize,
                                                    height: iconSmallSize,
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100.r),
                                                      color: Colors.red,
                                                    ),
                                                    child: Center(
                                                      child: Text(
                                                        '${cubit.discountSpecificUserModel!.discountUserProductDataList![index].percent}%',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w300),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  SizedBox(
                                                    width: width * 0.02,
                                                  ),
                                          itemCount: cubit
                                              .discountSpecificUserModel!
                                              .discountUserProductDataList!
                                              .length),
                                    )
                                  : Padding(
                                    padding: EdgeInsets.symmetric(vertical: height*0.04),
                                    child: Center(
                                        child: Text(
                                          'No Discounts for this user',
                                          style: TextStyle(
                                              color: basicColor,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 35.sp),
                                        ),
                                      ),
                                  )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              size: 40.sp,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: width * 0.01,
                            ),
                            Text(
                              'Orders',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 38.sp,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: height*0.02,),
                    cubit.generalOrdersModel!.ordersList!.isNotEmpty ? SizedBox(
                      height: height*0.5,
                      child: ListView.separated(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return OrderCard(
                              index,
                              width,
                              height,
                              context,
                              cubit,
                              cubit.generalOrdersModel!
                                  .ordersList![index].order_id!,
                              cubit.generalOrdersModel!
                                  .ordersList![index].totalPrice,
                              cubit.generalOrdersModel!
                                  .ordersList![index].createdAt!,
                              cubit.generalOrdersModel!
                                  .ordersList![index].status!,
                              cubit.generalOrdersModel!.ordersList![index]!.user!.name!,
                              cubit.generalOrdersModel!.ordersList![index]!.user!.userName!,
                              cubit.generalOrdersModel!.ordersList![index]!.user!.email!,
                              1,
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                width: width * 0.04,
                              ),
                          itemCount: cubit.generalOrdersModel!.ordersList!.length),
                    ) : Padding(padding: EdgeInsets.symmetric(vertical: height*0.05),child: Center(child: Text("No Orders Sent",style: TextStyle(color: basicColor,fontSize: 45.sp,fontWeight: FontWeight.w600),)),),

                    SizedBox(height: height*0.04,),
                  ],
                ),
              ),
            ),
            fallback: (context) => SpinKitWeb(width),
          ),
          //floatingActionButton: sortFloatingButton(cubit),
        );
      },
    ),
);
  }
}
