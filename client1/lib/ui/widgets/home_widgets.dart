
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_states.dart';
import 'package:zaza_dashboard/logic/sub/sub_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

Widget Welcome_Stack({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 12, bottom: height / 22),
    child: TitleText(text: 'Welcome Back..'),
  );
}

Widget number_container(
    {required double height,
      required double width,
      required IconData icon,
      required Color color,
      required String catagory,
      required int number}) {
  return Container(
    height: height / 9,
    width: width / 4,
    decoration: CircularBorder_decoration,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: height / 30),
      child: Row(
        children: [
          Icon(icon, size: width / 30, color: color),
          SizedBox(width: width / 30),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(catagory, style: Number_TextStyle(width: width)),
              SizedBox(
                height: height / 70,
              ),
              Text(
                '$number',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: width / 90),
              )
            ],
          )
        ],
      ),
    ),
  );
}


Widget mainPagination(
    context,
    width,
    height,
    HomeCubit cubit,
    ) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
      width: width < 1100 ? width * 0.7 : width * 0.34,
      height: width < 1100 ? height * 0.06 : height * 0.08,
      child: NumberPaginator(
        initialPage: cubit.currentIndex,
        numberPages: cubit.paginationNumberSave!,
        onPageChange: (int index) async {
          cubit.getCategories(limit: limit, page: index);
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







