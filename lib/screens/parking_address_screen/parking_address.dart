import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:country_picker/country_picker.dart'; // <--- import pour Country Picker
import 'package:intl_phone_field/intl_phone_field.dart'; // <--- import pour le champ téléphone
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/provider/provider_model/space_provider.dart';
import 'package:stepowner/provider/provider_model/facilities_provider.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/utils/AppString/app_strings.dart';
import 'package:stepowner/utils/change_language/app_location.dart';
import 'package:stepowner/utils/const_color/constant_color.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

import '../../utils/const_preference/preference.dart';
import '../../utils/const_preference/shared_preference_utils.dart';

class ParkingAddress extends StatefulWidget {
  const ParkingAddress({super.key});

  @override
  State<ParkingAddress> createState() => _ParkingAddressState();
}

class _ParkingAddressState extends State<ParkingAddress>
    with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();
  late TabController tabController;

  List<Map<String, String>> checkBoxValue = [];
  List<String> selectedFacilitiesList = [];
  bool isSwitched = false;
  bool isSwitchedOfflinePay = true;
  bool visible = true;
  int? indexIs = 0;
  String showSelectedFacilities = '';

  DateTime? parkingOpenTime;
  DateTime? parkingCloseTime;

  List parkingZone = [];
  List<int> nameEditList = [];
  List<int> sizeEditList = [];

  /// controller
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  // Champ téléphone
  String _completePhoneNumber = ""; // numéro complet (avec indicatif)

  // Champ country
  Country? _selectedCountry;

  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController postalCodeController = TextEditingController();
  TextEditingController stateController = TextEditingController();

  TextEditingController pricePerHourController = TextEditingController();

  TextEditingController parkingOpenTimeController = TextEditingController();
  TextEditingController parkingCloseTimeController = TextEditingController();

  int? offlinePaymentMode = 1;
  int? availableAllDaysController = 0;
  double latController = 22.2587;
  double longController = 71.1924;
  List<WidgetCard> serviceCardList = []; // Liste dynamique des zones

  /// map variable
  final Completer<GoogleMapController> _controller = Completer();
  MapType _currentMapType = MapType.normal;
  LatLng? _currentPosition;
  bool _isLoading = true;
  final Set<Marker> _markers = {};
  GoogleMapController? _mapController;
  bool _isSavedPositionFavorite = false;

  /// Custom marker icon
  BitmapDescriptor? _customMarkerIcon;

  late FacilitiesProvider facilitiesProvider;
  late GuardProvider guardProvider;
  late SpaceProvider addSpaceProvider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    guardProvider = Provider.of<GuardProvider>(context, listen: false);
    facilitiesProvider =
        Provider.of<FacilitiesProvider>(context, listen: false);

    // Charger l'icône personnalisée pour le marker
    _loadCustomMarker();

    Future.delayed(Duration.zero, () {
      if (PreferenceManager.getString(SharePreferenceKey.subscriptionStatus) ==
          "1") {
        facilitiesProvider.getFacilities();
        guardProvider.availableGuardApiCall();
      }
    });

    // Initialiser la position
    _getCurrentLocation();
    _checkIfPositionIsFavorite();

    if (PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) ==
            Provider.of<SpaceProvider>(context, listen: false)
                .getAllSpaces
                .length &&
        PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) > 0) {
      Future.delayed(
        const Duration(microseconds: 500),
        () {
          if (!mounted) return;
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              surfaceTintColor: AppColors.white,
              shadowColor: AppColors.white,
              backgroundColor: AppColors.white,
              title: const Text("Limit Reached!"),
              content: const Text(
                  "You've reached the maximum parking space limit.\nPlease upgrade your subscription plan & then re-login"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    AppLocalizations.of(context).translate(AppString.okBtn),
                  ),
                )
              ],
            ),
          );
        },
      );
    }
  }

  /// Charge l’image personnalisée depuis assets pour l’utiliser en marker
  Future<void> _loadCustomMarker() async {
    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)), // taille du marker
      'assets/app_icon.png', // chemin dans pubspec.yaml
    );
    setState(() {
      _customMarkerIcon = icon;
    });
  }

  // Nouvelle méthode pour obtenir la position actuelle
  Future<void> _getCurrentLocation() async {
    try {
      // Vérifier les permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Utiliser une position par défaut si permission refusée
          _setDefaultLocation();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _setDefaultLocation();
        return;
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        latController = position.latitude;
        longController = position.longitude;
        _isLoading = false;
      });

      // Ajouter un marqueur initial si l’icône est chargée
      _addMarker(_currentPosition!);
    } catch (e) {
      if (kDebugMode) {
        print("Erreur lors de la récupération de la position: $e");
      }
      _setDefaultLocation();
    }
  }

  // Position par défaut si problème
  void _setDefaultLocation() {
    setState(() {
      _currentPosition =
          const LatLng(22.2587, 71.1924); // Exemple: Surat, India
      latController = _currentPosition!.latitude;
      longController = _currentPosition!.longitude;
      _isLoading = false;
    });
    _addMarker(_currentPosition!);
  }

  // Méthode pour ajouter/mettre à jour le marqueur avec l’icône personnalisée
  void _addMarker(LatLng position) {
    // N'ajoute le marker que si l'icône personnalisée est prête
    if (_customMarkerIcon == null) return;

    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          markerId: const MarkerId('parking_location'),
          position: position,
          draggable: true,
          icon: _customMarkerIcon!, // Utilisation de l’icône personnalisée
          infoWindow: InfoWindow(
            title:
                AppLocalizations.of(context).translate(AppString.thisIsTitle),
            snippet:
                AppLocalizations.of(context).translate(AppString.thisIsSnippet),
          ),
          onDragEnd: (LatLng newPosition) {
            setState(() {
              latController = newPosition.latitude;
              longController = newPosition.longitude;
            });
          },
        ),
      );
    });
  }

  // Modifier _onMapCreated
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _controller.complete(controller);
  }

  // Nouvelle méthode pour permettre à l'utilisateur de placer un marqueur en tapant
  void _handleTap(LatLng position) {
    setState(() {
      latController = position.latitude;
      longController = position.longitude;
      _addMarker(position);
    });
  }

  // Sauvegarder position favorite
  void _toggleFavoritePosition() {
    if (_isSavedPositionFavorite) {
      // Supprimer la position favorite
      PreferenceManager.removeKey('saved_lat');
      PreferenceManager.removeKey('saved_lng');
      setState(() {
        _isSavedPositionFavorite = false;
      });
      CommonFunction.toastMessage("Position favorite supprimée");
    } else {
      // Sauvegarder la position actuelle en tant que String
      PreferenceManager.setString('saved_lat', latController.toString());
      PreferenceManager.setString('saved_lng', longController.toString());
      setState(() {
        _isSavedPositionFavorite = true;
      });
      CommonFunction.toastMessage("Position sauvegardée dans les favoris");
    }
  }

  // Vérifier si la position actuelle est favorite
  void _checkIfPositionIsFavorite() {
    String? savedLat = PreferenceManager.getString('saved_lat');
    String? savedLng = PreferenceManager.getString('saved_lng');

    if (savedLat.isNotEmpty && savedLng.isNotEmpty) {
      try {
        double lat = double.parse(savedLat);
        double lng = double.parse(savedLng);
        setState(() {
          _isSavedPositionFavorite =
              (lat == latController && lng == longController);
        });
      } catch (e) {
        // Gérer l'erreur de parsing
        setState(() {
          _isSavedPositionFavorite = false;
        });
      }
    }
  }

  // Charger position favorite
  void _loadFavoritePosition() {
    String? savedLat = PreferenceManager.getString('saved_lat');
    String? savedLng = PreferenceManager.getString('saved_lng');

    if (savedLat.isNotEmpty && savedLng.isNotEmpty) {
      try {
        double lat = double.parse(savedLat);
        double lng = double.parse(savedLng);
        LatLng favoritePosition = LatLng(lat, lng);
        _mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(favoritePosition, 15),
        );
        _handleTap(favoritePosition);
      } catch (e) {
        CommonFunction.toastMessage(
            "Erreur lors du chargement de la position favorite");
      }
    } else {
      CommonFunction.toastMessage("Aucune position favorite sauvegardée");
    }
  }

  @override
  Widget build(BuildContext context) {
    addSpaceProvider = Provider.of<SpaceProvider>(context);

    /// facilities check true / false
    facilitiesProvider = Provider.of(context);
    checkBoxValue.clear();

    Map<String, String> facilitiesMap;
    for (int i = 0; i < facilitiesProvider.facilitiesData.length; i++) {
      if (facilitiesProvider.facilitiesData[i].isCheck == true) {
        facilitiesMap = {
          "title": facilitiesProvider.facilitiesData[i].title.toString(),
          "id": facilitiesProvider.facilitiesData[i].id.toString(),
        };
        checkBoxValue.add(facilitiesMap);
      }
    }
    addSpaceProvider.showSelectedGuardName.clear();
    addSpaceProvider.showSelectedGuardId.clear();
    for (int i = 0; i < guardProvider.availableGuardData.length; i++) {
      if (guardProvider.availableGuardData[i]!.isCheck == true) {
        addSpaceProvider.showSelectedGuardName
            .add(guardProvider.availableGuardData[i]!.name.toString());
        addSpaceProvider.showSelectedGuardId
            .add(guardProvider.availableGuardData[i]!.id.toString());
      }
    }

    return Scaffold(
      key: _globalKey,
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        physics: indexIs == 2
            ? const NeverScrollableScrollPhysics()
            : const AlwaysScrollableScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête de l’écran
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(top: 3.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      "assets/owner_parking_detail.png",
                      height: 18.h,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate(AppString.rateYourSpace),
                      style: const TextStyle(
                          fontFamily: AppString.rubik,
                          fontSize: 20,
                          color: AppColors.fontColorBlue),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10, top: 1.h),
                      margin: EdgeInsets.only(bottom: 2.h),
                      width: 70.w,
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.fillAllDetailsAndThen),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: AppString.rubik,
                          color: AppColors.greyWithAlpha,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Barre de navigation en haut (Basic / Zone / Map / Guard)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          indexIs = 0;
                        });
                      },
                      child: Column(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: indexIs == 0
                                ? AppColors.commonColorSkyBlue
                                : AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.basic)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: indexIs == 0
                                    ? AppColors.commonColorSkyBlue
                                    : AppColors.black,
                              ),
                            ),
                          ),
                          Container(
                            color: indexIs == 0
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 1;
                              });
                            },
                      child: Column(
                        children: [
                          Icon(
                            Icons.wifi_tethering_outlined,
                            color: indexIs == 1
                                ? AppColors.commonColorSkyBlue
                                : AppColors.black,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.zone)
                                  .toUpperCase(),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: indexIs == 1
                                    ? AppColors.commonColorSkyBlue
                                    : AppColors.black,
                              ),
                            ),
                          ),
                          Container(
                            color: indexIs == 1
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 2;
                              });
                            },
                      child: Column(
                        children: [
                          const Icon(Icons.location_pin),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.map)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            color: indexIs == 2
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) ==
                                  Provider.of<SpaceProvider>(context,
                                          listen: false)
                                      .getAllSpaces
                                      .length &&
                              PreferenceManager.getInt(
                                      SharePreferenceKey.maxSpaceLimit) >
                                  0
                          ? null
                          : () {
                              setState(() {
                                indexIs = 3;
                              });
                            },
                      child: Column(
                        children: [
                          const Icon(Icons.person_outlined),
                          Padding(
                            padding: EdgeInsets.only(top: 0.5.h, bottom: 0.5.h),
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.guard)
                                  .toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Container(
                            color: indexIs == 3
                                ? AppColors.commonColorSkyBlue
                                : AppColors.white,
                            height: 3,
                            width: 20.w,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // **************** STEP 1 : BASIC ****************
              if (indexIs == 0)
                Container(
                  margin: EdgeInsets.only(
                      top: 2.h, bottom: 5.h, right: 3.h, left: 3.h),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre “Add Parking Detail”
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.addParkingDetail),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 13.sp),
                      ),

                      // Espace Name
                      Padding(
                        padding: EdgeInsets.only(top: 3.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.spaceName),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      TextFormField(
                        controller: titleController,
                        validator: RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.enterYourName))
                            .call,
                        scrollPadding: const EdgeInsets.only(bottom: 10),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.enterYourName),
                          hintStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),

                      // Description
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.description),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      TextFormField(
                        controller: descriptionController,
                        validator: RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.enterDescription))
                            .call,
                        scrollPadding: const EdgeInsets.only(bottom: 10),
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.enterDescription),
                          hintStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),

                      // Champ Téléphone avec indicatif pays
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.phoneNumber),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.entrePhoneNo),
                        ),
                        initialCountryCode: 'FR', // code par défaut
                        onChanged: (phone) {
                          setState(() {
                            _completePhoneNumber = phone.completeNumber;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.number.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate(AppString.entrePhoneNo);
                          }
                          return null;
                        },
                      ),

                      // Prix par heure
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.pricePerHour),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      TextFormField(
                        controller: pricePerHourController,
                        validator: RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.enterPrice))
                            .call,
                        scrollPadding: const EdgeInsets.only(bottom: 10),
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.price),
                          hintStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),

                      // Facilities (liste déroulante)
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.facilities),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          facilitiesAlertDialog(context);
                        },
                        icon: const Icon(
                          Icons.arrow_drop_down_sharp,
                          color: AppColors.black,
                        ),
                        label: Text(
                          () {
                            showSelectedFacilities = '';
                            selectedFacilitiesList = [];
                            for (int i = 0; i < checkBoxValue.length; i++) {
                              showSelectedFacilities +=
                                  " ${checkBoxValue[i]['title']},";
                              selectedFacilitiesList
                                  .add(checkBoxValue[i]['id']!);
                            }
                            return showSelectedFacilities.isEmpty
                                ? AppLocalizations.of(context)
                                    .translate(AppString.selectFacilities)
                                : showSelectedFacilities;
                          }(),
                          style: TextStyle(
                              color: AppColors.black,
                              fontSize: 12.sp,
                              fontFamily: AppString.rubik),
                        ),
                      ),

                      // Switch « Available 24h »
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.available_24hour),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppString.rubikRegular,
                                  color: AppColors.commonColorSkyBlue),
                            ),
                            Switch(
                              value: isSwitched,
                              onChanged: (value) {
                                setState(() {
                                  isSwitched = value;
                                  isSwitched == true
                                      ? visible = false
                                      : visible = true;
                                  isSwitched == true
                                      ? availableAllDaysController = 1
                                      : availableAllDaysController = 0;
                                  if (kDebugMode) {
                                    print(isSwitched);
                                  }
                                });
                              },
                              activeTrackColor: AppColors.commonColorSkyBlue,
                              activeColor: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColors.black,
                      ),

                      // Horaire d’ouverture / fermeture
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 1.h),
                        child: Visibility(
                          visible: visible,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Open Time
                                    InkWell(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(AppString
                                                                  .cancelBtn),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: AppColors
                                                                  .blue,
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  AppString
                                                                      .doneBtn),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: AppColors
                                                                  .blue,
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .copyWith()
                                                          .size
                                                          .height *
                                                      0.35,
                                                  color: AppColors.white,
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    onDateTimeChanged: (value) {
                                                      setState(() {
                                                        parkingOpenTime = value;
                                                        parkingOpenTimeController
                                                                .text =
                                                            DateFormat()
                                                                .add_jm()
                                                                .format(value);
                                                      });
                                                    },
                                                    initialDateTime:
                                                        parkingOpenTime,
                                                    use24hFormat: false,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate(AppString.openTime),
                                        style: TextStyle(
                                            fontFamily: AppString.rubik,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                    TextFormField(
                                      enabled: false,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: InputDecoration(
                                        hintText: parkingOpenTime != null
                                            ? DateFormat()
                                                .add_jm()
                                                .format(parkingOpenTime!)
                                            : AppLocalizations.of(context)
                                                .translate(
                                                    AppString.selectTime),
                                        hintStyle: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Close Time
                                    InkWell(
                                      onTap: () {
                                        showCupertinoModalPopup(
                                          context: context,
                                          builder: (BuildContext builder) {
                                            return Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
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
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(AppString
                                                                  .cancelBtn),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: AppColors
                                                                  .blue,
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          setState(() {});
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                          AppLocalizations.of(
                                                                  context)
                                                              .translate(
                                                                  AppString
                                                                      .doneBtn),
                                                          style: TextStyle(
                                                              fontSize: 13.sp,
                                                              color: AppColors
                                                                  .blue,
                                                              fontFamily:
                                                                  AppString
                                                                      .rubik),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: MediaQuery.of(context)
                                                          .copyWith()
                                                          .size
                                                          .height *
                                                      0.35,
                                                  color: AppColors.white,
                                                  child: CupertinoDatePicker(
                                                    mode:
                                                        CupertinoDatePickerMode
                                                            .time,
                                                    onDateTimeChanged: (value) {
                                                      setState(() {
                                                        parkingCloseTime =
                                                            value;
                                                        parkingCloseTimeController
                                                                .text =
                                                            DateFormat()
                                                                .add_jm()
                                                                .format(value);
                                                      });
                                                    },
                                                    initialDateTime:
                                                        parkingCloseTime,
                                                    minimumDate: DateTime.now()
                                                        .subtract(
                                                            const Duration(
                                                                minutes: 1)),
                                                    use24hFormat: false,
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .translate(AppString.closeTime),
                                        style: TextStyle(
                                            fontFamily: AppString.rubik,
                                            fontSize: 12.sp),
                                      ),
                                    ),
                                    TextFormField(
                                      enabled: false,
                                      scrollPadding:
                                          const EdgeInsets.only(bottom: 10),
                                      decoration: InputDecoration(
                                        hintText: parkingCloseTime != null
                                            ? DateFormat()
                                                .add_jm()
                                                .format(parkingCloseTime!)
                                            : AppLocalizations.of(context)
                                                .translate(
                                                    AppString.selectTime),
                                        hintStyle: TextStyle(fontSize: 12.sp),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Switch Offline Payment
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 0.2.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.offlinePayment),
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontFamily: AppString.rubikRegular,
                                  color: AppColors.commonColorSkyBlue),
                            ),
                            Switch(
                              value: isSwitchedOfflinePay,
                              onChanged: (value) {
                                setState(() {
                                  isSwitchedOfflinePay = value;
                                  isSwitchedOfflinePay == true
                                      ? offlinePaymentMode = 1
                                      : offlinePaymentMode = 0;
                                });
                              },
                              activeTrackColor: AppColors.commonColorSkyBlue,
                              activeColor: AppColors.white,
                            ),
                          ],
                        ),
                      ),
                      const Divider(
                        color: AppColors.black,
                      ),

                      // *** Champ Country en liste déroulante ***
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 0.5.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.country),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode:
                                true, // afficher l’indicatif téléphonique à droite
                            onSelect: (Country country) {
                              setState(() {
                                _selectedCountry = country;
                              });
                            },
                          );
                        },
                        child: AbsorbPointer(
                          // pour que le TextFormField ne soit pas éditable directement
                          child: TextFormField(
                            controller: TextEditingController(
                              text: _selectedCountry == null
                                  ? ""
                                  : "${_selectedCountry!.name}",
                            ),
                            validator: (value) {
                              if (_selectedCountry == null) {
                                return AppLocalizations.of(context)
                                    .translate(AppString.enterCountryName);
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText: AppLocalizations.of(context).translate(
                                  AppString
                                      .country), // Use the correct key for "Select Country"
                              suffixIcon: const Icon(Icons.arrow_drop_down),
                            ),
                          ),
                        ),
                      ),

                      // Adresse, Ville, Postal Code, State
                      Padding(
                        padding: EdgeInsets.only(top: 2.h, bottom: 1.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.address),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      TextFormField(
                        controller: addressController,
                        validator: RequiredValidator(
                                errorText: AppLocalizations.of(context)
                                    .translate(AppString.enterAddress))
                            .call,
                        decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.enterAddress),
                          hintStyle: TextStyle(fontSize: 12.sp),
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 17.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.city),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: cityController,
                                    validator: RequiredValidator(
                                            errorText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterCityName))
                                        .call,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate(AppString.enterCityName),
                                      hintStyle: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 17.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.postalCode),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: postalCodeController,
                                    validator: RequiredValidator(
                                            errorText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterPostalCode))
                                        .call,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate(AppString.enterPostalCode),
                                      hintStyle: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 17.h,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 2.h),
                                    child: Text(
                                      AppLocalizations.of(context)
                                          .translate(AppString.state),
                                      style: TextStyle(
                                          fontFamily: AppString.rubik,
                                          fontSize: 13.sp),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: stateController,
                                    validator: RequiredValidator(
                                            errorText: AppLocalizations.of(
                                                    context)
                                                .translate(
                                                    AppString.enterStateName))
                                        .call,
                                    decoration: InputDecoration(
                                      hintText: AppLocalizations.of(context)
                                          .translate(AppString.enterStateName),
                                      hintStyle: TextStyle(fontSize: 12.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: SizedBox(
                              height: 17.h,
                              child: SizedBox
                                  .shrink(), // Placeholder vide, on supprime le champ country ici
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

              // **************** STEP 2 : ZONE ****************
              if (indexIs == 1)
                Container(
                  margin: EdgeInsets.only(left: 2.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.addZoneDetails),
                        style: TextStyle(
                            fontSize: 13.sp, fontFamily: AppString.rubik),
                      ),
                      ...serviceCardList,
                      serviceCardList.isEmpty
                          ? const SizedBox(height: 15)
                          : const SizedBox.shrink(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            addServiceCard();
                          });
                        },
                        child: Padding(
                          padding: EdgeInsets.only(bottom: 1.5.h),
                          child: Text(
                            AppLocalizations.of(context)
                                .translate(AppString.addNewZone),
                            style: TextStyle(
                                fontFamily: AppString.rubikRegular,
                                fontSize: 13.sp,
                                color: AppColors.commonColorSkyBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // **************** STEP 3 : MAP ****************
              if (indexIs == 2)
                Container(
                  margin: EdgeInsets.only(
                      top: 1.h, bottom: 1.h, right: 3.h, left: 3.h),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              AppLocalizations.of(context)
                                  .translate(AppString.whereYouAre),
                              style: TextStyle(
                                  fontSize: 14.sp, fontFamily: AppString.rubik),
                            ),
                          ),
                          // Dropdown pour le type de carte
                          DropdownButton<MapType>(
                            value: _currentMapType,
                            underline: const SizedBox.shrink(),
                            icon: const Icon(Icons.layers,
                                color: AppColors.commonColorSkyBlue),
                            items: [
                              DropdownMenuItem(
                                value: MapType.normal,
                                child: Text("Normal",
                                    style: TextStyle(fontSize: 11.sp)),
                              ),
                              DropdownMenuItem(
                                value: MapType.satellite,
                                child: Text("Satellite",
                                    style: TextStyle(fontSize: 11.sp)),
                              ),
                              DropdownMenuItem(
                                value: MapType.hybrid,
                                child: Text("Hybride",
                                    style: TextStyle(fontSize: 11.sp)),
                              ),
                            ],
                            onChanged: (MapType? value) {
                              setState(() {
                                _currentMapType = value!;
                              });
                            },
                          ),
                          // Bouton pour position favorite
                          IconButton(
                            icon: Icon(
                              _isSavedPositionFavorite
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: AppColors.commonColorSkyBlue,
                            ),
                            onPressed: _toggleFavoritePosition,
                            tooltip: "Sauvegarder position favorite",
                          ),
                          // Bouton pour charger position favorite
                          IconButton(
                            icon:
                                const Icon(Icons.star, color: AppColors.amber),
                            onPressed: _loadFavoritePosition,
                            tooltip: "Charger position favorite",
                          ),
                          // Bouton pour recentrer sur la position actuelle
                          IconButton(
                            icon: const Icon(Icons.my_location,
                                color: AppColors.commonColorSkyBlue),
                            onPressed: () async {
                              if (_mapController != null) {
                                final position = _currentPosition ??
                                    const LatLng(22.2587, 71.1924);
                                _mapController!.animateCamera(
                                  CameraUpdate.newLatLngZoom(position, 15),
                                );
                              }
                            },
                            tooltip: "Ma position",
                          ),
                        ],
                      ),
                      _isLoading
                          ? SizedBox(
                              height: 30.h,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.commonColorSkyBlue,
                                ),
                              ),
                            )
                          : Container(
                              margin: EdgeInsets.only(top: 1.h),
                              height: 30.h,
                              width: 100.w,
                              child: Stack(
                                children: [
                                  GoogleMap(
                                    myLocationEnabled: true,
                                    myLocationButtonEnabled:
                                        false, // On utilise notre propre bouton
                                    zoomGesturesEnabled: true,
                                    zoomControlsEnabled: true,
                                    mapType: _currentMapType,
                                    markers: _markers,
                                    initialCameraPosition: CameraPosition(
                                      target: _currentPosition ??
                                          const LatLng(22.2587, 71.1924),
                                      zoom: 15.0,
                                    ),
                                    onMapCreated: _onMapCreated,
                                    onTap:
                                        _handleTap, // Permettre de placer un marqueur
                                  ),
                                  // Instructions overlay
                                  Positioned(
                                    top: 10,
                                    left: 10,
                                    right: 10,
                                    child: Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.1),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        "Tapez sur la carte pour placer le marqueur ou glissez-le pour ajuster la position",
                                        style: TextStyle(
                                          fontSize: 10.sp,
                                          fontFamily: AppString.rubik,
                                          color: AppColors.fontColorBlue,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      // Afficher les coordonnées sélectionnées
                      if (!_isLoading)
                        Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Lat: ${latController.toStringAsFixed(6)}",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: AppString.rubik,
                                  color: AppColors.greyWithAlpha,
                                ),
                              ),
                              Text(
                                "Long: ${longController.toStringAsFixed(6)}",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontFamily: AppString.rubik,
                                  color: AppColors.greyWithAlpha,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

              // **************** STEP 4 : GUARD ****************
              if (indexIs == 3)
                Container(
                  margin: EdgeInsets.only(
                      top: 3.h, bottom: 2.h, left: 4.h, right: 4.h),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)
                            .translate(AppString.pleaseProviderWorkforce),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 14.sp),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: Text(
                          AppLocalizations.of(context)
                              .translate(AppString.guardList),
                          style: TextStyle(
                              fontFamily: AppString.rubik, fontSize: 13.sp),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          guardListAlertDialog(context);
                        },
                        child: TextFormField(
                          decoration: InputDecoration(
                            enabled: false,
                            labelText: addSpaceProvider.showSelectedGuardName
                                .join(","),
                            suffixIcon: const Icon(Icons.arrow_drop_down_sharp),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 2.h),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushNamed(
                                context, RouteName.newGuardRoute);
                          },
                          child: Text(
                            AppLocalizations.of(context)
                                .translate(AppString.addNewGuard),
                            style: TextStyle(
                                fontFamily: AppString.rubikRegular,
                                fontSize: 13.sp,
                                color: AppColors.commonColorSkyBlue),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),

      /// Button du bas (“Next” / “Add”)
      bottomNavigationBar: ElevatedButton(
        onPressed: PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) ==
                    Provider.of<SpaceProvider>(context, listen: false)
                        .getAllSpaces
                        .length &&
                PreferenceManager.getInt(SharePreferenceKey.maxSpaceLimit) > 0
            ? null
            : () {
                Map<String, dynamic> map;
                parkingZone = [];
                for (int i = 0; i < serviceCardList.length; i++) {
                  map = {
                    "name":
                        serviceCardList[i].spaceNameController.text.toString(),
                    "size": serviceCardList[i].sizeController.text.toString(),
                  };
                  parkingZone.add(map);
                }
                setState(() {
                  /// Basic
                  if (indexIs == 0) {
                    if (formKey.currentState!.validate() &&
                        showSelectedFacilities.isNotEmpty &&
                        _selectedCountry != null &&
                        _completePhoneNumber.isNotEmpty) {
                      indexIs = 1;
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillProperData));
                    }
                  }

                  /// Zone
                  else if (indexIs == 1) {
                    if (serviceCardList.isNotEmpty) {
                      if (formKey.currentState!.validate()) {
                        indexIs = 2;
                      }
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillZoneDetails));
                    }
                  }

                  /// Map
                  else if (indexIs == 2) {
                    if (formKey.currentState!.validate()) {
                      indexIs = 3;
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.fillProperData));
                    }
                  }

                  /// Guard
                  else if (indexIs == 3) {
                    if (addSpaceProvider.showSelectedGuardName.isNotEmpty) {
                      if (formKey.currentState!.validate()) {
                        addSpaceProvider.addSpaceApiCall(
                          addressController.text.toString(),
                          availableAllDaysController.toString(),
                          latController.toDouble(),
                          longController.toDouble(),
                          offlinePaymentMode.toString(),
                          parkingZone,
                          pricePerHourController.text.toString(),
                          titleController.text.toString(),
                          cityController.text.toString(),
                          // On passe directement le nom du Country sélectionné
                          _selectedCountry!.name,
                          descriptionController.text.toString(),
                          selectedFacilitiesList,
                          _completePhoneNumber, // numéro complet avec indicatif
                          postalCodeController.text.toString(),
                          stateController.text.toString(),
                          parkingOpenTimeController.text.toString(),
                          parkingCloseTimeController.text.toString(),
                          addSpaceProvider.showSelectedGuardId,
                          context,
                        );
                      } else {
                        CommonFunction.toastMessage(AppLocalizations.of(context)
                            .translate(AppString.fillProperData));
                      }
                    } else {
                      CommonFunction.toastMessage(AppLocalizations.of(context)
                          .translate(AppString.selectGuard));
                    }
                  }
                });
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.commonColorSkyBlue,
          minimumSize: Size(MediaQuery.of(context).size.width, 50),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        child: Text(
          indexIs == 0
              ? AppLocalizations.of(context).translate(AppString.nextBtn)
              : indexIs == 1
                  ? AppLocalizations.of(context).translate(AppString.nextBtn)
                  : indexIs == 2
                      ? AppLocalizations.of(context)
                          .translate(AppString.nextBtn)
                      : AppLocalizations.of(context)
                          .translate(AppString.addBtn),
          style: TextStyle(
              fontFamily: AppString.rubik,
              fontSize: 14.sp,
              color: AppColors.white),
        ),
      ),
    );
  }

  /// removeService Card
  void removeServiceCard(index) {
    setState(() {
      serviceCardList.remove(index);
    });
  }

  /// add service Card
  void addServiceCard() {
    setState(() {
      serviceCardList
          .add(WidgetCard(removeServiceCard, index: serviceCardList.length));
    });
  }

  /// facilitiesAlertDialog
  void facilitiesAlertDialog(BuildContext context) {
    facilitiesProvider = Provider.of(context, listen: false);

    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.okBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 12.sp),
      ),
      onPressed: () {
        setState(() {
          // Forcer le rebuild pour que checkBoxValue se mette à jour
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.cancelBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      titlePadding: const EdgeInsets.only(top: 10, left: 7, right: 7),
      title: Padding(
        padding: EdgeInsets.only(top: 1.h, bottom: 1.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).translate(AppString.facilities),
              style: TextStyle(fontSize: 18.sp),
            ),
            const Divider(
              color: AppColors.greyWithAlpha,
            )
          ],
        ),
      ),
      content: SizedBox(
        height: 40.h,
        width: 100.w,
        child: StatefulBuilder(
          builder: (context, myState) {
            return facilitiesProvider.facilitiesData.isEmpty
                ? Text(
                    AppLocalizations.of(context)
                        .translate(AppString.noDataFound),
                    style:
                        TextStyle(fontSize: 12.sp, fontFamily: AppString.rubik),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: facilitiesProvider.facilitiesData.length,
                    itemBuilder: (context, index) {
                      return CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(
                            facilitiesProvider.facilitiesData[index].title!),
                        value: facilitiesProvider.facilitiesData[index].isCheck,
                        onChanged: (value) {
                          myState(() {
                            facilitiesProvider.facilitiesData[index].isCheck =
                                value!;
                          });
                        },
                      );
                    },
                  );
          },
        ),
      ),
      contentPadding:
          const EdgeInsets.only(top: 20, left: 10, right: 5, bottom: 10),
      buttonPadding: EdgeInsets.zero,
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /// guardListAlertDialog
  void guardListAlertDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.okBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 12.sp),
      ),
      onPressed: () {
        setState(() {
          // Forcer le rebuild pour les guards
        });
        Navigator.pop(context);
      },
    );
    Widget cancelButton = TextButton(
      child: Text(
        AppLocalizations.of(context).translate(AppString.cancelBtn),
        style: TextStyle(
            color: AppColors.blue,
            fontFamily: AppString.rubik,
            fontSize: 13.sp),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    AlertDialog alert = AlertDialog(
      surfaceTintColor: AppColors.white,
      shadowColor: AppColors.white,
      backgroundColor: AppColors.white,
      titlePadding:
          EdgeInsets.only(top: 2.5.h, left: 7, right: 7, bottom: 1.5.h),
      title: Column(
        children: [
          Text(
            AppLocalizations.of(context).translate(AppString.guardList),
            style: TextStyle(fontSize: 15.sp, fontFamily: AppString.rubik),
          ),
          const Divider(
            color: AppColors.black54,
            thickness: 2,
          )
        ],
      ),
      content: SizedBox(
        height: 40.h,
        width: 100.w,
        child: StatefulBuilder(
          builder: (context, myState) {
            return SizedBox(
              height: 40.h,
              child: guardProvider.availableGuardData.isEmpty
                  ? Text(
                      AppLocalizations.of(context)
                          .translate(AppString.noDataFound),
                      style: TextStyle(
                          fontSize: 12.sp, fontFamily: AppString.rubik),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: guardProvider.availableGuardData.length,
                      itemBuilder: (context, index) {
                        return CheckboxListTile(
                          controlAffinity: ListTileControlAffinity.leading,
                          title: Text(guardProvider
                              .availableGuardData[index]!.name
                              .toString()),
                          value:
                              guardProvider.availableGuardData[index]!.isCheck,
                          onChanged: (value) {
                            myState(() {
                              guardProvider.availableGuardData[index]!.isCheck =
                                  value!;
                            });
                          },
                        );
                      },
                    ),
            );
          },
        ),
      ),
      contentPadding:
          EdgeInsets.only(top: 0.5.h, left: 10, right: 5, bottom: 10),
      buttonPadding: EdgeInsets.zero,
      actions: [
        cancelButton,
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class WidgetCard extends StatelessWidget {
  final int index;
  final Function(WidgetCard) removeServiceCard;

  WidgetCard(this.removeServiceCard, {super.key, required this.index});
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController spaceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 17.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                      ),
                      child: Text(
                        AppLocalizations.of(context)
                            .translate(AppString.spaceName),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 13.sp),
                      ),
                    ),
                    TextFormField(
                      controller: spaceNameController,
                      validator: RequiredValidator(
                              errorText: AppLocalizations.of(context)
                                  .translate(AppString.enterSpaceName))
                          .call,
                      decoration: InputDecoration(
                          hintText: AppLocalizations.of(context)
                              .translate(AppString.spaceName),
                          hintStyle: TextStyle(fontSize: 12.sp)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 17.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                        top: 2.h,
                      ),
                      child: Text(
                        AppLocalizations.of(context).translate(AppString.size),
                        style: TextStyle(
                            fontFamily: AppString.rubik, fontSize: 13.sp),
                      ),
                    ),
                    TextFormField(
                      controller: sizeController,
                      keyboardType: TextInputType.number,
                      validator: RequiredValidator(
                              errorText: AppLocalizations.of(context)
                                  .translate(AppString.enterSpaceSize))
                          .call,
                      decoration: InputDecoration(
                        suffixIcon: InkWell(
                          onTap: () {
                            removeServiceCard(this);
                          },
                          child: const Icon(
                            Icons.delete_outline,
                            color: AppColors.redColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
