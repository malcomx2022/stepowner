class SpaceIdLiveModel {
  SpaceIdLiveModel({
    dynamic msg,
    List<LiveSpaceData>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  SpaceIdLiveModel.fromJson(dynamic json) {
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(LiveSpaceData.fromJson(v));
      });
    }
    _success = json['success'];
  }

  dynamic _msg;
  List<LiveSpaceData>? _data;
  bool? _success;

  SpaceIdLiveModel copyWith({
    dynamic msg,
    List<LiveSpaceData>? data,
    bool? success,
  }) =>
      SpaceIdLiveModel(
        msg: msg ?? _msg,
        data: data ?? _data,
        success: success ?? _success,
      );

  dynamic get msg => _msg;

  List<LiveSpaceData>? get data => _data;

  bool? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    map['success'] = _success;
    return map;
  }
}
class LiveSpaceData {
  LiveSpaceData({
    int? id,
    int? spaceId,
    int? ownerId,
    String? name,
    int? status,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Slots>? slots,
  }) {
    _id = id;
    _spaceId = spaceId;
    _ownerId = ownerId;
    _name = name;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _slots = slots;
  }

  LiveSpaceData.fromJson(dynamic json) {
    _id = json['id'];
    _spaceId = json['space_id'];
    _ownerId = json['owner_id'];
    _name = json['name'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    if (json['slots'] != null) {
      _slots = [];
      json['slots'].forEach((v) {
        _slots?.add(Slots.fromJson(v));
      });
    }
  }

  int? _id;
  int? _spaceId;
  int? _ownerId;
  String? _name;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  List<Slots>? _slots;

  LiveSpaceData copyWith({
    int? id,
    int? spaceId,
    int? ownerId,
    String? name,
    int? status,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    List<Slots>? slots,
  }) =>
      LiveSpaceData(
        id: id ?? _id,
        spaceId: spaceId ?? _spaceId,
        ownerId: ownerId ?? _ownerId,
        name: name ?? _name,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        slots: slots ?? _slots,
      );

  int? get id => _id;

  int? get spaceId => _spaceId;

  int? get ownerId => _ownerId;

  String? get name => _name;

  int? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  dynamic get deletedAt => _deletedAt;

  List<Slots>? get slots => _slots;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['space_id'] = _spaceId;
    map['owner_id'] = _ownerId;
    map['name'] = _name;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    if (_slots != null) {
      map['slots'] = _slots?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Slots {
  Slots({
    int? id,
    int? zoneId,
    int? spaceId,
    String? name,
    int? position,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    bool? available,
    Booking? booking,
  }) {
    _id = id;
    _zoneId = zoneId;
    _spaceId = spaceId;
    _name = name;
    _position = position;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _deletedAt = deletedAt;
    _available = available;
    _booking = booking;
  }

  Slots.fromJson(dynamic json) {
    _id = json['id'];
    _zoneId = json['zone_id'];
    _spaceId = json['space_id'];
    _name = json['name'];
    _position = json['position'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _available = json['available'];
    _booking = json['booking'] != null ? Booking.fromJson(json['booking']) : null;
  }

  int? _id;
  int? _zoneId;
  int? _spaceId;
  String? _name;
  int? _position;
  String? _createdAt;
  String? _updatedAt;
  dynamic _deletedAt;
  bool? _available;
  Booking? _booking;

  Slots copyWith({
    int? id,
    int? zoneId,
    int? spaceId,
    String? name,
    int? position,
    String? createdAt,
    String? updatedAt,
    dynamic deletedAt,
    bool? available,
    Booking? booking,
  }) =>
      Slots(
        id: id ?? _id,
        zoneId: zoneId ?? _zoneId,
        spaceId: spaceId ?? _spaceId,
        name: name ?? _name,
        position: position ?? _position,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        deletedAt: deletedAt ?? _deletedAt,
        available: available ?? _available,
        booking: booking ?? _booking,
      );

  int? get id => _id;

  int? get zoneId => _zoneId;

  int? get spaceId => _spaceId;

  String? get name => _name;

  int? get position => _position;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  dynamic get deletedAt => _deletedAt;

  bool? get available => _available;

  Booking? get booking => _booking;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['zone_id'] = _zoneId;
    map['space_id'] = _spaceId;
    map['name'] = _name;
    map['position'] = _position;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['deleted_at'] = _deletedAt;
    map['available'] = _available;
    if (_booking != null) {
      map['booking'] = _booking?.toJson();
    }
    return map;
  }
}
class Booking {
  Booking({
    int? id,
    int? ownerId,
    int? spaceId,
    int? userId,
    int? vehicleId,
    int? slotId,
    String? arrivingTime,
    String? leavingTime,
    dynamic totalAmount,
    String? orderNo,
    User? user,
    Vehicle? vehicle,
  }) {
    _id = id;
    _ownerId = ownerId;
    _spaceId = spaceId;
    _userId = userId;
    _vehicleId = vehicleId;
    _slotId = slotId;
    _arrivingTime = arrivingTime;
    _leavingTime = leavingTime;
    _totalAmount = totalAmount;
    _orderNo = orderNo;
    _user = user;
    _vehicle = vehicle;
  }

  Booking.fromJson(dynamic json) {
    _id = json['id'];
    _ownerId = json['owner_id'];
    _spaceId = json['space_id'];
    _userId = json['user_id'];
    _vehicleId = json['vehicle_id'];
    _slotId = json['slot_id'];
    _arrivingTime = json['arriving_time'];
    _leavingTime = json['leaving_time'];
    _totalAmount = json['total_amount'];
    _orderNo = json['order_no'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _vehicle = json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
  }

  int? _id;
  int? _ownerId;
  int? _spaceId;
  int? _userId;
  int? _vehicleId;
  int? _slotId;
  String? _arrivingTime;
  String? _leavingTime;
  dynamic _totalAmount;
  String? _orderNo;
  User? _user;
  Vehicle? _vehicle;

  Booking copyWith({
    int? id,
    int? ownerId,
    int? spaceId,
    int? userId,
    int? vehicleId,
    int? slotId,
    String? arrivingTime,
    String? leavingTime,
    dynamic totalAmount,
    String? orderNo,
    User? user,
    Vehicle? vehicle,
  }) =>
      Booking(
        id: id ?? _id,
        ownerId: ownerId ?? _ownerId,
        spaceId: spaceId ?? _spaceId,
        userId: userId ?? _userId,
        vehicleId: vehicleId ?? _vehicleId,
        slotId: slotId ?? _slotId,
        arrivingTime: arrivingTime ?? _arrivingTime,
        leavingTime: leavingTime ?? _leavingTime,
        totalAmount: totalAmount ?? _totalAmount,
        orderNo: orderNo ?? _orderNo,
        user: user ?? _user,
        vehicle: vehicle ?? _vehicle,
      );

  int? get id => _id;

  int? get ownerId => _ownerId;

  int? get spaceId => _spaceId;

  int? get userId => _userId;

  int? get vehicleId => _vehicleId;

  int? get slotId => _slotId;

  String? get arrivingTime => _arrivingTime;

  String? get leavingTime => _leavingTime;

  dynamic get totalAmount => _totalAmount;

  String? get orderNo => _orderNo;

  User? get user => _user;

  Vehicle? get vehicle => _vehicle;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner_id'] = _ownerId;
    map['space_id'] = _spaceId;
    map['user_id'] = _userId;
    map['vehicle_id'] = _vehicleId;
    map['slot_id'] = _slotId;
    map['arriving_time'] = _arrivingTime;
    map['leaving_time'] = _leavingTime;
    map['total_amount'] = _totalAmount;
    map['order_no'] = _orderNo;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_vehicle != null) {
      map['vehicle'] = _vehicle?.toJson();
    }
    return map;
  }
}

class Vehicle {
  Vehicle({
    int? id,
    String? model,
    String? vehicleNo,
  }) {
    _id = id;
    _model = model;
    _vehicleNo = vehicleNo;
  }

  Vehicle.fromJson(dynamic json) {
    _id = json['id'];
    _model = json['model'];
    _vehicleNo = json['vehicle_no'];
  }

  int? _id;
  String? _model;
  String? _vehicleNo;

  Vehicle copyWith({
    int? id,
    String? model,
    String? vehicleNo,
  }) =>
      Vehicle(
        id: id ?? _id,
        model: model ?? _model,
        vehicleNo: vehicleNo ?? _vehicleNo,
      );

  int? get id => _id;

  String? get model => _model;

  String? get vehicleNo => _vehicleNo;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['model'] = _model;
    map['vehicle_no'] = _vehicleNo;
    return map;
  }
}


class User {
  User({
    int? id,
    String? name,
    String? image,
    String? imageUri,
  }) {
    _id = id;
    _name = name;
    _image = image;
    _imageUri = imageUri;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _image = json['image'];
    _imageUri = json['imageUri'];
  }

  int? _id;
  String? _name;
  String? _image;
  String? _imageUri;

  User copyWith({
    int? id,
    String? name,
    String? image,
    String? imageUri,
  }) =>
      User(
        id: id ?? _id,
        name: name ?? _name,
        image: image ?? _image,
        imageUri: imageUri ?? _imageUri,
      );

  int? get id => _id;

  String? get name => _name;

  String? get image => _image;

  String? get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['image'] = _image;
    map['imageUri'] = _imageUri;
    return map;
  }
}
