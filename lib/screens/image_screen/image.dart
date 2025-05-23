import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import '../../provider/provider_model/image_provider.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  late ImagesProvider imagesProvider;

  File? selectDriverImage;
  final picker = ImagePicker();
  String? id;

  @override
  void initState() {
    super.initState();
    imagesProvider = Provider.of(context, listen: false);
    Future.delayed(Duration.zero, () {
      imagesProvider.getSpaceImage(
          PreferenceManager.getString(SharePreferenceKey.spaceIdKey));
    });
  }

  @override
  Widget build(BuildContext context) {
    imagesProvider = Provider.of<ImagesProvider>(context);

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Container(
            height: 100.h,
            padding: EdgeInsets.only(bottom: 15.h),
            child: Column(
              children: [
                imagesProvider.pickUploadImage.path == ""
                    ? Container()
                    : Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 3.h, bottom: 2.h),
                            height: 30.h,
                            color: AppColors.grey,
                            child: Image.file(
                              imagesProvider.pickUploadImage,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(
                          top: 2.h, left: 2.h, right: 2.h, bottom: 1.h),
                      primary: false,
                      itemCount: imagesProvider.imageSpaceData.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 30.h,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                child: CachedNetworkImage(
                                  imageUrl: imagesProvider
                                      .imageSpaceData[index].imageUri!,
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 20.h,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(05),
                                      shape: BoxShape.rectangle,
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                    ),
                                  ),
                                  placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) =>
                                      Image.asset("assets/icon/noImage.png"),
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                deleteDialog(context, index);
                              },
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all(
                                      const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(05)))),
                                  backgroundColor: MaterialStateProperty.all(
                                      AppColors.redColor)),
                              child: Text(
                                AppLocalizations.of(context)
                                    .translate(AppString.delete),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 13.sp,
                                    fontFamily: AppString.rubik),
                              ),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            )),
      ),
    );
  }

  Future<dynamic> deleteDialog(BuildContext context, int index) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              backgroundColor: AppColors.white,
              shadowColor: AppColors.white,
              surfaceTintColor: AppColors.white,
              title: Text(AppLocalizations.of(context)
                  .translate(AppString.areYouSureToDelete)),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(AppLocalizations.of(context)
                        .translate(AppString.cancelBtn))),
                TextButton(
                    onPressed: () {
                      imagesProvider.deleteImage(
                          imagesProvider.imageSpaceData[index].id.toString());
                      Navigator.pop(ctx);
                    },
                    child: Text(
                      AppLocalizations.of(context).translate(AppString.delete),
                      style: const TextStyle(color: AppColors.redColor),
                    ))
              ],
            ));
  }
}
