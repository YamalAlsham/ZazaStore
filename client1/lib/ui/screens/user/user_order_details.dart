import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

class UserOrderDetails extends StatelessWidget {
  const UserOrderDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return BlocProvider.value(
      value: UserProfileCubit()..getOrderDetailsForUser(order_id: orderId),
      child: BlocConsumer<UserProfileCubit, UserProfileState>(
        listener: (context, state) {
          var cubit = UserProfileCubit.get(context);

          if (state is GetAllOrderDetailsSuccessState) {
            print('data comes true');
          }

          if (state is GetAllOrderDetailsErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

          if (state is UpdateStatusSuccessState) {
            cubit.getOrders(limit: limit, page: cubit.currentIndex, sort: 'newest', user_id: userIdToUser);
          }

          if (state is UpdateStatusErrorState) {
            showToast(text: state.errorModel.message!, state: ToastState.error);
          }

        },
        builder: (context, state) {
          var cubit = UserProfileCubit.get(context);
          //DateTime inputDate = DateTime.parse(cubit.orderDetailsModel!.createdAt!);
          //String outputDateString = DateFormat("yyyy/MM/dd : HH:m:s").format(inputDate);
          var formatter = NumberFormat('#,###');
          var formattedNumber1 = formatter.format(1500);
          return Scaffold(
            backgroundColor: backgroundColor,
            appBar: appBarWeb(width, height, context),
            drawer: drawerWeb(width, height, context),
            body: ConditionalBuilder(
              condition: cubit.orderDetailsForUserModel != null,
              builder: (context) => SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: width * 0.04, vertical: height * 0.03),
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
                              TitleText(text: 'Order Details'),
                            ],
                          ),
                          Icon(
                            Icons.shopping_cart,
                            color: Colors.red,
                            size: 65.sp,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.06,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: height * 0.3,
                            width: width * 0.5,
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
                                horizontal: width * 0.02, vertical: height * 0.01),
                            child: Row(
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        /*Text('Status: ',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),
                                            Text('${cubit.orderDetailsModel!.status}',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),*/

                                        Text(
                                          'Status: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        cubit.orderDetailsForUserModel!.status == 'approved'
                                            ? Text(
                                          'Approved',
                                          style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                            : cubit.orderDetailsForUserModel!.status ==
                                            'pending'
                                            ? Text(
                                          'Pending',
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w600),
                                        )
                                            : Text(
                                          'Rejected',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        /*Text('Invoice Value: ',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                                            Text('${cubit.orderDetailsModel!.totalPrice}\€',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),*/
                                        Text(
                                          'Invoice Value: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.145,
                                          child: Text(
                                            '${NumberFormat('#,###').format(cubit.orderDetailsForUserModel!.totalPrice)}\€',
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '${DateFormat("yyyy/MM/dd : HH:m:s").format(DateTime.parse(cubit.orderDetailsForUserModel!.createdAt!))}',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 23.sp,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    //  Text('${cubit.orderDetailsModel!.createdAt}',style: TextStyle(color: Colors.grey,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        /*Text('Status: ',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),
                                            Text('${cubit.orderDetailsModel!.status}',style: TextStyle(color: Colors.black,fontSize: 16.sp,fontWeight: FontWeight.w600),),*/

                                        Text(
                                          'Restaurant: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.1,
                                          child: Text(
                                            '${nameGlobal}',
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        /*Text('Invoice Value: ',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),
                                            Text('${cubit.orderDetailsModel!.totalPrice}\€',style: TextStyle(color: Colors.black,fontSize: 12.sp,fontWeight: FontWeight.w400),),*/
                                        Text(
                                          'UserName: ',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          width: width * 0.1,
                                          child: Text(
                                            '${userNameGlobal}',
                                            style: TextStyle(
                                                color: basicColor,
                                                fontSize: 24.sp,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                //Image.asset(''),
                              ],
                            ),
                          ),
                          Container(
                            height: height * 0.3,
                            width: width * 0.3,
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
                                horizontal: width * 0.02, vertical: height * 0.01),
                            child: cubit.orderDetailsForUserModel!.status == 'pending' ? Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  'Update Order Status: ',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 28.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      width: width * 0.1,
                                      height: height * 0.038,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          textStyle: const TextStyle(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          awsDialogChangeStatusToRejected(context, width, cubit, orderId);
                                        },
                                        child: Center(
                                          child: Text(
                                            'Reject',
                                            style: TextStyle(
                                              fontSize: 19.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: width * 0.1,
                                      height: height * 0.038,
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          textStyle: const TextStyle(),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          awsDialogChangeStatusToApproved(context, width, cubit, orderId);
                                        },
                                        child: Center(
                                          child: Text(
                                            'Approve',
                                            style: TextStyle(
                                              fontSize: 19.sp,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ) : cubit.orderDetailsForUserModel!.status == 'approved' ? Icon(Icons.check,color: Colors.green,size: 60.sp,) : Icon(Icons.close,color: Colors.red,size: 60.sp,),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.04,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.add_shopping_cart,
                                color: seconderyColor,
                                size: 20.sp,
                              ),
                              Text(
                                'Ordered Product',
                                style: TextStyle(
                                    color: seconderyColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 25.sp),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.02,
                      ),
                      SizedBox(
                        width: width*0.45,
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context, mainIndex) {
                            var path =
                                '${url}${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].image}';
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 3),
                                    color: Colors.redAccent.withOpacity(0.2),
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: width * 0.03,
                                  vertical: height * 0.01),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Image.network(
                                        path,
                                        width: width * 0.2,
                                        height: height * 0.12,
                                        fit: BoxFit.contain,
                                      ),
                                      SizedBox(
                                        width: width * 0.005,
                                      ),
                                      SizedBox(
                                        width: width * 0.15,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].productName}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 24.sp,
                                                  color: primaryColor),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            SizedBox(
                                              height: height * 0.02,
                                            ),
                                            Text(
                                              '#${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].barCode}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.sp,
                                                  color: Colors.yellow),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(
                                    height: height * 0.15,
                                    child: ListView.separated(
                                      physics: BouncingScrollPhysics(),
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) => Container(
                                        width: width * 0.2,
                                        decoration: BoxDecoration(
                                            color: Color(0xFFFEF9F9),
                                            borderRadius: BorderRadius.circular(15),
                                            border:
                                            Border.all(color: primaryColor)),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width * 0.03,
                                            vertical: height * 0.01),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              '${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitOrderModel!.unitName}',
                                              style: TextStyle(
                                                  color: primaryColor,
                                                  fontSize: 22.sp,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].desc}',
                                              style: TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              'Amount: ${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitDetailsOrderModel!.amount}',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight: FontWeight.w600),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                            Text(
                                              '${cubit.orderDetailsForUserModel!.productsOrderDetailsList![mainIndex].productUnitsOrderDetailsList![index].unitDetailsOrderModel!.totalPrice}€',
                                              style: TextStyle(
                                                  color: basicColor,
                                                  fontSize: 20.sp,
                                                  fontWeight: FontWeight.bold),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      separatorBuilder:
                                          (BuildContext context, int index) =>
                                          SizedBox(
                                            width: width * 0.02,
                                          ),
                                      itemCount: cubit
                                          .orderDetailsForUserModel!
                                          .productsOrderDetailsList![mainIndex]
                                          .productUnitsOrderDetailsList!
                                          .length,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              SizedBox(
                                height: height * 0.02,
                              ),
                          itemCount: cubit
                              .orderDetailsForUserModel!.productsOrderDetailsList!.length,
                        ),
                      ),
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
