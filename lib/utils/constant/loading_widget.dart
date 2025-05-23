import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import '../const_color/constant_color.dart';

class LoadingWidget extends StatefulWidget {
  const LoadingWidget({super.key});

  @override
  State<LoadingWidget> createState() => _LoadingWidgetState();
}

class _LoadingWidgetState extends State<LoadingWidget> {
  late bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: ModalProgressHUD(
            inAsyncCall: loading,
            opacity: 1.0,
            color: Colors.transparent.withOpacity(0.2),
            child: const SpinKitFadingCircle(color: AppColors.commonColorSkyBlue),
          ),
        ),
      ),
    );
  }
}
