class ReviewModel {
  ReviewModel({
    dynamic msg,
    List<Data>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  ReviewModel.fromJson(dynamic json) {
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(Data.fromJson(v));
      });
    }
    _success = json['success'];
  }

  dynamic _msg;
  List<Data>? _data;
  bool? _success;

  dynamic get msg => _msg;

  List<Data>? get data => _data;

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
class Data {
  Data({
    int? id,
    int? userId,
    int? spaceId,
    dynamic star,
    String? description,
    String? createdAt,
    String? updatedAt,
    User? user,
    Space? space,
  }) {
    _id = id;
    _userId = userId;
    _spaceId = spaceId;
    _star = star;
    _description = description;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _user = user;
    _space = space;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _spaceId = json['space_id'];
    _star = json['star'];
    _description = json['description'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _space = json['space'] != null ? Space.fromJson(json['space']) : null;
  }

  int? _id;
  int? _userId;
  int? _spaceId;
  dynamic _star;
  String? _description;
  String? _createdAt;
  String? _updatedAt;
  User? _user;
  Space? _space;

  int? get id => _id;

  int? get userId => _userId;

  int? get spaceId => _spaceId;

  dynamic get star => _star;

  String? get description => _description;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  User? get user => _user;

  Space? get space => _space;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['space_id'] = _spaceId;
    map['star'] = _star;
    map['description'] = _description;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_user != null) {
      map['user'] = _user?.toJson();
    }
    if (_space != null) {
      map['space'] = _space?.toJson();
    }
    return map;
  }
}
class Space {
  Space({
    int? id,
    String? title,
  }) {
    _id = id;
    _title = title;
  }

  Space.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
  }

  int? _id;
  String? _title;

  int? get id => _id;

  String? get title => _title;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    return map;
  }
}
class User {
  User({
    int? id,
    String? name,
    String? email,
    String? phoneNo,
    dynamic otp,
    int? verified,
    int? status,
    String? image,
    String? deviceToken,
    String? createdAt,
    String? updatedAt,
    String? imageUri,
  }) {
    _id = id;
    _name = name;
    _email = email;
    _phoneNo = phoneNo;
    _otp = otp;
    _verified = verified;
    _status = status;
    _image = image;
    _deviceToken = deviceToken;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageUri = imageUri;
  }

  User.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNo = json['phone_no'];
    _otp = json['OTP'];
    _verified = json['verified'];
    _status = json['status'];
    _image = json['image'];
    _deviceToken = json['device_token'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageUri = json['imageUri'];
  }

  int? _id;
  String? _name;
  String? _email;
  String? _phoneNo;
  dynamic _otp;
  int? _verified;
  int? _status;
  String? _image;
  String? _deviceToken;
  String? _createdAt;
  String? _updatedAt;
  String? _imageUri;

  int? get id => _id;

  String? get name => _name;

  String? get email => _email;

  String? get phoneNo => _phoneNo;

  dynamic get otp => _otp;

  int? get verified => _verified;

  int? get status => _status;

  String? get image => _image;

  String? get deviceToken => _deviceToken;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_no'] = _phoneNo;
    map['OTP'] = _otp;
    map['verified'] = _verified;
    map['status'] = _status;
    map['image'] = _image;
    map['device_token'] = _deviceToken;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['imageUri'] = _imageUri;
    return map;
  }
}
