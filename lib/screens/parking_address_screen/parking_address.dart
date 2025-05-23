import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/provider/provider_model/facilities_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class ParkingAddress extends StatefulWidget {
  const ParkingAddress({super.key});

  @override
  State<ParkingAddress> createState() => _ParkingAddressState();
}

class _ParkingAddressState extends State<ParkingAddress>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late TabController tabController;

  List<Map<String, String>> checkBoxValue = [];

  List<String> selectedFacilitiesList = [];
  bool isSwitched = false;
  bool isSwitchedOfflinePay = true;
  bool visible = true;
  int? indexIs = 0;
  String showSelectedFacilities = '';

  DateTime? parkingOpenTime;
  DateTime? parkingCloseTime;

  List parkingZone = [];
  List<int> nameEditList = [];
  List<int> sizeEditList = [];

  /// controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController pricePerHourController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController parkingOpenTimeController = TextEditingController();
  TextEditingController parkingCloseTimeController = TextEditingController();
  int? offlinePaymentMode = 1;
  int? availableAllDaysController = 0;
  double latController = 22.2587;
  double longController = 71.1924;
  List<WidgetCard> serviceCardList = []; //Define the dynamic list

  /// map variable
  final Completer<GoogleMapController> _controller = Completer();

  final MapType _currentMapType = MapType.normal;

  Widget button(Function function, IconData icon) {
    return FloatingActionButton(
      onPressed: function.call(),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      backgroundColor: AppColors.blue,
      child: Icon(
        icon,
        color: AppColors.white,
        size: 36.0,
      ),
    );
  }

  late FacilitiesProvider facilitiesProvider;
  late GuardProvider guardProvider;
  late SpaceProvider addSpaceProvider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  static LatLng? _center;
  LatLng? _lastMapPosition;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    guardProvider = Provider.of<GuardProvider>(context, listen: false);
    facilitiesProvider =
        Provider.of<FacilitiesProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      if (PreferenceManager.getString(SharePreferenceKey.subscriptionStatus) ==
          "1") {
        facilitiesProvider.getFacilities();
        guardProvider.availableGuardApiCall();
      }
    });

    /// current location
    guardProvider.getLiveLocation();
    Future.delayed(const Duration(seconds: 4), () {
      latController = guardProvider.liveLocation!.latitude;
      longController = guardProvider.liveLocation!.latitude;
      _center = guardProvider.liveLocation;
      _lastMapPosition = guardProvider.liveLocation;
    });
    _lastMapPosition = guardProvider.liveLocation;
    if (PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) ==
            Provider.of<SpaceProvider>(context, listen: false)
                .getAllSpaces
                .length &&
        PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) > 0) {
      Future.delayed(
        const Duration(microseconds: 500),
        () {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              surfaceTintColor: AppColors.white,
              shadowColor: AppColors.white,
              backgroundColor: AppColors.white,
              title: const Text("Limit Reached!"),
              content: const Text(
                  "You've reached the maximum parking space limit.\nPlease upgrade your subscription plan & then re-login"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      AppLocalizations.of(context).translate(AppString.okBtn),
                    ))
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    addSpaceProvider = Provider.of<SpaceProvider>(context);

    /// facilities check true / false
    facilitiesProvider = Provider.of(context);
    checkBoxValue.clear();

    Map<String, String> facilitiesMap;
    for (int i = 0; i < facilitiesProvider.facilitiesData.length; i++) {
      if (facilitiesProvider.facilitiesData[i].isCheck == true) {
        facilitiesMap = {
          "title": facilitiesProvider.facilitiesData[i].title.toString(),
          "id": facilitiesProvider.facilitiesData[i].id.toString(),
        };
        checkBoxValue.add(facilitiesMap);
      }
    }
    addSpaceProvider.showSelectedGuardName.clear();
    addSpaceProvider.showSelectedGuardId.clear();
    for (int i = 0; i < guardProvider.availableGuardData.length; i++) {
      if (guardProvider.availableGuardData[i]!.isCheck == true) {
        addSpaceProvider.showSelectedGuardName
            .add(guardProvider.availableGuardData[i]!.name.toString());
        addSpaceProvider.showSelectedGuardId
            .add(guardProvider.availableGuardData[i]!.id.toString());
      }
    }
    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: indexIs == 2
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/owner_parking_detail.png",
                      height: 18.h,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppString.rateYourSpace),
                      style: const TextStyle(
                          fontFamily: AppString.rubik,
                          fontSize: 20,
                          color: AppColors.fontColorBlue),
                    ),
                    Container(
                        padding: EdgeInsets.only(bottom: 10, top: 1.h),
                        margin: EdgeInsets.only(bottom: 2.h),
                        width: 70.w,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.fillAllDetailsAndThen),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: AppString.rubik,
                            color: AppColors.greyWithAlpha,
                          ),
                        )),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          indexIs = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: indexIs == 0
                                ? AppColors.commonColorSkyBlue
                                : AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.basic)
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: indexIs == 0
                                      ? AppColors.commonColorSkyBlue
                                      : AppColors.black),
                            ),
                          ),
                          Container(
                            color: indexIs == 0
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 1;
                              });
                            },
                      child: Column(
                        children: [
                          Icon(
                            Icons.wifi_tethering_outlined,
                            color: indexIs == 1
                                ? AppColors.commonColorSkyBlue
                                : AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.zone)
                                    .toUpperCase(),
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: indexIs == 1
                                        ? AppColors.commonColorSkyBlue
                                        : AppColors.black)),
                          ),
                          Container(
                            color: indexIs == 1
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 2;
                              });
                            },
                      child: Column(
                        children: [
                          const Icon(Icons.location_pin),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.map)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            color: indexIs == 2
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 3;
                              });
                            },
                      child: Column(
                        children: [
                          const Icon(Icons.person_outlined),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.guard)
                                    .toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            color: indexIs == 3
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              indexIs == 0
                  ?

                  /// Basic
                  Container(
                      margin: EdgeInsets.only(
                          top: 2.h, bottom: 5.h, right: 3.h, left: 3.h),
                      color: AppColors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppLocalizations.of(context)
                                .translate(AppString.addParkingDetail),
                            style: TextStyle(
                                fontFamily: AppString.rubik, fontSize: 13.sp),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.spaceName),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextFormField(
                            controller: titleController,
                            validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate(AppString.enterYourName))
                                .call,
                            scrollPadding: const EdgeInsets.only(bottom: 10),
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate(AppString.enterYourName),
                                hintStyle: TextStyle(fontSize: 12.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.description),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate(AppString.enterDescription))
                                .call,
                            controller: descriptionController,
                            scrollPadding: const EdgeInsets.only(bottom: 10),
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate(AppString.enterDescription),
                                hintStyle: TextStyle(fontSize: 12.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.phoneNumber),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: AppLocalizations.of(context)
                                      .translate(AppString.entrePhoneNo)),
                              MinLengthValidator(6,
                                  errorText: AppLocalizations.of(context)
                                      .translate(AppString.minPhoneNo))
                            ]).call,
                            controller: phoneNoController,
                            scrollPadding: const EdgeInsets.only(bottom: 10),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate(AppString.entrePhoneNo),
                                hintStyle: TextStyle(fontSize: 12.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.pricePerHour),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate(AppString.enterPrice))
                                .call,
                            controller: pricePerHourController,
                            scrollPadding: const EdgeInsets.only(bottom: 10),
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate(AppString.price),
                                hintStyle: TextStyle(fontSize: 12.sp)),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.facilities),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextButton.icon(
                              onPressed: () {
                                facilitiesAlertDialog(context);
                              },
                              icon: const Icon(
                                Icons.arrow_drop_down_sharp,
                                color: AppColors.black,
                              ),
                              label: Text(
                                () {
                                  showSelectedFacilities = '';
                                  selectedFacilitiesList = [];
                                  for (int i = 0;
                                      i < checkBoxValue.length;
                                      i++) {
                                    showSelectedFacilities +=
                                        " ${checkBoxValue[i]['title']},";
                                    selectedFacilitiesList
                                        .add(checkBoxValue[i]['id']!);
                                  }
                                  return showSelectedFacilities.isEmpty
                                      ? AppLocalizations.of(context)
                                          .translate(AppString.selectFacilities)
                                      : showSelectedFacilities;
                                }(),
                                style: TextStyle(
                                    color: AppColors.black,
                                    fontSize: 12.sp,
                                    fontFamily: AppString.rubik),
                              )),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.available_24hour),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppString.rubikRegular,
                                      color: AppColors.commonColorSkyBlue),
                                ),
                                Switch(
                                  value: isSwitched,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitched = value;
                                      isSwitched == true
                                          ? visible = false
                                          : visible = true;
                                      isSwitched == true
                                          ? availableAllDaysController = 1
                                          : availableAllDaysController = 0;
                                      if (kDebugMode) {
                                        print(isSwitched);
                                      }
                                    });
                                  },
                                  activeTrackColor:
                                      AppColors.commonColorSkyBlue,
                                  activeColor: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: Visibility(
                              visible: visible,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// openTime
                                        InkWell(
                                            onTap: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            color:
                                                                AppColors.white,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .translate(AppString
                                                                              .cancelBtn),
                                                                      style: TextStyle(
                                                                          fontSize: 13
                                                                              .sp,
                                                                          color: AppColors
                                                                              .blue,
                                                                          fontFamily:
                                                                              AppString.rubik)),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            AppString.doneBtn),
                                                                    style: TextStyle(
                                                                        fontSize: 13
                                                                            .sp,
                                                                        color: AppColors
                                                                            .blue,
                                                                        fontFamily:
                                                                            AppString.rubik),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.35,
                                                          color:
                                                              AppColors.white,
                                                          child:
                                                              CupertinoDatePicker(
                                                            mode:
                                                                CupertinoDatePickerMode
                                                                    .time,
                                                            onDateTimeChanged:
                                                                (value) {
                                                              parkingOpenTime =
                                                                  value;
                                                              parkingOpenTimeController =
                                                                  value
                                                                      as TextEditingController;
                                                            },
                                                            initialDateTime:
                                                                parkingOpenTime,
                                                            use24hFormat: false,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      AppString.openTime),
                                              style: TextStyle(
                                                  fontFamily: AppString.rubik,
                                                  fontSize: 12.sp),
                                            )),
                                        TextFormField(
                                          enabled: false,
                                          scrollPadding:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: InputDecoration(
                                              hintText: parkingOpenTime != null
                                                  ? DateFormat()
                                                      .add_jm()
                                                      .format(parkingOpenTime!)
                                                  : AppLocalizations.of(context)
                                                      .translate(
                                                          AppString.selectTime),
                                              hintStyle:
                                                  TextStyle(fontSize: 12.sp)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        /// close time
                                        InkWell(
                                            onTap: () {
                                              showCupertinoModalPopup(
                                                  context: context,
                                                  builder:
                                                      (BuildContext builder) {
                                                    return Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        Container(
                                                            color:
                                                                AppColors.white,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .end,
                                                              children: [
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                      AppLocalizations.of(
                                                                              context)
                                                                          .translate(AppString
                                                                              .cancelBtn),
                                                                      style: TextStyle(
                                                                          fontSize: 13
                                                                              .sp,
                                                                          color: AppColors
                                                                              .blue,
                                                                          fontFamily:
                                                                              AppString.rubik)),
                                                                ),
                                                                TextButton(
                                                                  onPressed:
                                                                      () {
                                                                    setState(
                                                                        () {});
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  child: Text(
                                                                    AppLocalizations.of(
                                                                            context)
                                                                        .translate(
                                                                            AppString.doneBtn),
                                                                    style: TextStyle(
                                                                        fontSize: 13
                                                                            .sp,
                                                                        color: AppColors
                                                                            .blue,
                                                                        fontFamily:
                                                                            AppString.rubik),
                                                                  ),
                                                                ),
                                                              ],
                                                            )),
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .copyWith()
                                                                  .size
                                                                  .height *
                                                              0.35,
                                                          color:
                                                              AppColors.white,
                                                          child:
                                                              CupertinoDatePicker(
                                                            mode:
                                                                CupertinoDatePickerMode
                                                                    .time,
                                                            onDateTimeChanged:
                                                                (value) {
                                                              parkingCloseTime =
                                                                  value;
                                                              parkingCloseTimeController =
                                                                  value
                                                                      as TextEditingController;
                                                            },
                                                            initialDateTime:
                                                                parkingCloseTime,
                                                            minimumDate: DateTime
                                                                    .now()
                                                                .subtract(
                                                                    const Duration(
                                                                        minutes:
                                                                            1)),
                                                            use24hFormat: false,
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)
                                                  .translate(
                                                      AppString.closeTime),
                                              style: TextStyle(
                                                  fontFamily: AppString.rubik,
                                                  fontSize: 12.sp),
                                            )),
                                        TextFormField(
                                          enabled: false,
                                          scrollPadding:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: InputDecoration(
                                              hintText: parkingCloseTime != null
                                                  ? DateFormat()
                                                      .add_jm()
                                                      .format(parkingCloseTime!)
                                                  : AppLocalizations.of(context)
                                                      .translate(
                                                          AppString.selectTime),
                                              hintStyle:
                                                  TextStyle(fontSize: 12.sp)),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 0.2.h),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.offlinePayment),
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontFamily: AppString.rubikRegular,
                                      color: AppColors.commonColorSkyBlue),
                                ),
                                Switch(
                                  value: isSwitchedOfflinePay,
                                  onChanged: (value) {
                                    setState(() {
                                      isSwitchedOfflinePay = value;
                                      isSwitchedOfflinePay == true
                                          ? offlinePaymentMode = 1
                                          : offlinePaymentMode = 0;
                                    });
                                  },
                                  activeTrackColor:
                                      AppColors.commonColorSkyBlue,
                                  activeColor: AppColors.white,
                                ),
                              ],
                            ),
                          ),
                          const Divider(
                            color: AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.address),
                              style: TextStyle(
                                  fontFamily: AppString.rubik, fontSize: 13.sp),
                            ),
                          ),
                          TextFormField(
                            validator: RequiredValidator(
                                    errorText: AppLocalizations.of(context)
                                        .translate(AppString.enterAddress))
                                .call,
                            controller: addressController,
                            scrollPadding: const EdgeInsets.only(bottom: 10),
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .translate(AppString.enterAddress),
                                hintStyle: TextStyle(fontSize: 12.sp)),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 17.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 2.h,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(AppString.city),
                                          style: TextStyle(
                                              fontFamily: AppString.rubik,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: RequiredValidator(
                                                errorText:
                                                    AppLocalizations.of(context)
                                                        .translate(AppString
                                                            .enterCityName))
                                            .call,
                                        controller: cityController,
                                        decoration: InputDecoration(
                                            hintText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterCityName),
                                            hintStyle:
                                                TextStyle(fontSize: 12.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 17.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 2.h,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(AppString.postalCode),
                                          style: TextStyle(
                                              fontFamily: AppString.rubik,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                      TextFormField(
                                        controller: postalCodeController,
                                        validator: RequiredValidator(
                                                errorText:
                                                    AppLocalizations.of(context)
                                                        .translate(AppString
                                                            .enterPostalCode))
                                            .call,
                                        decoration: InputDecoration(
                                            hintText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterPostalCode),
                                            hintStyle:
                                                TextStyle(fontSize: 12.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 17.h,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: 2.h,
                                        ),
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(AppString.state),
                                          style: TextStyle(
                                              fontFamily: AppString.rubik,
                                              fontSize: 13.sp),
                                        ),
                                      ),
                                      TextFormField(
                                        validator: RequiredValidator(
                                                errorText:
                                                    AppLocalizations.of(context)
                                                        .translate(AppString
                                                            .enterStateName))
                                            .call,
                                        controller: stateController,
                                        decoration: InputDecoration(
                                            hintText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterStateName),
                                            hintStyle:
                                                TextStyle(fontSize: 12.sp)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: SizedBox(
                                height: 17.h,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 2.h,
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate(AppString.country),
                                        style: TextStyle(
                                            fontFamily: AppString.rubik,
                                            fontSize: 13.sp),
                                      ),
                                    ),
                                    TextFormField(
                                      validator: RequiredValidator(
                                              errorText:
                                                  AppLocalizations.of(context)
                                                      .translate(AppString
                                                          .enterCountryName))
                                          .call,
                                      controller: countryController,
                                      decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context)
                                              .translate(
                                                  AppString.enterCountryName),
                                          hintStyle:
                                              TextStyle(fontSize: 12.sp)),
                                    ),
                                  ],
                                ),
                              ))
                            ],
                          ),
                        ],
                      ),
                    )
                  : indexIs == 1
                      ?

                      /// Zone
                      Container(
                          margin: EdgeInsets.only(left: 2.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.addZoneDetails),
                                style: TextStyle(
                                    fontSize: 13.sp,
                                    fontFamily: AppString.rubik),
                              ),
                              ...serviceCardList,
                              serviceCardList.isEmpty
                                  ? SizedBox(
                                      height: 1.5.h,
                                    )
                                  : const SizedBox(
                                      height: 0,
                                    ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      addServiceCard();
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 1.5.h),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.addNewZone),
                                      style: TextStyle(
                                          fontFamily: AppString.rubikRegular,
                                          fontSize: 13.sp,
                                          color: AppColors.commonColorSkyBlue),
                                    ),
                                  )),
                            ],
                          ),
                        )
                      : indexIs == 2
                          ?

                          ///Map
                          Container(
                              margin: EdgeInsets.only(
                                  top: 1.h, bottom: 1.h, right: 3.h, left: 3.h),
                              color: AppColors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)
                                        .translate(AppString.whereYouAre),
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppString.rubik),
                                  ),
                                  guardProvider.liveLocation?.latitude != null
                                      ? Container(
                                          margin: EdgeInsets.only(top: 2.h),
                                          height: 30.h,
                                          width: 100.w,
                                          child: Stack(
                                            children: [
                                              GoogleMap(
                                                myLocationEnabled: true,
                                                myLocationButtonEnabled: true,
                                                zoomGesturesEnabled: true,
                                                zoomControlsEnabled: true,
                                                mapType: _currentMapType,
                                                markers: _markers,
                                                initialCameraPosition:
                                                    CameraPosition(
                                                  target: _center != null
                                                      ? _center!
                                                      : LatLng(
                                                          guardProvider
                                                              .liveLocation!
                                                              .latitude,
                                                          guardProvider
                                                              .liveLocation!
                                                              .longitude),
                                                  zoom: 14.4746,
                                                ),
                                                onMapCreated: _onMapCreated,
                                                onCameraMove: _onCameraMove,
                                              ),
                                            ],
                                          ),
                                        )
                                      : const Center(
                                          child: CircularProgressIndicator()),
                                ],
                              ))
                          :

                          ///Guard
                          Container(
                              margin: EdgeInsets.only(
                                  top: 3.h, bottom: 2.h, left: 4.h, right: 4.h),
                              color: AppColors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).translate(
                                        AppString.pleaseProviderWorkforce),
                                    style: TextStyle(
                                        fontFamily: AppString.rubik,
                                        fontSize: 14.sp),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.guardList),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      guardListAlertDialog(context);
                                    },
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          enabled: false,
                                          labelText: addSpaceProvider
                                              .showSelectedGuardName
                                              .join(","),
                                          suffixIcon: const Icon(
                                              Icons.arrow_drop_down_sharp)),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, RouteName.newGuardRoute);
                                        },
                                        child: Text(
                                          AppLocalizations.of(context)
                                              .translate(AppString.addNewGuard),
                                          style: TextStyle(
                                              fontFamily:
                                                  AppString.rubikRegular,
                                              fontSize: 13.sp,
                                              color:
                                                  AppColors.commonColorSkyBlue),
                                        )),
                                  )
                                ],
                              ),
                            ),
            ],
          ),
        ),
      ),

      /// Button
      bottomNavigationBar: ElevatedButton(
        onPressed: PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) ==
                    Provider.of<SpaceProvider>(context, listen: false)
                        .getAllSpaces
                        .length &&
                PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) > 0
            ? null
            : () {
                Map<String, dynamic> map;
                parkingZone = [];
                for (int i = 0; i < serviceCardList.length; i++) {
                  map = {
                    "name":
                        serviceCardList[i].spaceNameController.text.toString(),
                    "size": serviceCardList[i].sizeController.text.toString(),
                  };
                  parkingZone.add(map);
                }
                setState(() {
                  /// basic
                  if (indexIs == 0) {
                    if (formKey.currentState!.validate() &&
                        showSelectedFacilities.isNotEmpty) {
                      indexIs = 1;
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillProperData));
                    }
                  }

                  /// zone
                  else if (indexIs == 1) {
                    if (serviceCardList.isNotEmpty) {
                      if (formKey.currentState!.validate()) {
                        indexIs = 2;
                      }
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillZoneDetails));
                    }
                  }

                  /// map
                  else if (indexIs == 2) {
                    if (formKey.currentState!.validate()) {
                      indexIs = 3;
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillProperData));
                    }
                  }

                  /// guard
                  else if (indexIs == 3) {
                    if (addSpaceProvider.showSelectedGuardName.isNotEmpty) {
                      if (formKey.currentState!.validate()) {
                        addSpaceProvider.addSpaceApiCall(
                          addressController.text.toString(),
                          availableAllDaysController.toString(),
                          latController.toDouble(),
                          longController.toDouble(),
                          offlinePaymentMode.toString(),
                          parkingZone,
                          pricePerHourController.text.toString(),
                          titleController.text.toString(),
                          cityController.text.toString(),
                          countryController.text.toString(),
                          descriptionController.text.toString(),
                          selectedFacilitiesList,
                          phoneNoController.text.toString(),
                          postalCodeController.text.toString(),
                          stateController.text.toString(),
                          parkingOpenTimeController.text.toString(),
                          parkingCloseTimeController.text.toString(),
                          addSpaceProvider.showSelectedGuardId,
                          context,
                        );
                      } else {
                        CommonFunction.toastMessage(AppLocalizations.of(context)
                            .translate(AppString.fillProperData));
                      }
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.selectGuard));
                    }
                  }
                });
              },
        style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.commonColorSkyBlue,
            minimumSize: Size(MediaQuery.of(context).size.width, 50),
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
        child: Text(
          indexIs == 0
              ? AppLocalizations.of(context).translate(AppString.nextBtn)
              : indexIs == 1
                  ? AppLocalizations.of(context).translate(AppString.nextBtn)
                  : indexIs == 2
                      ? AppLocalizations.of(context)
                          .translate(AppString.nextBtn)
                      : AppLocalizations.of(context)
                          .translate(AppString.addBtn),
          style: TextStyle(
              fontFamily: AppString.rubik,
              fontSize: 14.sp,
              color: AppColors.white),
        ),
      ),
    );
  }

  center() {
    _center = LatLng(guardProvider.liveLocation!.latitude,
        guardProvider.liveLocation!.longitude);
    _lastMapPosition = _center;
  }

  _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
    _onAddMarkerButtonPresses();
  }

  _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  _onAddMarkerButtonPresses() {
    setState(() {
      _markers.add(Marker(
          draggable: true,
          markerId: MarkerId(
            _lastMapPosition.toString(),
          ),
          position: _lastMapPosition!,
          infoWindow: InfoWindow(
              title:
                  AppLocalizations.of(context).translate(AppString.thisIsTitle),
              snippet: AppLocalizations.of(context)
                  .translate(AppString.thisIsSnippet)),
          icon: BitmapDescriptor.defaultMarker,
          onDragEnd: ((newPosition) {
            latController = newPosition.latitude;
            longController = newPosition.longitude;
          })));
    });
  }

  final Set<Marker> _markers = {};

  /// removeService Card
  void removeServiceCard(index) {
    setState(() {
      serviceCardList.remove(index);
    });
  }

  /// add service Card
  void addServiceCard() {
    setState(() {
      serviceCardList
          .add(WidgetCard(removeServiceCard, index: serviceCardList.length));
    });
  }

  /// facilities
  facilitiesAlertDialog(BuildContext context) {
    facilitiesProvider = Provider.of(context, listen: false);

    /// Create button
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.okBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 12.sp),
      ),
      onPressed: () {
        setState(() {
          checkBoxValue.toString();
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.cancelBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    /// logout AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      titlePadding: const EdgeInsets.only(top: 10, left: 7, right: 7),
      title: Padding(
        padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate(AppString.facilities),
              style: TextStyle(fontSize: 18.sp),
            ),
            const Divider(
              color: AppColors.greyWithAlpha,
            )
          ],
        ),
      ),
      content: SizedBox(
        height: 40.h,
        width: 100.w,
        child: StatefulBuilder(
          builder: (context, myState) {
            return facilitiesProvider.facilitiesData.isEmpty
                ? Text(
                    AppLocalizations.of(context)
                        .translate(AppString.noDataFound),
                    style:
                        TextStyle(fontSize: 12.sp, fontFamily: AppString.rubik),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: facilitiesProvider.facilitiesData.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(
                              facilitiesProvider.facilitiesData[index].title!),
                          value:
                              facilitiesProvider.facilitiesData[index].isCheck,
                          onChanged: (value) {
                            myState(() {
                              facilitiesProvider.facilitiesData[index].isCheck =
                                  value!;
                            });
                          });
                    },
                  );
          },
        ),
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 10, right: 5, bottom: 10),
      buttonPadding: EdgeInsets.zero,
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// selected guard
  guardListAlertDialog(BuildContext context) {
    /// Create button
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.okBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 12.sp),
      ),
      onPressed: () {
        setState(() {
          checkBoxValue.toString();
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.cancelBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    /// logout AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      titlePadding:
          EdgeInsets.only(top: 2.5.h, left: 7, right: 7, bottom: 1.5.h),
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate(AppString.guardList),
            style: TextStyle(fontSize: 15.sp, fontFamily: AppString.rubik),
          ),
          const Divider(
            color: AppColors.black54,
            thickness: 2,
          )
        ],
      ),
      content: SizedBox(
        height: 40.h,
        width: 100.w,
        child: StatefulBuilder(
          builder: (context, myState) {
            return SizedBox(
              height: 40.h,
              child: guardProvider.availableGuardData.isEmpty
                  ? Text(
                      AppLocalizations.of(context)
                          .translate(AppString.noDataFound),
                      style: TextStyle(
                          fontSize: 12.sp, fontFamily: AppString.rubik),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: guardProvider.availableGuardData.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                            controlAffinity: ListTileControlAffinity.leading,
                            title: Text(guardProvider
                                .availableGuardData[index]!.name
                                .toString()),
                            value: guardProvider
                                .availableGuardData[index]!.isCheck,
                            onChanged: (value) {
                              myState(() {
                                guardProvider.availableGuardData[index]!
                                    .isCheck = value!;
                              });
                            });
                      },
                    ),
            );
          },
        ),
      ),
      contentPadding:
          EdgeInsets.only(top: 0.5.h, left: 10, right: 5, bottom: 10),
      buttonPadding: EdgeInsets.zero,
      actions: [
        cancelButton,
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class WidgetCard extends StatelessWidget {
  final int index;
  final Function(WidgetCard) removeServiceCard;

  WidgetCard(this.removeServiceCard, {super.key, required this.index});
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController spaceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 17.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.spaceName),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 13.sp),
                      ),
                    ),
                    TextFormField(
                      controller: spaceNameController,
                      validator: RequiredValidator(
                              errorText: AppLocalizations.of(context)
                                  .translate(AppString.enterSpaceName))
                          .call,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.spaceName),
                          hintStyle: TextStyle(fontSize: 12.sp)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
                child: SizedBox(
              height: 17.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                    ),
                    child: Text(
                      AppLocalizations.of(context).translate(AppString.size),
                      style: TextStyle(
                          fontFamily: AppString.rubik, fontSize: 13.sp),
                    ),
                  ),
                  TextFormField(
                    controller: sizeController,
                    keyboardType: TextInputType.number,
                    validator: RequiredValidator(
                            errorText: AppLocalizations.of(context)
                                .translate(AppString.enterSpaceSize))
                        .call,
                    decoration: InputDecoration(
                      suffixIcon: InkWell(
                          onTap: () {
                            removeServiceCard(this);
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.redColor,
                          )),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ],
    );
  }
}
