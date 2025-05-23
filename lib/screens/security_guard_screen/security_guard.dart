import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/retrofit/models/get_all_guard.dart';
import 'package:stepowner/screens/new_guard_add_screen/new_guard.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class SecurityGuard extends StatefulWidget {
  const SecurityGuard({super.key});

  @override
  State<SecurityGuard> createState() => _SecurityGuardState();
}

class Model {
  String id = UniqueKey().toString();
  int? index;

  @override
  String toString() {
    return index.toString();
  }
}

class _SecurityGuardState extends State<SecurityGuard> {
  late GuardProvider guardProvider;
  Timer? _timer;
  String previousKeyword = "";

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      guardProvider = Provider.of(context, listen: false);
      if (PreferenceManager.getString(SharePreferenceKey.subscriptionStatus) ==
          "1") {
        guardProvider.getGuardApiCall();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    guardProvider = Provider.of<GuardProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      height: 7.h,
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
                        controller: guardProvider.searchController,
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
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 2.h, right: 2.h, top: 3.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppString.guardShift),
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppString.rubik,
                          color: AppColors.fontColorBlue),
                    ),
                  ],
                ),
              ),
              guardProvider.searchAllGuardList.isEmpty &&
                      guardProvider.searchController.text.isNotEmpty
                  ? Center(
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.noDataFound),
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontFamily: AppString.rubik,
                            color: AppColors.black),
                      ),
                    )
                  : guardProvider.searchController.text.isNotEmpty ||
                          guardProvider.searchAllGuardList.isNotEmpty
                      ? _searchListView(
                          context, guardProvider.searchAllGuardList)
                      : _listView(context, guardProvider.allGuardList)
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView(BuildContext context, List<AllGuardDataList> guardProvider) {
    return guardProvider.isEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Center(
                child: Text(
              AppLocalizations.of(context).translate(AppString.noDataFound),
              style: TextStyle(fontFamily: AppString.rubik, fontSize: 12.sp),
            )),
          )
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: guardProvider.length,
            itemBuilder: (BuildContext context, int index) {
              return SwipeActionCell(
                key: ObjectKey(guardProvider[index]),
                child: Container(
                  width: 85.w,
                  color: AppColors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      elevation: 1.5,
                      shadowColor: AppColors.commonColorSkyBlue,
                      child: InkWell(
                          splashColor: Colors.grey.withAlpha(30),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NewGuard(
                                          isEdit: true,
                                          index: index,
                                          spaceId: guardProvider[index].spaceId,
                                        )));
                          },
                          child: SizedBox(
                            height: 52,
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Row(
                                children: [
                                  Text(
                                    guardProvider[index].name.toString(),
                                    style: const TextStyle(
                                        fontFamily: AppString.rubik,
                                        color: AppColors.fontColorBlue,
                                        fontSize: 16),
                                  )
                                ],
                              ),
                            ),
                          )),
                    ),
                  ),
                ),
              );
            });
  }

  Widget _searchListView(
      BuildContext context, List<AllGuardDataList> guardProvider) {
    return guardProvider.isEmpty
        ? Padding(
            padding: EdgeInsets.only(top: 1.h),
            child: Center(
                child: Text(
              AppLocalizations.of(context).translate(AppString.noDataFound),
              style: TextStyle(fontFamily: AppString.rubik, fontSize: 12.sp),
            )),
          )
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: guardProvider.length,
            itemBuilder: (BuildContext context, int index) {
              return SwipeActionCell(
                key: ObjectKey(guardProvider[index]),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Card(
                    elevation: 1.5,
                    shadowColor: AppColors.commonColorSkyBlue,
                    child: InkWell(
                        splashColor: Colors.grey.withAlpha(30),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NewGuard(
                                        isEdit: true,
                                        index: index,
                                        spaceId: guardProvider[index].spaceId,
                                      )));
                        },
                        child: SizedBox(
                          height: 52,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: [
                                Text(
                                  guardProvider[index].name.toString(),
                                  style: const TextStyle(
                                      fontFamily: AppString.rubik,
                                      color: AppColors.fontColorBlue,
                                      fontSize: 16),
                                )
                              ],
                            ),
                          ),
                        )),
                  ),
                ),
              );
            });
  }

  void searchWithThrottle(String keyword, {int? throttleTime}) {
    _timer?.cancel();
    if (keyword != previousKeyword && keyword.isNotEmpty) {
      previousKeyword = keyword;
      _timer =
          Timer.periodic(Duration(milliseconds: throttleTime ?? 350), (timer) {
        onSearchTextChanged(keyword);
        _timer!.cancel();
      });
    }
  }

  onSearchTextChanged(String text) async {
    guardProvider.searchAllGuardList.clear();
    for (var element in guardProvider.allGuardList) {
      if (element.name.toString().toLowerCase().contains(text.toLowerCase())) {
        setState(() {
          guardProvider.searchAllGuardList.add(element);
        });
      }
    }
  }
}
