class GetSpaceIdDataBookingVehicle {
  String? id;
  String? model;
  String? vehicleNo;

  GetSpaceIdDataBookingVehicle({
    this.id,
    this.model,
    this.vehicleNo,
  });

  GetSpaceIdDataBookingVehicle.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
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

class GetSpaceIdDataBookingUser {
  String? id;
  String? name;
  String? email;
  String? phoneNo;
  String? otp;
  String? verified;
  String? status;
  String? image;
  String? deviceToken;
  String? createdAt;
  String? updatedAt;
  String? imageUri;

  GetSpaceIdDataBookingUser({
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

  GetSpaceIdDataBookingUser.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phoneNo = json['phone_no']?.toString();
    otp = json['OTP']?.toString();
    verified = json['verified']?.toString();
    status = json['status']?.toString();
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

class GetSpaceIdDataBooking {
  String? id;
  String? ownerId;
  String? spaceId;
  String? userId;
  String? vehicleId;
  String? slotId;
  String? paymentType;
  String? paymentToken;
  String? paymentStatus;
  String? status;
  String? arrivingTime;
  String? leavingTime;
  String? totalAmount;
  String? orderNo;
  String? discount;
  String? createdAt;
  String? updatedAt;
  GetSpaceIdDataBookingUser? user;
  GetSpaceIdDataBookingVehicle? vehicle;

  GetSpaceIdDataBooking({
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

  GetSpaceIdDataBooking.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ownerId = json['owner_id']?.toString();
    spaceId = json['space_id']?.toString();
    userId = json['user_id']?.toString();
    vehicleId = json['vehicle_id']?.toString();
    slotId = json['slot_id']?.toString();
    paymentType = json['payment_type']?.toString();
    paymentToken = json['payment_token']?.toString();
    paymentStatus = json['payment_status']?.toString();
    status = json['status']?.toString();
    arrivingTime = json['arriving_time']?.toString();
    leavingTime = json['leaving_time']?.toString();
    totalAmount = json['total_amount']?.toString();
    orderNo = json['order_no']?.toString();
    discount = json['discount']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    user = (json['user'] != null) ? GetSpaceIdDataBookingUser.fromJson(json['user']) : null;
    vehicle = (json['vehicle'] != null) ? GetSpaceIdDataBookingVehicle.fromJson(json['vehicle']) : null;
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

class GetSpaceIdDataSpaceZonesSlots {
  String? id;
  String? zoneId;
  String? spaceId;
  String? name;
  String? position;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  GetSpaceIdDataSpaceZonesSlots({
    this.id,
    this.zoneId,
    this.spaceId,
    this.name,
    this.position,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  GetSpaceIdDataSpaceZonesSlots.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    zoneId = json['zone_id']?.toString();
    spaceId = json['space_id']?.toString();
    name = json['name']?.toString();
    position = json['position']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['zone_id'] = zoneId;
    data['space_id'] = spaceId;
    data['name'] = name;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class GetSpaceIdDataSpaceZones {
  String? id;
  String? spaceId;
  String? ownerId;
  String? name;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<GetSpaceIdDataSpaceZonesSlots?>? slots;

  GetSpaceIdDataSpaceZones({
    this.id,
    this.spaceId,
    this.ownerId,
    this.name,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.slots,
  });

  GetSpaceIdDataSpaceZones.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    spaceId = json['space_id']?.toString();
    ownerId = json['owner_id']?.toString();
    name = json['name']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    deletedAt = json['deleted_at']?.toString();
    if (json['slots'] != null) {
      final v = json['slots'];
      final arr0 = <GetSpaceIdDataSpaceZonesSlots>[];
      v.forEach((v) {
        arr0.add(GetSpaceIdDataSpaceZonesSlots.fromJson(v));
      });
      slots = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['space_id'] = spaceId;
    data['owner_id'] = ownerId;
    data['name'] = name;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    if (slots != null) {
      final v = slots;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['slots'] = arr0;
    }
    return data;
  }
}

class GetSpaceIdDataSpaceGuards {
  String? id;
  String? ownerId;
  String? spaceId;
  String? name;
  String? email;
  String? phoneNo;
  String? image;
  String? password;
  String? status;
  String? createdAt;
  String? updatedAt;
  String? imageUri;

  GetSpaceIdDataSpaceGuards({
    this.id,
    this.ownerId,
    this.spaceId,
    this.name,
    this.email,
    this.phoneNo,
    this.image,
    this.password,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUri,
  });

  GetSpaceIdDataSpaceGuards.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ownerId = json['owner_id']?.toString();
    spaceId = json['space_id']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phoneNo = json['phone_no']?.toString();
    image = json['image']?.toString();
    password = json['password']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUri = json['imageUri']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['space_id'] = spaceId;
    data['name'] = name;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['image'] = image;
    data['password'] = password;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['imageUri'] = imageUri;
    return data;
  }
}

class GetSpaceIdDataSpaceFacilitiesData {
  String? id;
  String? title;
  String? image;
  String? imageUri;

  GetSpaceIdDataSpaceFacilitiesData({
    this.id,
    this.title,
    this.image,
    this.imageUri,
  });

  GetSpaceIdDataSpaceFacilitiesData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    title = json['title']?.toString();
    image = json['image']?.toString();
    imageUri = json['imageUri']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['image'] = image;
    data['imageUri'] = imageUri;
    return data;
  }
}

class GetSpaceIdDataSpace {
  String? id;
  String? ownerId;
  String? vehicleTypes;
  String? title;
  String? description;
  List<String?>? facilities;
  String? address;
  String? lat;
  String? lng;
  String? priceParHour;
  String? phoneNumber;
  String? openTime;
  String? closeTime;
  String? availableAllDay;
  String? offlinePayment;
  String? verified;
  String? status;
  String? createdAt;
  String? updatedAt;
  List<GetSpaceIdDataSpaceFacilitiesData?>? facilitiesData;
  List<String?>? vehicleTypeData;
  List<GetSpaceIdDataSpaceGuards?>? guards;
  List<GetSpaceIdDataSpaceZones?>? zones;

  GetSpaceIdDataSpace({
    this.id,
    this.ownerId,
    this.vehicleTypes,
    this.title,
    this.description,
    this.facilities,
    this.address,
    this.lat,
    this.lng,
    this.priceParHour,
    this.phoneNumber,
    this.openTime,
    this.closeTime,
    this.availableAllDay,
    this.offlinePayment,
    this.verified,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.facilitiesData,
    this.vehicleTypeData,
    this.guards,
    this.zones,
  });

  GetSpaceIdDataSpace.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ownerId = json['owner_id']?.toString();
    vehicleTypes = json['vehicle_types']?.toString();
    title = json['title']?.toString();
    description = json['description']?.toString();
    if (json['facilities'] != null) {
      final v = json['facilities'];
      final arr0 = <String>[];
      v.forEach((v) {
        arr0.add(v.toString());
      });
      facilities = arr0;
    }
    address = json['address']?.toString();
    lat = json['lat']?.toString();
    lng = json['lng']?.toString();
    priceParHour = json['price_par_hour']?.toString();
    phoneNumber = json['phone_number']?.toString();
    openTime = json['open_time']?.toString();
    closeTime = json['close_time']?.toString();
    availableAllDay = json['available_all_day']?.toString();
    offlinePayment = json['offline_payment']?.toString();
    verified = json['verified']?.toString();
    status = json['status']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    if (json['facilitiesData'] != null) {
      final v = json['facilitiesData'];
      final arr0 = <GetSpaceIdDataSpaceFacilitiesData>[];
      v.forEach((v) {
        arr0.add(GetSpaceIdDataSpaceFacilitiesData.fromJson(v));
      });
      facilitiesData = arr0;
    }

    if (json['guards'] != null) {
      final v = json['guards'];
      final arr0 = <GetSpaceIdDataSpaceGuards>[];
      v.forEach((v) {
        arr0.add(GetSpaceIdDataSpaceGuards.fromJson(v));
      });
      guards = arr0;
    }
    if (json['zones'] != null) {
      final v = json['zones'];
      final arr0 = <GetSpaceIdDataSpaceZones>[];
      v.forEach((v) {
        arr0.add(GetSpaceIdDataSpaceZones.fromJson(v));
      });
      zones = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['vehicle_types'] = vehicleTypes;
    data['title'] = title;
    data['description'] = description;
    if (facilities != null) {
      final v = facilities;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v);
      }
      data['facilities'] = arr0;
    }
    data['address'] = address;
    data['lat'] = lat;
    data['lng'] = lng;
    data['price_par_hour'] = priceParHour;
    data['phone_number'] = phoneNumber;
    data['open_time'] = openTime;
    data['close_time'] = closeTime;
    data['available_all_day'] = availableAllDay;
    data['offline_payment'] = offlinePayment;
    data['verified'] = verified;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (facilitiesData != null) {
      final v = facilitiesData;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['facilitiesData'] = arr0;
    }

    if (guards != null) {
      final v = guards;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['guards'] = arr0;
    }
    if (zones != null) {
      final v = zones;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['zones'] = arr0;
    }
    return data;
  }
}

class GetSpaceIdData {
  GetSpaceIdDataSpace? space;
  List<GetSpaceIdDataBooking?>? booking;

  GetSpaceIdData({
    this.space,
    this.booking,
  });

  GetSpaceIdData.fromJson(Map<String, dynamic> json) {
    space = (json['space'] != null) ? GetSpaceIdDataSpace.fromJson(json['space']) : null;
    if (json['booking'] != null) {
      final v = json['booking'];
      final arr0 = <GetSpaceIdDataBooking>[];
      v.forEach((v) {
        arr0.add(GetSpaceIdDataBooking.fromJson(v));
      });
      booking = arr0;
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (space != null) {
      data['space'] = space!.toJson();
    }
    if (booking != null) {
      final v = booking;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['booking'] = arr0;
    }
    return data;
  }
}

class GetSpaceId {
  String? msg;
  GetSpaceIdData? data;
  bool? success;

  GetSpaceId({
    this.msg,
    this.data,
    this.success,
  });

  GetSpaceId.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = (json['data'] != null) ? GetSpaceIdData.fromJson(json['data']) : null;
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
