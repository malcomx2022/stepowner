class SettingModelData {
  int? id;
  String? color;
  String? logo;
  String? whiteLogo;
  String? favicon;
  String? bgImg;
  String? name;
  String? pp;
  String? countryCode;
  int? currencyId;
  String? currency;
  String? currencySymbol;
  int? verification;
  int? notification;
  String? licenseCode;
  String? clientName;
  String? licenseStatus;
  String? appId;
  String? restApiKey;
  String? userAuthKey;
  String? projectNumber;
  String? ownerAppId;
  String? ownerRestApiKey;
  String? ownerAuthKey;
  String? guardAppId;
  String? guardRestApiKey;
  String? guardAuthKey;
  String? stripePublic;
  int? stripeStatus;
  String? stripeSecret;
  int? razorpayStatus;
  String? razorpayKey;
  int? paypalStatus;
  String? paypalClientId;
  String? paypalSecretKey;
  int? flutterWaveStatus;
  String? flutterWaveKey;
  int? isLiveMode;
  String? createdAt;
  String? updatedAt;

  SettingModelData({
    this.id,
    this.color,
    this.logo,
    this.whiteLogo,
    this.favicon,
    this.bgImg,
    this.name,
    this.pp,
    this.countryCode,
    this.currencyId,
    this.currency,
    this.currencySymbol,
    this.verification,
    this.notification,
    this.licenseCode,
    this.clientName,
    this.licenseStatus,
    this.appId,
    this.restApiKey,
    this.userAuthKey,
    this.projectNumber,
    this.ownerAppId,
    this.ownerRestApiKey,
    this.ownerAuthKey,
    this.guardAppId,
    this.guardRestApiKey,
    this.guardAuthKey,
    this.stripePublic,
    this.stripeStatus,
    this.stripeSecret,
    this.razorpayStatus,
    this.razorpayKey,
    this.paypalStatus,
    this.paypalClientId,
    this.paypalSecretKey,
    this.flutterWaveStatus,
    this.flutterWaveKey,
    this.isLiveMode,
    this.createdAt,
    this.updatedAt,
  });

  SettingModelData.fromJson(Map<String, dynamic> json) {
    id = int.tryParse(json['id']?.toString() ?? '');
    color = json['color']?.toString();
    logo = json['logo']?.toString();
    whiteLogo = json['white_logo']?.toString();
    favicon = json['favicon']?.toString();
    bgImg = json['bg_img']?.toString();
    name = json['name']?.toString();
    pp = json['pp']?.toString();
    countryCode = json['country_code']?.toString();
    currencyId = int.tryParse(json['currency_id']?.toString() ?? '');
    currency = json['currency']?.toString();
    currencySymbol = json['currency_symbol']?.toString();
    verification = int.tryParse(json['verification']?.toString() ?? '');
    notification = int.tryParse(json['notification']?.toString() ?? '');
    licenseCode = json['license_code']?.toString();
    clientName = json['client_name']?.toString();
    licenseStatus = json['license_status']?.toString();
    appId = json['app_id']?.toString();
    restApiKey = json['rest_api_key']?.toString();
    userAuthKey = json['user_auth_key']?.toString();
    projectNumber = json['project_number']?.toString();
    ownerAppId = json['owner_app_id']?.toString();
    ownerRestApiKey = json['owner_rest_api_key']?.toString();
    ownerAuthKey = json['owner_auth_key']?.toString();
    guardAppId = json['guard_app_id']?.toString();
    guardRestApiKey = json['guard_rest_api_key']?.toString();
    guardAuthKey = json['guard_auth_key']?.toString();
    stripePublic = json['stripe_public']?.toString();
    stripeStatus = int.tryParse(json['stripe_status']?.toString() ?? '');
    stripeSecret = json['stripe_secret']?.toString();
    razorpayStatus = int.tryParse(json['razorpay_status']?.toString() ?? '');
    razorpayKey = json['razorpay_key']?.toString();
    paypalStatus = int.tryParse(json['paypal_status']?.toString() ?? '');
    paypalClientId = json['paypal_client_id']?.toString();
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
    data['color'] = color;
    data['logo'] = logo;
    data['white_logo'] = whiteLogo;
    data['favicon'] = favicon;
    data['bg_img'] = bgImg;
    data['name'] = name;
    data['pp'] = pp;
    data['country_code'] = countryCode;
    data['currency_id'] = currencyId;
    data['currency'] = currency;
    data['currency_symbol'] = currencySymbol;
    data['verification'] = verification;
    data['notification'] = notification;
    data['license_code'] = licenseCode;
    data['client_name'] = clientName;
    data['license_status'] = licenseStatus;
    data['app_id'] = appId;
    data['rest_api_key'] = restApiKey;
    data['user_auth_key'] = userAuthKey;
    data['project_number'] = projectNumber;
    data['owner_app_id'] = ownerAppId;
    data['owner_rest_api_key'] = ownerRestApiKey;
    data['owner_auth_key'] = ownerAuthKey;
    data['guard_app_id'] = guardAppId;
    data['guard_rest_api_key'] = guardRestApiKey;
    data['guard_auth_key'] = guardAuthKey;
    data['stripe_public'] = stripePublic;
    data['stripe_status'] = stripeStatus;
    data['stripe_secret'] = stripeSecret;
    data['razorpay_status'] = razorpayStatus;
    data['razorpay_key'] = razorpayKey;
    data['paypal_status'] = paypalStatus;
    data['paypal_client_id'] = paypalClientId;
    data['paypal_secret_key'] = paypalSecretKey;
    data['flutterwave_status'] = flutterWaveStatus;
    data['flutterwave_key'] = flutterWaveKey;
    data['isLiveMode'] = isLiveMode;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class SettingModel {
  String? msg;
  SettingModelData? data;
  bool? success;

  SettingModel({
    this.msg,
    this.data,
    this.success,
  });

  SettingModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = (json['data'] != null && (json['data'] is Map)) ? SettingModelData.fromJson(json['data']) : null;
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['data'] = this.data!.toJson();
    data['success'] = success;
    return data;
  }
}
