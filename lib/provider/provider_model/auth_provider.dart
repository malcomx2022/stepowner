import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/owner_setting_model.dart';
import 'package:stepowner/retrofit/models/setting_model.dart';
import 'package:stepowner/retrofit/models/guard_forgot_password_model.dart';
import 'package:stepowner/retrofit/models/login_model.dart';
import 'package:stepowner/retrofit/models/register_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:stepowner/utils/constant/loading.dart';

class AuthProvider extends ChangeNotifier {
  var type = "owner";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  /// login api
  Future<BaseModel<LoginModel>> checkLogin(
      String email, String password, String owner, deviceToken, context) async {
    if (kDebugMode) {
      print(deviceToken);
    }
    LoginModel response;
    Map<String, String> body = {
      "email": email,
      "password": password,
      "type": owner,
      "device_token": deviceToken
    };
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).postLogin(body);
      if (kDebugMode) {
        print('login api data : ${response.toJson()}');
      }
      if (response.success == true) {
        if (response.data!.verified == 1) {
          PreferenceManager.setString(
              SharePreferenceKey.tokenKey, response.data!.token.toString());
          PreferenceManager.setString(
              SharePreferenceKey.emailKey, response.data!.email.toString());
          PreferenceManager.setString(
              SharePreferenceKey.nameKey, response.data!.name.toString());
          PreferenceManager.setString(
              SharePreferenceKey.imageKey, response.data!.image.toString());
          PreferenceManager.setString(SharePreferenceKey.phoneNumberKey,
              response.data!.phoneNo.toString());
          PreferenceManager.setString(SharePreferenceKey.customerId,
              response.data!.customerId.toString());
          PreferenceManager.setString(
              SharePreferenceKey.id, response.data!.id.toString());
          PreferenceManager.setString(SharePreferenceKey.subscriptionStatus,
              response.data!.subscriptionStatus.toString());
          PreferenceManager.setString(SharePreferenceKey.planExpiredOn,
              response.data!.planExpireOn.toString());
          PreferenceManager.setInt(
              SharePreferenceKey.maxSpaceLimit,
              response.data!.maxSpaceLimit != null
                  ? response.data!.maxSpaceLimit!
                  : 00);
          PreferenceManager.setBoolean(SharePreferenceKey.isLogin, true);
          CommonFunction.toastMessage("Welcome To StepOwner");
          if (kDebugMode) {
            print(response.data);
          }
          Loading.hideDialog();
          ownerSettingApiCall();
          notifyListeners();
          Navigator.pushNamedAndRemoveUntil(
              context, RouteName.mainDrawerRoute, (route) => false);
        }

        notifyListeners();
      } else {
        Loading.hideDialog();
        if (kDebugMode) {
          print('error msg : ${response.msg}');
        }
        CommonFunction.toastMessage(response.msg.toString());
      }
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// register
  Future<BaseModel<RegisterModel>> userRegister(
      String email, String name, String password, context) async {
    RegisterModel response;

    Map<String, String> body = {
      "email": email,
      "name": name,
      "password": password,
    };

    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).postRegisterUser(body);
      if (response.success == true) {
        CommonFunction.toastMessage("Register Successful");
        Loading.hideDialog();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.onBoard5,
          (route) => false,
        );
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// forgot api call

  Future<BaseModel<OwnerForgotPasswordModel>> forgotApiCall(
      String email, context) async {
    OwnerForgotPasswordModel response;

    Map<String, String> body = {"email": email};
    try {
      Loading.showLoader();
      response =
          await ClientApi(RestClient().dioData()).forgotPasswordCall(body);
      if (response.success == true) {
        Navigator.pushReplacementNamed(context, RouteName.signInRoute);
        Loading.hideDialog();
        CommonFunction.toastMessage(response.msg.toString());
        if (kDebugMode) {
          print(response.msg);
        }
      }
      CommonFunction.toastMessage(response.msg.toString());
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// setting api call
  Future<BaseModel<SettingModel>> getSettingData() async {
    SettingModel response;
    try {
      response = await ClientApi(RestClient().dioData()).settingApiCall();
      if (response.success == true) {
        if (response.data != null) {
          PreferenceManager.setString(
              SharePreferenceKey.appId, response.data!.ownerAppId.toString());
          PreferenceManager.setString(SharePreferenceKey.flutterWaveKey,
              response.data!.flutterWaveKey.toString());
          PreferenceManager.setString(SharePreferenceKey.flutterWaveMode,
              response.data!.isLiveMode.toString());
          PreferenceManager.setString(SharePreferenceKey.stripePublicKey,
              response.data!.stripePublic.toString());
          PreferenceManager.setString(SharePreferenceKey.stripeSecretKey,
              response.data!.stripeSecret.toString());
          PreferenceManager.setString(SharePreferenceKey.razorPayKey,
              response.data!.razorpayKey.toString());
          PreferenceManager.setString(
              SharePreferenceKey.appId, response.data!.ownerAppId.toString());
          PreferenceManager.setString(SharePreferenceKey.payPalSecretKey,
              response.data!.paypalSecretKey.toString());
          PreferenceManager.setString(SharePreferenceKey.payPalClientId,
              response.data!.paypalClientId.toString());
          PreferenceManager.setString(
              SharePreferenceKey.currency, response.data!.currency.toString());
          PreferenceManager.setString(SharePreferenceKey.currencySymbol,
              response.data!.currencySymbol.toString());
          PreferenceManager.setString(SharePreferenceKey.payPalStatus,
              response.data!.paypalStatus.toString());
          PreferenceManager.setString(SharePreferenceKey.flutterWaveStatus,
              response.data!.flutterWaveStatus.toString());
          PreferenceManager.setString(SharePreferenceKey.razorPayStatus,
              response.data!.razorpayStatus.toString());
          PreferenceManager.setString(SharePreferenceKey.stripeStatus,
              response.data!.stripeStatus.toString());
          if (response.data!.ownerAppId != null) {
            getOneSingleToken(response.data!.ownerAppId);
          }
          notifyListeners();
        }
      }
      notifyListeners();
    } catch (error) {
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// owner setting model
  Future<BaseModel<OwnerSettingModel>> ownerSettingApiCall() async {
    OwnerSettingModel response;

    try {
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
        notifyListeners();
      }
      notifyListeners();
    } catch (error) {
      return BaseModel().setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// one signal code
  Future<void> getOneSingleToken(String? appId) async {
    if (appId == null) {
      getSettingData(); // ou gestion d'erreur si appId est requis
      return;
    }

    try {
      // Étape 1 : Initialisation de OneSignal
      OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

      OneSignal.initialize(appId); // ✅ Nouvelle méthode au lieu de setAppId

      // Étape 2 : Demander les autorisations utilisateur
      await OneSignal.Notifications.requestPermission(true);

      // Si vous avez besoin de localisation, demandez-la séparément (si configuré)
      // OneSignal.Location.enableLocationCollection(); // Optionnel si activé dans le dashboard

      // Étape 3 : Récupérer le device token après un délai court
      Future.delayed(const Duration(seconds: 3), () async {
        var deviceState = OneSignal.User.pushSubscription;
        String? pushToken = deviceState.token;

        if (pushToken != null) {
          PreferenceManager.setString(
              SharePreferenceKey.deviceToken, pushToken);
          print("device token: $pushToken");
        } else {
          // Réessayer en cas d'échec
          getOneSingleToken(appId);
        }
      });

      // Vérification finale (optionnelle)
      var finalDeviceState = OneSignal.User.pushSubscription;
      if (finalDeviceState.token != null) {
        PreferenceManager.setString(
            SharePreferenceKey.deviceToken, finalDeviceState.token!);
      }
    } catch (e) {
      print("Erreur OneSignal : $e");
      getOneSingleToken(appId); // Réessayer en cas d’erreur
    }
  }

  notify() {
    notifyListeners();
  }

  static onError(error) {
    if (kDebugMode) {
      print('the error is ${error.detail}');
    }
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
