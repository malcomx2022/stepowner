import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const_color/constant_color.dart';

class Loading {
  static showLoader() {
    Get.defaultDialog(
        title: "",
        contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        backgroundColor: AppColors.white,
        content: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              color: AppColors.fontColorBlue,
            ),
            SizedBox(
              width: 25,
            ),
            Text("Loading"),
          ],
        ));
  }

  static hideDialog() {
    Get.back();
  }
}
