import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'package:stepowner/provider/provider_model/subscription_provider.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';

class StripePaymentProvider extends ChangeNotifier {
  Map<String, dynamic>? paymentIntent;
  String stripeKey = "";

  Future<void> makePayment({
    required BuildContext context,
    required int amount,
    required String subscriptionDuration,
    required String subscriptionId,
    required SubscriptionProvider subscriptionProvider,
  }) async {
    try {
      stripeKey =
          PreferenceManager.getString(SharePreferenceKey.stripeSecretKey);
      paymentIntent = await createPaymentIntent(
        amount.toString(),
      );

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Paypark'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      // ignore: use_build_context_synchronously
      displayPaymentSheet(
          context: context,
          amount: amount,
          subscriptionDuration: subscriptionDuration,
          subscriptionId: subscriptionId,
          subscriptionProvider: subscriptionProvider);
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet({
    required BuildContext context,
    required int amount,
    required String subscriptionDuration,
    required String subscriptionId,
    required SubscriptionProvider subscriptionProvider,
  }) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        if (kDebugMode) {
          print("Stripe Token : ${paymentIntent!["id"]}");
        }
        subscriptionProvider.purchaseSubscriptionApiCall(
            amount,
            paymentIntent!["id"],
            "STRIPE",
            subscriptionDuration,
            subscriptionId);
        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      if (kDebugMode) {
        print('Error is:---> $e');
      }
      const AlertDialog(
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.white,
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      if (kDebugMode) {
        print('$e');
      }
      const AlertDialog(
        surfaceTintColor: AppColors.white,
        shadowColor: AppColors.white,
        backgroundColor: AppColors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    }
  }

  createPaymentIntent(
    String amount,
  ) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': "USD",
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':
              'Bearer $stripeKey', // ${dotenv.env['STRIPE_SECRET']}
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    Widget continueButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
          elevation: 0, backgroundColor: AppColors.fontColorBlue),
      child: const Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  int? bookTicketId;
}
