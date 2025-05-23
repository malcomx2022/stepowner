import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stepowner/provider/provider_model/review_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:intl/intl.dart' as date_lib;
import '../../retrofit/models/review_model.dart';

class Review extends StatefulWidget {
  const Review({super.key});

  @override
  State<Review> createState() => _ReviewState();
}

class _ReviewState extends State<Review> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  late ReviewProvider reviewProvider;
  Timer? _timer;
  String previousKeyword = "";
  String dropdownValue = 'ALL';
  TextEditingController reviewSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      reviewProvider.reviewData();
    });
  }

  @override
  Widget build(BuildContext context) {
    reviewProvider = Provider.of<ReviewProvider>(context, listen: true);
    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.white,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 7.h,
                width: 100.w,
                margin: const EdgeInsets.all(10),
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
                  controller: reviewSearchController,
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
                    contentPadding: const EdgeInsets.only(top: 15, left: 10),
                    border: InputBorder.none,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppColors.white)),
                    disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppColors.white)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(color: AppColors.white)),
                    hintText: AppLocalizations.of(context)
                        .translate(AppString.search),
                    hintStyle: TextStyle(
                        color: AppColors.grey,
                        fontSize: 12.sp,
                        fontFamily: AppString.rubikRegular),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context).translate(AppString.review),
                      style: const TextStyle(
                          fontSize: 16,
                          fontFamily: AppString.rubik,
                          color: AppColors.fontColorBlue),
                    ),
                    InkWell(
                      onTap: () {},
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            value: dropdownValue,
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
                              setState(() {
                                dropdownValue = newValue!;
                              });
                            },
                            items: <String>[
                              AppLocalizations.of(context)
                                  .translate(AppString.today),
                              AppLocalizations.of(context)
                                  .translate(AppString.all)
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              reviewProvider.searchReviewAllData.isEmpty &&
                      reviewSearchController.text.isNotEmpty
                  ? Text(
                      AppLocalizations.of(context)
                          .translate(AppString.noDataFound),
                      style: TextStyle(
                          fontSize: 12.sp,
                          fontFamily: AppString.rubik,
                          color: AppColors.black),
                    )
                  : reviewProvider.searchReviewAllData.isNotEmpty &&
                          reviewSearchController.text != ''
                      ? _searchReviewList(context,
                          reviewProvider.searchReviewAllData, dropdownValue)
                      : _listView(
                          context, reviewProvider.reviewAllData, dropdownValue),
            ],
          ),
        ),
      ),
    );
  }

  Widget _listView(
      BuildContext context, List<Data> reviewProvider, dropdownValue) {
    return reviewProvider.isEmpty
        ? Center(
            child: Text(
            AppLocalizations.of(context).translate(AppString.noDataFound),
            style: TextStyle(fontFamily: AppString.rubik, fontSize: 12.sp),
          ))
        : ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: reviewProvider.length,
            itemBuilder: (BuildContext context, int index) {
              return dropdownValue == 'ALL'
                  ? Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 85.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 10.h,
                              width: 20.w,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      reviewProvider[index].user!.imageUri!,
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
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        "assets/image/noImage.png",
                                        fit: BoxFit.cover,
                                      )),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 0.9.h),
                                  child: Text(
                                    "${reviewProvider[index].user!.name!}  ( ${reviewProvider[index].space!.title} )",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppString.rubik),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  width: 68.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: reviewProvider[index]
                                            .star
                                            .toDouble(),
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemSize: 17,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        unratedColor: AppColors.grey,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star_outlined,
                                          color: AppColors.amber,
                                        ),
                                        onRatingUpdate: (double rating) {
                                          setState(() {
                                            if (kDebugMode) {
                                              print(rating);
                                            }
                                          });
                                        },
                                        updateOnDrag: false,
                                      ),
                                      Text(
                                        "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}, "
                                        "${date_lib.DateFormat().add_jm().format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}",
                                        style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 10.sp,
                                            fontFamily: AppString.rubikRegular),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 70.w,
                                  margin:
                                      EdgeInsets.only(top: 0.5.h, left: 0.8.h),
                                  child: Text(
                                    reviewProvider[index].description!,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: AppColors.greyWithAlpha,
                                        fontFamily: AppString.rubikRegular),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    )
                  : dropdownValue == 'Today' &&
                          DateTime.now().toString().split(" ")[0] ==
                              reviewProvider[index]
                                  .createdAt!
                                  .toString()
                                  .split(' ')[0]
                      ? Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            width: 85.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10.h,
                                  width: 20.w,
                                  child: CachedNetworkImage(
                                      imageUrl: reviewProvider[index]
                                          .user!
                                          .imageUri!,
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
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(left: 0.9.h),
                                      child: Text(
                                        "${reviewProvider[index].user!.name!}  ( ${reviewProvider[index].space!.title} )",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontFamily: AppString.rubik),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.only(top: 0.5.h),
                                      width: 68.w,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          RatingBar.builder(
                                            initialRating: reviewProvider[index]
                                                .star
                                                .toDouble(),
                                            minRating: 0,
                                            direction: Axis.horizontal,
                                            allowHalfRating: false,
                                            itemSize: 17,
                                            itemCount: 5,
                                            ignoreGestures: true,
                                            unratedColor: AppColors.grey,
                                            itemPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 2),
                                            itemBuilder: (context, _) =>
                                                const Icon(
                                              Icons.star_outlined,
                                              color: AppColors.amber,
                                            ),
                                            onRatingUpdate: (double rating) {
                                              setState(() {
                                                if (kDebugMode) {
                                                  print(rating);
                                                }
                                              });
                                            },
                                            updateOnDrag: false,
                                          ),
                                          Text(
                                            "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}, "
                                            "${date_lib.DateFormat().add_jm().format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}",
                                            style: TextStyle(
                                                color: AppColors.grey,
                                                fontSize: 10.sp,
                                                fontFamily:
                                                    AppString.rubikRegular),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: 70.w,
                                      margin: EdgeInsets.only(
                                          top: 0.5.h, left: 0.8.h),
                                      child: Text(
                                        reviewProvider[index].description!,
                                        maxLines: 2,
                                        style: const TextStyle(
                                            color: AppColors.greyWithAlpha,
                                            fontFamily: AppString.rubikRegular),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container();
            });
  }

  Widget _searchReviewList(
      BuildContext context, List<Data> reviewProvider, dropdownValue) {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: reviewProvider.length,
        itemBuilder: (BuildContext context, int index) {
          return dropdownValue == 'All'
              ? Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: 85.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                          width: 20.w,
                          child: CachedNetworkImage(
                              imageUrl: reviewProvider[index].user!.imageUri!,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Image.asset(
                                    "assets/image/noImage.png",
                                    fit: BoxFit.cover,
                                  )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 0.9.h),
                              child: Text(
                                "${reviewProvider[index].user!.name!}  ( ${reviewProvider[index].space!.title} )",
                                style: TextStyle(
                                    fontSize: 14.sp,
                                    fontFamily: AppString.rubik),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(top: 0.5.h),
                              width: 68.w,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RatingBar.builder(
                                    initialRating:
                                        reviewProvider[index].star.toDouble(),
                                    minRating: 0,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemSize: 17,
                                    itemCount: 5,
                                    ignoreGestures: true,
                                    unratedColor: AppColors.grey,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star_outlined,
                                      color: AppColors.amber,
                                    ),
                                    onRatingUpdate: (double rating) {
                                      setState(() {
                                        if (kDebugMode) {
                                          print(rating);
                                        }
                                      });
                                    },
                                    updateOnDrag: false,
                                  ),
                                  Text(
                                    "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}, "
                                    "${date_lib.DateFormat().add_jm().format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}",
                                    style: TextStyle(
                                        color: AppColors.grey,
                                        fontSize: 10.sp,
                                        fontFamily: AppString.rubikRegular),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: 70.w,
                              margin: EdgeInsets.only(top: 0.5.h, left: 0.8.h),
                              child: Text(
                                reviewProvider[index].description!,
                                maxLines: 2,
                                style: const TextStyle(
                                    color: AppColors.greyWithAlpha,
                                    fontFamily: AppString.rubikRegular),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : dropdownValue == 'Today' &&
                      DateTime.now().toString().split(" ")[0] ==
                          reviewProvider[index]
                              .createdAt!
                              .toString()
                              .split(' ')[0]
                  ? Container(
                      color: AppColors.redColor,
                      height: 2,
                    )
                  : Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: 85.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                              width: 20.w,
                              child: CachedNetworkImage(
                                  imageUrl:
                                      reviewProvider[index].user!.imageUri!,
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
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                        "assets/image/noImage.png",
                                        fit: BoxFit.cover,
                                      )),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 0.9.h),
                                  child: Text(
                                    "${reviewProvider[index].user!.name!}  ( ${reviewProvider[index].space!.title} )",
                                    style: TextStyle(
                                        fontSize: 14.sp,
                                        fontFamily: AppString.rubik),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.only(top: 0.5.h),
                                  width: 68.w,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: reviewProvider[index]
                                            .star
                                            .toDouble(),
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: false,
                                        itemSize: 17,
                                        itemCount: 5,
                                        ignoreGestures: true,
                                        unratedColor: AppColors.grey,
                                        itemPadding: const EdgeInsets.symmetric(
                                            horizontal: 2),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star_outlined,
                                          color: AppColors.amber,
                                        ),
                                        onRatingUpdate: (double rating) {
                                          setState(() {
                                            if (kDebugMode) {
                                              print(rating);
                                            }
                                          });
                                        },
                                        updateOnDrag: false,
                                      ),
                                      Text(
                                        "${date_lib.DateFormat('dd-MMM-yy').format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}, "
                                        "${date_lib.DateFormat().add_jm().format(DateTime.parse(reviewProvider[index].user!.createdAt.toString()))}",
                                        style: TextStyle(
                                            color: AppColors.grey,
                                            fontSize: 10.sp,
                                            fontFamily: AppString.rubikRegular),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 70.w,
                                  margin:
                                      EdgeInsets.only(top: 0.5.h, left: 0.8.h),
                                  child: Text(
                                    reviewProvider[index].description!,
                                    maxLines: 2,
                                    style: const TextStyle(
                                        color: AppColors.greyWithAlpha,
                                        fontFamily: AppString.rubikRegular),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
        if (kDebugMode) {
          print("Going to search with keyword : $keyword");
        }
        reviewProvider.onSearchTextChanged(keyword);
        _timer!.cancel();
      });
      reviewProvider.notify();
    }
  }
}
