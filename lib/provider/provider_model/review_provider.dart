import 'package:flutter/foundation.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/review_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';
import '../../retrofit/base_model.dart';
import '../../retrofit/client_api.dart';

class ReviewProvider extends ChangeNotifier {
  /// search review variable
  List<Data> searchReviewAllData = [];

  /// save data variable
  List<Data> reviewAllData = [];

  Future<BaseModel<ReviewModel>> reviewData() async {
    ReviewModel response;
    try {
      Loading.showLoader();
      reviewAllData.clear();
      response = await ClientApi(RestClient().dioData()).getAllReview();
      if (response.success == true) {
        if (response.data!.isNotEmpty) {
          reviewAllData = response.data!;
        }
        if (kDebugMode) {
          print(reviewAllData);
        }
      }
      notifyListeners();
      Loading.hideDialog();
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

  onSearchTextChanged(String text) async {
    searchReviewAllData.clear();
    for (var element in reviewAllData) {
      if (element.space!.title
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase()) ||
          element.user!.name
              .toString()
              .toLowerCase()
              .contains(text.toLowerCase())) searchReviewAllData.add(element);
      for (int i = 0; i < searchReviewAllData.length; i++) {
        if (kDebugMode) {
          print(searchReviewAllData[i].space!.title);
        }
      }
      notifyListeners();
    }
  }
}
