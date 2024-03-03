import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/order/orders_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/orders_widgets.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = heightSize;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<OrdersCubit, OrdersState>(
          listener: (context, state) {
            var cubit = OrdersCubit.get(context);
          },
          builder: (context, state) {
            var cubit = OrdersCubit.get(context);
            return Scaffold(
              drawer: drawerWeb(width, height, context),
              appBar: appBarWeb(width, height, context),
              body: ConditionalBuilder(
                condition: cubit.generalAllOrdersModel != null,
                builder: (context) => SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: height * 0.001),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Padding(
                    padding: EdgeInsets.only(top: height / 12, bottom: height / 22),
                    child: TitleText(text: 'Orders'),
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
                                    'All Orders',
                                    style: TextStyle(
                                        fontSize: 45.sp,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'Number of Orders: ${cubit.generalAllOrdersModel!.totalOrders}',
                                    style: TextStyle(
                                        fontSize: 25.sp,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.grey),
                                  ),
                                  // DropDown
                                  DropdownButton<String>(
                                    value: cubit.status,
                                    items: statusList
                                        .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: TextStyle(color: basicColor,fontWeight: item == cubit.status ? FontWeight.bold : FontWeight.w400),
                                        )))
                                        .toList(),
                                    onChanged: (item) {
                                      print(item);
                                      cubit.changeDropdownValue(item!);
                                    },),
                                ],
                              ),
                              SizedBox(
                                height: height * 0.05,
                              ),
                              //Main Categories
                              cubit.generalAllOrdersModel!.ordersList!.isNotEmpty
                                  ? GridView.builder(
                                shrinkWrap: true,
                                gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: 400,
                                  mainAxisExtent: 320,
                                  crossAxisSpacing: 15,
                                  mainAxisSpacing: 15,
                                ),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return OrderCard(
                                      index,
                                      width,
                                      height,
                                      context,
                                      cubit,
                                      cubit.generalAllOrdersModel!.ordersList![index].order_id!,
                                      cubit.generalAllOrdersModel!.ordersList![index].totalPrice!,
                                      cubit.generalAllOrdersModel!.ordersList![index].createdAt!,
                                      cubit.generalAllOrdersModel!.ordersList![index].status!,
                                      cubit.generalAllOrdersModel!.ordersList![index]!.user!.name!,
                                    cubit.generalAllOrdersModel!.ordersList![index]!.user!.userName!,
                                    cubit.generalAllOrdersModel!.ordersList![index]!.user!.email!,
                                    0,
                                  );
                                },
                                itemCount: cubit
                                    .generalAllOrdersModel!.ordersList!.length,
                              )
                                  : Center(
                                child: Text(
                                  'No Orders found',
                                  style: TextStyle(
                                      fontSize: 35.sp,
                                      color: basicColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              SizedBox(
                                height: height * 0.05,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: height * 0.02,
                        ),
                        cubit.generalAllOrdersModel!.ordersList!.isNotEmpty
                            ? ordersPagination(context, width, height, cubit)
                            : Container(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                      ],
                    ),
                  ),
                ),
                fallback: (context) => SpinKitWeb(width),
              ),
            );
          },
    );
  }
}
