import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late AuthProvider auth;
  bool _isObscure = true;
  final bool _isCredentialsReadOnly = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    auth = Provider.of<AuthProvider>(context, listen: false);
    if (PreferenceManager.getBoolean(SharePreferenceKey.locationPermission) ==
        true) {
      auth.getSettingData();
    }
  }

  void validate() {
    if (formKey.currentState!.validate()) {
      if (kDebugMode) {
        print("Done validation");
      }
    } else {
      if (kDebugMode) {
        print("Error validation");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferenceManager.getBoolean(SharePreferenceKey.locationPermission) == false
        ? Future.delayed(Duration.zero, () {
            showAlertDialog(context);
          })
        : null;
    auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: SingleChildScrollView(
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: Form(
                key: formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/payPark.png",
                          width: 130,
                          height: 120,
                        ),
                      ),
                      SizedBox(
                        height: 2.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppString.signIn),
                            style: TextStyle(
                                fontSize: 18.sp,
                                fontFamily: AppString.workSans,
                                color: AppColors.lightBlue),
                          )
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 5.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.email),
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.fontColorBlue),
                        ),
                      ),
                      TextFormField(
                        readOnly: _isCredentialsReadOnly,
                        controller: emailController,
                        scrollPadding: EdgeInsets.zero,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.entreYourEmail),
                          hintStyle: const TextStyle(
                              color: AppColors.greyWithAlpha,
                              fontFamily: AppString.rubikRegular),
                          border: InputBorder.none,
                        ),
                      ),
                      Container(
                        color: AppColors.greyWithAlpha,
                        height: 1,
                        margin: EdgeInsets.only(
                          bottom: 3.h,
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.password),
                        style: TextStyle(
                            fontSize: 13.sp,
                            fontFamily: AppString.rubik,
                            color: AppColors.fontColorBlue),
                      ),
                      TextFormField(
                        readOnly: _isCredentialsReadOnly,
                        controller: passwordController,
                        obscureText: _isObscure,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.entrePassword),
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                color: AppColors.greyWithAlpha,
                                fontFamily: AppString.rubikRegular),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isObscure
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.fontColorBlue,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isObscure = !_isObscure;
                                });
                              },
                            )),
                      ),
                      Container(
                        color: AppColors.greyWithAlpha,
                        height: 1,
                        margin: EdgeInsets.only(bottom: 3.h),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacementNamed(
                                  context, RouteName.forgotPasswordRoute);
                            },
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.loginForget),
                              style: TextStyle(
                                  fontSize: 11.sp, fontFamily: AppString.rubik),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (emailController.text.isNotEmpty) {
                            if (passwordController.text.isNotEmpty) {
                              auth.checkLogin(
                                  emailController.text.toString(),
                                  passwordController.text.toString(),
                                  auth.type,
                                  PreferenceManager.getString(
                                      SharePreferenceKey.deviceToken),
                                  context);
                            } else {
                              CommonFunction.toastMessage(
                                  AppLocalizations.of(context)
                                      .translate(AppString.entrePassword));
                            }
                          } else {
                            CommonFunction.toastMessage(
                                AppLocalizations.of(context)
                                    .translate(AppString.validationEmailEntre));
                          }
                        },
                        color: AppColors.blue,
                        height: 50,
                        minWidth: MediaQuery.of(context).size.width,
                        textColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25)),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.signInAsOwner),
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: "Rubik",
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                            color: Colors.grey.withAlpha(120),
                          )),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppString.or),
                            style:
                                TextStyle(color: Colors.black54.withAlpha(120)),
                          ),
                          Expanded(
                              child: Divider(
                            color: Colors.grey.withAlpha(120),
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.needAccount),
                              style: TextStyle(
                                  fontSize: 13.sp,
                                  color: AppColors.lightBlue,
                                  fontFamily: AppString.rubikRegular),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.signUP),
                              style: TextStyle(
                                fontFamily: AppString.rubik,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: AppColors.lightBlue,
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
              )),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(AppLocalizations.of(context).translate(AppString.okBtn)),
      onPressed: () {
        Navigator.pop(context);
        PreferenceManager.setBoolean(
            SharePreferenceKey.locationPermission, true);
        auth.getSettingData();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      title: Text(
        AppLocalizations.of(context).translate(AppString.disclaimer),
        style: const TextStyle(fontFamily: AppString.rubik, fontSize: 20),
      ),
      content: Text(
        AppLocalizations.of(context)
            .translate(AppString.payParkAppUsesLocation),
        style:
            const TextStyle(fontFamily: AppString.rubikRegular, fontSize: 18),
      ),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
