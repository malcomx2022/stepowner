class ImageUploadModel {
  ImageUploadModel({
    String? msg,
    dynamic data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  ImageUploadModel.fromJson(dynamic json) {
    _msg = json['msg'];
    _data = json['data'];
    _success = json['success'];
  }

  String? _msg;
  dynamic _data;
  bool? _success;

  String? get msg => _msg;

  dynamic get data => _data;

  bool? get success => _success;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['msg'] = _msg;
    map['data'] = _data;
    map['success'] = _success;
    return map;
  }
}
