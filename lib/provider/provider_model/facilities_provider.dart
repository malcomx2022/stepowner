import 'package:flutter/foundation.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/facility_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';

class FacilitiesProvider extends ChangeNotifier {
  List<Data> facilitiesData = [];

  /// get facilities
  Future<BaseModel<FacilityModel>> getFacilities() async {
    FacilityModel response;

    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).getFacilities();
      Loading.hideDialog();
      if (response.success == true) {
        if (response.data!.isNotEmpty) {
          facilitiesData = response.data!;
        }
        if (kDebugMode) {
          print(facilitiesData);
        }
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

  static onError(error) {
    if (kDebugMode) {
      print('the error is ${error.detail}');
    }
    return {'status': false, 'message': 'Unsuccessful Request', 'data': error};
  }
}
