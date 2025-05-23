import 'package:flutter/material.dart';
import 'package:stepowner/provider/provider_model/subscription_provider.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class SubscriptionHistory extends StatefulWidget {
  const SubscriptionHistory({super.key});

  @override
  State<SubscriptionHistory> createState() => _SubscriptionHistoryState();
}

class _SubscriptionHistoryState extends State<SubscriptionHistory> {
  late SubscriptionProvider subscriptionProvider;

  @override
  void initState() {
    super.initState();
    subscriptionProvider =
        Provider.of<SubscriptionProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      subscriptionProvider.subscriptionHistoryApiCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    subscriptionProvider = Provider.of<SubscriptionProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.white),
        backgroundColor: AppColors.commonColorSkyBlue,
        centerTitle: true,
        title: const Text(
          "Subscription History",
          style: TextStyle(color: AppColors.white, fontFamily: AppString.rubik),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 10),
        height: MediaQuery.of(context).size.height,
        child: ListView.builder(
            shrinkWrap: true,
            primary: false,
            itemCount: subscriptionProvider.subscriptionHistoryData.length,
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: AppColors.grey,
                          blurRadius: 1,
                          spreadRadius: 0.1)
                    ],
                    borderRadius: BorderRadius.circular(10)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Plan : ${subscriptionProvider.subscriptionHistoryData[index].subscription?.subscriptionName}",
                        style: TextStyle(
                            fontSize: 13.sp, fontFamily: AppString.rubik),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Duration : ${subscriptionProvider.subscriptionHistoryData[index].duration}",
                              style: TextStyle(
                                  fontFamily: AppString.rubikRegular,
                                  fontSize: 11.sp),
                            ),
                            Text(
                                "Status : ${subscriptionProvider.subscriptionHistoryData[index].status == 0 ? "Expire" : "Active"}",
                                style: TextStyle(
                                    fontFamily: AppString.rubikRegular,
                                    fontSize: 11.sp)),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Start Date : ${subscriptionProvider.subscriptionHistoryData[index].startAt}",
                              style: TextStyle(
                                  fontFamily: AppString.rubikRegular,
                                  fontSize: 11.sp)),
                          Text(
                              "End Date : ${subscriptionProvider.subscriptionHistoryData[index].endAt}",
                              style: TextStyle(
                                  fontFamily: AppString.rubikRegular,
                                  fontSize: 11.sp)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        child: Text(
                            "Transaction ID : ${subscriptionProvider.subscriptionHistoryData[index].paymentToken ?? "~"}",
                            style: TextStyle(
                                fontFamily: AppString.rubikRegular,
                                fontSize: 11.sp)),
                      ),
                    ]),
              );
            }),
      ),
    );
  }
}
