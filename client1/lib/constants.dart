import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/network/local/cash_helper.dart';
import 'package:zaza_dashboard/ui/screens/login_screen.dart';


void signOut(context)
{
  CacheHelper.clearShared().then((value)
  {
    if(value)
    {
      GoRouter.of(context).pushReplacement('/');
    }
  });
}

List<String> statusList = [
  'all','pending','approved','rejected'
];

var limit = 10; //Number of categories or products in one page
var limitOrders = 10000000;
var limitUsers = 10;

var token;
var refreshTokenSave;
var heightSize = 800.0;

var categoryId;
var productId;
var productName;

var orderId;

var languageCode = 'de';

var userIdToUser;


var userNameGlobal;
var nameGlobal;
