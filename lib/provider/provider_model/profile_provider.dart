import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/get_owner_profile.dart';
import 'package:stepowner/retrofit/models/profile_password_update.dart';
import 'package:stepowner/retrofit/models/profile_picture_update.dart';
import 'package:stepowner/retrofit/models/profile_setting_update_model.dart';
import 'package:stepowner/retrofit/models/profile_update.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';

import '../../retrofit/models/owner_setting_model.dart';
import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class ProfileProvider extends ChangeNotifier {
  TextEditingController stripSecretController = TextEditingController();
  TextEditingController stripKeyController = TextEditingController();
  TextEditingController flutterWaveKeyController = TextEditingController();
  TextEditingController payPalClientIdController = TextEditingController();
  TextEditingController payPalSecretKeyController = TextEditingController();
  TextEditingController razorKeyController = TextEditingController();

  AuthProvider authProvider = AuthProvider();

  /// profile password update
  Future<BaseModel<ProfilePasswordUpdate>> updatePassword(
      password, confirmPassword) async {
    ProfilePasswordUpdate response;

    Map<String, String> body = {
      "password": password,
      "password_confirmation": confirmPassword
    };
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).changePassword(body);
      if (response.success == true) {
        if (kDebugMode) {
          print(response.msg);
        }
        CommonFunction.toastMessage(response.msg!);
        Loading.hideDialog();
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// get Owner Profile
  GetOwnerProfile profileData = GetOwnerProfile(
      name: "",
      image: "",
      createdAt: "",
      customerId: "",
      email: "",
      id: 0,
      imageUri: "",
      phoneNo: "",
      status: 0,
      updatedAt: "",
      verified: 0,
      stripePk: "",
      stripeSk: "",
      subscriptionStatus: 0);

  Future<BaseModel<GetOwnerProfile>> getProfileApiCall() async {
    GetOwnerProfile response;
    try {
      response = await ClientApi(RestClient().dioData()).getProfile();
      if (response.email != null) {
        profileData = response;
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// Profile Update
  Future<BaseModel<ProfileUpdate>> profileUpdate(
      String name, String phoneNo, context) async {
    ProfileUpdate response;

    Map<String, String> body = {"name": name, "phone_no": phoneNo};
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).profileUpdate(body);
      if (response.success == true) {
        getProfileApiCall();
        CommonFunction.toastMessage(response.msg!);
      }
      notifyListeners();
      Loading.hideDialog();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// Profile picture update
  Future<BaseModel<ProfilePictureUpdate>> pictureUpdate(image) async {
    ProfilePictureUpdate response;
    Map<String, String> body = {"image": image};
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).pictureUpdate(body);
      if (response.success == true) {
        getProfileApiCall();
        CommonFunction.toastMessage(response.msg!);
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// profile setting update
  Future<BaseModel<ProfileSettingUpdateModel>> profileSetting(
      stripeStatus,
      razorPayStatus,
      payPalStatus,
      flutterWaveStatus,
      stripeSecretKey,
      stripePublicKey,
      razorPayKey,
      payPalClientKey,
      payPalSecretKey,
      flutterWaveKey,
      flutterWaveLiveMode,
      cod) async {
    ProfileSettingUpdateModel response;
    Map<String, dynamic> body = {
      "stripe_status": stripeStatus,
      "razorpay_status": razorPayStatus,
      "paypal_status": payPalStatus,
      "flutterwave_status": flutterWaveStatus,
      "stripe_secret": stripeSecretKey,
      "stripe_public": stripePublicKey,
      "razorpay_key": razorPayKey,
      "paypal_client_key": payPalClientKey,
      "paypal_secret_key": payPalSecretKey,
      "flutterwave_key": flutterWaveKey,
      "isLiveMode": flutterWaveLiveMode,
      "cod": cod
    };

    try {
      Loading.showLoader();
      response =
          await ClientApi(RestClient().dioData()).profileSettingUpdate(body);
      if (response.success == true) {
        CommonFunction.toastMessage(response.msg!);
        authProvider.getSettingData();
        Loading.hideDialog();
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// owner setting model
  Future<BaseModel<OwnerSettingModel>> ownerSettingApiCall() async {
    OwnerSettingModel response;

    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).ownerSettingApiCall();
      if (response.success == true) {
        PreferenceManager.setString(SharePreferenceKey.userStripeStatus,
            response.data!.stripeStatus.toString());
        PreferenceManager.setString(SharePreferenceKey.userFlutterWaveStatus,
            response.data!.flutterWaveStatus.toString());
        PreferenceManager.setString(SharePreferenceKey.userPayPalStatus,
            response.data!.paypalStatus.toString());
        PreferenceManager.setString(SharePreferenceKey.userRazorPayStatus,
            response.data!.razorpayStatus.toString());
        PreferenceManager.setString(SharePreferenceKey.userStripePublic,
            response.data!.stripePublic.toString());
        PreferenceManager.setString(SharePreferenceKey.userStripeSecret,
            response.data!.stripeSecret.toString());
        PreferenceManager.setString(SharePreferenceKey.userRazorpayKey,
            response.data!.razorpayKey.toString());
        PreferenceManager.setString(SharePreferenceKey.userFlutterWaveKey,
            response.data!.flutterWaveKey.toString());
        PreferenceManager.setString(SharePreferenceKey.userFlutterWaveLiveMode,
            response.data!.isLiveMode.toString());
        PreferenceManager.setString(SharePreferenceKey.userPaypalClientKey,
            response.data!.paypalClientKey.toString());
        PreferenceManager.setString(SharePreferenceKey.userPaypalSecretKey,
            response.data!.paypalSecretKey.toString());
        PreferenceManager.setString(
            SharePreferenceKey.userCodAvailable, response.data!.cod.toString());
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel().setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  notify() {
    notifyListeners();
  }

  clearData() {
    profileData = GetOwnerProfile(
        name: "",
        image: "",
        createdAt: "",
        customerId: "",
        email: "",
        id: 0,
        imageUri: "",
        phoneNo: "",
        status: 0,
        updatedAt: "",
        verified: 0,
        stripePk: "",
        stripeSk: "",
        subscriptionStatus: 0);
  }

  static onError(error) {
    if (kDebugMode) {
      print('the error is ${error.detail}');
    }
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  String convertBase64(File selectedFile) {
    List<int> imageBytes = selectedFile.readAsBytesSync();
    return base64Encode(imageBytes);
  }

  ProfileProvider() {
    clearData();
  }
}
