import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:stepowner/provider/provider_model/profile_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/models/space_id_model.dart';
import 'package:stepowner/screens/subscription_screen/subscription.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:intl/intl.dart' as date_lib;
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../custom_router/route_names.dart';
import '../../provider/provider_model/current_time_provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late SpaceProvider spaceProvider;
  late ProfileProvider profileProvider;
  late TimeProvider timeProvider;
  Timer? timer;

  Timer? _timer;
  String previousKeyword = "";

  @override
  void initState() {
    super.initState();
    checkForPermission();
    Future.delayed(Duration.zero, () {
      spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
      profileProvider = Provider.of<ProfileProvider>(context, listen: false);

      if (PreferenceManager.getString(SharePreferenceKey.subscriptionStatus) ==
          "1") {
        spaceProvider.getAllSpacesApiCall();

        PreferenceManager.getString(SharePreferenceKey.spaceIdKey).isNotEmpty
            ? spaceProvider.getSpaceIdData(
                PreferenceManager.getString(SharePreferenceKey.spaceIdKey))
            : null;
      } else {
        showAlertDialog(context);
      }
      spaceProvider.getSpaceIdDataSpace = GetSpaceIdDataSpace();
      spaceProvider.spaceIdDataBooking?.clear();
    });
    timeProvider = Provider.of<TimeProvider>(context, listen: false);
    timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      timeProvider.updateTime();
    });
  }

  DateTime currentBackPressTime = DateTime.now();

  @override
  void dispose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    spaceProvider = Provider.of<SpaceProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Consumer<TimeProvider>(
                      builder: (context, provider, _) => Text(
                        provider.currentDT,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12.sp, color: AppColors.greyWithAlpha),
                      ),
                    ),
                    SizedBox(
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ///search text field
                          Padding(
                            padding: EdgeInsets.only(
                                top: 1.h, left: 2.h, right: 2.h, bottom: 1.5.h),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: AppColors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.withAlpha(50),
                                        blurRadius: 5,
                                        spreadRadius: 3,
                                        offset: const Offset(0.3, 0.3))
                                  ],
                                  borderRadius: BorderRadius.circular(30)),
                              child: TextFormField(
                                controller: spaceProvider.homeSearchController,
                                onChanged: (String value) {
                                  if (value.isNotEmpty)
                                    searchWithThrottle(value,
                                        throttleTime: 100);
                                },
                                decoration: InputDecoration(
                                  suffixIcon: const Icon(
                                    Icons.search_outlined,
                                    size: 25,
                                  ),
                                  filled: true,
                                  fillColor: AppColors.white,
                                  contentPadding:
                                      const EdgeInsets.only(top: 15, left: 10),
                                  border: InputBorder.none,
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: AppColors.white)),
                                  disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: AppColors.white)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(30),
                                      borderSide: const BorderSide(
                                          color: AppColors.white)),
                                  hintText: AppLocalizations.of(context)
                                      .translate(AppString.search),
                                  hintStyle: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 12.sp,
                                      fontFamily: AppString.rubikRegular),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 3.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.assignGuard),
                              style: TextStyle(
                                  fontFamily: AppString.rubikRegular,
                                  color: AppColors.commonColorSkyBlue,
                                  fontSize: 13.sp),
                            ),
                          ),
                          Container(
                            height: 19.h,
                            margin: EdgeInsets.only(left: 3.h, right: 0.5.h),
                            child: spaceProvider.getSpaceIdDataSpace.guards ==
                                    null
                                ? Center(
                                    child: Text(
                                    AppLocalizations.of(context)
                                        .translate(AppString.noDataFound),
                                    style: TextStyle(
                                        fontFamily: AppString.rubik,
                                        fontSize: 12.sp),
                                  ))
                                : ListView.builder(
                                    itemCount: spaceProvider
                                        .getSpaceIdDataSpace.guards?.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 12.h,
                                            width: 22.w,
                                            padding: const EdgeInsets.all(5),
                                            child: CachedNetworkImage(
                                                imageUrl: spaceProvider
                                                    .getSpaceIdDataSpace
                                                    .guards![index]!
                                                    .imageUri
                                                    .toString(),
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        shape:
                                                            BoxShape.rectangle,
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit: BoxFit.cover),
                                                      ),
                                                    ),
                                                placeholder: (context, url) =>
                                                    const Center(
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                          "assets/image/noImage.png",
                                                          fit: BoxFit.cover,
                                                        )),
                                          ),
                                          const SizedBox(height: 05),
                                          Text(spaceProvider.getSpaceIdDataSpace
                                              .guards![index]!.name
                                              .toString()),
                                        ],
                                      );
                                    }),
                          ),
                          Container(
                            height: 3.h,
                            color: AppColors.lightGrey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    AppLocalizations.of(context)
                                        .translate(AppString.bookedUser),
                                    style: TextStyle(
                                        fontFamily: AppString.rubikRegular,
                                        color: AppColors.commonColorSkyBlue,
                                        fontSize: 13.sp)),
                                Row(
                                  children: [
                                    DropdownButton<String>(
                                      value: spaceProvider.dropdownValue,
                                      icon: const Icon(
                                        Icons.arrow_drop_down_outlined,
                                        color: AppColors.commonColorSkyBlue,
                                      ),
                                      elevation: 16,
                                      style: const TextStyle(
                                          color: AppColors.commonColorSkyBlue),
                                      underline: Container(
                                        height: 0,
                                        color: Colors.transparent,
                                      ),
                                      onChanged: (String? newValue) {
                                        spaceProvider.dropdownValue = newValue!;
                                        spaceProvider.notify();
                                      },
                                      items: <String>['Today', 'All']
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 7,
                          ),
                          SizedBox(
                            height: 55.h,
                            child: spaceProvider
                                        .homeSearchController.text.isNotEmpty &&
                                    spaceProvider.searchSpaceIdDataBooking ==
                                        null
                                ? Text(
                                    AppLocalizations.of(context)
                                        .translate(AppString.noDataFound),
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        fontFamily: AppString.rubik,
                                        color: AppColors.black),
                                  )
                                : spaceProvider.searchSpaceIdDataBooking !=
                                            null &&
                                        spaceProvider.homeSearchController.text
                                            .isNotEmpty
                                    ? _searchBookingList(
                                        context,
                                        spaceProvider.dropdownValue,
                                        spaceProvider.searchSpaceIdDataBooking)
                                    : _listView(
                                        context,
                                        spaceProvider.dropdownValue,
                                        spaceProvider.spaceIdDataBooking),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    if (PreferenceManager.getString(SharePreferenceKey.spaceIdKey).isNotEmpty) {
      spaceProvider.getSpaceIdData(
          PreferenceManager.getString(SharePreferenceKey.spaceIdKey));
    }
  }

  Future<void> checkForPermission() async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    permission = await Geolocator.checkPermission();

    setState(() {
      if (permission == LocationPermission.denied) {
        if (kDebugMode) {
          print("denied");
        }
        checkForPermission();
      } else if (permission == LocationPermission.deniedForever) {
        CommonFunction.toastMessage(
            "Please Enable manually location after show data");
      } else if (permission == LocationPermission.whileInUse) {
        if (kDebugMode) {
          print("whileInUse56362");
        }
      } else if (permission == LocationPermission.always) {
        if (kDebugMode) {
          print("always");
        }
      }
    });
  }

  Widget _listView(BuildContext context, dropdownValue,
      List<GetSpaceIdDataBooking?>? bookingUserData) {
    return bookingUserData == null
        ? Center(
            child: Text(
            AppLocalizations.of(context).translate(AppString.noDataFound),
            style: TextStyle(fontSize: 15.sp, fontFamily: AppString.rubik),
          ))
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: bookingUserData.length,
            itemBuilder: (BuildContext context, int index) {
              return dropdownValue == 'All'
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                  width: 15.w,
                                  child: CachedNetworkImage(
                                      imageUrl: bookingUserData[index]!
                                          .user!
                                          .imageUri
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/image/noImage.png",
                                            fit: BoxFit.cover,
                                          )),
                                ),
                                Container(
                                  width: 78.w,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                bookingUserData[index]!
                                                    .user!
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.fontColorBlue,
                                                    fontFamily:
                                                        AppString.rubik),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}"
                                                "${double.parse(bookingUserData[index]!.totalAmount ?? "").toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: AppColors
                                                        .commonColorSkyBlue,
                                                    fontFamily:
                                                        AppString.rubik),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "assets/surface1.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  bookingUserData[index]!
                                                      .vehicle!
                                                      .model
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: AppColors
                                                          .greyWithAlpha),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5.h),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/surface1.png"),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    bookingUserData[index]!
                                                        .vehicle!
                                                        .vehicleNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: AppColors
                                                            .greyWithAlpha),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}, "
                                            "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                          Text(
                                            " To ",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                          Text(
                                            " ${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}, "
                                            "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  "assets/Repeat Grid_1.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                bookingUserData[index]!
                                                    .orderNo
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                            ],
                                          ),
                                          textWidget(bookingUserData[index]!
                                              .paymentStatus)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: AppColors.greyWithAlpha,
                            height: 0.3,
                          ),
                        ],
                      ),
                    )
                  : DateTime.now().toString().split(" ")[0] ==
                          bookingUserData[index]!
                              .arrivingTime
                              .toString()
                              .split(' ')[0]
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 8.h,
                                      width: 15.w,
                                      child: CachedNetworkImage(
                                          imageUrl: bookingUserData[index]!
                                              .user!
                                              .imageUri
                                              .toString(),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                "assets/image/noImage.png",
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                    Container(
                                      width: 78.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    bookingUserData[index]!
                                                        .user!
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: AppColors
                                                            .fontColorBlue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time_rounded,
                                                    size: 10.sp,
                                                    color:
                                                        AppColors.greyWithAlpha,
                                                  ),
                                                  Text(
                                                    "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}"
                                                    "${double.parse(bookingUserData[index]!.totalAmount ?? "").toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppColors
                                                            .commonColorSkyBlue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                        "assets/surface1.png"),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      bookingUserData[index]!
                                                          .vehicle!
                                                          .model
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .greyWithAlpha),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.h),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/surface1.png"),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bookingUserData[index]!
                                                            .vehicle!
                                                            .vehicleNo
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: AppColors
                                                                .greyWithAlpha),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}, "
                                                "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                              Text(
                                                " To ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                              Text(
                                                " ${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}, "
                                                "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/Repeat Grid_1.png"),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    bookingUserData[index]!
                                                        .orderNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: AppColors
                                                            .greyWithAlpha),
                                                  ),
                                                ],
                                              ),
                                              textWidget(bookingUserData[index]!
                                                  .paymentStatus)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: AppColors.greyWithAlpha,
                                height: 0.3,
                              ),
                            ],
                          ),
                        )
                      : Container();
            });
  }

  Widget _searchBookingList(BuildContext context, dropdownValue,
      List<GetSpaceIdDataBooking?>? bookingUserData) {
    return bookingUserData == null
        ? Center(
            child: Text(
            AppLocalizations.of(context).translate(AppString.noDataFound),
            style: TextStyle(fontSize: 15.sp, fontFamily: AppString.rubik),
          ))
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: bookingUserData.length,
            itemBuilder: (BuildContext context, int index) {
              return dropdownValue == 'All'
                  ? Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: Row(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                  width: 15.w,
                                  child: CachedNetworkImage(
                                      imageUrl: bookingUserData[index]!
                                          .user!
                                          .imageUri
                                          .toString(),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                            height: 20.h,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              shape: BoxShape.rectangle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                      placeholder: (context, url) =>
                                          const Center(
                                              child:
                                                  CircularProgressIndicator()),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                            "assets/image/noImage.png",
                                            fit: BoxFit.cover,
                                          )),
                                ),
                                Container(
                                  //color: Colors.red,
                                  width: 78.w,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                bookingUserData[index]!
                                                    .user!
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.fontColorBlue,
                                                    fontFamily:
                                                        AppString.rubik),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text(
                                                "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}"
                                                "${double.parse(bookingUserData[index]!.totalAmount ?? "").toStringAsFixed(2)}",
                                                style: TextStyle(
                                                    fontSize: 12.sp,
                                                    color: AppColors
                                                        .commonColorSkyBlue,
                                                    fontFamily:
                                                        AppString.rubik),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        margin:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Image.asset(
                                                    "assets/surface1.png"),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                  bookingUserData[index]!
                                                      .vehicle!
                                                      .model
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 10.sp,
                                                      color: AppColors
                                                          .greyWithAlpha),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 5.h),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/surface1.png"),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    bookingUserData[index]!
                                                        .vehicle!
                                                        .vehicleNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: AppColors
                                                            .greyWithAlpha),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}, "
                                            "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                          Text(
                                            " To ",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                          Text(
                                            " ${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}, "
                                            "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}",
                                            style: TextStyle(
                                                fontSize: 10.sp,
                                                color: AppColors.greyWithAlpha),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                  "assets/Repeat Grid_1.png"),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Text(
                                                bookingUserData[index]!
                                                    .orderNo
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                            ],
                                          ),
                                          textWidget(bookingUserData[index]!
                                              .paymentStatus)
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: AppColors.greyWithAlpha,
                            height: 0.3,
                          ),
                        ],
                      ),
                    )
                  : DateTime.now().toString().split(" ")[0] ==
                          bookingUserData[index]!
                              .arrivingTime
                              .toString()
                              .split(' ')[0]
                      ? Container(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(bottom: 2.h),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      height: 8.h,
                                      width: 15.w,
                                      child: CachedNetworkImage(
                                          imageUrl: bookingUserData[index]!
                                              .user!
                                              .imageUri
                                              .toString(),
                                          imageBuilder: (context,
                                                  imageProvider) =>
                                              Container(
                                                height: 20.h,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  shape: BoxShape.rectangle,
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover),
                                                ),
                                              ),
                                          placeholder: (context, url) =>
                                              const Center(
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                                "assets/image/noImage.png",
                                                fit: BoxFit.cover,
                                              )),
                                    ),
                                    Container(
                                      //color: Colors.red,
                                      width: 78.w,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    bookingUserData[index]!
                                                        .user!
                                                        .name
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 14.sp,
                                                        color: AppColors
                                                            .fontColorBlue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time_rounded,
                                                    size: 10.sp,
                                                    color:
                                                        AppColors.greyWithAlpha,
                                                  ),
                                                  Text(
                                                    "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}"
                                                    "${double.parse(bookingUserData[index]!.totalAmount ?? "").toStringAsFixed(2)}",
                                                    style: TextStyle(
                                                        fontSize: 12.sp,
                                                        color: AppColors
                                                            .commonColorSkyBlue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            margin: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                        "assets/surface1.png"),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      bookingUserData[index]!
                                                          .vehicle!
                                                          .model
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .greyWithAlpha),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 5.h),
                                                  child: Row(
                                                    children: [
                                                      Image.asset(
                                                          "assets/surface1.png"),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        bookingUserData[index]!
                                                            .vehicle!
                                                            .vehicleNo
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 10.sp,
                                                            color: AppColors
                                                                .greyWithAlpha),
                                                      )
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}, "
                                                "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.arrivingTime.toString()))}",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                              Text(
                                                " To ",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                              Text(
                                                " ${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}, "
                                                "${date_lib.DateFormat().add_jm().format(DateTime.parse(bookingUserData[index]!.leavingTime.toString()))}",
                                                style: TextStyle(
                                                    fontSize: 10.sp,
                                                    color: AppColors
                                                        .greyWithAlpha),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Image.asset(
                                                      "assets/Repeat Grid_1.png"),
                                                  const SizedBox(
                                                    width: 5,
                                                  ),
                                                  Text(
                                                    bookingUserData[index]!
                                                        .orderNo
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 10.sp,
                                                        color: AppColors
                                                            .greyWithAlpha),
                                                  ),
                                                ],
                                              ),
                                              textWidget(bookingUserData[index]!
                                                  .paymentStatus)
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                color: AppColors.greyWithAlpha,
                                height: 0.3,
                              ),
                            ],
                          ),
                        )
                      : Container();
            });
  }

  textWidget(status) {
    if (status == "0") {
      return Text(
        "Waiting For Payment",
        style: TextStyle(
            fontSize: 11.sp,
            // fontWeight: FontWeight.bold,
            fontFamily: AppString.rubik,
            color: AppColors.commonColorSkyBlue),
      );
    } else if (status == "1") {
      return Text(
        "Payment Successfully",
        style: TextStyle(
            fontSize: 11.sp,
            // fontWeight: FontWeight.bold,
            fontFamily: AppString.rubik,
            color: Colors.green),
      );
    } else {
      return Text(
        "Canceled",
        style: TextStyle(
            fontSize: 11.sp,
            // fontWeight: FontWeight.bold,
            fontFamily: AppString.rubik,
            color: AppColors.redColor),
      );
    }
  }

  void searchWithThrottle(String keyword, {int? throttleTime}) {
    _timer?.cancel();
    if (keyword != previousKeyword && keyword.isNotEmpty) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
        if (kDebugMode) {
          print("Going to search with keyword : $keyword");
        }
        spaceProvider.onSearchTextChanged(keyword);
        _timer!.cancel();
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.logout),
        style: const TextStyle(color: AppColors.commonColorSkyBlue),
      ),
      onPressed: () {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteName.signInRoute, (route) => false);
      },
    );
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.okBtn),
        style: const TextStyle(color: AppColors.commonColorSkyBlue),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
        );
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      title: Text(
        AppLocalizations.of(context).translate(AppString.subscriptionExpired),
        style: const TextStyle(fontFamily: AppString.rubik, fontSize: 20),
      ),
      content: Text(
        AppLocalizations.of(context)
            .translate(AppString.pleaseRenewTheSubscriptionFirst),
        style:
            const TextStyle(fontFamily: AppString.rubikRegular, fontSize: 18),
      ),
      actions: [
        cancelButton,
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
