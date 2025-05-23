class GetImageSpace {
  GetImageSpace({
    dynamic msg,
    List<ImageData>? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  GetImageSpace.fromJson(dynamic json) {
    _msg = json['msg'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(ImageData.fromJson(v));
      });
    }
    _success = json['success'];
  }

  dynamic _msg;
  List<ImageData>? _data;
  bool? _success;

  dynamic get msg => _msg;

  List<ImageData>? get data => _data;

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


class ImageData {
  ImageData({
    int? id,
    int? spaceId,
    String? image,
    String? createdAt,
    String? updatedAt,
    String? imageUri,
  }) {
    _id = id;
    _spaceId = spaceId;
    _image = image;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _imageUri = imageUri;
  }

  ImageData.fromJson(dynamic json) {
    _id = json['id'];
    _spaceId = json['space_id'];
    _image = json['image'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _imageUri = json['imageUri'];
  }

  int? _id;
  int? _spaceId;
  String? _image;
  String? _createdAt;
  String? _updatedAt;
  String? _imageUri;

  int? get id => _id;

  int? get spaceId => _spaceId;

  String? get image => _image;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  String? get imageUri => _imageUri;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['space_id'] = _spaceId;
    map['image'] = _image;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['imageUri'] = _imageUri;
    return map;
  }
}
