class OrderScannerModelDataVehicle {
  int? id;
  String? model;
  String? vehicleNo;

  OrderScannerModelDataVehicle({
    this.id,
    this.model,
    this.vehicleNo,
  });

  OrderScannerModelDataVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    model = json['model']?.toString();
    vehicleNo = json['vehicle_no']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['model'] = model;
    data['vehicle_no'] = vehicleNo;
    return data;
  }
}

class OrderScannerModelDataUser {
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

  OrderScannerModelDataUser({
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

  OrderScannerModelDataUser.fromJson(Map<String, dynamic> json) {
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

class OrderScannerModelData {
  int? id;
  int? ownerId;
  int? spaceId;
  int? userId;
  int? vehicleId;
  int? slotId;
  String? paymentType;
  String? paymentToken;
  int? paymentStatus;
  int? status;
  String? arrivingTime;
  String? leavingTime;
  int? totalAmount;
  String? orderNo;
  int? discount;
  String? createdAt;
  String? updatedAt;
  OrderScannerModelDataUser? user;
  OrderScannerModelDataVehicle? vehicle;

  OrderScannerModelData({
    this.id,
    this.ownerId,
    this.spaceId,
    this.userId,
    this.vehicleId,
    this.slotId,
    this.paymentType,
    this.paymentToken,
    this.paymentStatus,
    this.status,
    this.arrivingTime,
    this.leavingTime,
    this.totalAmount,
    this.orderNo,
    this.discount,
    this.createdAt,
    this.updatedAt,
    this.user,
    this.vehicle,
  });

  OrderScannerModelData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    ownerId = json['owner_id']?.toInt();
    spaceId = json['space_id']?.toInt();
    userId = json['user_id']?.toInt();
    vehicleId = json['vehicle_id']?.toInt();
    slotId = json['slot_id']?.toInt();
    paymentType = json['payment_type']?.toString();
    paymentToken = json['payment_token']?.toString();
    paymentStatus = json['payment_status']?.toInt();
    status = json['status']?.toInt();
    arrivingTime = json['arriving_time']?.toString();
    leavingTime = json['leaving_time']?.toString();
    totalAmount = json['total_amount']?.toInt();
    orderNo = json['order_no']?.toString();
    discount = json['discount']?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = (json['user'] != null) ? OrderScannerModelDataUser.fromJson(json['user']) : null;
    vehicle = (json['vehicle'] != null) ? OrderScannerModelDataVehicle.fromJson(json['vehicle']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['space_id'] = spaceId;
    data['user_id'] = userId;
    data['vehicle_id'] = vehicleId;
    data['slot_id'] = slotId;
    data['payment_type'] = paymentType;
    data['payment_token'] = paymentToken;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['arriving_time'] = arrivingTime;
    data['leaving_time'] = leavingTime;
    data['total_amount'] = totalAmount;
    data['order_no'] = orderNo;
    data['discount'] = discount;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    return data;
  }
}

class OrderScannerModel {
  String? msg;
  OrderScannerModelData? data;
  bool? success;

  OrderScannerModel({
    this.msg,
    this.data,
    this.success,
  });

  OrderScannerModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = (json['data'] != null) ? OrderScannerModelData.fromJson(json['data']) : null;
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
