import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../utils/change_language/app_location.dart';

class OnBoard5 extends StatefulWidget {
  const OnBoard5({super.key});

  @override
  State<OnBoard5> createState() => _OnBoard5State();
}

class _OnBoard5State extends State<OnBoard5> {
  final PageController _pageController = PageController();

  late AuthProvider auth = Provider.of(context, listen: false);

  @override
  Widget build(BuildContext context) {
    auth = Provider.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
          child: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              children: [
                Container(
                  width: 100.w,
                  height: 50.h,
                  margin: EdgeInsets.only(top: 5.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Image.asset(
                          "assets/onboard4.png",
                          height: 190,
                          width: 300,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.vehicleNumberLabel),
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            color: AppColors.fontColorBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        width: 80.w,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.clientName),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyWithAlpha,
                              fontFamily: AppString.rubikRegular),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 100.w,
                  height: 50.h,
                  margin: EdgeInsets.only(top: 5.h),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            top: 10.h, left: 10, right: 10, bottom: 10.h),
                        child: Image.asset(
                          "assets/onboard5.png",
                          height: 190,
                          width: 300,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.growUpYourParking),
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            color: AppColors.fontColorBlue,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        width: 80.w,
                        padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.clientName),
                          textAlign: TextAlign.center,
                          maxLines: 4,
                          style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.greyWithAlpha,
                              fontFamily: AppString.rubikRegular),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 10.h,
              left: 10,
              right: 10,
              child: MaterialButton(
                onPressed: () {
                  auth.checkLogin(
                      auth.emailController.text,
                      auth.passwordController.text,
                      auth.type,
                      PreferenceManager.getString(
                          SharePreferenceKey.deviceToken),
                      context);
                },
                color: AppColors.commonColorSkyBlue,
                textColor: AppColors.white,
                height: 50,
                minWidth: 90.w,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Text(
                  AppLocalizations.of(context).translate(AppString.skip),
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: AppString.rubik),
                ),
              ),
            ),
            Positioned(
              right: 0,
              left: 0,
              top: 57.h,
              child: Center(
                  child: SmoothPageIndicator(
                controller: _pageController, // PageController
                count: 2,
                effect: const WormEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor:
                        AppColors.commonColorSkyBlue), // your preferred effect
              )),
            ),
          ],
        ),
      )),
    );
  }
}
