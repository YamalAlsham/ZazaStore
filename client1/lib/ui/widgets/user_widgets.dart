import 'package:collection/collection.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_cubit.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/models/user/user_list_model.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

Widget AddUsersTitle({
  required double height,
  required double width,
}) {
  return TitleText(text: 'Add New User');
}

List<DataColumn2> getUsersColumns(UserCubit cubit) => cubit.UsersColumns.map(
      (String column) => DataColumn2(label: Text(column), onSort: cubit.onSort),
    ).toList();

List<DataRow> getStudentsRows(
  List<UserDataModel> allUsers,
  width,
  heigth,
  context,
  UserCubit cubit,
) =>
    allUsers.mapIndexed((
      index,
      UserDataModel us,
    ) {
      DateTime dateTime = DateTime.parse(us.created_at!);

      String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

      return DataRow2(
        onTap: () {},
        cells: [
          //us is object
          DataCell(Text(us.userId!.toString())),
          DataCell(Text(us.username!)),
          DataCell(Text(us.resName!)),
          DataCell(Text(us.email!)),
          DataCell(Text(formattedDate)),
          DataCell(Row(
            children: [
              IconButton(
                onPressed: () {
                  print(us.userId!);
                  awsDialogDeleteForOne(
                      context, width, cubit, us.userId!, 4, null, null);
                },
                icon: Icon(
                  Icons.delete,
                  size: width * 0.015,
                ),
              ),
              IconButton(
                onPressed: () {
                  userIdToUser = us.userId!;
                  //UserProfileCubit.get(context).getUserProfile(user_id: userIdToUser);
                  GoRouter.of(context).go(
                    '/users/user-profile/${userIdToUser}',
                  );
                },
                icon: Icon(
                  Icons.edit,
                  size: width * 0.015,
                ),
              ),
            ],
          )),
        ],
      );
    }).toList();

Widget dataTableUsers(
    context, width, height, UserCubit cubit, UsersModel model) {
  return SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
    scrollDirection: Axis.horizontal,
    child: DataTable(
      sortAscending: cubit.isAscending,
      sortColumnIndex: cubit.sortColumnIndex,
      dividerThickness: 2,
      columnSpacing: width * 0.06,
      headingRowHeight: height * 0.06,
      showCheckboxColumn: true,
      headingRowColor: MaterialStateProperty.all(Colors.white54),
      headingTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      dataTextStyle: TextStyle(
        fontSize: 20.sp,
      ),
      horizontalMargin: 12,
      //minWidth: 600,
      columns: getUsersColumns(cubit),
      rows:
          getStudentsRows(model.usersList!, width, heightSize, context, cubit),
    ),
  );
}

Widget userPagination(
  context,
  width,
  height,
  UserCubit cubit,
) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
      width: width < 1100 ? width * 0.7 : width * 0.34,
      height: width < 1100 ? height * 0.06 : height * 0.08,
      child: NumberPaginator(
        initialPage: cubit.currentIndex,
        numberPages: cubit.paginationNumberSave!,
        onPageChange: (int index) async {
          cubit.getUsersTableData(
              limit: limitUsers, paginationNumber: index, sort: 'oldest');
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

Widget User_Stack({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 40, bottom: height / 40),
    child: TitleText(text: 'User Profile'),
  );
}

Future<String?> editDiscountForUserDialog(
        {required int discountPrUsId,
        required context,
        required width,
        required height,
        required int index,
        required formKey,
        required UserProfileCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Edit Specific Discount",
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.02,
        ),
        content: BlocBuilder<UserProfileCubit, UserProfileState>(
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
                          'Discount',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.editDiscountForUserController,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Discount';
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
              cubit.clear();
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
                  () => cubit.editDiscountProductForUser(
                      discountPrUsId: discountPrUsId,
                      percent: int.parse(
                        cubit.editDiscountForUserController.text,
                      ),
                      index: index),
                );
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

Future<String?> createDiscountForUserDialog(
        {required int userId,
        required int product_id,
        required context,
        required width,
        required height,
        required formKey,
        required UserProfileCubit cubit}) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Padding(
          padding: EdgeInsets.only(
              bottom: height / 30, top: height / 40, right: width / 30),
          child: TitleText(
            text: "Add Specific Discount To User",
          ),
        ),
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: width * 0.02,
        ),
        content: BlocBuilder<UserProfileCubit, UserProfileState>(
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
                          'Discount',
                          style: TextStyle(
                              fontSize: 30.sp, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: height * 0.012,
                        ),
                        def_TextFromField(
                          fillColor: Colors.white,
                          keyboardType: TextInputType.text,
                          controller: cubit.addDiscountForUserController,
                          br: 10,
                          borderFocusedColor: Colors.black,
                          borderNormalColor: Colors.grey,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter Discount';
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
              cubit.clear();
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
                    () => cubit.addDiscountProductForUser(
                        userId: userId,
                        percent:
                            int.parse(cubit.addDiscountForUserController.text),
                        productId: product_id));
              }
            },
            child: Text(
              'Create',
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: width * 0.01,
                  color: Colors.red),
            ),
          ),
        ],
      ),
    );

Widget Specific_Discount_Stack({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 40, bottom: height / 40),
    child: TitleText(text: 'Add Discount For User'),
  );
}
