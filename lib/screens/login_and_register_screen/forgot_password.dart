import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController emailController = TextEditingController();
  TextEditingController otpVerifyController = TextEditingController();

  late AuthProvider auth = Provider.of(context, listen: false);

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    auth = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.white,
        leading: null,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pushReplacementNamed(context, RouteName.signInRoute);
              },
              child: const Icon(Icons.arrow_back_ios_outlined),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppLocalizations.of(context)
                        .translate(AppString.loginForget),
                    style:
                        TextStyle(fontFamily: AppString.rubik, fontSize: 15.sp),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 30, left: 10, right: 10, bottom: 10),
                child: Text(
                  AppLocalizations.of(context)
                      .translate(AppString.forgotScreenTextResetEmail),
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(fontSize: 15.sp, fontFamily: AppString.rubik),
                ),
              ),
              Container(
                height: 8.h,
                width: 90.w,
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.only(top: 7),
                decoration: BoxDecoration(
                    border:
                        Border.all(color: AppColors.greyWithAlpha, width: 1)),
                child: TextFormField(
                  controller: emailController,
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: AppLocalizations.of(context)
                            .translate(AppString.validationEmailEntre)),
                    EmailValidator(
                        errorText: AppLocalizations.of(context)
                            .translate(AppString.entreValidEmail))
                  ]).call,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: AppColors.commonColorSkyBlue,
                      ),
                      prefixIconColor: AppColors.commonColorSkyBlue,
                      hintText: AppLocalizations.of(context)
                          .translate(AppString.emailHint)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: MaterialButton(
                  onPressed: () {
                    emailController.text.isNotEmpty
                        ? auth.forgotApiCall(
                            emailController.text.toString(), context)
                        : CommonFunction.toastMessage(
                            AppLocalizations.of(context)
                                .translate(AppString.validationEmailEntre));
                  },
                  height: 7.5.h,
                  minWidth: 90.w,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: AppColors.commonColorSkyBlue,
                  child: Text(
                    emailController.text.isEmpty
                        ? AppLocalizations.of(context)
                            .translate(AppString.sendText)
                        : AppLocalizations.of(context)
                            .translate(AppString.verifyText),
                    style: TextStyle(
                        fontSize: 17.sp,
                        fontFamily: AppString.rubik,
                        color: AppColors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
