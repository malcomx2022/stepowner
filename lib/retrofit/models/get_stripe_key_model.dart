class GetStripeKeyModel {
  GetStripeKeyModel({
    dynamic msg,
    Data? data,
    bool? success,
  }) {
    _msg = msg;
    _data = data;
    _success = success;
  }

  GetStripeKeyModel.fromJson(dynamic json) {
    _msg = json['msg'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
    _success = json['success'];
  }

  dynamic _msg;
  Data? _data;
  bool? _success;

  dynamic get msg => _msg;

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
    String? stripeSk,
    String? stripePk,
  }) {
    _stripeSk = stripeSk;
    _stripePk = stripePk;
  }

  Data.fromJson(dynamic json) {
    _stripeSk = json['stripe_sk'];
    _stripePk = json['stripe_pk'];
  }

  String? _stripeSk;
  String? _stripePk;

  String? get stripeSk => _stripeSk;

  String? get stripePk => _stripePk;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['stripe_sk'] = _stripeSk;
    map['stripe_pk'] = _stripePk;
    return map;
  }
}
