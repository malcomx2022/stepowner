import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/get_buy_plan_model.dart';
import 'package:stepowner/retrofit/models/get_owner_plan.dart';
import 'package:stepowner/retrofit/models/owner_card_delete_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:stepowner/utils/constant/loading.dart';
import '../../retrofit/models/get_subscription_model.dart';
import '../../retrofit/models/subscription_history_model.dart';
import '../../retrofit/models/common_model.dart';
import '../../retrofit/models/setting_model.dart';

class SubscriptionProvider extends ChangeNotifier {
  GetOwnerPlanDataCard? character;
  bool loader = false;

  /// zip controller

  int? subscriptionAmount;
  String subscriptionDuration = '';
  String subscriptionId = '';
  List<SubscriptionHistoryModelData> subscriptionHistoryData = [];
  TextEditingController zipCode = TextEditingController();

  CardFieldInputDetails? card;

  TokenData? tokenData;

  /// get owner plan data variable
  List<SubscriptionData> getSubscriptionData = [];

  /// get plan data api
  Future<BaseModel<GetSubscriptionModel>> getPlanDataApiCall() async {
    GetSubscriptionModel response;
    try {
      Loading.showLoader();
      loader = true;
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).getPlanD();
      if (response.success == true) {
        getSubscriptionData = response.data!;
        Loading.hideDialog();
        notifyListeners();
      }
      loader = false;
      notifyListeners();
    } catch (error) {
      loader = false;
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  ///purchase Subscription api call
  Future<BaseModel<CommonModel>> purchaseSubscriptionApiCall(
      amount, paymentToken, paymentType, duration, subscriptionId) async {
    CommonModel response;
    Map<String, dynamic> body = {
      "amount": amount,
      "payment_token": paymentToken,
      "payment_type": paymentType,
      "duration": duration,
      "subscription_id": subscriptionId,
    };
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData())
          .purchaseSubscriptionCall(body);
      if (response.success == true) {
        CommonFunction.toastMessage(response.message!);
        getPlanDataApiCall();
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel().setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// subscription History Api call
  Future<BaseModel<SubscriptionHistoryModel>>
      subscriptionHistoryApiCall() async {
    SubscriptionHistoryModel response;
    try {
      Loading.showLoader();
      response =
          await ClientApi(RestClient().dioData()).subscriptionHistoryCall();
      if (response.data != null) {
        subscriptionHistoryData = response.data!.reversed.toList();
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel().setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// history plan api
  Future<BaseModel<GetBuyPlanModel>> getBuyPlan(String id) async {
    GetBuyPlanModel response;

    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).buyPlanHistory(id);
      if (response.success == true) {
        getPlanDataApiCall();
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
          notifyListeners();
        }
      }
      notifyListeners();
    } catch (error) {
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// delete card model
  Future<BaseModel<OwnerCardDeleteModel>> cardDeleteApiCall(String id) async {
    OwnerCardDeleteModel response;
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).cardDeleteCall(id);
      if (response.success == true) {
        getPlanDataApiCall();
        CommonFunction.toastMessage(response.msg.toString());
        Loading.hideDialog();
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// Stripe token create
  Future<void> handleCreateTokenPress(context, zipCode) async {
    if (card == null) {
      return;
    }
    try {
      final address = Address(
        city: "",
        country: "",
        line1: "",
        line2: "",
        state: '',
        postalCode: zipCode,
      ); // mocked data for tests

      tokenData = await Stripe.instance.createToken(
        CreateTokenParams.card(
            params: CardTokenParams(
          address: address,
        )),
      );

      tokenData = tokenData;
      notifyListeners();
      if (kDebugMode) {
        print(tokenData!.id);
      }

      return;
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
      rethrow;
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
