class RegisterModel {
  RegisterModel({
    String? msg,
    Data? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  RegisterModel.fromJson(dynamic json) {
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
    String? email,
    String? name,
    String? updatedAt,
    String? createdAt,
    int? id,
    String? token,
    dynamic imageUri,
  }) {
    _email = email;
    _name = name;
    _updatedAt = updatedAt;
    _createdAt = createdAt;
    _id = id;
    _token = token;
    _imageUri = imageUri;
  }

  Data.fromJson(dynamic json) {
    _email = json['email'];
    _name = json['name'];
    _updatedAt = json['updated_at'];
    _createdAt = json['created_at'];
    _id = json['id'];
    _token = json['token'];
    _imageUri = json['imageUri'];
  }

  String? _email;
  String? _name;
  String? _updatedAt;
  String? _createdAt;
  int? _id;
  String? _token;
  dynamic _imageUri;

  String? get email => _email;

  String? get name => _name;

  String? get updatedAt => _updatedAt;

  String? get createdAt => _createdAt;

  int? get id => _id;

  String? get token => _token;

  dynamic get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['email'] = _email;
    map['name'] = _name;
    map['updated_at'] = _updatedAt;
    map['created_at'] = _createdAt;
    map['id'] = _id;
    map['token'] = _token;
    map['imageUri'] = _imageUri;
    return map;
  }
}
