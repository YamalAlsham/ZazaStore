

import 'package:flutter/material.dart';
import 'package:zaza_dashboard/ui/components/components.dart';

Widget TitleTax({
  required double height,
  required double width,
}) {
  return Padding(
    padding: EdgeInsets.only(top: height / 20, bottom: height / 32),
    child: TitleText(text: 'Taxes & Units'),
  );
}