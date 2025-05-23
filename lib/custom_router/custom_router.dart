import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stepowner/screens/drawer/custom_drawer.dart';
import 'package:stepowner/screens/home_screens/god_view.dart';
import 'package:stepowner/screens/home_screens/live_parking_view.dart';
import 'package:stepowner/screens/login_and_register_screen/forgot_password.dart';
import 'package:stepowner/screens/new_guard_add_screen/new_guard.dart';
import 'package:stepowner/screens/onBoarding_screen/on_board_five.dart';
import 'package:stepowner/screens/parking_address_screen/parking_address.dart';
import 'package:stepowner/screens/review_screen/review_rate.dart';
import 'package:stepowner/screens/scanner_screen/scanner_screen.dart';
import 'package:stepowner/screens/security_guard_screen/security_guard.dart';
import 'package:stepowner/screens/setting_screen/setting_screen.dart';
import 'package:stepowner/screens/transaction_screen/transaction.dart';
import 'package:stepowner/screens/image_screen/image.dart';
import 'package:stepowner/screens/profile_screen/profile.dart';
import 'package:stepowner/screens/subscription_screen/subscription.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/screens/home_screens/home.dart';
import 'package:stepowner/screens/login_and_register_screen/login.dart';
import 'package:stepowner/screens/login_and_register_screen/sign_up.dart';

class CustomRouter {
  static Route<dynamic> allRoutes(RouteSettings routeSettings) {
    if (kDebugMode) {
      print('settings ${routeSettings.name}');
    }
    switch (routeSettings.name) {
      case RouteName.signInRoute:
        return MaterialPageRoute(builder: (_) => const Login());
      case RouteName.signUpRoute:
        return MaterialPageRoute(builder: (_) => const Signup());
      case RouteName.onBoard5:
        return MaterialPageRoute(builder: (_) => const OnBoard5());
      case RouteName.mainDrawerRoute:
        return MaterialPageRoute(builder: (_) => const Main());
      case RouteName.profileRoute:
        return MaterialPageRoute(builder: (_) => const Profile());
      case RouteName.subscriptionRoute:
        return MaterialPageRoute(builder: (_) => const SubscriptionScreen());
      case RouteName.securityGuardRoute:
        return MaterialPageRoute(builder: (_) => const SecurityGuard());
      case RouteName.addNewSpace:
        return MaterialPageRoute(builder: (_) => const ParkingAddress());
      case RouteName.transactionRoute:
        return MaterialPageRoute(builder: (_) => const Transaction());
      case RouteName.addImageRoute:
        return MaterialPageRoute(builder: (_) => const ImageScreen());
      case RouteName.reviewRoute:
        return MaterialPageRoute(builder: (_) => const Review());
      case RouteName.scannerRoute:
        return MaterialPageRoute(builder: (_) => const Scanner());
      case RouteName.settingRoute:
        return MaterialPageRoute(builder: (_) => const Setting());
      case RouteName.newGuardRoute:
        return MaterialPageRoute(builder: (_) => const NewGuard(isEdit: false));
      case RouteName.godView:
        return MaterialPageRoute(builder: (_) => const GodView());
      case RouteName.liveSpaceView:
        return MaterialPageRoute(builder: (_) => const LiveParkingView());
      case RouteName.forgotPasswordRoute:
        return MaterialPageRoute(builder: (_) => const ForgotPassword());
      case RouteName.homeRoute:
        return MaterialPageRoute(builder: (_) => const Home());
    }
    return MaterialPageRoute(builder: (_) => const Login());
  }
}
