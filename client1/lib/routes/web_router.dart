
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zaza_dashboard/constants.dart';
import 'package:zaza_dashboard/ui/screens/orders/order_details.dart';
import 'package:zaza_dashboard/ui/screens/orders/orders_screen.dart';
import 'package:zaza_dashboard/ui/screens/product/create_product.dart';
import 'package:zaza_dashboard/ui/screens/product/edit_product_units.dart';
import 'package:zaza_dashboard/ui/screens/product/products.dart';
import 'package:zaza_dashboard/ui/screens/taxes&discount/taxes&units.dart';
import 'package:zaza_dashboard/ui/screens/user/add_discount_specific_user.dart';
import 'package:zaza_dashboard/ui/screens/user/add_users.dart';
import 'package:zaza_dashboard/ui/screens/home/home.dart';
import 'package:zaza_dashboard/ui/screens/login_screen.dart';
import 'package:zaza_dashboard/ui/screens/home/sub.dart';
import 'package:zaza_dashboard/ui/screens/user/user_order_details.dart';
import 'package:zaza_dashboard/ui/screens/user/user_profile.dart';
import 'package:zaza_dashboard/ui/screens/user/users_list_data.dart';


class WebRouter {
  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
        );
        break;
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/sub':
        return MaterialPageRoute(
          builder: (_) => SubPage(),
        );
      default:
        return null;
    }
  }
}


final GoRouter router = GoRouter(
  //debugLogDiagnostics: true,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      pageBuilder: (context, state) {
        return MaterialPage(child: token != null ? HomePage() : LoginScreen());
      },
      routes: [
        GoRoute(
          path: 'sub',
          name: 'sub',
          pageBuilder: (context, state) {
            return MaterialPage(child: SubPage());
          },
        ),
      ],
    ),
    GoRoute(
        path: '/products',
        name: 'products',
        pageBuilder: (context, state) {
          return  MaterialPage(child: ProductScreen());
        },
        routes: [
          GoRoute(
            path: 'edit-product-units/:productId',
            name: 'edit-product-units',
            pageBuilder: (context, state) {
              productId = int.parse(state.pathParameters['productId']!);
              return  MaterialPage(child: EditProductUnits());
            },
          ),
        ]
    ),
    GoRoute(
      path: '/create-product',
      name: 'create-product',
      pageBuilder: (context, state) {
        return  MaterialPage(child: CreateProduct());
      },
    ),
    GoRoute(
      path: '/tax&unit',
      name: 'tax',
      pageBuilder: (context, state) {
        return MaterialPage(child: TaxesUnits());
      },
    ),
    GoRoute(
        path: '/users',
        name: 'users',
        pageBuilder: (context, state) {
          return MaterialPage(child: UsersList());
        },
        routes: [
          GoRoute(
            path: 'adduser',
            name: 'adduser',
            pageBuilder: (context, state) {
              return MaterialPage(child: AddUsers());
            },
          ),
          GoRoute(
              path: 'user-profile/:userId',
              name: 'user-profile',
              pageBuilder: (context, state) {
                userIdToUser = int.parse(state.pathParameters['userId']!);
                return MaterialPage(child: UserProfile());
              },
              routes: [
                GoRoute(
                  path: 'discount-specific-user',
                  name: 'discount-specific-user',
                  pageBuilder: (context, state) {
                    return MaterialPage(child: DiscountSpecificUser());
                  },
                ),
                GoRoute(
                  path: 'order-details-user/:orderId',
                  name: 'order-details-user',
                  pageBuilder: (context, state) {
                    orderId = int.parse(state.pathParameters['orderId']!);
                    return MaterialPage(child: UserOrderDetails());
                  },
                ),
              ]
          ),
        ]
    ),
    GoRoute(
      path: '/orders',
      name: 'orders',
      pageBuilder: (context, state) {
        return MaterialPage(child: OrdersScreen());
      },
      routes: [
        GoRoute(
          path: 'order-details/:orderId',
          name: 'order-details',
          pageBuilder: (context, state) {
            orderId = int.parse(state.pathParameters['orderId']!);
            return MaterialPage(child: OrderDetalis());
          },
        ),
      ],
    ),
  ],
);


class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  Future<dynamic> navigateTo(String routeName) {
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }

}