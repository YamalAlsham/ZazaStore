import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zaza_dashboard/BlocObserver.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/logic/auth/auth_cubit.dart';
import 'package:zaza_dashboard/logic/home/home_cubit.dart';
import 'package:zaza_dashboard/logic/order/orders_cubit.dart';
import 'package:zaza_dashboard/logic/product/create_product_cubit.dart';
import 'package:zaza_dashboard/logic/product/products_list_cubit.dart';
import 'package:zaza_dashboard/logic/sub/sub_cubit.dart';
import 'package:zaza_dashboard/logic/taxes%20&%20units/tax&unit_cubit.dart';
import 'package:zaza_dashboard/logic/user/user_cubit.dart';
import 'package:zaza_dashboard/logic/user/user_profile_cubit.dart';
import 'package:zaza_dashboard/network/local/cash_helper.dart';
import 'package:zaza_dashboard/network/remote/dio_helper.dart';
import 'package:zaza_dashboard/routes/web_router.dart';
import 'package:zaza_dashboard/theme/web_theme.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //usePathUrlStrategy();

  print(WidgetsBinding.instance.window.physicalSize.height);
  print(WidgetsBinding.instance.window.physicalSize.width);

  Bloc.observer = MyBlocObserver();

  DioHelper.init();

  DioHelper();

  await CacheHelper.init();

  token = CacheHelper.getData(key: 'token');

  refreshTokenSave = CacheHelper.getData(key: 'refresh-token');

  print('token=$token');
  print('refreshTokenSave=$refreshTokenSave');

  //await ScreenUtil.ensureScreenSize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final WebRouter _appRouter = WebRouter();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => AuthCubit()),
        BlocProvider(create: (BuildContext context) => OrdersCubit()..getOrders(limit: limitOrders, page: 0, sort: 'newest', status: 'all')),
        BlocProvider(create: (BuildContext context) => UserProfileCubit()),
        BlocProvider(create: (BuildContext context) => HomeCubit()..getCategories(limit: limit, page: 0)),
        BlocProvider(create: (BuildContext context) => UserCubit()..getUsersTableData(limit: limitUsers, paginationNumber: 0, sort: 'oldest')),
      ],
      child: ScreenUtilInit(
        designSize: width>800 ? Size(1920, 934) : Size(1000, 200),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MaterialApp.router(
            scrollBehavior: MaterialScrollBehavior().copyWith(
              dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
            ),
            title: 'Zaza Web',

            theme: WebTheme.lightTheme,
            debugShowCheckedModeBanner: false,

            /*initialRoute: token != null ? '/home' : '/login',
            onGenerateRoute: _appRouter.onGenerateRoute,*/
            routerDelegate: router.routerDelegate,
            routeInformationParser: router.routeInformationParser,
            routeInformationProvider: router.routeInformationProvider,

            builder: (context, child) {
              final MediaQueryData data = MediaQuery.of(context);
              return MediaQuery(
                data: data.copyWith(textScaleFactor: 1.0),
                child: child!,
              );
            },
          );
        },
      ),
    );
  }
}
