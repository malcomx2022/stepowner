class LoginModel {
  LoginModel({
    String? msg,
    Data? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  LoginModel.fromJson(dynamic json) {
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
  }

  String? _msg;
  Data? _data;
  bool? _success;

  String? get msg => _msg;

  Data? get data => _data;

  bool? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = _msg;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    map['success'] = _success;
    return map;
  }
}
class Data {
  Data({
    int? id,
    String? name,
    String? email,
    String? phoneNo,
    String? image,
    String? customerId,
    int? verified,
    int? status,
    String? stripePk,
    String? stripeSk,
    int? subscriptionStatus,
    String? createdAt,
    String? updatedAt,
    String? token,
    String? imageUri,
    String? planExpireOn,
    int? maxSpaceLimit,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _phoneNo = phoneNo;
    _image = image;
    _customerId = customerId;
    _verified = verified;
    _status = status;
    _stripePk = stripePk;
    _stripeSk = stripeSk;
    _subscriptionStatus = subscriptionStatus;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _token = token;
    _imageUri = imageUri;
    _planExpireOn = planExpireOn;
    _maxSpaceLimit = maxSpaceLimit;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNo = json['phone_no'];
    _image = json['image'];
    _customerId = json['customer_id'];
    _verified = json['verified'];
    _status = json['status'];
    _stripePk = json['stripe_pk'];
    _stripeSk = json['stripe_sk'];
    _subscriptionStatus = json['subscription_status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _token = json['token'];
    _imageUri = json['imageUri'];
    _planExpireOn = json['plan_expire_on'];
    _maxSpaceLimit = json['max_space_limit'];
  }

  int? _id;
  String? _name;
  String? _email;
  String? _phoneNo;
  String? _image;
  String? _customerId;
  int? _verified;
  int? _status;
  String? _stripePk;
  String? _stripeSk;
  int? _subscriptionStatus;
  String? _createdAt;
  String? _updatedAt;
  String? _token;
  String? _imageUri;
  String? _planExpireOn;
  int? _maxSpaceLimit;

  int? get id => _id;

  String? get name => _name;

  String? get email => _email;

  String? get phoneNo => _phoneNo;

  String? get image => _image;

  String? get customerId => _customerId;

  int? get verified => _verified;

  int? get status => _status;

  String? get stripePk => _stripePk;

  String? get stripeSk => _stripeSk;

  int? get subscriptionStatus => _subscriptionStatus;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get token => _token;

  String? get imageUri => _imageUri;

  String? get planExpireOn => _planExpireOn;

  int? get maxSpaceLimit => _maxSpaceLimit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_no'] = _phoneNo;
    map['image'] = _image;
    map['customer_id'] = _customerId;
    map['verified'] = _verified;
    map['status'] = _status;
    map['stripe_pk'] = _stripePk;
    map['stripe_sk'] = _stripeSk;
    map['subscription_status'] = _subscriptionStatus;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['token'] = _token;
    map['imageUri'] = _imageUri;
    map['plan_expire_on'] = _planExpireOn;
    map['max_space_limit'] = _maxSpaceLimit;
    return map;
  }
}
