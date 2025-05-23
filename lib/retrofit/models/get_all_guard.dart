class GetAllGuard {
  GetAllGuard({
    dynamic msg,
    List<AllGuardDataList>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  GetAllGuard.fromJson(dynamic json) {
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(AllGuardDataList.fromJson(v));
      });
    }
    _success = json['success'];
  }

  dynamic _msg;
  List<AllGuardDataList>? _data;
  bool? _success;

  dynamic get msg => _msg;

  List<AllGuardDataList>? get data => _data;

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
class AllGuardDataList {
  AllGuardDataList({
    int? id,
    int? ownerId,
    int? spaceId,
    String? name,
    String? email,
    String? phoneNo,
    String? image,
    String? password,
    int? status,
    String? createdAt,
    String? updatedAt,
    String? imageUri,
  }) {
    _id = id;
    _ownerId = ownerId;
    _spaceId = spaceId;
    _name = name;
    _email = email;
    _phoneNo = phoneNo;
    _image = image;
    _password = password;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageUri = imageUri;
  }

  AllGuardDataList.fromJson(dynamic json) {
    _id = json['id'];
    _ownerId = json['owner_id'];
    _spaceId = json['space_id'];
    _name = json['name'];
    _email = json['email'];
    _phoneNo = json['phone_no'];
    _image = json['image'];
    _password = json['password'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageUri = json['imageUri'];
  }

  int? _id;
  int? _ownerId;
  int? _spaceId;
  String? _name;
  String? _email;
  String? _phoneNo;
  String? _image;
  String? _password;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  String? _imageUri;

  int? get id => _id;

  int? get ownerId => _ownerId;

  int? get spaceId => _spaceId;

  String? get name => _name;

  String? get email => _email;

  String? get phoneNo => _phoneNo;

  String? get image => _image;

  String? get password => _password;

  int? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner_id'] = _ownerId;
    map['space_id'] = _spaceId;
    map['name'] = _name;
    map['email'] = _email;
    map['phone_no'] = _phoneNo;
    map['image'] = _image;
    map['password'] = _password;
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['imageUri'] = _imageUri;
    return map;
  }
}
