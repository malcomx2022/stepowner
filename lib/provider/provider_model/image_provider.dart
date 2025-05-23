import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/delete_image_model.dart';
import 'package:stepowner/retrofit/models/get_image_space.dart';
import 'package:stepowner/retrofit/models/image_upload_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/const_preference/preference.dart';
import 'package:stepowner/utils/const_preference/shared_preference_utils.dart';
import 'package:stepowner/utils/constant/loading.dart';

class ImagesProvider extends ChangeNotifier {
  bool loader = false;

  /// store imageAllData
  List<ImageData> imageSpaceData = [];

  List<String> allImages = [];

  /// Single image show
  File pickUploadImage = File("");

  /// get image api call
  Future<BaseModel<GetImageSpace>> getSpaceImage(String id) async {
    GetImageSpace response;
    if (id.isNotEmpty) {
      try {
        Loading.showLoader();
        response = await ClientApi(RestClient().dioData()).getImageSpace(id);
        notifyListeners();
        if (response.success == true) {
          imageSpaceData = response.data!;
        }
        notifyListeners();
        Loading.hideDialog();
      } catch (error) {
        Loading.hideDialog();
        return BaseModel()..setException(ServerError.withError(error: error));
      }
      return BaseModel()..data = response;
    }
    return CommonFunction.toastMessage("Please Select Space");
  }

  /// image Upload api call
  Future<BaseModel<ImageUploadModel>> uploadImage(image, String spaceId) async {
    ImageUploadModel response;
    Map<String, dynamic> body = {"images": image, "space_id": spaceId};
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).uploadImage(body);
      if (response.success == true) {
        CommonFunction.toastMessage(response.msg!);
        getSpaceImage(
            PreferenceManager.getString(SharePreferenceKey.spaceIdKey));
        allImages.clear();
        pickUploadImage = File('');
        if (kDebugMode) {
          print(pickUploadImage);
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

  /// delete image api call
  Future<BaseModel<DeleteImageModel>> deleteImage(String id) async {
    DeleteImageModel response;
    try {
      Loading.showLoader();
      response = await ClientApi(RestClient().dioData()).imageDelete(id);
      if (response.success == true) {
        getSpaceImage(
            PreferenceManager.getString(SharePreferenceKey.spaceIdKey));
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

  /// convertBase64
  String convertBase64(File selectedFile) {
    List<int> imageBytes = selectedFile.readAsBytesSync();
    return base64Encode(imageBytes);
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
