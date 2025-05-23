import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stepowner/custom_router/route_names.dart';
import 'package:stepowner/provider/provider_model/guard_provider.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/get_all_space_model.dart';
import 'package:stepowner/retrofit/models/parking_space_added_model.dart';
import 'package:stepowner/retrofit/models/space_id_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';
import '../../retrofit/models/space_id_live_model.dart';

class SpaceProvider extends ChangeNotifier {
  TextEditingController homeSearchController = TextEditingController();

  String dropdownValue = 'All';
  List<String> showSelectedGuardName = [];
  List<String> showSelectedGuardId = [];

  /// good view screen variable
  LatLng? lastMapPosition;
  final Set<Marker> markers = {};
  bool mapViewLoader = false;
  GuardProvider guardProvider = GuardProvider();

  /// space id live api data store variable
  List<LiveSpaceData> spaceIdLivedata = [];

  /// get all space variable
  List<AllSpaceData> getAllSpaces = [];

  /// get spaceId Data Variable
  List<GetSpaceIdDataBooking?>? searchSpaceIdDataBooking = [];

  List<GetSpaceIdDataBooking?>? spaceIdDataBooking = [];

  List<GetSpaceIdDataBooking?>? get paceIdDataBooking => spaceIdDataBooking;

  set spaceIdDataBookingSet(List<GetSpaceIdDataBooking?>? value) {
    spaceIdDataBooking = value;
  }

  SpaceProvider() {
    clearData();
    if (kDebugMode) {
      print('space provider calling');
    }
  }

  GetSpaceIdDataSpace _getSpaceIdDataS11 = GetSpaceIdDataSpace();

  // ignore: unnecessary_getters_setters
  GetSpaceIdDataSpace get getSpaceIdDataSpace => _getSpaceIdDataS11;

  set getSpaceIdDataSpace(GetSpaceIdDataSpace value) {
    _getSpaceIdDataS11 = value;
  }

  ///get all space
  Future<BaseModel<GetAllSpaceModel>> getAllSpacesApiCall() async {
    GetAllSpaceModel response;
    try {
      Loading.showLoader();
      lastMapPosition = null;
      mapViewLoader = true;
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).getSpaces();
      if (response.success == true) {
        if (response.data!.isNotEmpty) {
          getAllSpaces = response.data!.reversed.toList();
          _onAddMarkerButtonPresses();
          notifyListeners();
        }
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      mapViewLoader = false;
      Loading.hideDialog();
      notifyListeners();
      if (kDebugMode) {
        print("calling error home page get all space $error");
      }
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  double? latController;
  double? longController;

  _onAddMarkerButtonPresses() {
    for (int i = 0; i < getAllSpaces.length; i++) {
      lastMapPosition = LatLng(
          getAllSpaces[i].lat!.toDouble(), getAllSpaces[i].lng!.toDouble());
      if (lastMapPosition != null) {
        markers.add(Marker(
            draggable: true,
            markerId: MarkerId(lastMapPosition.toString()),
            position: lastMapPosition!,
            icon: BitmapDescriptor.defaultMarker,
            onDragEnd: ((newPosition) {
              latController = newPosition.latitude;
              longController = newPosition.longitude;
              if (kDebugMode) {
                print(longController);
                print(latController);
              }
            })));
      }
    }
    mapViewLoader = false;
    Loading.hideDialog();
  }

  /// get space Id live api (live Parking view)
  Future<BaseModel<SpaceIdLiveModel>> getSpaceIdLiveApiCall(String id) async {
    SpaceIdLiveModel response;
    try {
      Loading.showLoader();
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).getSpaceIdLive(id);
      if (response.success == true) {
        spaceIdLivedata = response.data!;
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// get SpaceId Data
  Future<BaseModel<GetSpaceId>> getSpaceIdData(String id) async {
    GetSpaceId response;
    try {
      Loading.showLoader();
      getSpaceIdDataSpace = GetSpaceIdDataSpace();
      spaceIdDataBooking?.clear();
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).spaceIDData(id);
      if (response.success == true) {
        _getSpaceIdDataS11 = response.data!.space!;
        spaceIdDataBooking = response.data!.booking;
        if (kDebugMode) {
          print(_getSpaceIdDataS11);
        }
        notifyListeners();
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// add Space
  Future<BaseModel<ParkingSpaceAddedModel>> addSpaceApiCall(
      String address,
      String availableAllDay,
      double lat,
      double long,
      String offlinePayment,
      parkingZone,
      String pricePerHour,
      String title,
      String city,
      String country,
      String description,
      List facilities,
      String phoneNo,
      String postalCode,
      String state,
      String openTime,
      String closeTime,
      List spaceId,
      context) async {
    ParkingSpaceAddedModel response;

    Map<String, dynamic> body = {
      "address": address,
      "available_all_day": availableAllDay,
      "lat": lat,
      "lng": long,
      "offline_payment": offlinePayment,
      "parkingZone": parkingZone,
      "price_par_hour": pricePerHour,
      "title": title,
      "city": city,
      "country": country,
      "description": description,
      "facilities": facilities,
      "phone_number": phoneNo,
      "postal": postalCode,
      "state": state,
      "start_time": openTime,
      "end_time": closeTime,
      "guardList": spaceId,
    };

    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).spaceAdded(body);
      if (response.success == true) {
        getAllSpacesApiCall();
        showSelectedGuardName.clear();
        showSelectedGuardId.clear();
        notifyListeners();
        Navigator.pushNamedAndRemoveUntil(
          context,
          RouteName.godView,
          (route) => false,
        );
        guardProvider.availableGuardApiCall();
        CommonFunction.toastMessage(response.msg!);
        Loading.hideDialog();
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  notify() {
    notifyListeners();
  }

  clearData() {
    spaceIdLivedata.clear();
    spaceIdDataBooking?.clear();
    _getSpaceIdDataS11 = GetSpaceIdDataSpace(
        address: "",
        description: "",
        id: "",
        createdAt: "",
        ownerId: "0",
        updatedAt: "",
        verified: "",
        vehicleTypes: "",
        title: "",
        status: "",
        priceParHour: "",
        phoneNumber: "",
        openTime: "",
        offlinePayment: "",
        lng: "",
        lat: "",
        closeTime: "",
        availableAllDay: "",
        guards: [],
        facilities: [],
        facilitiesData: [],
        vehicleTypeData: [],
        zones: []);
    getAllSpaces.clear();
    searchSpaceIdDataBooking?.clear();
  }

  static onError(error) {
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }

  onSearchTextChanged(String text) async {
    searchSpaceIdDataBooking?.clear();
    if (homeSearchController.text.isNotEmpty) {
      for (int i = 0; i < spaceIdDataBooking!.length; i++) {
        GetSpaceIdDataBooking? data = spaceIdDataBooking![i];
        if (data!.orderNo!
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ||
            data.user!.name
                .toString()
                .toLowerCase()
                .contains(text.toLowerCase()))
          searchSpaceIdDataBooking!.add(data);
      }
      notifyListeners();
    }
  }
}
