class GetOwnerProfile {
  GetOwnerProfile({
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
    String? imageUri,
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
    _imageUri = imageUri;
  }

  GetOwnerProfile.fromJson(dynamic json) {
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
    _imageUri = json['imageUri'];
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
  String? _imageUri;

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

  String? get imageUri => _imageUri;

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
    map['imageUri'] = _imageUri;
    return map;
  }
}
