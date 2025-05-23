import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../retrofit/models/get_all_space_model.dart';
import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class NewGuard extends StatefulWidget {
  final bool isEdit;
  final int? index;
  final int? spaceId;

  const NewGuard({super.key, this.index, required this.isEdit, this.spaceId});

  @override
  State<NewGuard> createState() => _NewGuardState();
}

class _NewGuardState extends State<NewGuard> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController showSelectedSpace =
      TextEditingController(text: "Select Space");
  late SpaceProvider spaceProvider;
  late GuardProvider guardProvider;
  int? spaceId;
  int? guardId;
  String guardStatus = "Disable";
  final _formKey = GlobalKey<FormState>();
  AllSpaceData singleSpaceData = AllSpaceData();

  @override
  void initState() {
    super.initState();
    spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
    guardProvider = Provider.of<GuardProvider>(context, listen: false);
    fillData();
  }

  fillData() {
    widget.isEdit
        ? guardId = guardProvider.allGuardList[widget.index!].id
        : null;
    widget.isEdit
        ? nameController.text =
            guardProvider.allGuardList[widget.index!].name.toString()
        : nameController = TextEditingController(text: "");
    widget.isEdit
        ? emailController.text =
            guardProvider.allGuardList[widget.index!].email.toString()
        : emailController = TextEditingController(text: "");
    widget.isEdit
        ? phoneNoController.text =
            guardProvider.allGuardList[widget.index!].phoneNo.toString()
        : phoneNoController = TextEditingController(text: "");
    if (widget.isEdit == true) {
      for (int i = 0; i < spaceProvider.getAllSpaces.length; i++) {
        if (spaceProvider.getAllSpaces[i].id == widget.spaceId) {
          singleSpaceData = spaceProvider.getAllSpaces[i];
          showSelectedSpace.text =
              spaceProvider.getAllSpaces[i].title.toString();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print(widget.index);
      print(widget.isEdit);
    }
    guardProvider = Provider.of<GuardProvider>(context);
    spaceProvider = Provider.of<SpaceProvider>(context);
    return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.commonColorSkyBlue,
          elevation: 0,
          titleSpacing: 0,
          iconTheme: const IconThemeData(color: AppColors.white),
          automaticallyImplyLeading: true,
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context).translate(
                widget.isEdit ? AppString.updateGuard : AppString.newGuard),
            style: TextStyle(
                color: AppColors.white,
                fontFamily: AppString.rubik,
                fontSize: 14.sp),
          ),
        ),
        body: Scaffold(
          key: _globalKey,
          backgroundColor: AppColors.white,
          body: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: SizedBox(
              height: 90.h,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 30, vertical: 35),
                            child: Image.asset(
                              "assets/owner_parking_detail.png",
                              width: 40.h,
                              height: 40.w,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppString.securityGuardLabel),
                            style: const TextStyle(
                                fontFamily: AppString.rubik,
                                fontSize: 20,
                                color: AppColors.fontColorBlue),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          Padding(
                            padding: EdgeInsets.only(bottom: 3.h),
                            child: Text(
                              AppLocalizations.of(context).translate(
                                  AppString.providerBetterSecurityParkingSpace),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: AppString.rubik,
                                color: AppColors.greyWithAlpha,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context).translate(
                                          AppString.securityGuardDetail),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: AppString.rubik,
                                          color: AppColors.fontColorBlue,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Card(
                            margin: EdgeInsets.only(
                                top: 2.h,
                                bottom: 3.h,
                                left: 2.5.h,
                                right: 2.5.h),
                            shadowColor: AppColors.commonColorSkyBlue,
                            elevation: 10,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate(AppString.name),
                                    style: TextStyle(
                                        fontFamily: AppString.rubik,
                                        fontSize: 13.sp),
                                  ),
                                  TextFormField(
                                    validator: RequiredValidator(
                                            errorText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterYourName))
                                        .call,
                                    controller: nameController,
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 10),
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(AppString.enterYourName),
                                        hintStyle: TextStyle(fontSize: 12.sp)),
                                  ),
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.email),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp)),
                                  TextFormField(
                                    // readOnly: widget.isEdit?true:false,
                                    validator: RequiredValidator(
                                            errorText:
                                                AppLocalizations.of(context)
                                                    .translate(AppString
                                                        .validationEmailEntre))
                                        .call,
                                    controller: emailController,
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 10),
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(
                                                AppString.entreYourEmail),
                                        hintStyle: TextStyle(fontSize: 12.sp)),
                                  ),
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.phoneNumber),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp)),
                                  TextFormField(
                                    validator: MultiValidator([
                                      RequiredValidator(
                                          errorText:
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      AppString.entrePhoneNo)),
                                      MinLengthValidator(6,
                                          errorText: AppLocalizations.of(
                                                  context)
                                              .translate(AppString.minPhoneNo))
                                    ]).call,
                                    keyboardType: TextInputType.phone,
                                    controller: phoneNoController,
                                    scrollPadding:
                                        const EdgeInsets.only(bottom: 10),
                                    decoration: InputDecoration(
                                        hintText: AppLocalizations.of(context)
                                            .translate(AppString.entrePhoneNo),
                                        hintStyle: TextStyle(fontSize: 12.sp)),
                                  ),
                                  widget.isEdit
                                      ? Container()
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 11,
                                            ),
                                            Text(
                                                AppLocalizations.of(context)
                                                    .translate(
                                                        AppString.password),
                                                style: TextStyle(
                                                    fontFamily: AppString.rubik,
                                                    fontSize: 13.sp)),
                                            TextFormField(
                                              validator: MultiValidator([
                                                RequiredValidator(
                                                    errorText: AppLocalizations
                                                            .of(context)
                                                        .translate(AppString
                                                            .entrePassword)),
                                                MinLengthValidator(6,
                                                    errorText: AppLocalizations
                                                            .of(context)
                                                        .translate(AppString
                                                            .entrePasswordMustBeSixCharacter))
                                              ]).call,
                                              controller: passwordController,
                                              scrollPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 10),
                                              decoration: InputDecoration(
                                                  hintText: AppLocalizations.of(
                                                          context)
                                                      .translate(AppString
                                                          .entrePassword),
                                                  hintStyle: TextStyle(
                                                      fontSize: 12.sp)),
                                            ),
                                          ],
                                        ),
                                  const SizedBox(
                                    height: 11,
                                  ),
                                  widget.isEdit
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      AppString.textSpace),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontFamily: AppString.rubik,
                                                  fontSize: 13.sp),
                                            ),
                                            TextFormField(
                                              controller: showSelectedSpace,
                                              readOnly: true,
                                              onTap: () {
                                                showAlertDialog(context);
                                              },
                                              scrollPadding: EdgeInsets.zero,
                                            ),
                                            const SizedBox(
                                              height: 11,
                                            ),
                                            Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      AppString.textStatus),
                                              textAlign: TextAlign.start,
                                              style: TextStyle(
                                                  fontFamily: AppString.rubik,
                                                  fontSize: 13.sp),
                                            ),
                                            FormField<String>(
                                              builder: (FormFieldState<String>
                                                  state) {
                                                return InputDecorator(
                                                  decoration: const InputDecoration(
                                                      // prefixIcon: Icon(CupertinoIcons.time),
                                                      ),
                                                  child: DropdownButton<String>(
                                                    value: guardStatus,
                                                    icon: const Icon(Icons
                                                        .keyboard_arrow_down),
                                                    elevation: 16,
                                                    style: TextStyle(
                                                        fontFamily:
                                                            AppString.rubik,
                                                        fontSize: 15.sp),
                                                    underline: const SizedBox(),
                                                    isExpanded: true,
                                                    onChanged:
                                                        (String? newValue) {
                                                      setState(() {
                                                        guardStatus =
                                                            newValue.toString();
                                                        if (kDebugMode) {
                                                          print(guardStatus);
                                                        }
                                                      });
                                                    },
                                                    items: <String>[
                                                      'Enable',
                                                      'Disable',
                                                    ].map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (String value) {
                                                      return DropdownMenuItem<
                                                          String>(
                                                        value: value,
                                                        child: Text(
                                                          value,
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .titleMedium!
                                                              .copyWith(
                                                                  fontSize:
                                                                      14.sp,
                                                                  color: AppColors
                                                                      .black54),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          bottomNavigationBar: MaterialButton(
            onPressed: () {
              if (widget.isEdit) {
                if (spaceId != null || singleSpaceData.id != null) {
                  guardProvider.updateGuard(
                      guardId,
                      spaceId ?? singleSpaceData.id,
                      emailController.text.toString(),
                      nameController.text.toString(),
                      phoneNoController.text.toString(),
                      guardStatus,
                      context);
                } else {
                  CommonFunction.toastMessage(AppLocalizations.of(context)
                      .translate(AppString.selectSpace));
                }
              } else {
                if (_formKey.currentState!.validate()) {
                  if (PreferenceManager.getString(
                          SharePreferenceKey.subscriptionStatus) ==
                      "1") {
                    guardProvider.addGuard(
                        emailController.text.toString(),
                        nameController.text.toString(),
                        passwordController.text.toString(),
                        phoneNoController.text.toString(),
                        context);
                  } else {
                    CommonFunction.toastMessage(
                        "Please Purchase Subscription First");
                  }
                }
              }
            },
            color: AppColors.commonColorSkyBlue,
            textColor: AppColors.white,
            minWidth: MediaQuery.of(context).size.width,
            height: 50,
            child: Text(
              AppLocalizations.of(context).translate(
                  widget.isEdit ? AppString.updateGuard : AppString.buttonSave),
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: AppString.rubik),
            ),
          ),
        ));
  }

  showAlertDialog(BuildContext context) {
    /// Create AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      title: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate(AppString.yourParkingSpace),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
          ),
          Container(
            color: AppColors.greyWithAlpha,
            height: 1,
            margin: const EdgeInsets.only(top: 10),
          ),
        ],
      ),
      content: Wrap(
        children: [
          _showAllSpaceHomePage(context),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
      buttonPadding: EdgeInsets.zero,
      actions: const [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _showAllSpaceHomePage(BuildContext context) {
    return StatefulBuilder(builder: (context, myState) {
      spaceProvider = Provider.of(context);
      return SizedBox(
        height: 35.h,
        width: 80.w,
        child: spaceProvider.getAllSpaces.isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context).translate(AppString.noDataFound),
                style: TextStyle(fontFamily: AppString.rubik, fontSize: 12.sp),
              ))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: spaceProvider.getAllSpaces.length,
                padding: const EdgeInsets.symmetric(vertical: 5),
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<AllSpaceData>(
                      activeColor: AppColors.commonColorSkyBlue,
                      title: Text(
                          spaceProvider.getAllSpaces[index].title.toString(),
                          style: TextStyle(
                              fontFamily: AppString.rubikRegular,
                              fontSize: 14.sp)),
                      value: spaceProvider.getAllSpaces[index],
                      groupValue: singleSpaceData,
                      onChanged: (value) {
                        myState(() {
                          debugPrint(value.toString());
                          spaceProvider.notify();
                          showSelectedSpace.text = value!.title.toString();
                          spaceId = value.id;
                          Navigator.of(context).pop();
                        });
                      });
                }),
      );
    });
  }
}
