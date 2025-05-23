import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/profile_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

List<String> list = <String>['Yes', 'No'];

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late ProfileProvider profileProvider;
  bool isStrip = false;
  bool isFlutterWave = false;
  bool isPayPal = false;
  bool isRazorPay = false;
  bool isCOD = false;

  String dropdownValue = list.first;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.red;
    }
    return AppColors.commonColorSkyBlue;
  }

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      profileProvider.ownerSettingApiCall().then((value) {
        setPaymentKey();
      });
    });
  }

  setPaymentKey() {
    isStrip =
        PreferenceManager.getString(SharePreferenceKey.userStripeStatus) == "1"
            ? true
            : false;
    isFlutterWave =
        PreferenceManager.getString(SharePreferenceKey.userFlutterWaveStatus) ==
                "1"
            ? true
            : false;
    isRazorPay =
        PreferenceManager.getString(SharePreferenceKey.userRazorPayStatus) ==
                "1"
            ? true
            : false;
    isPayPal =
        PreferenceManager.getString(SharePreferenceKey.userPayPalStatus) == "1"
            ? true
            : false;
    isCOD =
        PreferenceManager.getString(SharePreferenceKey.userCodAvailable) == "1"
            ? true
            : false;
    if (PreferenceManager.getString(SharePreferenceKey.userFlutterWaveLiveMode)
        .isNotEmpty) {
      dropdownValue = PreferenceManager.getString(
                  SharePreferenceKey.userFlutterWaveLiveMode) ==
              "0"
          ? "No"
          : "Yes";
    }

    if (kDebugMode) {
      print(PreferenceManager.getString(SharePreferenceKey.userStripeSecret));
    }
    profileProvider.stripSecretController.text =
        PreferenceManager.getString(SharePreferenceKey.userStripeSecret);
    profileProvider.stripKeyController.text =
        PreferenceManager.getString(SharePreferenceKey.userStripePublic);
    profileProvider.flutterWaveKeyController.text =
        PreferenceManager.getString(SharePreferenceKey.userFlutterWaveKey);
    profileProvider.razorKeyController.text =
        PreferenceManager.getString(SharePreferenceKey.userRazorpayKey);
    profileProvider.payPalClientIdController.text =
        PreferenceManager.getString(SharePreferenceKey.userPaypalClientKey);
    profileProvider.payPalSecretKeyController.text =
        PreferenceManager.getString(SharePreferenceKey.userPaypalSecretKey);
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.commonColorSkyBlue,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: AppColors.white),
        leading: null,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).translate(AppString.setting),
          style: TextStyle(
              color: AppColors.white,
              fontFamily: AppString.rubik,
              fontSize: 14.sp),
        ),
        actions: [
          IconButton(
              onPressed: () {
                profileProvider.profileSetting(
                    isStrip == true ? 1 : 0,
                    isRazorPay == true ? 1 : 0,
                    isPayPal == true ? 1 : 0,
                    isFlutterWave == true ? 1 : 0,
                    profileProvider.stripSecretController.text.toString(),
                    profileProvider.stripKeyController.text.toString(),
                    profileProvider.razorKeyController.text.toString(),
                    profileProvider.payPalClientIdController.text.toString(),
                    profileProvider.payPalSecretKeyController.text.toString(),
                    profileProvider.flutterWaveKeyController.text,
                    dropdownValue,
                    isCOD == true ? 1 : 0);
              },
              icon: const Icon(
                Icons.check_outlined,
                color: AppColors.white,
              ))
        ],
      ),
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.only(top: 5.h, left: 13, right: 13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              title: Text(
                AppLocalizations.of(context).translate(AppString.stripeKey),
                style: TextStyle(fontSize: 14.sp, fontFamily: AppString.rubik),
              ),
              children: <Widget>[
                ListTile(
                    subtitle: TextFormField(
                        controller: profileProvider.stripKeyController,
                        decoration: InputDecoration(
                            labelText: AppLocalizations.of(context)
                                .translate(AppString.stripePublicKey),
                            labelStyle: TextStyle(
                                fontSize: 15.sp,
                                fontFamily: AppString.rubik,
                                color: AppColors.black),
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.stripePublicKey))),
                    leading: Checkbox(
                      checkColor: AppColors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isStrip,
                      onChanged: (bool? value) {
                        setState(() {
                          isStrip = value!;
                          if (kDebugMode) {
                            print(isStrip);
                          }
                        });
                      },
                    ),
                    title: TextFormField(
                      controller: profileProvider.stripSecretController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate(AppString.stripeSecret),
                        labelStyle: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: AppString.rubik,
                            color: AppColors.black),
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.stripeSecret),
                      ),
                    )),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).translate(AppString.payPal),
                  style:
                      TextStyle(fontSize: 14.sp, fontFamily: AppString.rubik)),
              children: <Widget>[
                ListTile(
                    subtitle: TextFormField(
                      controller: profileProvider.payPalSecretKeyController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate(AppString.payPalSecret),
                          labelStyle: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.black),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.payPalSecret)),
                    ),
                    leading: Checkbox(
                      checkColor: AppColors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isPayPal,
                      onChanged: (bool? value) {
                        setState(() {
                          isPayPal = value!;
                        });
                      },
                    ),
                    title: TextFormField(
                      controller: profileProvider.payPalClientIdController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate(AppString.payPalClientId),
                          labelStyle: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.black),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.payPalClientId)),
                    )),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).translate(AppString.flutterWave),
                  style:
                      TextStyle(fontSize: 14.sp, fontFamily: AppString.rubik)),
              children: <Widget>[
                ListTile(
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppString.liveMode),
                          style: TextStyle(
                              fontSize: 11.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.black),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: DropdownButton<String>(
                            value: dropdownValue,
                            elevation: 16,
                            iconSize: 0.0,
                            underline: Container(),
                            style: const TextStyle(
                                color: AppColors.commonColorSkyBlue),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                                if (kDebugMode) {
                                  print(dropdownValue);
                                }
                              });
                            },
                            items: list
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                    leading: Checkbox(
                      checkColor: AppColors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isFlutterWave,
                      onChanged: (bool? value) {
                        setState(() {
                          isFlutterWave = value!;
                        });
                      },
                    ),
                    title: TextFormField(
                      controller: profileProvider.flutterWaveKeyController,
                      decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)
                              .translate(AppString.flutterWaveKey),
                          labelStyle: TextStyle(
                              fontSize: 15.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.black),
                          border: InputBorder.none,
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.flutterWaveKey)),
                    )),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).translate(AppString.razorPay),
                  style:
                      TextStyle(fontSize: 14.sp, fontFamily: AppString.rubik)),
              children: <Widget>[
                ListTile(
                    leading: Checkbox(
                      checkColor: AppColors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isRazorPay,
                      onChanged: (bool? value) {
                        setState(() {
                          isRazorPay = value!;
                        });
                      },
                    ),
                    title: TextFormField(
                      controller: profileProvider.razorKeyController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)
                            .translate(AppString.razorPayKey),
                        labelStyle: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: AppString.rubik,
                            color: AppColors.black),
                        border: InputBorder.none,
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.razorPayKey),
                      ),
                    )),
              ],
            ),
            ExpansionTile(
              title: Text(
                  AppLocalizations.of(context).translate(AppString.codText),
                  style:
                      TextStyle(fontSize: 14.sp, fontFamily: AppString.rubik)),
              children: <Widget>[
                ListTile(
                    leading: Checkbox(
                      checkColor: AppColors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isCOD,
                      onChanged: (bool? value) {
                        setState(() {
                          isCOD = value!;
                        });
                      },
                    ),
                    title: Text(AppLocalizations.of(context)
                        .translate(AppString.codText))),
              ],
            ),
          ],
        ),
      )),
    );
  }
}
