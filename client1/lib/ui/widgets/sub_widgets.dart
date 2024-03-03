

import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/sub/sub_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

Widget Sub_Stack({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 12, bottom: height / 22),
    child: TitleText(text: 'Sub Items'),
  );
}


Widget subPagination(
    context,
    width,
    height,
    SubCubit cubit,
    ) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
      width: width < 1100 ? width * 0.7 : width * 0.34,
      height: width < 1100 ? height * 0.06 : height * 0.08,
      child: NumberPaginator(
        initialPage: cubit.currentIndex,
        numberPages: cubit.paginationNumberSave!,
        onPageChange: (int index) async {
          cubit.getCategoryChildren(limit: limit, page: index, id: cubit.catPerCubitId);
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