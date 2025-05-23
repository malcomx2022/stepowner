import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutterwave_standard/flutterwave.dart';
import 'package:stepowner/provider/provider_model/stripe_payment_provider.dart';
import 'package:stepowner/provider/provider_model/subscription_provider.dart';
import 'package:stepowner/retrofit/models/get_subscription_model.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:sizer/sizer.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';
import 'package:flutter_stripe/flutter_stripe.dart' hide Card;
import '../../retrofit/error_class.dart';

enum SingingCharacter { lafayette, jefferson }

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<SubscriptionScreen> {
  double? price;

  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late SubscriptionProvider subscriptionProvider;
  late Razorpay razorpay;
  Plan _character = Plan();

  @override
  void initState() {
    super.initState();
    setKey();
    subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      subscriptionProvider.getSettingData();
      subscriptionProvider.getPlanDataApiCall();
    });
    razorpay = Razorpay();
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
  }

  Future setKey() async {
    Stripe.publishableKey =
        PreferenceManager.getString(SharePreferenceKey.stripePublicKey);
    await Stripe.instance.applySettings();
  }

  @override
  Widget build(BuildContext context) {
    subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    return Scaffold(
      /// this condition revers work with same as other condition
      appBar:
          PreferenceManager.getString(SharePreferenceKey.subscriptionStatus) ==
                  "0"
              ? AppBar(
                  centerTitle: true,
                  iconTheme: const IconThemeData(color: AppColors.white),
                  backgroundColor: AppColors.commonColorSkyBlue,
                  title: Text(
                    AppLocalizations.of(context).translate(
                      AppString.subscription,
                    ),
                    style: TextStyle(
                        color: AppColors.white,
                        fontSize: 14.sp,
                        fontFamily: AppString.rubik),
                  ),
                )
              : null,
      body: subscriptionProvider.loader == true
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 5),
                    child: RichText(
                        text: TextSpan(
                            text: "Current Plan Expiry : ",
                            style: const TextStyle(
                                fontFamily: AppString.workSans,
                                color: AppColors.black),
                            children: [
                          TextSpan(
                            text: PreferenceManager.getString(
                                SharePreferenceKey.planExpiredOn),
                            style: const TextStyle(
                                fontFamily: AppString.workSans,
                                color: Colors.red),
                          )
                        ])),
                  ),
                  ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount:
                          subscriptionProvider.getSubscriptionData.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 14),
                          decoration: BoxDecoration(
                              color: AppColors.blue.withAlpha(50),
                              borderRadius: BorderRadius.circular(10)),
                          width: MediaQuery.of(context).size.width / 1.1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    subscriptionProvider
                                        .getSubscriptionData[index]
                                        .subscriptionName
                                        .toString(),
                                    style: TextStyle(
                                        fontFamily: AppString.rubik,
                                        fontSize: 20.sp),
                                  ),
                                  Text(
                                    subscriptionProvider
                                                .getSubscriptionData[index]
                                                .isPurchase ==
                                            1
                                        ? AppLocalizations.of(context)
                                            .translate(AppString.active)
                                        : "",
                                    style: TextStyle(
                                        fontFamily: AppString.rubik,
                                        fontSize: 10.sp),
                                  ),
                                ],
                              ),
                              GridView.builder(
                                  shrinkWrap: true,
                                  primary: false,
                                  padding: const EdgeInsets.all(8),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: subscriptionProvider
                                      .getSubscriptionData[index].plan?.length,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          childAspectRatio: 3),
                                  itemBuilder: (context, indexes) {
                                    return subscriptionProvider
                                                    .getSubscriptionData[index]
                                                    .subscriptionName ==
                                                "Trial" ||
                                            subscriptionProvider
                                                    .getSubscriptionData[index]
                                                    .subscriptionName ==
                                                "Free Trial" ||
                                            subscriptionProvider
                                                    .getSubscriptionData[index]
                                                    .subscriptionName ==
                                                "Free"
                                        ? Center(
                                            child: Text(
                                            "Free ${subscriptionProvider.getSubscriptionData[index].trialDays} Days Validity",
                                            style: TextStyle(
                                                fontSize: 12.sp,
                                                fontFamily: AppString.rubik),
                                          ))
                                        : RadioListTile<Plan>(
                                            contentPadding: EdgeInsets.zero,
                                            visualDensity: const VisualDensity(
                                                horizontal: -4, vertical: -4),
                                            title: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)} ${subscriptionProvider.getSubscriptionData[index].plan![indexes].price.toString()}" /*"${subscriptionProvider.getSubscriptionData[index].plan![indexes].month.toString()} Month"*/),
                                                Text(
                                                    /*"${PreferenceManager.getString(SharePreferenceKey.currency_Symbol)} ${subscriptionProvider.getSubscriptionData[index].plan![indexes].price.toString()}/"*/
                                                    "${subscriptionProvider.getSubscriptionData[index].plan![indexes].month.toString()} - ${AppLocalizations.of(context).translate(AppString.month)}"),
                                              ],
                                            ),
                                            value: subscriptionProvider
                                                .getSubscriptionData[index]
                                                .plan![indexes],
                                            groupValue: _character,
                                            onChanged: (Plan? value) {
                                              setState(() {
                                                _character = value!;
                                                if (kDebugMode) {
                                                  print(value.month);
                                                  print(subscriptionProvider
                                                      .getSubscriptionData[
                                                          index]
                                                      .id!);
                                                }
                                                subscriptionProvider
                                                        .subscriptionId =
                                                    subscriptionProvider
                                                        .getSubscriptionData[
                                                            index]
                                                        .id
                                                        .toString();
                                                subscriptionProvider
                                                        .subscriptionAmount =
                                                    int.parse(
                                                        value.price.toString());
                                                subscriptionProvider
                                                        .subscriptionDuration =
                                                    value.month.toString();
                                                subscriptionProvider.notify();
                                              });
                                            },
                                          );
                                  }),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Text(
                                    "• Maximum ${subscriptionProvider.getSubscriptionData[index].maxSpaceLimit} Spaces Allowed"),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              ),
            ),
      bottomNavigationBar: MaterialButton(
        height: 50,
        minWidth: MediaQuery.of(context).size.width,
        color: _character.month == null
            ? AppColors.grey
            : AppColors.commonColorSkyBlue,
        onPressed: () {
          if (kDebugMode) {
            print(_character.month);
          }
          _character.month == null
              ? null
              : showModalBottomSheet(
                  context: context,
                  builder: ((context) => bottomSheet(context)),
                );
        },
        child: Text(
          AppLocalizations.of(context).translate(AppString.buyText),
          style: TextStyle(
              fontFamily: AppString.rubik,
              fontSize: 15.sp,
              color: AppColors.white),
        ),
      ),
    );
  }

  Widget bottomSheet(context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                AppLocalizations.of(context)
                    .translate(AppString.selectPaymentMethod),
                style:
                    const TextStyle(fontFamily: AppString.rubik, fontSize: 20),
              ),
            ),

            /// Stripe
            PreferenceManager.getString(SharePreferenceKey.stripeStatus) == "1"
                ? ListTile(
                    onTap: () {
                      Provider.of<StripePaymentProvider>(context, listen: false)
                          .makePayment(
                              context: context,
                              amount: subscriptionProvider.subscriptionAmount!,
                              subscriptionDuration:
                                  subscriptionProvider.subscriptionDuration,
                              subscriptionId:
                                  subscriptionProvider.subscriptionId,
                              subscriptionProvider: subscriptionProvider)
                          .whenComplete(() {
                        Navigator.of(context).pop();
                      });
                    },
                    title: paymentDesign("assets/image/stripe.png", "Stripe"),
                  )
                : Container(),

            /// RazorPay
            PreferenceManager.getString(SharePreferenceKey.razorPayStatus) ==
                    "1"
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      openCheckout();
                    },
                    title:
                        paymentDesign("assets/image/razorPay.png", "Razorpay"),
                  )
                : Container(),

            /// PayPal
            PreferenceManager.getString(SharePreferenceKey.payPalStatus) == "1"
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => payPalPaymentCall()));
                    },
                    title: paymentDesign(
                        "assets/image/Paypal_2014_logo.png", "PayPal"),
                  )
                : Container(),

            /// FlutterWave
            PreferenceManager.getString(SharePreferenceKey.flutterWaveStatus) ==
                    "1"
                ? ListTile(
                    onTap: () {
                      Navigator.pop(context);
                      flutterWavePayment(context);
                    },
                    title: paymentDesign(
                        "assets/image/Flutterwave-Symbol.png", "flutterwave"))
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget paymentDesign(image, name) {
    return Row(
      children: [
        Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 10),
          width: 60,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
              color: Colors.blueAccent.withAlpha(80),
              borderRadius: BorderRadius.circular(10)),
          child: Image.asset(
            image,
            width: 55,
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Text(
          name,
          style: TextStyle(fontSize: 12.sp, fontFamily: AppString.rubik),
        ),
      ],
    );
  }

  /// payPal
  Widget payPalPaymentCall() {
    final String currency;
    if (PreferenceManager.getString(SharePreferenceKey.currency).isEmpty ||
        PreferenceManager.getString(SharePreferenceKey.currency) != "null") {
      currency = 'USD';
    } else {
      currency = PreferenceManager.getString(SharePreferenceKey.currency);
    }
    return UsePaypal(
        sandboxMode: true,
        clientId:
            PreferenceManager.getString(SharePreferenceKey.payPalClientId),
        secretKey:
            PreferenceManager.getString(SharePreferenceKey.payPalSecretKey),
        returnURL: "https://samplesite.com/return",
        cancelURL: "https://samplesite.com/cancel",
        transactions: [
          {
            "amount": {
              "total": subscriptionProvider.subscriptionAmount,
              "currency": currency,
              "details": {
                "subtotal": subscriptionProvider.subscriptionAmount,
              }
            },
            "description": "The payment transaction description.",
            "payment_options": const {
              "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
            },
            "item_list": {
              "items": [
                {
                  "name": "PayPark Owner",
                  "quantity": 1,
                  "price": subscriptionProvider.subscriptionAmount,
                  "currency": currency
                }
              ],
            }
          }
        ],
        note: "Contact us for any questions on your order.",
        onSuccess: (Map params) async {
          if (kDebugMode) {
            print("onSuccess: ${params["token"]}");
          }
          subscriptionProvider.purchaseSubscriptionApiCall(
              subscriptionProvider.subscriptionAmount,
              params["token"],
              "PAYPAL",
              subscriptionProvider.subscriptionDuration,
              subscriptionProvider.subscriptionId);
          CommonFunction.toastMessage("Payment Successfully");
        },
        onError: (error) {
          if (kDebugMode) {
            print("onError: $error");
          }
        },
        onCancel: (params) {
          if (kDebugMode) {
            print('cancelled: $params');
          }
        });
  }

  /// RazorPay
  void openCheckout() async {
    var options = {
      'key': PreferenceManager.getString(SharePreferenceKey.razorPayKey),
      'amount': subscriptionProvider.subscriptionAmount! * 100,
      'currency': PreferenceManager.getString(SharePreferenceKey.currency),
      'receipt': 'rcptid #11',
      'name': 'PayPark Owner',
      'send_sms_hash': true,
      'prefill': {
        'contact':
            PreferenceManager.getString(SharePreferenceKey.phoneNumberKey),
        'email': PreferenceManager.getString(SharePreferenceKey.emailKey)
      },
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    if (kDebugMode) {
      print(response.paymentId);
    }
    if (response.paymentId != null) {
      subscriptionProvider.purchaseSubscriptionApiCall(
          subscriptionProvider.subscriptionAmount,
          response.paymentId,
          "RAZORPAY",
          subscriptionProvider.subscriptionDuration,
          subscriptionProvider.subscriptionId);
    }
  }

  /// Flutter wave stander
  final String currencyFlutterWave = "RWF";

  flutterWavePayment(BuildContext context) async {
    final flutterWave = Flutterwave(
      publicKey: PreferenceManager.getString(SharePreferenceKey.flutterWaveKey),
      currency: currencyFlutterWave,
      txRef: const Uuid().v1(),
      amount: subscriptionProvider.subscriptionAmount.toString(),
      customer: customer,
      paymentOptions: "card",
      customization: Customization(
        title: "PayPark Owner",
        description: "Demo",
        logo: "Logo",
      ),
      redirectUrl: "https://www.google.com",
      isTestMode: true,
    );

    final ChargeResponse response = await flutterWave.charge(context);

    if (response.transactionId != null && response.transactionId!.isNotEmpty) {
      if (mounted) {
        setState(() {
          if (kDebugMode) {
            print("Wave token: ${response.txRef}");
          }
          subscriptionProvider.purchaseSubscriptionApiCall(
            subscriptionProvider.subscriptionAmount,
            response.transactionId,
            "FLUTTERWAVE",
            subscriptionProvider.subscriptionDuration,
            subscriptionProvider.subscriptionId,
          );
          if (kDebugMode) {
            print("Wave Transaction Id: ${response.transactionId}");
          }
        });
      }
    }
  }

  final Customer customer = Customer(
      name: PreferenceManager.getString(SharePreferenceKey.nameKey),
      phoneNumber:
          PreferenceManager.getString(SharePreferenceKey.phoneNumberKey),
      email: PreferenceManager.getString(SharePreferenceKey.emailKey));
}

class LoadingButton extends StatefulWidget {
  final Future Function()? onPressed;
  final String text;

  const LoadingButton({super.key, required this.onPressed, required this.text});

  @override
  State<LoadingButton> createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12)),
            onPressed:
                (_isLoading || widget.onPressed == null) ? null : _loadFuture,
            child: _isLoading
                ? const SizedBox(
                    height: 22,
                    width: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ))
                : Text(widget.text),
          ),
        ),
      ],
    );
  }

  Future<void> _loadFuture() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onPressed!();
    } catch (e, s) {
      log(e.toString(), error: e, stackTrace: s);
      if (context.mounted)
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error $e')));
      rethrow;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
