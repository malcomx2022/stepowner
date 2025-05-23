import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as date_lib;
import 'package:stepowner/provider/provider_model/transaction_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/constant/loading.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sizer/sizer.dart';
import '../../utils/change_language/app_location.dart';
import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class Scanner extends StatefulWidget {
  const Scanner({super.key});

  @override
  State<Scanner> createState() => _ScannerState();
}

class _ScannerState extends State<Scanner> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  Barcode? result;
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  late TransactionProvider transactionProvider;

  @override
  Widget build(BuildContext context) {
    transactionProvider = Provider.of<TransactionProvider>(context);

    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.white,
      body: transactionProvider.loader == true
          ? Loading.showLoader()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 4.h, bottom: 3.h),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.scanUserBarcode),
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontFamily: AppString.rubik,
                            color: AppColors.darkBlue)),
                  ),
                  Container(
                    height: 40.h,
                    margin: EdgeInsets.symmetric(horizontal: 4.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 6,
                          child: QRView(
                            key: qrKey,
                            onQRViewCreated: _onQRViewCreated,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Center(
                            child: (result != null)
                                ? Text(AppLocalizations.of(context)
                                    .translate(AppString.success))
                                : Container(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    height: 3.h,
                    color: AppColors.skyBlue,
                    thickness: 25,
                  ),

                  /// stack ticket
                  transactionProvider.visible == true
                      ? Padding(
                          padding: const EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 23),
                                  child: Card(
                                    color: AppColors.blueWithAlpha,
                                    elevation: 5,
                                    shadowColor: AppColors.skyBlue,
                                    child: InkWell(
                                      splashColor: Colors.blue.withAlpha(30),
                                      onTap: () {},
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                transactionProvider
                                                            .bookingUserData
                                                            .paymentStatus ==
                                                        0
                                                    ? AppLocalizations.of(
                                                            context)
                                                        .translate(AppString
                                                            .waitingForPayment)
                                                    : transactionProvider
                                                                .bookingUserData
                                                                .paymentStatus ==
                                                            1
                                                        ? AppLocalizations.of(
                                                                context)
                                                            .translate(AppString
                                                                .paymentSuccessful)
                                                        : AppLocalizations.of(
                                                                context)
                                                            .translate(AppString
                                                                .paymentRejected),
                                                style: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontFamily: AppString.rubik,
                                                    color: AppColors
                                                        .fontColorBlue),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 20, top: 10),
                                            child: Text(
                                              '${AppLocalizations.of(context).translate(AppString.idNo)}. ${transactionProvider.bookingUserData.orderNo}',
                                              style: TextStyle(
                                                  fontSize: 11.sp,
                                                  fontFamily: AppString.rubik,
                                                  color: AppColors
                                                      .commonColorSkyBlue),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              transactionProvider
                                                          .bookingUserData
                                                          .status ==
                                                      0
                                                  ? Container(
                                                      height: 6.h,
                                                      width: 30.w,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .cyan,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Center(
                                                          child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(AppString
                                                                .booked),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 2.5.h,
                                                            fontFamily:
                                                                AppString.rubik,
                                                            color:
                                                                AppColors.cyan),
                                                      )),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                              transactionProvider
                                                          .bookingUserData
                                                          .status ==
                                                      1
                                                  ? Container(
                                                      height: 6.h,
                                                      width: 30.w,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .dBlue,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Center(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      AppString
                                                                          .inParking),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      2.5.h,
                                                                  fontFamily:
                                                                      AppString
                                                                          .rubik,
                                                                  color: AppColors
                                                                      .dBlue))),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                              transactionProvider
                                                          .bookingUserData
                                                          .status ==
                                                      2
                                                  ? Container(
                                                      height: 6.h,
                                                      width: 30.w,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .green,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Center(
                                                          child: Text(
                                                        AppLocalizations.of(
                                                                context)
                                                            .translate(AppString
                                                                .complete),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: 2.5.h,
                                                            fontFamily:
                                                                AppString.rubik,
                                                            color: AppColors
                                                                .green),
                                                      )),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                              transactionProvider
                                                          .bookingUserData
                                                          .status ==
                                                      3
                                                  ? Container(
                                                      height: 6.h,
                                                      width: 30.w,
                                                      margin:
                                                          const EdgeInsets.only(
                                                              bottom: 5),
                                                      decoration: BoxDecoration(
                                                          shape: BoxShape
                                                              .rectangle,
                                                          border: Border.all(
                                                              color: AppColors
                                                                  .redColor,
                                                              width: 2),
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          30))),
                                                      child: Center(
                                                          child: Text(
                                                              AppLocalizations.of(
                                                                      context)
                                                                  .translate(
                                                                      AppString
                                                                          .cancelBtn),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      2.5.h,
                                                                  fontFamily:
                                                                      AppString
                                                                          .rubik,
                                                                  color: AppColors
                                                                      .redColor))),
                                                    )
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    ),
                                            ],
                                          ),
                                          Container(
                                            color: AppColors.greyWithAlpha,
                                            height: 1,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                          ),
                                          Container(
                                            padding:
                                                const EdgeInsets.only(top: 15),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              AppString.date),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              AppString.rubik,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          date_lib.DateFormat(
                                                                  'dd-mm-yy')
                                                              .format(DateTime.parse(
                                                                  transactionProvider
                                                                      .bookingUserData
                                                                      .arrivingTime
                                                                      .toString())),
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik,
                                                              fontSize: 10.sp,
                                                              color: AppColors
                                                                  .fontColorBlue),
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              AppString.time),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              AppString.rubik,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      '${date_lib.DateFormat('hh:mm').format(DateTime.parse(transactionProvider.bookingUserData.arrivingTime!))} TO '
                                                      '${date_lib.DateFormat('hh:mm').format(DateTime.parse(transactionProvider.bookingUserData.leavingTime!))}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppString.rubik,
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    )
                                                  ],
                                                ),
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(
                                                              AppString.price),
                                                      style: TextStyle(
                                                          fontSize: 12.sp,
                                                          fontFamily:
                                                              AppString.rubik,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    ),
                                                    const SizedBox(
                                                      height: 2,
                                                    ),
                                                    Text(
                                                      r'$'
                                                      '${transactionProvider.bookingUserData.totalAmount!.round()}',
                                                      style: TextStyle(
                                                          fontFamily:
                                                              AppString.rubik,
                                                          fontSize: 10.sp,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            color: AppColors.greyWithAlpha,
                                            height: 1,
                                            margin:
                                                const EdgeInsets.only(top: 5),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              top: 2.h,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  transactionProvider
                                                      .bookingUserData
                                                      .user!
                                                      .name
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontFamily:
                                                          AppString.rubik,
                                                      fontSize: 14.sp,
                                                      color: AppColors
                                                          .fontColorBlue),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Row(
                                              children: [
                                                Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      '${AppLocalizations.of(context).translate(AppString.vehicleTypeCar)} : ${transactionProvider.bookingUserData.vehicle!.model}',
                                                      style: TextStyle(
                                                          fontSize: 9.5.sp,
                                                          fontFamily:
                                                              AppString.rubik,
                                                          color: AppColors
                                                              .fontColorBlue),
                                                    ),
                                                    Text(
                                                        '${AppLocalizations.of(context).translate(AppString.vehicleNumber)} : ${transactionProvider.bookingUserData.vehicle!.vehicleNo}',
                                                        style: TextStyle(
                                                            fontSize: 9.5.sp,
                                                            fontFamily:
                                                                AppString.rubik,
                                                            color: AppColors
                                                                .fontColorBlue))
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 4,
                                left: 1,
                                right: 1,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.fontColorBlue,
                                  minRadius: 25,
                                  child: Image.asset(
                                    "assets/Path_3267.png",
                                    width: 100,
                                    height: 50,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        if (PreferenceManager.getString(
                SharePreferenceKey.subscriptionStatus) ==
            "1") {
          if (kDebugMode) {
            print("Scanner Code : ${result!.code!}");
            print("Scanner Format Name : ${result!.format.formatName}");
            print("Scanner Format index : ${result!.format.index}");
            print("Scanner Name : ${result!.format.name}");
          }
          transactionProvider.scanOderApiCall(result!.code!);
        } else {
          CommonFunction.toastMessage("Please Purchase Subscription First");
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
