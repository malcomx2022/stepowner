import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../retrofit/models/space_id_live_model.dart';

class LiveParkingView extends StatefulWidget {
  const LiveParkingView({super.key});

  @override
  State<LiveParkingView> createState() => _LiveParkingViewState();
}

class _LiveParkingViewState extends State<LiveParkingView> {
  late SpaceProvider spaceProvider;

  @override
  void initState() {
    super.initState();
    if (kDebugMode) {
      print(
          "Space Id : ${PreferenceManager.getString(SharePreferenceKey.spaceIdKey)}");
    }
    spaceProvider = Provider.of<SpaceProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      spaceProvider.spaceIdLivedata.clear();
      spaceProvider.getSpaceIdLiveApiCall(
          PreferenceManager.getString(SharePreferenceKey.spaceIdKey));
    });
  }

  var indexIs = 0;
  var gridViewIndexIs = -1;

  @override
  Widget build(BuildContext context) {
    spaceProvider = Provider.of<SpaceProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.commonColorSkyBlue,
        foregroundColor: AppColors.white,
        title: Text(
          AppLocalizations.of(context).translate(AppString.liveParkingView),
          style: TextStyle(
              fontFamily: AppString.rubik,
              fontSize: 16.sp,
              color: AppColors.white),
        ),
      ),
      body: Container(
        width: 100.w,
        margin: const EdgeInsets.only(left: 10, right: 10),
        padding: const EdgeInsets.only(top: 25),
        child: spaceProvider.spaceIdLivedata.isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context).translate(AppString.noDataFound),
                style: TextStyle(fontFamily: AppString.rubik, fontSize: 15.sp),
              ))
            : Column(
                children: [
                  Container(
                    height: 6.h,
                    margin: const EdgeInsets.only(bottom: 15),
                    child: spaceProvider.spaceIdLivedata.isNotEmpty
                        ? ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemCount: spaceProvider.spaceIdLivedata.length,
                            itemBuilder: (BuildContext context, index) {
                              return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        indexIs = index;
                                        setState(() {});
                                      },
                                      style: ButtonStyle(
                                          elevation:
                                              MaterialStateProperty.all(0),
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  indexIs == index
                                                      ? AppColors
                                                          .commonColorSkyBlue
                                                      : AppColors.white)),
                                      child: Text(
                                        spaceProvider
                                            .spaceIdLivedata[index].name
                                            .toString(),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: indexIs == index
                                                ? AppColors.white
                                                : AppColors.commonColorSkyBlue),
                                      )));
                            },
                          )
                        : Container(),
                  ),
                  Expanded(
                      child: spaceProvider
                              .spaceIdLivedata[indexIs].slots!.isNotEmpty
                          ? GridView.builder(
                              itemCount: spaceProvider
                                  .spaceIdLivedata[indexIs].slots!.length,
                              padding:
                                  const EdgeInsets.only(top: 7, bottom: 50),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, mainAxisExtent: 99),
                              itemBuilder: (BuildContext context, int index) {
                                if (index.isEven) {
                                  return SizedBox(
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const DottedLine(
                                          lineLength: 98,
                                          direction: Axis.vertical,
                                          lineThickness: 2.0,
                                          dashLength: 4.0,
                                          dashColor:
                                              AppColors.commonColorSkyBlue,
                                          dashRadius: 0.0,
                                          dashGapLength: 2.0,
                                          dashGapColor: Colors.transparent,
                                          dashGapRadius: 0.0,
                                        ),
                                        Container(
                                          padding: EdgeInsets.zero,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Transform.rotate(
                                                angle: 0.35,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      top: 18),
                                                  child: const DottedLine(
                                                    lineLength: 140,
                                                    direction: Axis.horizontal,
                                                    lineThickness: 2.0,
                                                    dashLength: 4.0,
                                                    dashColor: AppColors
                                                        .commonColorSkyBlue,
                                                    dashRadius: 0.0,
                                                    dashGapLength: 2.0,
                                                    dashGapColor:
                                                        Colors.transparent,
                                                    dashGapRadius: 0.0,
                                                  ),
                                                ),
                                              ),
                                              Transform.rotate(
                                                angle: 0.35,
                                                child: Container(
                                                  height: 70,
                                                  margin: const EdgeInsets.only(
                                                    left: 15,
                                                  ),
                                                  child: InkWell(
                                                    onTap: () {
                                                      spaceProvider
                                                                  .spaceIdLivedata[
                                                                      indexIs]
                                                                  .slots![index]
                                                                  .available ==
                                                              true
                                                          ? showAlertDialog(
                                                              context,
                                                              spaceProvider
                                                                  .spaceIdLivedata[
                                                                      indexIs]
                                                                  .slots![index]
                                                                  .booking!)
                                                          : null;
                                                      setState(() {});
                                                    },
                                                    child: Container(
                                                      alignment:
                                                          Alignment.center,
                                                      width: 110,
                                                      child: spaceProvider
                                                                  .spaceIdLivedata[
                                                                      indexIs]
                                                                  .slots![index]
                                                                  .available ==
                                                              true
                                                          ? Transform.rotate(
                                                              angle: 1.5,
                                                              child:
                                                                  Image.asset(
                                                                "assets/image/myParkingCar.png",
                                                                height: 90,
                                                                width: 80,
                                                              ),
                                                            )
                                                          : Text(
                                                              spaceProvider
                                                                  .spaceIdLivedata[
                                                                      indexIs]
                                                                  .slots![index]
                                                                  .name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontFamily:
                                                                    AppString
                                                                        .rubik,
                                                                color: AppColors
                                                                    .fontColorBlue,
                                                                fontSize: 12.sp,
                                                              ),
                                                            ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return SizedBox(
                                    height: 55,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Transform.rotate(
                                              angle: 2.7,
                                              child: Container(
                                                margin: const EdgeInsets.only(
                                                    bottom: 25),
                                                child: const DottedLine(
                                                  lineLength: 140,
                                                  direction: Axis.horizontal,
                                                  lineThickness: 2.0,
                                                  dashLength: 4.0,
                                                  dashColor: AppColors
                                                      .commonColorSkyBlue,
                                                  dashRadius: 0.0,
                                                  dashGapLength: 2.0,
                                                  dashGapColor:
                                                      Colors.transparent,
                                                  dashGapRadius: 0.0,
                                                ),
                                              ),
                                            ),
                                            Transform.rotate(
                                              angle: -0.4,
                                              child: Container(
                                                height: 70,
                                                padding: EdgeInsets.zero,
                                                alignment: Alignment.center,
                                                margin: const EdgeInsets.only(
                                                    right: 13),
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {});
                                                    spaceProvider
                                                                .spaceIdLivedata[
                                                                    indexIs]
                                                                .slots![index]
                                                                .available ==
                                                            true
                                                        ? showAlertDialog(
                                                            context,
                                                            spaceProvider
                                                                .spaceIdLivedata[
                                                                    indexIs]
                                                                .slots![index]
                                                                .booking!)
                                                        : null;
                                                  },
                                                  child: Container(
                                                    width: 110,
                                                    alignment: Alignment.center,
                                                    child: spaceProvider
                                                                .spaceIdLivedata[
                                                                    indexIs]
                                                                .slots![index]
                                                                .available ==
                                                            true
                                                        ? Transform.rotate(
                                                            angle: 4.7,
                                                            child: Image.asset(
                                                                "assets/image/myParkingCar.png",
                                                                height: 90,
                                                                width: 80,
                                                                alignment:
                                                                    Alignment
                                                                        .center),
                                                          )
                                                        : Text(
                                                            spaceProvider
                                                                .spaceIdLivedata[
                                                                    indexIs]
                                                                .slots![index]
                                                                .name
                                                                .toString(),
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: TextStyle(
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik,
                                                              color: AppColors
                                                                  .fontColorBlue,
                                                              fontSize: 12.sp,
                                                            ),
                                                          ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const DottedLine(
                                          lineLength: 95,
                                          direction: Axis.vertical,
                                          lineThickness: 2.0,
                                          dashLength: 4.0,
                                          dashColor:
                                              AppColors.commonColorSkyBlue,
                                          dashRadius: 0.0,
                                          dashGapLength: 2.0,
                                          dashGapColor: Colors.transparent,
                                          dashGapRadius: 0.0,
                                        ),
                                      ],
                                    ),
                                  );
                                }
                              },
                            )
                          : Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.noDataFound),
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontFamily: AppString.rubik))),
                ],
              ),
      ),
    );
  }

  showAlertDialog(BuildContext context, Booking booking) {
    /// Create AlertDialog
    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      title: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            booking.user!.name.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                fontFamily: AppString.rubik),
          ),
          Container(
            color: AppColors.greyWithAlpha,
            height: 1,
            margin: const EdgeInsets.only(top: 10),
          ),
        ],
      ),
      content: Padding(
        padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15, right: 5),
        child: Wrap(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "${AppLocalizations.of(context).translate(AppString.orderNo)} : ",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontFamily: AppString.rubikRegular),
                ),
                Text(
                  booking.orderNo.toString(),
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontFamily: AppString.rubikRegular,
                    color: AppColors.black,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "${AppLocalizations.of(context).translate(AppString.vehicleModel)} : ",
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.black,
                        fontFamily: AppString.rubikRegular),
                  ),
                  Text(
                    booking.vehicle!.model.toString(),
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.black,
                        fontFamily: AppString.rubikRegular),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Text(
                  "${AppLocalizations.of(context).translate(AppString.vehicleNo)} : ",
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontFamily: AppString.rubikRegular),
                ),
                Text(
                  booking.vehicle!.vehicleNo.toString(),
                  style: TextStyle(
                      fontSize: 13.sp,
                      color: AppColors.black,
                      fontFamily: AppString.rubikRegular),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${DateFormat('dd-MMM-yy').format(DateTime.parse(booking.arrivingTime.toString()))}, "
                    "${DateFormat().add_jm().format(DateTime.parse(booking.arrivingTime.toString()))}  To ",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.black,
                        fontFamily: AppString.rubikRegular),
                  ),
                  Text(
                    " ${DateFormat('dd-MMM-yy').format(DateTime.parse(booking.leavingTime.toString()))}, "
                    "${DateFormat().add_jm().format(DateTime.parse(booking.leavingTime.toString()))}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.black,
                        fontFamily: AppString.rubikRegular),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}"
                    "${booking.totalAmount ?? 00.toStringAsFixed(2)}",
                    style: TextStyle(
                        fontSize: 13.sp,
                        color: AppColors.commonColorSkyBlue,
                        fontFamily: AppString.rubik),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
      buttonPadding: EdgeInsets.zero,
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
