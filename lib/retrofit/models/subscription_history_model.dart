class SubscriptionHistoryModel {
  SubscriptionHistoryModel({
    bool? success,
    List<SubscriptionHistoryModelData>? data,
  }) {
    _success = success;
    _data = data;
  }

  SubscriptionHistoryModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SubscriptionHistoryModelData.fromJson(v));
      });
    }
  }

  bool? _success;
  List<SubscriptionHistoryModelData>? _data;

  SubscriptionHistoryModel copyWith({
    bool? success,
    List<SubscriptionHistoryModelData>? data,
  }) =>
      SubscriptionHistoryModel(
        success: success ?? _success,
        data: data ?? _data,
      );

  bool? get success => _success;

  List<SubscriptionHistoryModelData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}
class SubscriptionHistoryModelData {
  SubscriptionHistoryModelData({
    int? id,
    int? ownerId,
    int? subscriptionId,
    int? price,
    int? duration,
    String? startAt,
    String? endAt,
    int? paymentStatus,
    int? status,
    dynamic paymentToken,
    String? paymentType,
    String? createdAt,
    String? updatedAt,
    Subscription? subscription,
  }) {
    _id = id;
    _ownerId = ownerId;
    _subscriptionId = subscriptionId;
    _price = price;
    _duration = duration;
    _startAt = startAt;
    _endAt = endAt;
    _paymentStatus = paymentStatus;
    _status = status;
    _paymentToken = paymentToken;
    _paymentType = paymentType;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _subscription = subscription;
  }

  SubscriptionHistoryModelData.fromJson(dynamic json) {
    _id = json['id'];
    _ownerId = json['owner_id'];
    _subscriptionId = json['subscription_id'];
    _price = json['price'];
    _duration = json['duration'];
    _startAt = json['start_at'];
    _endAt = json['end_at'];
    _paymentStatus = json['payment_status'];
    _status = json['status'];
    _paymentToken = json['payment_token'];
    _paymentType = json['payment_type'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _subscription = json['subscription'] != null ? Subscription.fromJson(json['subscription']) : null;
  }

  int? _id;
  int? _ownerId;
  int? _subscriptionId;
  int? _price;
  int? _duration;
  String? _startAt;
  String? _endAt;
  int? _paymentStatus;
  int? _status;
  dynamic _paymentToken;
  String? _paymentType;
  String? _createdAt;
  String? _updatedAt;
  Subscription? _subscription;

  SubscriptionHistoryModelData copyWith({
    int? id,
    int? ownerId,
    int? subscriptionId,
    int? price,
    int? duration,
    String? startAt,
    String? endAt,
    int? paymentStatus,
    int? status,
    dynamic paymentToken,
    String? paymentType,
    String? createdAt,
    String? updatedAt,
    Subscription? subscription,
  }) =>
      SubscriptionHistoryModelData(
        id: id ?? _id,
        ownerId: ownerId ?? _ownerId,
        subscriptionId: subscriptionId ?? _subscriptionId,
        price: price ?? _price,
        duration: duration ?? _duration,
        startAt: startAt ?? _startAt,
        endAt: endAt ?? _endAt,
        paymentStatus: paymentStatus ?? _paymentStatus,
        status: status ?? _status,
        paymentToken: paymentToken ?? _paymentToken,
        paymentType: paymentType ?? _paymentType,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        subscription: subscription ?? _subscription,
      );

  int? get id => _id;

  int? get ownerId => _ownerId;

  int? get subscriptionId => _subscriptionId;

  int? get price => _price;

  int? get duration => _duration;

  String? get startAt => _startAt;

  String? get endAt => _endAt;

  int? get paymentStatus => _paymentStatus;

  int? get status => _status;

  dynamic get paymentToken => _paymentToken;

  String? get paymentType => _paymentType;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  Subscription? get subscription => _subscription;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['owner_id'] = _ownerId;
    map['subscription_id'] = _subscriptionId;
    map['price'] = _price;
    map['duration'] = _duration;
    map['start_at'] = _startAt;
    map['end_at'] = _endAt;
    map['payment_status'] = _paymentStatus;
    map['status'] = _status;
    map['payment_token'] = _paymentToken;
    map['payment_type'] = _paymentType;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    if (_subscription != null) {
      map['subscription'] = _subscription?.toJson();
    }
    return map;
  }
}
class Subscription {
  Subscription({
    int? id,
    String? subscriptionName,
  }) {
    _id = id;
    _subscriptionName = subscriptionName;
  }

  Subscription.fromJson(dynamic json) {
    _id = json['id'];
    _subscriptionName = json['subscription_name'];
  }

  int? _id;
  String? _subscriptionName;

  Subscription copyWith({
    int? id,
    String? subscriptionName,
  }) =>
      Subscription(
        id: id ?? _id,
        subscriptionName: subscriptionName ?? _subscriptionName,
      );

  int? get id => _id;

  String? get subscriptionName => _subscriptionName;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['subscription_name'] = _subscriptionName;
    return map;
  }
}
