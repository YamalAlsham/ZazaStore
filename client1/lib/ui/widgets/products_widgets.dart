

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/product/create_product_cubit.dart';
import 'package:zaza_dashboard/logic/product/products_list_cubit.dart';
import 'package:zaza_dashboard/theme/colors.dart';
import 'package:zaza_dashboard/theme/styles.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

List<String> ll = ['milk','dog'];

Widget drop_add_product({
  required context,
  required double height,
  required double width,
  //required Class_Profile_cubit cubit,
}){
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Category',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: ll
          .map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Section';
        }
        return null;
      },
      onChanged: (value) {
        //MarksCubit.get(context).select_section(value);
        //print(MarksCubit.get(context).selected_section);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}


Widget drop_add_category({
  required context,
  required double height,
  required double width,
  required CreateProductCubit cubit,
  //required Class_Profile_cubit cubit,
}){
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Category',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: cubit.categoriesNamesListModel!
          .map((item) => DropdownMenuItem<int>(
        value: item.categoryId,
        child: Text(
          item.categoryName!,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Category';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeCategoryIdDropDown(value);
        print(value);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}

Widget drop_add_tax({
  required context,
  required double height,
  required double width,
  required CreateProductCubit cubit,
}){
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Tax',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: cubit.taxesNamesModel!.taxesListModel!
          .map((item) => DropdownMenuItem<int>(
        value: item.taxId,
        child: Text(
          item.taxName!,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Tax';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeTaxIdDropDown(value);
        print(value);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}


Widget drop_add_unit({
  required context,
  required double height,
  required double width,
  required CreateProductCubit cubit,
}){
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Unit',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: cubit.unitsNamesModel!.unitsListModel!
          .map((item) => DropdownMenuItem<int>(
        value: item.unitId,
        child: Text(
          item.unitName!,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Unit';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeUnitIdDropDown(value);
        print(value);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}


Widget drop_add_unitwithindex({
  required context,
  required double height,
  required double width,
  required int index,
  required CreateProductCubit cubit,
}){
  return Container(
    width: width * 0.15,
    child: DropdownButtonFormField2(
      decoration:drop_decoration(),
      isExpanded: false,
      hint:Text(
        'Choose Unit',
        style: TextStyle(fontSize: width/110,color: Colors.black54),
      ),
      items: cubit.unitsNamesModel!.unitsListModel!
          .map((item) => DropdownMenuItem<int>(
        value: item.unitId,
        child: Text(
          item.unitName!,
          style: TextStyle(
              fontSize: width/110,color: Colors.black
          ),),
      )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Unit';
        }
        return null;
      },
      onChanged: (value) {
        cubit.changeUnitIdDropDownWithIndex(value,index);
        print(value);
      },
      onSaved: (value) {
        //MarksCubit.get(context).select_section(value);
      },
      buttonStyleData: drop_button_style(width: width),
      iconStyleData:  drop_icon_style(size: 30),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),),
    ),
  );
}




Widget Product_Stack({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 12, bottom: height / 22),
    child: TitleText(text: 'Products'),
  );
}



Widget productPagination(
    context,
    width,
    height,
    cubit,
    ) {
  return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    SizedBox(
      width: width < 1100 ? width * 0.7 : width * 0.34,
      height: width < 1100 ? height * 0.06 : height * 0.08,
      child: NumberPaginator(
        initialPage: cubit.currentIndex,
        numberPages: cubit.paginationNumberSave!,
        onPageChange: (int index) async {
          cubit.getProducts(limit: limit, page: index, sort: 'newest', search: '');
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