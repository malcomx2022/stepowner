import 'package:flutter/cupertino.dart';
import 'package:stepowner/retrofit/base_model.dart';
import 'package:stepowner/retrofit/client_api.dart';
import 'package:stepowner/retrofit/error_class.dart';
import 'package:stepowner/retrofit/header.dart';
import 'package:stepowner/retrofit/models/order_scanner_model.dart';
import 'package:stepowner/retrofit/models/transaction_model.dart';
import 'package:stepowner/retrofit/server_error.dart';
import 'package:stepowner/utils/constant/loading.dart';

class TransactionProvider extends ChangeNotifier {
  bool loader = false;
  bool visible = false;
  String every = "day";

  DateTime? startTimeController;
  DateTime? endTimeController;

  TransactionModelData transactionData = TransactionModelData();
  List<UserDetails> searchTransactionData = [];
  String total = '';
  OrderScannerModelData bookingUserData = OrderScannerModelData(
      userId: 0,
      user: OrderScannerModelDataUser(),
      id: 0,
      spaceId: 0,
      updatedAt: "",
      createdAt: "",
      status: 0,
      ownerId: 0,
      discount: 0,
      arrivingTime: "",
      leavingTime: "",
      orderNo: "",
      paymentStatus: 0,
      paymentToken: "",
      paymentType: "",
      slotId: 0,
      totalAmount: 0,
      vehicle: OrderScannerModelDataVehicle(),
      vehicleId: 0);

  TextEditingController transactionSearchController = TextEditingController();

  /// transaction api call
  Future<BaseModel<TransactionModel>> transactionApiCall(
      String id, every) async {
    TransactionModel response;
    if (id != '') {
      try {
        Loading.showLoader();
        response = await ClientApi(RestClient().dioData())
            .transactionHistory(id, every);
        if (response.success == true) {
          Loading.hideDialog();
          if (response.data!.dataOfData!.isNotEmpty) {
            transactionData = response.data!;
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
    return CommonFunction.toastMessage("Please Select Space");
  }

  /// custom transaction api call
  Future<BaseModel<TransactionModel>> customTransactionApiCall(
      String startDate, String endDate) async {
    TransactionModel response;
    Map<String, String> body = {"start_date": startDate, "end_date": endDate};

    try {
      Loading.showLoader();
      response =
          await ClientApi(RestClient().dioData()).customTransactionCall(body);
      if (response.success == true) {
        Loading.hideDialog();
        if (response.data!.dataOfData!.isNotEmpty) {
          transactionData = response.data!;
        } else {
          Loading.hideDialog();
          CommonFunction.toastMessage("No Data Found");
        }
      }
      notifyListeners();
    } catch (error) {
      Loading.hideDialog();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  /// oder scan api call
  Future<BaseModel<OrderScannerModel>> scanOderApiCall(String oder) async {
    OrderScannerModel response;
    try {
      visible = false;
      loader = true;
      Loading.showLoader();
      notifyListeners();
      response = await ClientApi(RestClient().dioData()).scanOrderCall(oder);
      loader = false;
      notifyListeners();
      if (response.success == true) {
        if (response.data != null) {
          bookingUserData = response.data!;
          CommonFunction.toastMessage(response.msg.toString());
          visible = true;
          notifyListeners();
        } else {
          CommonFunction.toastMessage("No Data Found");
        }
      }
      Loading.hideDialog();
      notifyListeners();
    } catch (error) {
      visible = false;
      loader = false;
      Loading.hideDialog();
      notifyListeners();
      return BaseModel()..setException(ServerError.withError(error: error));
    }
    return BaseModel()..data = response;
  }

  notify() {
    notifyListeners();
  }

  onSearchTextChanged(String text) async {
    searchTransactionData.clear();
    if (transactionSearchController.text.isNotEmpty) {
      for (int i = 0; i < transactionData.dataOfData!.length; i++) {
        TransactionModelDataDataOfData? data = transactionData.dataOfData![i];
        if ((data?.user?.name ?? "").isNotEmpty) {
          if ((data?.user?.name ?? "")
              .toLowerCase()
              .contains(text.toLowerCase())) {
            searchTransactionData.add(UserDetails(
                name: (data?.user?.name ?? ""),
                total: double.parse(data?.total.toString() ?? "")));
            notifyListeners();
          }
        }
      }
    }
  }
}
