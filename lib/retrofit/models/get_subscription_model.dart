class GetSubscriptionModel {
  GetSubscriptionModel({
    bool? success,
    List<SubscriptionData>? data,
  }) {
    _success = success;
    _data = data;
  }

  GetSubscriptionModel.fromJson(dynamic json) {
    _success = json['success'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(SubscriptionData.fromJson(v));
      });
    }
  }

  bool? _success;
  List<SubscriptionData>? _data;

  GetSubscriptionModel copyWith({
    bool? success,
    List<SubscriptionData>? data,
  }) =>
      GetSubscriptionModel(
        success: success ?? _success,
        data: data ?? _data,
      );

  bool? get success => _success;

  List<SubscriptionData>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = _success;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class SubscriptionData {
  SubscriptionData({
    int? id,
    String? subscriptionName,
    List<Plan>? plan,
    int? status,
    String? createdAt,
    String? updatedAt,
    int? isPurchase,
    int? trialDays,
    int? maxSpaceLimit,
  }) {
    _id = id;
    _subscriptionName = subscriptionName;
    _plan = plan;
    _status = status;
    _createdAt = createdAt;
    _updatedAt = updatedAt;
    _isPurchase = isPurchase;
    _trialDays = trialDays;
    _maxSpaceLimit = maxSpaceLimit;
  }

  SubscriptionData.fromJson(dynamic json) {
    _id = json['id'];
    _subscriptionName = json['subscription_name'];
    if (json['plan'] != null) {
      _plan = [];
      json['plan'].forEach((v) {
        _plan?.add(Plan.fromJson(v));
      });
    }
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _isPurchase = json['isPurchase'];
    _trialDays = json['trial_days'];
    _maxSpaceLimit = json['max_space_limit'];
  }

  int? _id;
  String? _subscriptionName;
  List<Plan>? _plan;
  int? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _isPurchase;
  int? _trialDays;
  int? _maxSpaceLimit;

  SubscriptionData copyWith({
    int? id,
    String? subscriptionName,
    List<Plan>? plan,
    int? status,
    String? createdAt,
    String? updatedAt,
    int? isPurchase,
    int? trialDays,
    int? maxSpaceLimit,
  }) =>
      SubscriptionData(
        id: id ?? _id,
        subscriptionName: subscriptionName ?? _subscriptionName,
        plan: plan ?? _plan,
        status: status ?? _status,
        createdAt: createdAt ?? _createdAt,
        updatedAt: updatedAt ?? _updatedAt,
        isPurchase: isPurchase ?? _isPurchase,
        trialDays: trialDays ?? _trialDays,
        maxSpaceLimit: maxSpaceLimit ?? _maxSpaceLimit,
      );

  int? get id => _id;

  String? get subscriptionName => _subscriptionName;

  List<Plan>? get plan => _plan;

  int? get status => _status;

  String? get createdAt => _createdAt;

  String? get updatedAt => _updatedAt;

  int? get isPurchase => _isPurchase;

  int? get trialDays => _trialDays;

  int? get maxSpaceLimit => _maxSpaceLimit;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['subscription_name'] = _subscriptionName;
    if (_plan != null) {
      map['plan'] = _plan?.map((v) => v.toJson()).toList();
    }
    map['status'] = _status;
    map['created_at'] = _createdAt;
    map['updated_at'] = _updatedAt;
    map['isPurchase'] = _isPurchase;
    map['trial_days'] = _trialDays;
    map['max_space_limit'] = _maxSpaceLimit;
    return map;
  }
}

class Plan {
  Plan({
    String? month,
    String? price,
  }) {
    _month = month;
    _price = price;
  }

  Plan.fromJson(dynamic json) {
    _month = json['month'];
    _price = json['price'];
  }

  String? _month;
  String? _price;

  Plan copyWith({
    String? month,
    String? price,
  }) =>
      Plan(
        month: month ?? _month,
        price: price ?? _price,
      );

  String? get month => _month;

  String? get price => _price;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['month'] = _month;
    map['price'] = _price;
    return map;
  }
}
