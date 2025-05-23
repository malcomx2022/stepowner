import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fragment_navigate/navigate-control.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/navigator_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/provider/provider_model/subscription_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/screens/drawer/common_app_bar_widget/common_app_bar.dart';
import 'package:stepowner/provider/provider_model/image_provider.dart';
import 'package:stepowner/provider/provider_model/profile_provider.dart';
import 'package:stepowner/retrofit/models/get_all_space_model.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

const String homepage = 'homeScreen';
const String profile = 'Profile';
const String addressPage = 'Address';
const String spacePage = 'Space % price';
const String securityGuardPage = 'SecurityGuard';
const String transactionPage = 'Transaction';
const String scannerPage = 'Scanner';
const String reviewPage = 'Review';
const String settingPage = "Setting";
const String imagePage = "Image";
const String subscription = "Subscription";

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  File? selectDriverImage;
  final picker = ImagePicker();
  String? driverImage;
  late SpaceProvider spaceProvider;
  late ImagesProvider imagesProvider;
  late ProfileProvider profileProvider;

  String? appBarValue;
  late NavigatorProvider navigatorProvider;

  @override
  void initState() {
    super.initState();
    profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    Future.delayed(Duration.zero, () {
      profileProvider.getProfileApiCall();
    });
  }

  @override
  Widget build(BuildContext context) {
    NavigatorProvider.fragNav.setDrawerContext = context;
    spaceProvider = Provider.of<SpaceProvider>(context);
    return StreamBuilder<FullPosit>(
        stream: NavigatorProvider.fragNav.outStreamFragment,
        builder: (con, s) {
          if (s.data != null) {
            appBarValue = s.data!.key;
            return Scaffold(
                key: NavigatorProvider.fragNav.drawerKey,
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(9.h),
                  child: _checkAppBar(appBarValue, context),
                ),
                drawer: CustomDrawer(fragNav: NavigatorProvider.fragNav),
                body: ScreenNavigate(
                    control: NavigatorProvider.fragNav,
                    child: s.data!.fragment));
          }
          return Container(
            color: AppColors.white,
            child: const Center(
                child: CircularProgressIndicator(
              color: AppColors.commonColorSkyBlue,
            )),
          );
        });
  }

  /// all screen appBar
  Widget _checkAppBar(appBarValue, context) {
    profileProvider = Provider.of(context);
    if (appBarValue == "homeScreen") {
      return elseAppBarWidget(context);
    } else if (appBarValue == "Profile") {
      return CommonAppBar().profileWidget(NavigatorProvider.fragNav, context);
    } else if (appBarValue == "Subscription") {
      return CommonAppBar()
          .subscriptionWidget(NavigatorProvider.fragNav, context);
    } else if (appBarValue == "SecurityGuard") {
      return CommonAppBar()
          .securityGuardWidget(NavigatorProvider.fragNav, context);
    } else if (appBarValue == "Address") {
      return CommonAppBar().addressWidget(NavigatorProvider.fragNav, context);
    } else if (appBarValue == "Transaction") {
      return CommonAppBar()
          .transactionWidget(NavigatorProvider.fragNav, context);
    } else if (appBarValue == "Image") {
      imagesProvider = Provider.of<ImagesProvider>(context);
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.commonColorSkyBlue,
          elevation: 0,
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(color: AppColors.white),
          leading: IconButton(
            icon: const Icon(
              Icons.menu_outlined,
            ),
            onPressed: () {
              NavigatorProvider.fragNav.drawerKey.currentState!.openDrawer();
            },
          ),
          title: Text(
            AppLocalizations.of(context).translate(AppString.imageString),
            style: TextStyle(
                color: AppColors.white,
                fontFamily: AppString.rubik,
                fontSize: 14.sp),
          ),
          centerTitle: true,
          actions: imagesProvider.pickUploadImage.path == ""
              ? [
                  IconButton(
                    onPressed: () {
                      chooseProfileImage(profileProvider);
                    },
                    icon: const Icon(Icons.add),
                  )
                ]
              : [
                  IconButton(
                    onPressed: () {
                      PreferenceManager.getString(SharePreferenceKey.spaceIdKey)
                              .isNotEmpty
                          ? imagesProvider.uploadImage(
                              imagesProvider.allImages,
                              PreferenceManager.getString(
                                  SharePreferenceKey.spaceIdKey))
                          : CommonFunction.toastMessage(
                              AppLocalizations.of(context)
                                  .translate(AppString.selectSpace));
                    },
                    icon: const Icon(Icons.check_rounded),
                  ),
                  IconButton(
                    onPressed: () => clearImage(),
                    icon: const Icon(Icons.close),
                  ),
                ],
        ),
      );
    } else if (appBarValue == "Review") {
      return CommonAppBar().reviewWidget(NavigatorProvider.fragNav, context);
    } else {
      return CommonAppBar().scannerWidget(NavigatorProvider.fragNav, context);
    }
  }

  void clearImage() async {
    imagesProvider.pickUploadImage = File("");
    imagesProvider.allImages = [];
    imagesProvider.notify();
  }

  Widget elseAppBarWidget(
    context,
  ) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        primary: true,
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(
            Icons.menu_outlined,
            size: 30,
            color: AppColors.commonColorSkyBlue,
          ),
          onPressed: () {
            NavigatorProvider.fragNav.drawerKey.currentState!.openDrawer();
            spaceProvider.notify();
          },
        ),
        leadingWidth: 30,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(left: 1.5.h),
              child: InkWell(
                onTap: () {
                  showAlertDialog(context);
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            PreferenceManager.getString(
                                        SharePreferenceKey.showSpaceTitleKey)
                                    .isEmpty
                                ? Text(AppLocalizations.of(context)
                                    .translate(AppString.selectSpace))
                                : Text(
                                    PreferenceManager.getString(
                                            SharePreferenceKey
                                                .showSpaceTitleKey)
                                        .toString(),
                                    style: TextStyle(fontSize: 13.sp),
                                  ),
                            const Icon(
                              CupertinoIcons.chevron_down,
                              color: AppColors.redColor,
                            ),
                          ],
                        ),
                        Text(
                          PreferenceManager.getString(
                                  SharePreferenceKey.showSpaceTitleKey)
                              .toString(),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 8.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.remove_red_eye_outlined,
              size: 30,
              color: AppColors.commonColorSkyBlue,
            ),
            onPressed: () {
              if (PreferenceManager.getString(
                      SharePreferenceKey.showSpaceTitleKey)
                  .isEmpty) {
                Fluttertoast.showToast(
                    msg: AppLocalizations.of(context)
                        .translate(AppString.pleaseSelectSpace));
              } else {
                Navigator.pushNamed(
                  context,
                  RouteName.liveSpaceView,
                  arguments: NavigatorProvider.fragNav,
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.map_outlined,
              size: 30,
              color: AppColors.commonColorSkyBlue,
            ),
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                RouteName.godView,
              );
            },
          ),
        ],
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    /// Create AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: AppColors.white,
      shadowColor: AppColors.white,
      surfaceTintColor: AppColors.white,
      title: Wrap(
        alignment: WrapAlignment.center,
        children: [
          Text(
            AppLocalizations.of(context).translate(AppString.yourParkingSpace),
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
          ),
          Container(
            color: AppColors.greyWithAlpha,
            height: 1,
            margin: const EdgeInsets.only(top: 10),
          ),
        ],
      ),
      content: Wrap(
        children: [
          _showAllSpaceHomePage(context),
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 3),
      buttonPadding: EdgeInsets.zero,
      actions: const [],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _showAllSpaceHomePage(BuildContext context) {
    return StatefulBuilder(builder: (context, myState) {
      spaceProvider = Provider.of(context);
      return SizedBox(
        height: 35.h,
        width: 80.w,
        child: spaceProvider.getAllSpaces.isEmpty
            ? Center(
                child: Text(
                AppLocalizations.of(context).translate(AppString.noDataFound),
                style: TextStyle(fontFamily: AppString.rubik, fontSize: 12.sp),
              ))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: spaceProvider.getAllSpaces.length,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                itemBuilder: (BuildContext context, int index) {
                  return RadioListTile<AllSpaceData>(
                      activeColor: AppColors.commonColorSkyBlue,
                      title: Text(
                          spaceProvider.getAllSpaces[index].title.toString(),
                          style: TextStyle(
                              fontFamily: AppString.rubikRegular,
                              fontSize: 14.sp)),
                      value: spaceProvider.getAllSpaces[index],
                      groupValue: spaceProvider.getAllSpaces[index].id ==
                              int.tryParse(PreferenceManager.getString(
                                  SharePreferenceKey.spaceIdKey))
                          ? spaceProvider.getAllSpaces[index]
                          : null,
                      onChanged: (value) {
                        myState(() {
                          debugPrint(value.toString());
                          spaceProvider.notify();
                          PreferenceManager.setString(
                              SharePreferenceKey.spaceIdKey,
                              value!.id.toString());
                          PreferenceManager.setString(
                              SharePreferenceKey.showSpaceTitleKey,
                              value.title.toString());
                          PreferenceManager.setString(
                              SharePreferenceKey.spaceAddressKey,
                              value.address.toString());
                          spaceProvider.getSpaceIdData(
                              PreferenceManager.getString(
                                  SharePreferenceKey.spaceIdKey));
                          Navigator.of(context).pop();
                        });
                      });
                }),
      );
    });
  }

  void chooseProfileImage(ProfileProvider profileProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                title: Text(
                  AppLocalizations.of(context)
                      .translate(AppString.selectMethod),
                  style: const TextStyle(),
                ),
              ),
              ListTile(
                  visualDensity:
                      const VisualDensity(vertical: -4, horizontal: -4),
                  leading: const Icon(
                    Icons.photo_library_outlined,
                  ),
                  title: Text(
                    AppLocalizations.of(context).translate(AppString.gallery),
                    style: const TextStyle(),
                  ),
                  onTap: () {
                    imageFromGallery(profileProvider);
                    Navigator.of(context).pop();
                  }),
              ListTile(
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                leading: const Icon(Icons.photo_camera_outlined),
                title: Text(
                  AppLocalizations.of(context).translate(AppString.camera),
                  style: const TextStyle(),
                ),
                onTap: () {
                  imageFromCamera(profileProvider);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                visualDensity:
                    const VisualDensity(vertical: -4, horizontal: -4),
                leading: const Icon(
                  Icons.close_outlined,
                  color: AppColors.redColor,
                ),
                title: Text(
                  AppLocalizations.of(context).translate(AppString.cancelBtn),
                  style: const TextStyle(
                    color: AppColors.redColor,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void imageFromCamera(ProfileProvider profileProvider) async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        selectDriverImage = File(pickedFile.path);
        String base64 = imagesProvider.convertBase64(selectDriverImage!);
        imagesProvider.allImages
            .add("data:image/jpeg;base64,${jsonEncode(base64)}");
        imagesProvider.pickUploadImage = File(pickedFile.path);
        imagesProvider.notify();
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  void imageFromGallery(ProfileProvider profileProvider) async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        selectDriverImage = File(pickedFile.path);
        String base64 = imagesProvider.convertBase64(selectDriverImage!);
        imagesProvider.allImages
            .add("data:image/jpeg;base64,${jsonEncode(base64)}");
        imagesProvider.pickUploadImage = File(pickedFile.path);
        imagesProvider.notify();
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }
}

class CustomDrawer extends StatefulWidget {
  final FragNavigate fragNav;

  const CustomDrawer({super.key, required this.fragNav});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  late SubscriptionProvider subscriptionProvider;

  @override
  Widget build(BuildContext context) {
    ProfileProvider profileProvider = Provider.of(context);
    return CommonAppBar()
        .drawerWidget(profileProvider, NavigatorProvider.fragNav, context);
  }
}
