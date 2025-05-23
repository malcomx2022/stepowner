import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:stepowner/provider/provider_model/current_time_provider.dart';
import 'package:stepowner/provider/provider_model/image_provider.dart';
import 'package:stepowner/provider/provider_model/navigator_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/custom_router/custom_router.dart';
import 'package:stepowner/provider/provider_model/facilities_provider.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/provider/provider_model/profile_provider.dart';
import 'package:stepowner/provider/provider_model/review_provider.dart';
import 'package:stepowner/provider/provider_model/stripe_payment_provider.dart';
import 'package:stepowner/provider/provider_model/subscription_provider.dart';
import 'package:stepowner/provider/provider_model/transaction_provider.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'custom_router/route_names.dart';
import 'provider/provider_model/language_provider.dart';
import 'utils/change_language/app_location.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferenceManager.init();
  HttpOverrides.global = MyHttpOverrides();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
            create: (context) => AuthProvider()),
        ChangeNotifierProvider<ProfileProvider>(
            create: (context) => ProfileProvider()),
        ChangeNotifierProvider<GuardProvider>(
            create: (context) => GuardProvider()),
        ChangeNotifierProvider<SubscriptionProvider>(
            create: (context) => SubscriptionProvider()),
        ChangeNotifierProvider<ReviewProvider>(
            create: (context) => ReviewProvider()),
        ChangeNotifierProvider<FacilitiesProvider>(
            create: (context) => FacilitiesProvider()),
        ChangeNotifierProvider<SpaceProvider>(
            create: (context) => SpaceProvider()),
        ChangeNotifierProvider<ImagesProvider>(
            create: (context) => ImagesProvider()),
        ChangeNotifierProvider<TransactionProvider>(
            create: (context) => TransactionProvider()),
        ChangeNotifierProvider<NavigatorProvider>(
            create: (context) => NavigatorProvider()),
        ChangeNotifierProvider<LanguageProvider>(
            create: (context) => LanguageProvider()),
        ChangeNotifierProvider<TimeProvider>(
            create: (context) => TimeProvider()),
        ChangeNotifierProvider<StripePaymentProvider>(
            create: (context) => StripePaymentProvider())
      ],
      child: const MyApp(),
    ),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, host, port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return Consumer<LanguageProvider>(
        builder: (_, languageProviderRef, __) {
          return GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus &&
                  currentFocus.focusedChild != null) {
                FocusManager.instance.primaryFocus!.unfocus();
              }
            },
            child: GetMaterialApp(
                navigatorKey: navigatorKey,
                onGenerateRoute: CustomRouter.allRoutes,
                debugShowCheckedModeBanner: false,
                title: "Stepowner",
                locale: languageProviderRef.appLocale,
                supportedLocales: const [
                  /// TODO Localization: Add more languages here. Make sure the language JSON file is in the "/assets/language/" folder
                  Locale('en', 'US'),
                  Locale('zh', 'CN'),
                  // Locale('fr', 'FR'), // Add more languages like this
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode ||
                        supportedLocale.countryCode == locale?.countryCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
                theme: ThemeData(primarySwatch: Colors.cyan),
                initialRoute:
                    PreferenceManager.getBoolean(SharePreferenceKey.isLogin) ==
                            true
                        ? RouteName.mainDrawerRoute
                        : RouteName.signInRoute),
          );
        },
      );
    });
  }
}
