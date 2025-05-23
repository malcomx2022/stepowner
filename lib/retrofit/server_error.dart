// ignore: depend_on_referenced_packages
import 'package:dio/dio.dart' hide Headers;
import 'error_class.dart';

class ServerError implements Exception {
  int? _errorCode;
  final String _errorMessage = "";

  ServerError.withError({error}) {
    _handleError(error);
  }

  getErrorCode() {
    return _errorCode;
  }

  getErrorMessage() {
    return _errorMessage;
  }

  _handleError(DioException error) async {
    if (error.response!.statusCode == 403) {
      return CommonFunction.toastMessage(error.response!.data['message'].toString());
    } 
    if (error.response!.data['msg'] != null) {
      CommonFunction.toastMessage(error.response!.data['msg'].toString());
    }
    else if (error.response!.data['errors']['message'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['name'][0]);
      return;
    }  else if (error.response!.data['errors']['phone'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['phone'][0]);
      return;
    } else if (error.response!.data['errors']['phone'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['phone'][0]);
      return;
    } else if (error.response!.data['errors']['email'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['email'][0]);
      return;
    } else if (error.response!.data['errors']['password'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['password'][0]);
      return;
    } else if (error.response!.data['errors']['vendor_own_driver'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['vendor_own_driver'][0]);
      return;
    } else if (error.response!.data['errors']['phone_code'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['phone_code'][0]);
      return;
    } else if (error.response!.data['errors']['phone_no'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['phone_no'][0]);
      return;
    } else if (error.response!.data['errors']['title'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['title'][0]);
      return;
    } else if (error.response!.data['errors']['address'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['address'][0]);
      return;
    } else if (error.response!.data['errors']['price_par_hour'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['price_par_hour'][0]);
      return;
    } else if (error.response!.data['errors']['available_all_day'] != null) {
      CommonFunction.toastMessage(error.response!.data['errors']['available_all_day'][0]);
      return;
    } else {
      CommonFunction.toastMessage(error.response!.data['message'].toString());
    }
    return _errorMessage;
  }
}
