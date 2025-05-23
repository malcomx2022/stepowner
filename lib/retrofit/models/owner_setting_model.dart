class OwnerSettingModel {
  OwnerSettingModelData? data;
  bool? success;

  OwnerSettingModel({
    this.data,
    this.success,
  });

  OwnerSettingModel.fromJson(Map<String, dynamic> json) {
    data = (json['data'] != null && (json['data'] is Map)) ? OwnerSettingModelData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['data'] = this.data!.toJson();
    data['success'] = success;
    return data;
  }
}

class OwnerSettingModelData {
  int? id;
  int? ownerId;
  int? stripeStatus;
  int? cod;
  String? stripeSecret;
  String? stripePublic;
  int? razorpayStatus;
  String? razorpayKey;
  int? paypalStatus;
  String? paypalClientKey;
  String? paypalSecretKey;
  int? flutterWaveStatus;
  String? flutterWaveKey;
  int? isLiveMode;
  String? createdAt;
  String? updatedAt;

  OwnerSettingModelData({
    this.id,
    this.ownerId,
    this.stripeStatus,
    this.cod,
    this.stripeSecret,
    this.stripePublic,
    this.razorpayStatus,
    this.razorpayKey,
    this.paypalStatus,
    this.paypalClientKey,
    this.paypalSecretKey,
    this.flutterWaveStatus,
    this.flutterWaveKey,
    this.isLiveMode,
    this.createdAt,
    this.updatedAt,
  });

  OwnerSettingModelData.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    ownerId = int.tryParse(json['owner_id']?.toString() ?? '');
    stripeStatus = int.tryParse(json['stripe_status']?.toString() ?? '');
    cod = int.tryParse(json['cod']?.toString() ?? '');
    stripeSecret = json['stripe_secret']?.toString();
    stripePublic = json['stripe_public']?.toString();
    razorpayStatus = int.tryParse(json['razorpay_status']?.toString() ?? '');
    razorpayKey = json['razorpay_key']?.toString();
    paypalStatus = int.tryParse(json['paypal_status']?.toString() ?? '');
    paypalClientKey = json['paypal_client_key']?.toString();
    paypalSecretKey = json['paypal_secret_key']?.toString();
    flutterWaveStatus = int.tryParse(json['flutterwave_status']?.toString() ?? '');
    flutterWaveKey = json['flutterwave_key']?.toString();
    isLiveMode = int.tryParse(json['isLiveMode']?.toString() ?? '');
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['stripe_status'] = stripeStatus;
    data['cod'] = cod;
    data['stripe_secret'] = stripeSecret;
    data['stripe_public'] = stripePublic;
    data['razorpay_status'] = razorpayStatus;
    data['razorpay_key'] = razorpayKey;
    data['paypal_status'] = paypalStatus;
    data['paypal_client_key'] = paypalClientKey;
    data['paypal_secret_key'] = paypalSecretKey;
    data['flutterwave_status'] = flutterWaveStatus;
    data['flutterwave_key'] = flutterWaveKey;
    data['isLiveMode'] = isLiveMode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
