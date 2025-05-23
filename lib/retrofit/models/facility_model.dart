class FacilityModel {
  FacilityModel({
    dynamic msg,
    List<Data>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  FacilityModel.fromJson(dynamic json) {
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
    String? title,
    String? image,
    String? createdAt,
    String? updatedAt,
    bool isCheck = false,
    String? imageUri,
  }) {
    _id = id;
    _title = title;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageUri = imageUri;
    _isCheck = isCheck;
  }

  Data.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageUri = json['imageUri'];
  }

  int? _id;
  String? _title;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
  String? _imageUri;
  bool _isCheck = false;

  set isCheck(bool value) {
    _isCheck = value;
  }

  // ignore: unnecessary_getters_setters
  bool get isCheck => _isCheck;

  int? get id => _id;

  String? get title => _title;

  String? get image => _image;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['imageUri'] = _imageUri;
    return map;
  }
}
