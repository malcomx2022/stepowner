import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/common_model.dart';
import 'package:stepowner/retrofit/models/get_all_guard.dart';
import 'package:stepowner/retrofit/models/get_available_guard.dart';
import 'package:stepowner/retrofit/models/post_guard_add.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';

class GuardProvider extends ChangeNotifier {
  /// search functionality variable
  TextEditingController searchController = TextEditingController();
  List<AllGuardDataList> searchAllGuardList = [];

  /// all GuardData List variable
  List<AllGuardDataList> allGuardList = [];

  /// available guard variable
  List<GetAvailableGuardData?> availableGuardData = [];

  /// get all guard
  Future<BaseModel<GetAllGuard>> getGuardApiCall() async {
    GetAllGuard response;
    try {
      notifyListeners();
      Loading.showLoader();
      allGuardList.clear();
      response = await ClientApi(RestClient().dioData()).getAllGuardData();
      if (response.success == true) {
        if (response.data!.isNotEmpty) {
          allGuardList = response.data!.reversed.toList();
        }
        if (kDebugMode) {
          print(allGuardList);
        }

        notifyListeners();
        Loading.hideDialog();
      } else {
        CommonFunction.toastMessage(response.msg!);
        notifyListeners();
        Loading.hideDialog();
      }
      notifyListeners();
    } catch (error) {
      notifyListeners();
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// guard add api call
  Future<BaseModel<PostGuardAdd>> addGuard(
      String email, String name, String password, String phone, context) async {
    PostGuardAdd response;
    Map<String, String> body = {
      "email": email,
      "name": name,
      "password": password,
      "phone_no": phone
    };

    try {
      notifyListeners();
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).guardAdd(body);
      if (response.success == true) {
        CommonFunction.toastMessage(response.msg!);
        getGuardApiCall();
        availableGuardApiCall();
        Navigator.pop(context);
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      notifyListeners();
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// guard Update api call
  Future<BaseModel<CommonModel>> updateGuard(
      guardId, spaceId, email, name, phone, status, context) async {
    CommonModel response;
    Map<String, dynamic> body = {
      "guard_id": guardId,
      "space_id": spaceId,
      "name": name,
      "email": email,
      "phone_no": phone,
      "status": status
    };

    try {
      notifyListeners();
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).guardUpdate(body);
      if (response.success == true) {
        CommonFunction.toastMessage(response.message!);
        getGuardApiCall();
        availableGuardApiCall();
        Navigator.pop(context);
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      notifyListeners();
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// get Available guard
  Future<BaseModel<GetAvailableGuard>> availableGuardApiCall() async {
    GetAvailableGuard response;
    try {
      Loading.showLoader();
      availableGuardData.clear();
      response = await ClientApi(RestClient().dioData()).availableGuard();
      if (response.success == true) {
        if (response.data!.isNotEmpty) {
          availableGuardData = response.data!.reversed.toList();
        }
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  Location currentLocation = Location();
  LatLng? liveLocation;
  getLiveLocation() {
    currentLocation.getLocation().then((value) {
      liveLocation = LatLng(value.latitude!, value.longitude!);
      if (kDebugMode) {
        print("live Location $liveLocation");
      }
      notifyListeners();
    });
  }

  notify() {
    notifyListeners();
  }

  static onError(error) {
    if (kDebugMode) {
      print('the error is ${error.detail}');
    }
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
