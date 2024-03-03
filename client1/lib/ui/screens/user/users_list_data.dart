import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/user/user_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';
import 'package:zaza_dashboard/ui/widgets/user_widgets.dart';

class UsersList extends StatelessWidget {
  const UsersList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(heightSize);
    final height = 753.599975586;
    final width = MediaQuery.of(context).size.width;
    return BlocConsumer<UserCubit, UserState>(listener: (context, state) {
      var cubit = UserCubit.get(context);
      if (state is GetAllUsersSuccessState) {
        print('Users data come true');
      }
      if (state is GetAllUsersErrorState) {
        showToast(text: state.errorModel.message!, state: ToastState.error);
      }

      ////////////////////////////////////////////////////////////
      if (state is DeleteUserSuccessDataState) {
        showToast(text: 'User Deleted Successfully', state: ToastState.success);

        if (cubit.usersModel!.usersList!.length == 1 && cubit.currentIndex > 0) {
          cubit.currentIndex--;
          print(cubit.paginationNumberSave);
          print(cubit.currentIndex);
        }

        cubit.getUsersTableData(
            limit: limitUsers,
            paginationNumber: cubit.currentIndex,
            sort: 'oldest');
      }
    }, builder: (context, state) {
      var cubit = UserCubit.get(context);
      return Scaffold(
        backgroundColor: primaryColor,
        appBar: appBarWeb(width, height, context),
        drawer: drawerWeb(width, height, context),
        body: ConditionalBuilder(
          condition: cubit.usersModel != null,
          builder: (context) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: width * 0.06, vertical: height * 0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleText(text: 'Users'),
                  SizedBox(
                    height: height * 0.03,
                  ),
                  // white
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                        vertical: height * 0.04, horizontal: width * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            subTitle('All Users Data', width),
                            Container(
                              width: width < 600 ? width * 0.18 : width * 0.14,
                              height: height * 0.05,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: basicColor,
                              ),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: basicColor,
                                  textStyle: const TextStyle(),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: () {
                                  GoRouter.of(context).go('/users/adduser');
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Create New User',
                                      style: TextStyle(
                                          fontSize: width * 0.01,
                                          color: Colors.white),
                                    ),
                                    //SizedBox(width: width*0.01,),
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: width * 0.01,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: height * 0.06,
                        ),
                        dataTableUsers(
                          context,
                          width,
                          height,
                          cubit,
                          cubit.usersModel!,
                        ),
                        SizedBox(
                          height: height * 0.05,
                        ),
                        cubit.usersModel!.usersList!.isNotEmpty
                            ? Container()
                            : Center(
                                child: Text(
                                'There are no users yet',
                                style: TextStyle(
                                    fontSize: width * 0.02,
                                    fontWeight: FontWeight.w600,
                                    color: basicColor),
                              )),
                        cubit.usersModel!.usersList!.isNotEmpty
                            ? Container()
                            : SizedBox(
                                height: height * 0.06,
                              ),
                        userPagination(context, width, height, cubit),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          fallback: (context) => SpinKitWeb(width),
        ),
      );
    });
  }
}
