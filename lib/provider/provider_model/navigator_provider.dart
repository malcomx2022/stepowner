import 'package:flutter/material.dart';
import 'package:fragment_navigate/navigate-control.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/common_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/screens/home_screens/home.dart';
import 'package:stepowner/screens/image_screen/image.dart';
import 'package:stepowner/screens/parking_address_screen/parking_address.dart';
import 'package:stepowner/screens/profile_screen/profile.dart';
import 'package:stepowner/screens/review_screen/review_rate.dart';
import 'package:stepowner/screens/scanner_screen/scanner_screen.dart';
import 'package:stepowner/screens/security_guard_screen/security_guard.dart';
import 'package:stepowner/screens/subscription_screen/subscription.dart';
import 'package:stepowner/screens/transaction_screen/transaction.dart';
import 'package:stepowner/utils/constant/loading.dart';

import '../../screens/drawer/custom_drawer.dart';
import '../../utils/const_color/constant_color.dart';

class NavigatorProvider extends ChangeNotifier {
  static final FragNavigate fragNav =
      FragNavigate(firstKey: homepage, drawerContext: null, screens: <Posit>[
    Posit(
        key: homepage,
        title: 'Home',
        icon: Icons.home_outlined,
        fragmentBuilder: (p) => const Home()),
    Posit(
        key: profile,
        title: 'Profile',
        icon: Icons.person_outlined,
        fragmentBuilder: (p) => const Profile()),
    Posit(
        key: subscription,
        title: 'Subscription',
        icon: Icons.credit_card_outlined,
        fragmentBuilder: (p) => const SubscriptionScreen()),
    Posit(
        key: securityGuardPage,
        title: 'Security Guards',
        icon: Icons.person_outlined,
        fragmentBuilder: (p) => const SecurityGuard()),
    Posit(
        key: addressPage,
        title: 'Add New Space',
        icon: Icons.location_on_outlined,
        fragmentBuilder: (p) => const ParkingAddress()),
    Posit(
        key: transactionPage,
        title: 'Transactions',
        icon: Icons.monetization_on_outlined,
        fragmentBuilder: (p) => const Transaction()),
    Posit(
        key: imagePage,
        title: 'Images',
        icon: Icons.image_outlined,
        fragmentBuilder: (p) => const ImageScreen()),
    Posit(
        key: reviewPage,
        title: 'Reviews',
        icon: Icons.rate_review_outlined,
        fragmentBuilder: (p) => const Review()),
    Posit(
        key: scannerPage,
        title: 'Scanner',
        icon: Icons.qr_code_scanner_rounded,
        fragmentBuilder: (p) => const Scanner()),
  ], actionsList: [
    ActionPosit(keys: [
      homepage,
      profile,
      addressPage,
      spacePage,
      securityGuardPage,
      transactionPage,
      scannerPage,
      reviewPage,
      settingPage,
      imagePage,
      subscription,
    ], actions: [
      IconButton(
          icon: const Icon(Icons.add_outlined),
          onPressed: () {
            fragNav.action('teste');
          })
    ])
  ], bottomList: [
    const BottomPosit(
        keys: [
          homepage,
          profile,
          addressPage,
          spacePage,
          securityGuardPage,
          transactionPage,
          scannerPage,
          reviewPage,
          settingPage,
          imagePage,
          subscription,
        ],
        length: 10,
        child: TabBar(
          indicatorColor: AppColors.white,
          tabs: <Widget>[Text('a'), Text('b')],
        ))
  ]);

  Future<BaseModel<CommonModel>> callDeleteAccount() async {
    CommonModel response;
    try {
      Loading.showLoader();
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).accountDeleteCall();
      if (response.success == true) {
        if (response.message != null)
          CommonFunction.toastMessage(response.message!);
        notifyListeners();
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }
}
