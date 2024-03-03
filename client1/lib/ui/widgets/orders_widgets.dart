import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/order/orders_cubit.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';

Widget ordersPagination(
    context,
    width,
    height,
    OrdersCubit cubit,
    ) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
      width: width < 1100 ? width * 0.7 : width * 0.34,
      height: width < 1100 ? height * 0.06 : height * 0.08,
      child: NumberPaginator(
        initialPage: cubit.currentIndex,
        numberPages: cubit.paginationNumberSave!,
        onPageChange: (int index) async {
          cubit.getOrders(limit: limitOrders, page: index, sort: 'newest', status: cubit.status);
          print(index);
        },
        config: const NumberPaginatorUIConfig(
          buttonUnselectedBackgroundColor: Colors.white,
          buttonSelectedBackgroundColor: basicColor,
          buttonSelectedForegroundColor: Colors.white,
          buttonUnselectedForegroundColor: seconderyColor,
          mode: ContentDisplayMode.numbers,
        ),
      ),
    ),
    SizedBox(
      width: width < 1100 ? width * 0.01 : width * 0.04,
    ),
  ]);
}

Widget OrderCard (index, width, height, context,cubit, int order_id, dynamic total_price, String created_at, String status, String name,String userName, String email,int type) {
  DateTime inputDate = DateTime.parse(created_at);
  String outputDateString = DateFormat("yyyy/MM/dd : HH:m:s").format(inputDate);
  return Stack(
    children: [
      Container(
        width: type == 0 ? width * 0.53 : width * 0.23,
        decoration: BoxDecoration(
          color: type == 0 ? backgroundColor : Colors.white,
          border: Border.all(
            color: basicColor,
            width: 0.5,
          ),
          borderRadius:
          BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 0.1),
              color: Colors.redAccent
                  .withOpacity(0.2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(height: height*0.01,),
            Text(
              'Invoice Price',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 22.sp),
            ),
            Text(
              '${total_price}\€',
              style: TextStyle(
                  color: basicColor,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 20.sp),
            ),
            Container(
              height: height * 0.04,
              width: width * 0.1,
              decoration: BoxDecoration(
                color: basicColor,
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ElevatedButton(
                onPressed: () {
                  nameGlobal = name;
                  userNameGlobal = userName;
                  orderId = order_id;
                  print(type);
                  if (type == 0) {
                    GoRouter.of(context).go('/orders/order-details/${orderId}');
                  }
                  else if (type == 1){
                    GoRouter.of(context).go('/users/user-profile/${userIdToUser}/order-details-user/${orderId}');
                  }

                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: basicColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'See details',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp),
                ),
              ),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              'Resturant Name',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 24.sp),
            ),
            Text(
              '${name}',
              style: TextStyle(
                  color: basicColor,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 28.sp),
            ),
            Text(
              '${email}',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 18.sp),
            ),
            SizedBox(
              height: height * 0.01,
            ),
            Text(
              'Invoice Date',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 20.sp),
            ),
            Text(
              '${outputDateString}',
              style: TextStyle(
                  color: Colors.grey,
                  fontWeight:
                  FontWeight.w600,
                  fontSize: 16.sp,
                  letterSpacing: 1),
            ),
          ],
        ),
      ),
      Positioned(
        left: width*0.07,
        right: width*0.07,
        top: 0.0,
        child: Container(
          height: height * 0.024,
          width: width * 0.07,
          decoration: BoxDecoration(
            color: status == 'pending' ? Colors.yellow : status == 'approved' ? Colors.green : Colors.red,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Center(
            child: Text(
              status == 'pending' ? 'Pending' : status == 'approved' ? 'Approved' : 'Rejected',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 18.sp),
            ),
          ),
        ),
      ),
    ],
  );
}