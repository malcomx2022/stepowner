import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stepowner/provider/provider_model/navigator_provider.dart';
import 'package:stepowner/provider/provider_model/profile_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController confirmController = TextEditingController();

  late ProfileProvider profileProvider;

  late NavigatorProvider navigatorProvider;
  String _img64 = '';
  File? selectImage;

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of(context, listen: false);
    Future.delayed(Duration.zero, () {
      profileProvider.getProfileApiCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    profileProvider = Provider.of<ProfileProvider>(context);
    nameController.text = profileProvider.profileData.name.toString();
    emailController.text = profileProvider.profileData.email.toString();
    phoneNoController.text = profileProvider.profileData.phoneNo == 'null' ||
            profileProvider.profileData.phoneNo == null
        ? 'Enter Phone No'
        : profileProvider.profileData.phoneNo.toString();
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(children: <Widget>[
                Container(
                    height: 25.h,
                    width: 35.w,
                    margin: EdgeInsets.only(bottom: 10, top: 5.h),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.black),
                    ),
                    child: _imageFile != null
                        ? Image.file(
                            File(_imageFile!.path),
                            fit: BoxFit.cover,
                          )
                        : CachedNetworkImage(
                            imageUrl: profileProvider.profileData.imageUri!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) => Image.asset(
                              "assets/icon/noImage.png",
                              fit: BoxFit.cover,
                            ),
                          )),
                Positioned(
                  bottom: 15.0,
                  right: 10.0,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: ((builder) => bottomSheet()),
                      );
                    },
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.commonColorSkyBlue,
                      size: 28.0,
                    ),
                  ),
                ),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, bottom: 8),
              child: Text(
                AppLocalizations.of(context).translate(AppString.profileDetail),
                style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: AppString.rubik,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate(AppString.name),
                    style:
                        TextStyle(fontFamily: AppString.rubik, fontSize: 13.sp),
                  ),
                  TextFormField(
                    controller: nameController,
                    scrollPadding: const EdgeInsets.only(bottom: 10),
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.enterYourName),
                        hintStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  const SizedBox(
                    height: 11,
                  ),

                  /// change language button
                  Text(AppLocalizations.of(context).translate(AppString.email),
                      style: TextStyle(
                          fontFamily: AppString.rubik, fontSize: 13.sp)),
                  TextFormField(
                    controller: emailController,
                    scrollPadding: const EdgeInsets.only(bottom: 10),
                    enabled: false,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.entreYourEmail),
                        hintStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  const SizedBox(
                    height: 11,
                  ),
                  Text(
                      AppLocalizations.of(context)
                          .translate(AppString.phoneNumber),
                      style: TextStyle(
                          fontFamily: AppString.rubik, fontSize: 13.sp)),
                  TextFormField(
                    controller: phoneNoController,
                    scrollPadding: const EdgeInsets.only(bottom: 10),
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.entrePhoneNo),
                        hintStyle: TextStyle(fontSize: 12.sp)),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 14),
                    child: Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          profileProvider.profileUpdate(
                              nameController.text.toString(),
                              phoneNoController.text.toString(),
                              context);
                        },
                        color: AppColors.commonColorSkyBlue,
                        height: 6.h,
                        minWidth: 25.w,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.updateProfile)
                              .toUpperCase(),
                          style: const TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, left: 10, bottom: 8),
              child: Text(
                AppLocalizations.of(context)
                    .translate(AppString.changePassword),
                style: TextStyle(
                    fontSize: 15.sp,
                    fontFamily: AppString.rubik,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blue),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)
                          .translate(AppString.newPassword),
                      style: TextStyle(
                          fontFamily: AppString.rubik, fontSize: 13.sp)),
                  TextFormField(
                    controller: newPasswordController,
                    scrollPadding: const EdgeInsets.only(top: 10),
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.entrePassword),
                        hintStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.confirmPassword),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 13.sp)),
                  ),
                  TextFormField(
                    controller: confirmController,
                    decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)
                            .translate(AppString.entreConfirmPassword),
                        hintStyle: TextStyle(fontSize: 12.sp)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Center(
                      child: MaterialButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        onPressed: () {
                          if (newPasswordController.text.isNotEmpty) {
                            if (confirmController.text.isNotEmpty) {
                              profileProvider.updatePassword(
                                  newPasswordController.text.toString(),
                                  confirmController.text.toString());
                            } else {
                              CommonFunction.toastMessage(
                                  AppLocalizations.of(context).translate(
                                      AppString.entreConfirmPassword));
                            }
                          } else {
                            CommonFunction.toastMessage(
                                AppLocalizations.of(context)
                                    .translate(AppString.entrePassword));
                          }
                        },
                        color: AppColors.commonColorSkyBlue,
                        height: 6.h,
                        minWidth: 25.w,
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.changePassword)
                              .toUpperCase(),
                          style: const TextStyle(color: AppColors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          Text(
            AppLocalizations.of(context)
                .translate(AppString.chooseProfilePhoto),
            style: const TextStyle(
              fontSize: 20.0,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            TextButton.icon(
              icon: const Icon(
                Icons.camera_outlined,
                color: AppColors.commonColorSkyBlue,
              ),
              onPressed: () {
                takePhoto(
                  ImageSource.camera,
                );
                Navigator.pop(context);
              },
              label: Text(
                AppLocalizations.of(context).translate(AppString.camera),
                style: const TextStyle(color: AppColors.black),
              ),
            ),
            TextButton.icon(
              icon: const Icon(
                Icons.image_outlined,
                color: AppColors.commonColorSkyBlue,
              ),
              onPressed: () {
                takePhoto(
                  ImageSource.gallery,
                );
                Navigator.pop(context);
              },
              label: Text(
                  AppLocalizations.of(context).translate(AppString.gallery),
                  style: const TextStyle(color: AppColors.black)),
            ),
          ])
        ],
      ),
    );
  }

  void takePhoto(
    ImageSource source,
  ) async {
    var pickedFile = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = pickedFile;
      selectImage = File(pickedFile!.path);
      String base64 = profileProvider.convertBase64(selectImage!);
      _img64 = jsonEncode(base64);
      profileProvider.pictureUpdate("data:image/jpeg;base64,$_img64");
    });
  }
}
