

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:zaza_dashboard/theme/colors.dart';

const Circle_BoxDecoration=BoxDecoration(
shape: BoxShape.circle,
color: Colors.white
);

var CircularBorder_decoration=BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20)
);

TextStyle Number_TextStyle({
  required width,
  FontWeight fontWeight=FontWeight.w100,
  Color color= Colors.grey
}){
  return TextStyle(
      fontWeight: fontWeight,
      fontSize: width/100,color:color,
  );
}

/*
var side_text=TextStyle(fontSize: 13,fontWeight: FontWeight.w500,
      color: Colors.grey.shade300);

*/


ButtonStyleData drop_button_style({
  required double width
})
{
  return ButtonStyleData(
    height: 800/16,
    width: width/7,
    padding: const EdgeInsets.only(left: 14, right: 14),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
          color: Colors.grey,
          width: 2
      ),
      color: backgroundColor,
    ),
    elevation: 10,
  );
}
IconStyleData drop_icon_style({
  IconData icon=Icons.arrow_drop_down,
  Color icon_color=Colors.grey,
  double size=30
}){
  return IconStyleData(
    icon: Icon(icon,
      color: Colors.grey,
    ),
    iconSize: size,
  );}

InputDecoration drop_decoration(){
  return  InputDecoration(
    counterStyle: TextStyle(color: Colors.black),
    isDense:true,
    contentPadding: EdgeInsets.zero,
    border: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey), // Set the border color here
      borderRadius: BorderRadius.circular(12), // Set the border radius to 0 for not circular
    ),
  );
}

double iconSmallSize = 44.0;