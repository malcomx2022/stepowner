import 'dart:async';
import 'package:intl/intl.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/transaction_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/models/transaction_model.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  DateTime? parkingStartTime;
  DateTime? parkingEndTime;

  int showColor = 1;
  String? every;
  Timer? _timer;
  String previousKeyword = "";

  late TransactionProvider transactionProvider;

  @override
  void initState() {
    super.initState();
    transactionProvider =
        Provider.of<TransactionProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      transactionProvider.transactionApiCall(
          PreferenceManager.getString(SharePreferenceKey.spaceIdKey),
          transactionProvider.every);
    });
  }

  @override
  Widget build(BuildContext context) {
    transactionProvider = Provider.of<TransactionProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SizedBox(
          height: 100.h,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ///search bar
                      Container(
                        height: 7.h,
                        width: 95.w,
                        margin: const EdgeInsets.only(top: 10),
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
                          controller:
                              transactionProvider.transactionSearchController,
                          onChanged: (String value) {
                            if (value.isNotEmpty)
                              searchWithThrottle(value, throttleTime: 100);
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
                                borderSide:
                                    const BorderSide(color: AppColors.white)),
                            disabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: AppColors.white)),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide:
                                    const BorderSide(color: AppColors.white)),
                            hintText: AppLocalizations.of(context)
                                .translate(AppString.search),
                            hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12.sp,
                                fontFamily: AppString.rubikRegular),
                          ),
                        ),
                      ),

                      ///vehicle images
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                  "assets/bike.png",
                                  width: 84.91,
                                  height: 68.05,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/card.png",
                                  width: 84.91,
                                  height: 68.05,
                                )
                              ],
                            ),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/Group_5659.png",
                                  width: 84.91,
                                  height: 68.05,
                                )
                              ],
                            )
                          ],
                        ),
                      ),

                      ///Today,Week,Month
                      Container(
                        height: 12.h,
                        color: AppColors.lightGrey,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showColor = 1;
                                  transactionProvider.every = "day";
                                  transactionProvider.transactionApiCall(
                                      PreferenceManager.getString(
                                          SharePreferenceKey.spaceIdKey),
                                      transactionProvider.every.toString());
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.today),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppString.rubik,
                                    color: showColor == 1
                                        ? AppColors.commonColorSkyBlue
                                        : AppColors.fontColorBlue),
                              ),
                            ),
                            const CircleAvatar(
                              minRadius: 5,
                              backgroundColor: AppColors.commonColorSkyBlue,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showColor = 2;
                                  transactionProvider.every = "week";
                                  transactionProvider.transactionApiCall(
                                      PreferenceManager.getString(
                                          SharePreferenceKey.spaceIdKey),
                                      transactionProvider.every.toString());
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.week),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppString.rubik,
                                    color: showColor == 2
                                        ? AppColors.commonColorSkyBlue
                                        : AppColors.fontColorBlue),
                              ),
                            ),
                            const CircleAvatar(
                              minRadius: 5,
                              backgroundColor: AppColors.commonColorSkyBlue,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  showColor = 3;
                                  transactionProvider.every = "month";
                                  transactionProvider.transactionApiCall(
                                      PreferenceManager.getString(
                                          SharePreferenceKey.spaceIdKey),
                                      transactionProvider.every.toString());
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.month),
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontFamily: AppString.rubik,
                                    color: showColor == 3
                                        ? AppColors.commonColorSkyBlue
                                        : AppColors.fontColorBlue),
                              ),
                            ),
                          ],
                        ),
                      ),

                      ///start date ane end date button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          /// start date btn
                          TextButton(
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext builder) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            color: AppColors.white,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(AppString
                                                              .cancelBtn),
                                                      style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color: AppColors.blue,
                                                          fontFamily:
                                                              AppString.rubik)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      parkingStartTime =
                                                          transactionProvider
                                                              .startTimeController;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            AppString.doneBtn),
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: AppColors.blue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.35,
                                          color: AppColors.white,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            onDateTimeChanged: (value) {
                                              transactionProvider
                                                  .startTimeController = value;
                                            },
                                            initialDateTime: parkingStartTime,
                                            use24hFormat: false,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    AppColors.black87),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontWeight: FontWeight.normal))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.startDate),
                                  style: TextStyle(
                                      fontFamily: AppString.rubik,
                                      fontSize: 12.sp),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  parkingStartTime != null
                                      ? DateFormat()
                                          .add_MMMMEEEEd()
                                          .format(parkingStartTime!)
                                      : AppLocalizations.of(context)
                                          .translate(AppString.selectTime),
                                  style: const TextStyle(
                                      fontFamily: AppString.rubik),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 72,
                            child: DottedLine(
                              direction: Axis.vertical,
                              lineThickness: 1.0,
                              dashLength: 4.0,
                              dashColor: Colors.grey.withAlpha(50),
                              dashRadius: 0.0,
                              dashGapLength: 4.0,
                              dashGapColor: Colors.transparent,
                              dashGapRadius: 0.0,
                            ),
                          ),

                          /// end date btn
                          TextButton(
                            onPressed: () {
                              showCupertinoModalPopup(
                                  context: context,
                                  builder: (BuildContext builder) {
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                            color: AppColors.white,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)
                                                          .translate(AppString
                                                              .cancelBtn),
                                                      style: TextStyle(
                                                          fontSize: 13.sp,
                                                          color: AppColors.blue,
                                                          fontFamily:
                                                              AppString.rubik)),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      parkingEndTime =
                                                          transactionProvider
                                                              .endTimeController;
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  child: Text(
                                                    AppLocalizations.of(context)
                                                        .translate(
                                                            AppString.doneBtn),
                                                    style: TextStyle(
                                                        fontSize: 13.sp,
                                                        color: AppColors.blue,
                                                        fontFamily:
                                                            AppString.rubik),
                                                  ),
                                                ),
                                              ],
                                            )),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .copyWith()
                                                  .size
                                                  .height *
                                              0.35,
                                          color: AppColors.white,
                                          child: CupertinoDatePicker(
                                            mode: CupertinoDatePickerMode
                                                .dateAndTime,
                                            onDateTimeChanged: (value) {
                                              transactionProvider
                                                  .endTimeController = value;
                                            },
                                            initialDateTime: parkingEndTime,
                                            use24hFormat: false,
                                          ),
                                        ),
                                      ],
                                    );
                                  });
                            },
                            style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all(
                                    AppColors.black87),
                                textStyle: MaterialStateProperty.all(
                                    const TextStyle(
                                        fontWeight: FontWeight.normal))),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                    child: Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.endDate),
                                  style: TextStyle(
                                      fontFamily: AppString.rubik,
                                      fontSize: 12.sp),
                                )),
                                SizedBox(
                                  height: 9.sp,
                                ),
                                Text(
                                  parkingEndTime != null
                                      ? DateFormat()
                                          .add_MMMMEEEEd()
                                          .format(parkingEndTime!)
                                      : AppLocalizations.of(context)
                                          .translate(AppString.selectTime),
                                  style: const TextStyle(
                                      fontFamily: AppString.rubik),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      ///divider
                      Container(
                        width: 100.w,
                        margin: const EdgeInsets.only(bottom: 10),
                        child: DottedLine(
                          direction: Axis.horizontal,
                          lineThickness: 1.0,
                          dashLength: 4.0,
                          dashColor: Colors.grey.withAlpha(50),
                          dashRadius: 0.0,
                          dashGapLength: 4.0,
                          dashGapColor: Colors.transparent,
                          dashGapRadius: 0.0,
                        ),
                      ),

                      ///user name,search by date
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.userName),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: AppString.rubik,
                                  color: AppColors.commonColorSkyBlue),
                            ),
                            TextButton(
                              onPressed: () {
                                if (transactionProvider.startTimeController !=
                                    null) {
                                  if (transactionProvider.endTimeController !=
                                      null) {
                                    transactionProvider
                                        .customTransactionApiCall(
                                            transactionProvider
                                                .startTimeController
                                                .toString(),
                                            transactionProvider
                                                .endTimeController
                                                .toString());
                                  } else {
                                    CommonFunction.toastMessage(
                                        AppLocalizations.of(context).translate(
                                            AppString.selectEndDate));
                                  }
                                } else {
                                  CommonFunction.toastMessage(
                                      AppLocalizations.of(context).translate(
                                          AppString.selectStartDate));
                                }
                              },
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.searchByDate),
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppString.rubik,
                                    color: AppColors.commonColorSkyBlue),
                              ),
                            )
                          ],
                        ),
                      ),

                      ///transaction history
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: transactionProvider.transactionSearchController
                                      .text.isNotEmpty &&
                                  transactionProvider
                                      .searchTransactionData.isEmpty
                              ? Text(
                                  AppLocalizations.of(context)
                                      .translate(AppString.noDataFound),
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontFamily: AppString.rubik,
                                      color: AppColors.black),
                                )
                              : transactionProvider
                                          .searchTransactionData.isNotEmpty &&
                                      transactionProvider
                                          .transactionSearchController
                                          .text
                                          .isNotEmpty
                                  ? _transactionSearchList(
                                      context,
                                      transactionProvider.searchTransactionData,
                                    )
                                  : _listView(
                                      context,
                                      transactionProvider.transactionData,
                                    )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: AppColors.commonColorSkyBlue,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context).translate(AppString.totalIncome),
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppString.rubik,
                    color: AppColors.white),
              ),
              Text(
                transactionProvider.transactionData.grandTotal == null
                    ? "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}0"
                    : "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}${transactionProvider.transactionData.grandTotal.toString()}",
                style: const TextStyle(
                    fontSize: 18,
                    fontFamily: AppString.rubik,
                    color: AppColors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView(BuildContext context, TransactionModelData transactionData) {
    return transactionProvider.transactionData.dataOfData == null
        ? Center(
            child: Text(
            AppLocalizations.of(context).translate(AppString.noDataFound),
            style: TextStyle(fontFamily: AppString.rubik, fontSize: 13.sp),
          ))
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: transactionData.dataOfData!.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transactionData.dataOfData![index]!.user!.name
                            .toString(),
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            fontSize: 15,
                            color: AppColors.fontColorBlue),
                      ),
                      Text(
                        "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}${transactionData.dataOfData![index]!.total.toString()}",
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            fontSize: 15,
                            color: AppColors.fontColorBlue),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    color: AppColors.greyWithAlpha,
                    height: 1,
                  ),
                ],
              );
            });
  }

  Widget _transactionSearchList(
      BuildContext context, List<UserDetails> transactionData) {
    return transactionProvider.searchTransactionData.isEmpty
        ? Center(
            child: Text(
            AppLocalizations.of(context).translate(AppString.noDataFound),
            style: TextStyle(fontFamily: AppString.rubik, fontSize: 13.sp),
          ))
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: transactionData.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        transactionData[index].name.toString(),
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            fontSize: 15,
                            color: AppColors.fontColorBlue),
                      ),
                      Text(
                        "${PreferenceManager.getString(SharePreferenceKey.currencySymbol)}${transactionData[index].total.toString()}",
                        style: const TextStyle(
                            fontFamily: AppString.rubik,
                            fontSize: 15,
                            color: AppColors.fontColorBlue),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Container(
                    color: AppColors.greyWithAlpha,
                    height: 1,
                  ),
                ],
              );
            });
  }

  void searchWithThrottle(String keyword, {int? throttleTime}) {
    _timer?.cancel();
    if (keyword != previousKeyword && keyword.isNotEmpty) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
        transactionProvider.onSearchTextChanged(keyword);
        _timer!.cancel();
      });
      transactionProvider.notify();
    }
  }
}
