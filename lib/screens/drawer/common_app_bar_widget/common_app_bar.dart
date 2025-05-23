import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fragment_navigate/navigate-control.dart';
import 'package:fragment_navigate/navigate-support.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/navigator_provider.dart';
import 'package:stepowner/screens/setting_screen/setting_screen.dart';
import 'package:stepowner/screens/subscription_screen/subscription_history.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../../utils/const_preference/shared_preference_utils.dart';

// ignore: must_be_immutable
class CommonAppBar extends StatelessWidget {
  late NavigatorProvider navigatorProvider;

  CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget profileWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate(AppString.profileText),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget subscriptionWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        title: Text(
          AppLocalizations.of(context).translate(AppString.subscription),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
        actions: [
          Padding(
              padding: EdgeInsets.only(right: 2.h),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SubscriptionHistory()));
                },
                tooltip: "History",
                icon: const Icon(
                  Icons.history,
                  color: AppColors.white,
                  size: 30,
                ),
              )),
        ],
      ),
    );
  }

  Widget securityGuardWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate(AppString.guardList),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.h),
            child: InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.newGuardRoute);
                },
                child: const Icon(
                  Icons.add_outlined,
                  color: AppColors.white,
                )),
          ),
        ],
      ),
    );
  }

  Widget addressWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate(AppString.newSpace),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget transactionWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        title: Text(
          AppLocalizations.of(context).translate(AppString.transaction),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget reviewWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate(AppString.review),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget scannerWidget(fragNav, context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        titleSpacing: 0,
        centerTitle: true,
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
          ),
          onPressed: () {
            fragNav.drawerKey.currentState!.openDrawer();
          },
        ),
        title: Text(
          AppLocalizations.of(context).translate(AppString.scanner),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
      ),
    );
  }

  Widget setting(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Setting()));
            },
            icon: const Icon(
              Icons.settings_outlined,
              color: AppColors.black,
            ),
            label: Text(
              AppLocalizations.of(context).translate(AppString.setting),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.black),
            )),
        TextButton.icon(
            onPressed: () {
              signOutAlertDialog(context);
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: AppColors.black,
            ),
            label: Text(
              AppLocalizations.of(context).translate(AppString.logout),
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.black),
            ))
      ],
    );
  }

  signOutAlertDialog(BuildContext context) {
    /// Create button
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.logout),
        style: TextStyle(color: AppColors.blue, fontSize: 13.sp),
      ),
      onPressed: () {
        PreferenceManager.removeKey(SharePreferenceKey.id);
        PreferenceManager.removeKey(SharePreferenceKey.tokenKey);
        PreferenceManager.removeKey(SharePreferenceKey.nameKey);
        PreferenceManager.removeKey(SharePreferenceKey.emailKey);
        PreferenceManager.removeKey(SharePreferenceKey.imageKey);
        PreferenceManager.removeKey(SharePreferenceKey.phoneNumberKey);
        PreferenceManager.removeKey(SharePreferenceKey.isLogin);
        PreferenceManager.removeKey(SharePreferenceKey.subscriptionStatus);
        PreferenceManager.removeKey(SharePreferenceKey.stripePublicKey);
        PreferenceManager.removeKey(SharePreferenceKey.stripeSecretKey);
        PreferenceManager.removeKey(SharePreferenceKey.payPalClientId);
        PreferenceManager.removeKey(SharePreferenceKey.payPalSecretKey);
        PreferenceManager.removeKey(SharePreferenceKey.razorPayKey);
        PreferenceManager.removeKey(SharePreferenceKey.flutterWaveKey);
        PreferenceManager.removeKey(SharePreferenceKey.flutterWaveMode);
        PreferenceManager.removeKey(SharePreferenceKey.status);
        PreferenceManager.removeKey(SharePreferenceKey.customerId);
        PreferenceManager.removeKey(SharePreferenceKey.uploadImage);
        PreferenceManager.removeKey(SharePreferenceKey.spaceIdKey);
        PreferenceManager.removeKey(SharePreferenceKey.showSpaceTitleKey);
        PreferenceManager.removeKey(SharePreferenceKey.spaceAddressKey);
        PreferenceManager.removeKey(SharePreferenceKey.deviceToken);
        PreferenceManager.removeKey(SharePreferenceKey.appId);
        PreferenceManager.removeKey(SharePreferenceKey.stripeStatus);
        PreferenceManager.removeKey(SharePreferenceKey.razorPayStatus);
        PreferenceManager.removeKey(SharePreferenceKey.flutterWaveStatus);
        PreferenceManager.removeKey(SharePreferenceKey.payPalStatus);
        PreferenceManager.removeKey(SharePreferenceKey.currency);
        PreferenceManager.removeKey(SharePreferenceKey.currencySymbol);
        PreferenceManager.removeKey(
          SharePreferenceKey.userStripeStatus,
        );
        PreferenceManager.removeKey(
          SharePreferenceKey.userFlutterWaveStatus,
        );
        PreferenceManager.removeKey(SharePreferenceKey.userPayPalStatus);
        PreferenceManager.removeKey(
          SharePreferenceKey.userRazorPayStatus,
        );
        PreferenceManager.removeKey(SharePreferenceKey.userStripePublic);
        PreferenceManager.removeKey(SharePreferenceKey.userStripeSecret);
        PreferenceManager.removeKey(SharePreferenceKey.userRazorpayKey);
        PreferenceManager.removeKey(SharePreferenceKey.userFlutterWaveKey);
        PreferenceManager.removeKey(SharePreferenceKey.userFlutterWaveLiveMode);
        PreferenceManager.removeKey(SharePreferenceKey.userPaypalClientKey);
        PreferenceManager.removeKey(SharePreferenceKey.userPaypalSecretKey);

        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.signInRoute, (route) => false);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.btnCancel),
        style: TextStyle(color: AppColors.blue, fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    /// logout AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.white,
      shadowColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      title: Text(AppLocalizations.of(context).translate(AppString.logout)),
      content: Text(AppLocalizations.of(context)
          .translate(AppString.areYouSureDoYouWantToLogout)),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget drawerWidget(profileProvider, fragNav, context) {
    navigatorProvider = Provider.of(context);
    Widget getItem(
        {required String currentSelect,
        required text,
        required key,
        required icon}) {
      Color getColor() =>
          currentSelect == key ? AppColors.blue : AppColors.black87;
      return SizedBox(
        height: 6.2.h,
        child: ListTile(
            contentPadding: const EdgeInsets.only(left: 50),
            leading: Icon(icon,
                color: currentSelect == key ? AppColors.blue : AppColors.black),
            selected: currentSelect == key,
            title: Text(text,
                style:
                    TextStyle(color: getColor(), fontWeight: FontWeight.bold)),
            onTap: () {
              fragNav.jumpBackToFirst();
              fragNav.putPosit(key: key);
              NavigatorProvider.fragNav.drawerKey.currentState?.openEndDrawer();
            }),
      );
    }

    return Drawer(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.white,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: ListView(
          shrinkWrap: true,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: AppColors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: SizedBox(
                      child: Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/profile-bg.png"),
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                        child: CircleAvatar(
                          radius: 27,
                          backgroundColor: AppColors.commonColorSkyBlue,
                          foregroundImage: CachedNetworkImageProvider(
                              profileProvider.profileData.imageUri!),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profileProvider.profileData.name.toString(),
                    style: TextStyle(
                        fontFamily: AppString.rubik,
                        fontSize: 15.sp,
                        color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    AppLocalizations.of(context)
                        .translate(AppString.parkingOwner),
                    style: TextStyle(
                        fontFamily: AppString.rubik,
                        fontSize: 11.sp,
                        color: AppColors.white),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            for (Posit item in fragNav.screenList.values)
              getItem(
                  currentSelect: fragNav.currentKey,
                  text: item.drawerTitle ?? item.title,
                  key: item.key,
                  icon: item.icon),
            ListTile(
                contentPadding: const EdgeInsets.only(left: 50),
                leading: const Icon(
                  Icons.delete_outlined,
                  color: Colors.red,
                ),
                title: const Text("Delete Account",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red)),
                onTap: () {
                  deleteAccountAlertDialog(context);
                }),
            // Spacer(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CommonAppBar().setting(context),
            ),
          ],
        ));
  }

  deleteAccountAlertDialog(BuildContext context) {
    /// Create button
    Widget okButton = TextButton(
      child: Text(
        "Delete Account",
        style: TextStyle(color: Colors.red, fontSize: 13.sp),
      ),
      onPressed: () {
        navigatorProvider.callDeleteAccount().then((value) {
          if (value.data!.success == true) {
            PreferenceManager.removeKey(SharePreferenceKey.id);
            PreferenceManager.removeKey(SharePreferenceKey.tokenKey);
            PreferenceManager.removeKey(SharePreferenceKey.nameKey);
            PreferenceManager.removeKey(SharePreferenceKey.emailKey);
            PreferenceManager.removeKey(SharePreferenceKey.imageKey);
            PreferenceManager.removeKey(SharePreferenceKey.phoneNumberKey);
            PreferenceManager.removeKey(SharePreferenceKey.isLogin);
            PreferenceManager.removeKey(SharePreferenceKey.subscriptionStatus);
            PreferenceManager.removeKey(SharePreferenceKey.stripePublicKey);
            PreferenceManager.removeKey(SharePreferenceKey.stripeSecretKey);
            PreferenceManager.removeKey(SharePreferenceKey.payPalClientId);
            PreferenceManager.removeKey(SharePreferenceKey.payPalSecretKey);
            PreferenceManager.removeKey(SharePreferenceKey.razorPayKey);
            PreferenceManager.removeKey(SharePreferenceKey.flutterWaveKey);
            PreferenceManager.removeKey(SharePreferenceKey.flutterWaveMode);
            PreferenceManager.removeKey(SharePreferenceKey.status);
            PreferenceManager.removeKey(SharePreferenceKey.customerId);
            PreferenceManager.removeKey(SharePreferenceKey.uploadImage);
            PreferenceManager.removeKey(SharePreferenceKey.spaceIdKey);
            PreferenceManager.removeKey(SharePreferenceKey.showSpaceTitleKey);
            PreferenceManager.removeKey(SharePreferenceKey.spaceAddressKey);
            PreferenceManager.removeKey(SharePreferenceKey.deviceToken);
            PreferenceManager.removeKey(SharePreferenceKey.appId);
            PreferenceManager.removeKey(SharePreferenceKey.stripeStatus);
            PreferenceManager.removeKey(SharePreferenceKey.razorPayStatus);
            PreferenceManager.removeKey(SharePreferenceKey.flutterWaveStatus);
            PreferenceManager.removeKey(SharePreferenceKey.payPalStatus);
            PreferenceManager.removeKey(SharePreferenceKey.currency);
            PreferenceManager.removeKey(SharePreferenceKey.currencySymbol);
            PreferenceManager.removeKey(
              SharePreferenceKey.userStripeStatus,
            );
            PreferenceManager.removeKey(
              SharePreferenceKey.userFlutterWaveStatus,
            );
            PreferenceManager.removeKey(SharePreferenceKey.userPayPalStatus);
            PreferenceManager.removeKey(
              SharePreferenceKey.userRazorPayStatus,
            );
            PreferenceManager.removeKey(SharePreferenceKey.userStripePublic);
            PreferenceManager.removeKey(SharePreferenceKey.userStripeSecret);
            PreferenceManager.removeKey(SharePreferenceKey.userRazorpayKey);
            PreferenceManager.removeKey(SharePreferenceKey.userFlutterWaveKey);
            PreferenceManager.removeKey(
                SharePreferenceKey.userFlutterWaveLiveMode);
            PreferenceManager.removeKey(SharePreferenceKey.userPaypalClientKey);
            PreferenceManager.removeKey(SharePreferenceKey.userPaypalSecretKey);

            Navigator.pushNamedAndRemoveUntil(
                context, RouteName.signInRoute, (route) => false);
          }
        });
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        "Cancel",
        style: TextStyle(color: AppColors.blue, fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    /// logout AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      title: const Text("Delete"),
      content: const Text(
          "This will delete all your data, and you won't be able to log back in."),
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
