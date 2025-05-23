import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stepowner/provider/provider_model/auth_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _showPassword = true;
  bool _showConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    AuthProvider auth = Provider.of<AuthProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.white,
        body: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: SizedBox(
            width: 100.w,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 35, horizontal: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/payPark.png",
                              width: 155,
                              height: 150.86,
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.signUP),
                              style: TextStyle(
                                  fontSize: 18.sp,
                                  fontFamily: AppString.workSans,
                                  color: AppColors.fontColorBlue),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppString.name),
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.fontColorBlue),
                        ),
                        TextFormField(
                          validator: RequiredValidator(
                                  errorText: AppLocalizations.of(context)
                                      .translate(AppString.validationNameEntre))
                              .call,
                          controller: auth.nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.enterYourName),
                            hintStyle: const TextStyle(
                                color: AppColors.greyWithAlpha,
                                fontFamily: AppString.rubikRegular),
                          ),
                        ),
                        Container(
                          color: AppColors.greyWithAlpha,
                          height: 1,
                          margin: EdgeInsets.only(
                            bottom: 2.h,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppString.email),
                          style: TextStyle(
                              fontSize: 13.sp,
                              fontFamily: AppString.rubik,
                              color: AppColors.fontColorBlue),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.validationEmailEntre)),
                            EmailValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.entreValidEmail)),
                          ]).call,
                          controller: auth.emailController,
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: AppLocalizations.of(context)
                                  .translate(AppString.validationEmailEntre),
                              hintStyle: TextStyle(
                                  color: AppColors.greyWithAlpha,
                                  fontSize: 12.sp,
                                  fontFamily: AppString.rubikRegular)),
                        ),
                        Container(
                          color: AppColors.greyWithAlpha,
                          height: 1,
                          margin: EdgeInsets.only(
                            bottom: 2.h,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppString.password),
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.fontColorBlue,
                              fontFamily: AppString.rubik),
                        ),
                        TextFormField(
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.entrePassword)),
                            MinLengthValidator(6,
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString
                                        .entrePasswordMustBeSixCharacter))
                          ]).call,
                          controller: auth.passwordController,
                          obscureText: _showPassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.entrePassword),
                            hintStyle: const TextStyle(
                                color: AppColors.greyWithAlpha,
                                fontFamily: AppString.rubikRegular),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.fontColorBlue,
                              ),
                              onPressed: () {
                                setState(() => _showPassword = !_showPassword);
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: AppColors.greyWithAlpha,
                          height: 1,
                          margin: EdgeInsets.only(
                            bottom: 2.h,
                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)
                              .translate(AppString.confirmPassword),
                          style: TextStyle(
                              fontSize: 13.sp,
                              color: AppColors.fontColorBlue,
                              fontFamily: AppString.rubik),
                        ),
                        TextFormField(
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)
                                  .translate(AppString.entreConfirmPassword);
                            }
                            if (value.length < 6) {
                              return AppLocalizations.of(context).translate(
                                  AppString.entrePasswordMustBeSixCharacter);
                            }
                            if (auth.passwordController.text !=
                                auth.confirmPasswordController.text) {
                              return AppLocalizations.of(context)
                                  .translate(AppString.passwordDoNotMatch);
                            }
                            return null;
                          },
                          controller: auth.confirmPasswordController,
                          obscureText: _showConfirmPassword,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.entreConfirmPassword),
                            hintStyle: const TextStyle(
                                color: AppColors.greyWithAlpha,
                                fontFamily: AppString.rubikRegular),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: AppColors.fontColorBlue,
                              ),
                              onPressed: () {
                                setState(() => _showConfirmPassword =
                                    !_showConfirmPassword);
                              },
                            ),
                          ),
                        ),
                        Container(
                          color: AppColors.greyWithAlpha,
                          height: 1,
                          margin: EdgeInsets.only(
                            bottom: 2.h,
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        MaterialButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              auth.userRegister(
                                  auth.emailController.text.toString(),
                                  auth.nameController.text.toString(),
                                  auth.passwordController.text.toString(),
                                  context);
                            }
                          },
                          color: Colors.blue,
                          textColor: AppColors.white,
                          minWidth: 90.w,
                          height: 50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate(AppString.signUPAsOwner),
                            style: const TextStyle(
                                fontSize: 18, fontFamily: "Rubik"),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.or),
                              style: const TextStyle(color: Colors.grey),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.grey.withAlpha(50),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Login()));
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.alreadyHaveAccount),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: AppColors.fontColorBlue,
                                      fontFamily: AppString.rubikRegular),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.signIn),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppString.rubik,
                                      color: AppColors.lightBlue),
                                )
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
