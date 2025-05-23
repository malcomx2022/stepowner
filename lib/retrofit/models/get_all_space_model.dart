class GetAllSpaceModel {
  GetAllSpaceModel({
    dynamic msg,
    List<AllSpaceData>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  GetAllSpaceModel.fromJson(dynamic json) {
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AllSpaceData.fromJson(v));
      });
    }
    _success = json['success'];
  }

  dynamic _msg;
  List<AllSpaceData>? _data;
  bool? _success;

  dynamic get msg => _msg;

  List<AllSpaceData>? get data => _data;

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
class AllSpaceData {
  AllSpaceData({
    int? id,
    int? ownerId,
    dynamic vehicleTypes,
    String? title,
    dynamic description,
    dynamic facilities,
    String? address,
    double? lat,
    double? lng,
    dynamic priceParHour,
    dynamic phoneNumber,
    String? openTime,
    String? closeTime,
    int? availableAllDay,
    int? offlinePayment,
    int? verified,
    int? status,
    String? createdAt,
    String? updatedAt,
  }) {
    _id = id;
    _ownerId = ownerId;
    _vehicleTypes = vehicleTypes;
    _title = title;
    _description = description;
    _facilities = facilities;
    _address = address;
    _lat = lat;
    _lng = lng;
    _priceParHour = priceParHour;
    _phoneNumber = phoneNumber;
    _openTime = openTime;
    _closeTime = closeTime;
    _availableAllDay = availableAllDay;
    _offlinePayment = offlinePayment;
    _verified = verified;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
  }

  AllSpaceData.fromJson(dynamic json) {
    _id = json['id'];
    _ownerId = json['owner_id'];
    _vehicleTypes = json['vehicle_types'];
    _title = json['title'];
    _description = json['description'];
    _facilities = json['facilities'];
    _address = json['address'];
    _lat = json['lat'];
    _lng = json['lng'];
    _priceParHour = json['price_par_hour'];
    _phoneNumber = json['phone_number'];
    _openTime = json['open_time'];
    _closeTime = json['close_time'];
    _availableAllDay = json['available_all_day'];
    _offlinePayment = json['offline_payment'];
    _verified = json['verified'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  int? _id;
  int? _ownerId;
  dynamic _vehicleTypes;
  String? _title;
  dynamic _description;
  dynamic _facilities;
  String? _address;
  double? _lat;
  double? _lng;
  dynamic _priceParHour;
  dynamic _phoneNumber;
  String? _openTime;
  String? _closeTime;
  int? _availableAllDay;
  int? _offlinePayment;
  int? _verified;
  int? _status;
  String? _createdAt;
  String? _updatedAt;

  int? get id => _id;

  int? get ownerId => _ownerId;

  dynamic get vehicleTypes => _vehicleTypes;

  String? get title => _title;

  dynamic get description => _description;

  dynamic get facilities => _facilities;

  String? get address => _address;

  double? get lat => _lat;

  double? get lng => _lng;

  dynamic get priceParHour => _priceParHour;

  dynamic get phoneNumber => _phoneNumber;

  String? get openTime => _openTime;

  String? get closeTime => _closeTime;

  int? get availableAllDay => _availableAllDay;

  int? get offlinePayment => _offlinePayment;

  int? get verified => _verified;

  int? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner_id'] = _ownerId;
    map['vehicle_types'] = _vehicleTypes;
    map['title'] = _title;
    map['description'] = _description;
    map['facilities'] = _facilities;
    map['address'] = _address;
    map['lat'] = _lat;
    map['lng'] = _lng;
    map['price_par_hour'] = _priceParHour;
    map['phone_number'] = _phoneNumber;
    map['open_time'] = _openTime;
    map['close_time'] = _closeTime;
    map['available_all_day'] = _availableAllDay;
    map['offline_payment'] = _offlinePayment;
    map['verified'] = _verified;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    return map;
  }
}
