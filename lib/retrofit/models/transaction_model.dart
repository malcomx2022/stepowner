class UserDetails {
  String name;
  double total;

  UserDetails({required this.name, required this.total});
}

class TransactionModelDataDataOfDataUser {
  int? id;
  String? name;
  String? email;
  String? phoneNo;
  String? otp;
  int? verified;
  int? status;
  String? image;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? imageUri;

  TransactionModelDataDataOfDataUser({
    this.id,
    this.name,
    this.email,
    this.phoneNo,
    this.otp,
    this.verified,
    this.status,
    this.image,
    this.deviceToken,
    this.createdAt,
    this.updatedAt,
    this.imageUri,
  });

  TransactionModelDataDataOfDataUser.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phoneNo = json['phone_no']?.toString();
    otp = json['OTP']?.toString();
    verified = json['verified']?.toInt();
    status = json['status']?.toInt();
    image = json['image']?.toString();
    deviceToken = json['device_token']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUri = json['imageUri']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['OTP'] = otp;
    data['verified'] = verified;
    data['status'] = status;
    data['image'] = image;
    data['device_token'] = deviceToken;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['imageUri'] = imageUri;
    return data;
  }
}

class TransactionModelDataDataOfData {
  TransactionModelDataDataOfDataUser? user;
  int? userId;
  int? total;

  TransactionModelDataDataOfData({
    this.user,
    this.userId,
    this.total,
  });

  TransactionModelDataDataOfData.fromJson(Map<String, dynamic> json) {
    user = (json['user'] != null) ? TransactionModelDataDataOfDataUser.fromJson(json['user']) : null;
    userId = json['user_id']?.toInt();
    total = json['total']?.toInt();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['user_id'] = userId;
    data['total'] = total;
    return data;
  }
}

class TransactionModelData {
  double? grandTotal;
  List<TransactionModelDataDataOfData?>? dataOfData;

  TransactionModelData({
    this.grandTotal,
    this.dataOfData,
  });

  TransactionModelData.fromJson(Map<String, dynamic> json) {
    grandTotal = json['grandTotal']?.toDouble();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <TransactionModelDataDataOfData>[];
      v.forEach((v) {
        arr0.add(TransactionModelDataDataOfData.fromJson(v));
      });
      dataOfData = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['grandTotal'] = grandTotal;
    if (dataOfData != null) {
      final v = dataOfData;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['data'] = arr0;
    }
    return data;
  }
}

class TransactionModel {
  String? msg;
  TransactionModelData? data;
  bool? success;

  TransactionModel({
    this.msg,
    this.data,
    this.success,
  });

  TransactionModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = (json['data'] != null) ? TransactionModelData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['data'] = this.data!.toJson();
    data['success'] = success;
    return data;
  }
}
