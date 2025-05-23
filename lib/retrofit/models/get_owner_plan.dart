class GetOwnerPlanDataSubscriptionData {
  String? id;
  String? ownerId;
  String? planId;
  String? subId;
  String? price;
  String? startAt;
  String? endAt;
  String? createdAt;
  String? updatedAt;
  String? timeLeft;

  GetOwnerPlanDataSubscriptionData({
    this.id,
    this.ownerId,
    this.planId,
    this.subId,
    this.price,
    this.startAt,
    this.endAt,
    this.createdAt,
    this.updatedAt,
    this.timeLeft,
  });

  GetOwnerPlanDataSubscriptionData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    ownerId = json['owner_id']?.toString();
    planId = json['plan_id']?.toString();
    subId = json['sub_id']?.toString();
    price = json['price']?.toString();
    startAt = json['start_at']?.toString();
    endAt = json['end_at']?.toString();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    timeLeft = json['time_left']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['plan_id'] = planId;
    data['sub_id'] = subId;
    data['price'] = price;
    data['start_at'] = startAt;
    data['end_at'] = endAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['time_left'] = timeLeft;
    return data;
  }
}

class GetOwnerPlanDataCustomerDataInvoiceSettings {
  String? customFields;
  String? defaultPaymentMethod;
  String? footer;

  GetOwnerPlanDataCustomerDataInvoiceSettings({
    this.customFields,
    this.defaultPaymentMethod,
    this.footer,
  });

  GetOwnerPlanDataCustomerDataInvoiceSettings.fromJson(Map<String, dynamic> json) {
    customFields = json['custom_fields']?.toString();
    defaultPaymentMethod = json['default_payment_method']?.toString();
    footer = json['footer']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['custom_fields'] = customFields;
    data['default_payment_method'] = defaultPaymentMethod;
    data['footer'] = footer;
    return data;
  }
}

class GetOwnerPlanDataCustomerData {
  String? id;
  String? object;
  String? address;
  String? balance;
  String? created;
  String? currency;
  String? defaultSource;
  bool? delinquent;
  String? description;
  String? discount;
  String? email;
  String? invoicePrefix;
  GetOwnerPlanDataCustomerDataInvoiceSettings? invoiceSettings;
  bool? liveMode;
  List<String?>? metadata;
  String? name;
  String? nextInvoiceSequence;
  String? phone;
  List<String?>? preferredLocales;
  String? shipping;
  String? taxExempt;
  String? testClock;

  GetOwnerPlanDataCustomerData({
    this.id,
    this.object,
    this.address,
    this.balance,
    this.created,
    this.currency,
    this.defaultSource,
    this.delinquent,
    this.description,
    this.discount,
    this.email,
    this.invoicePrefix,
    this.invoiceSettings,
    this.liveMode,
    this.metadata,
    this.name,
    this.nextInvoiceSequence,
    this.phone,
    this.preferredLocales,
    this.shipping,
    this.taxExempt,
    this.testClock,
  });

  GetOwnerPlanDataCustomerData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    object = json['object']?.toString();
    address = json['address']?.toString();
    balance = json['balance']?.toString();
    created = json['created']?.toString();
    currency = json['currency']?.toString();
    defaultSource = json['default_source']?.toString();
    delinquent = json['delinquent'];
    description = json['description']?.toString();
    discount = json['discount']?.toString();
    email = json['email']?.toString();
    invoicePrefix = json['invoice_prefix']?.toString();
    invoiceSettings = (json['invoice_settings'] != null && (json['invoice_settings'] is Map)) ? GetOwnerPlanDataCustomerDataInvoiceSettings.fromJson(json['invoice_settings']) : null;
    liveMode = json['livemode'];
    name = json['name']?.toString();
    nextInvoiceSequence = json['next_invoice_sequence']?.toString();
    phone = json['phone']?.toString();
    shipping = json['shipping']?.toString();
    taxExempt = json['tax_exempt']?.toString();
    testClock = json['test_clock']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['address'] = address;
    data['balance'] = balance;
    data['created'] = created;
    data['currency'] = currency;
    data['default_source'] = defaultSource;
    data['delinquent'] = delinquent;
    data['description'] = description;
    data['discount'] = discount;
    data['email'] = email;
    data['invoice_prefix'] = invoicePrefix;
    if (invoiceSettings != null) {
      data['invoice_settings'] = invoiceSettings!.toJson();
    }
    data['livemode'] = liveMode;
    data['name'] = name;
    data['next_invoice_sequence'] = nextInvoiceSequence;
    data['phone'] = phone;
    data['shipping'] = shipping;
    data['tax_exempt'] = taxExempt;
    data['test_clock'] = testClock;
    return data;
  }
}

class GetOwnerPlanDataCard {
  String? id;
  String? object;
  String? addressCity;
  String? addressCountry;
  String? addressLine1;
  String? addressLine1Check;
  String? addressLine2;
  String? addressState;
  String? addressZip;
  String? addressZipCheck;
  String? brand;
  String? country;
  String? customer;
  String? cvcCheck;
  String? dynamicLast4;
  String? expMonth;
  String? expYear;
  String? fingerprint;
  String? funding;
  String? last4;
  List<String?>? metadata;
  String? name;
  String? tokenizationMethod;

  GetOwnerPlanDataCard({
    this.id,
    this.object,
    this.addressCity,
    this.addressCountry,
    this.addressLine1,
    this.addressLine1Check,
    this.addressLine2,
    this.addressState,
    this.addressZip,
    this.addressZipCheck,
    this.brand,
    this.country,
    this.customer,
    this.cvcCheck,
    this.dynamicLast4,
    this.expMonth,
    this.expYear,
    this.fingerprint,
    this.funding,
    this.last4,
    this.metadata,
    this.name,
    this.tokenizationMethod,
  });

  GetOwnerPlanDataCard.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    object = json['object']?.toString();
    addressCity = json['address_city']?.toString();
    addressCountry = json['address_country']?.toString();
    addressLine1 = json['address_line1']?.toString();
    addressLine1Check = json['address_line1_check']?.toString();
    addressLine2 = json['address_line2']?.toString();
    addressState = json['address_state']?.toString();
    addressZip = json['address_zip']?.toString();
    addressZipCheck = json['address_zip_check']?.toString();
    brand = json['brand']?.toString();
    country = json['country']?.toString();
    customer = json['customer']?.toString();
    cvcCheck = json['cvc_check']?.toString();
    dynamicLast4 = json['dynamic_last4']?.toString();
    expMonth = json['exp_month']?.toString();
    expYear = json['exp_year']?.toString();
    fingerprint = json['fingerprint']?.toString();
    funding = json['funding']?.toString();
    last4 = json['last4']?.toString();
    name = json['name']?.toString();
    tokenizationMethod = json['tokenization_method']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['address_city'] = addressCity;
    data['address_country'] = addressCountry;
    data['address_line1'] = addressLine1;
    data['address_line1_check'] = addressLine1Check;
    data['address_line2'] = addressLine2;
    data['address_state'] = addressState;
    data['address_zip'] = addressZip;
    data['address_zip_check'] = addressZipCheck;
    data['brand'] = brand;
    data['country'] = country;
    data['customer'] = customer;
    data['cvc_check'] = cvcCheck;
    data['dynamic_last4'] = dynamicLast4;
    data['exp_month'] = expMonth;
    data['exp_year'] = expYear;
    data['fingerprint'] = fingerprint;
    data['funding'] = funding;
    data['last4'] = last4;
    data['name'] = name;
    data['tokenization_method'] = tokenizationMethod;
    return data;
  }
}

class GetOwnerPlanDataPlanProduct {
  String? id;
  String? object;
  bool? active;
  List<String?>? attributes;
  String? created;
  String? description;
  List<String?>? images;
  bool? liveMode;
  List<String?>? metadata;
  String? name;
  String? packageDimensions;
  String? shippable;
  String? statementDescriptor;
  String? taxCode;
  String? type;
  String? unitLabel;
  String? updated;
  String? url;

  GetOwnerPlanDataPlanProduct({
    this.id,
    this.object,
    this.active,
    this.attributes,
    this.created,
    this.description,
    this.images,
    this.liveMode,
    this.metadata,
    this.name,
    this.packageDimensions,
    this.shippable,
    this.statementDescriptor,
    this.taxCode,
    this.type,
    this.unitLabel,
    this.updated,
    this.url,
  });

  GetOwnerPlanDataPlanProduct.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    object = json['object']?.toString();
    active = json['active'];
    created = json['created']?.toString();
    description = json['description']?.toString();
    liveMode = json['livemode'];
    name = json['name']?.toString();
    packageDimensions = json['package_dimensions']?.toString();
    shippable = json['shippable']?.toString();
    statementDescriptor = json['statement_descriptor']?.toString();
    taxCode = json['tax_code']?.toString();
    type = json['type']?.toString();
    unitLabel = json['unit_label']?.toString();
    updated = json['updated']?.toString();
    url = json['url']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['active'] = active;
    data['created'] = created;
    data['description'] = description;
    data['livemode'] = liveMode;
    data['name'] = name;
    data['package_dimensions'] = packageDimensions;
    data['shippable'] = shippable;
    data['statement_descriptor'] = statementDescriptor;
    data['tax_code'] = taxCode;
    data['type'] = type;
    data['unit_label'] = unitLabel;
    data['updated'] = updated;
    data['url'] = url;
    return data;
  }
}

class GetOwnerPlanDataPlan {
  String? id;
  String? object;
  bool? active;
  String? aggregateUsage;
  String? amount;
  String? amountDecimal;
  String? billingScheme;
  String? created;
  String? currency;
  String? interval;
  String? intervalCount;
  bool? liveMode;
  List<String?>? metadata;
  String? nickname;
  GetOwnerPlanDataPlanProduct? product;
  String? tiersMode;
  String? transformUsage;
  String? trialPeriodDays;
  String? usageType;

  GetOwnerPlanDataPlan({
    this.id,
    this.object,
    this.active,
    this.aggregateUsage,
    this.amount,
    this.amountDecimal,
    this.billingScheme,
    this.created,
    this.currency,
    this.interval,
    this.intervalCount,
    this.liveMode,
    this.metadata,
    this.nickname,
    this.product,
    this.tiersMode,
    this.transformUsage,
    this.trialPeriodDays,
    this.usageType,
  });

  GetOwnerPlanDataPlan.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toString();
    object = json['object']?.toString();
    active = json['active'];
    aggregateUsage = json['aggregate_usage']?.toString();
    amount = json['amount']?.toString();
    amountDecimal = json['amount_decimal']?.toString();
    billingScheme = json['billing_scheme']?.toString();
    created = json['created']?.toString();
    currency = json['currency']?.toString();
    interval = json['interval']?.toString();
    intervalCount = json['interval_count']?.toString();
    liveMode = json['livemode'];
    nickname = json['nickname']?.toString();
    product = (json['product'] != null && (json['product'] is Map)) ? GetOwnerPlanDataPlanProduct.fromJson(json['product']) : null;
    tiersMode = json['tiers_mode']?.toString();
    transformUsage = json['transform_usage']?.toString();
    trialPeriodDays = json['trial_period_days']?.toString();
    usageType = json['usage_type']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['object'] = object;
    data['active'] = active;
    data['aggregate_usage'] = aggregateUsage;
    data['amount'] = amount;
    data['amount_decimal'] = amountDecimal;
    data['billing_scheme'] = billingScheme;
    data['created'] = created;
    data['currency'] = currency;
    data['interval'] = interval;
    data['interval_count'] = intervalCount;
    data['livemode'] = liveMode;
    data['nickname'] = nickname;
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['tiers_mode'] = tiersMode;
    data['transform_usage'] = transformUsage;
    data['trial_period_days'] = trialPeriodDays;
    data['usage_type'] = usageType;
    return data;
  }
}

class GetOwnerPlanData {
  List<GetOwnerPlanDataPlan?>? plan;
  List<GetOwnerPlanDataCard?>? card;
  GetOwnerPlanDataCustomerData? customerData;
  GetOwnerPlanDataSubscriptionData? subscriptionData;

  GetOwnerPlanData({
    this.plan,
    this.card,
    this.customerData,
    this.subscriptionData,
  });

  GetOwnerPlanData.fromJson(Map<String, dynamic> json) {
    if (json['plan'] != null && (json['plan'] is List)) {
      final v = json['plan'];
      final arr0 = <GetOwnerPlanDataPlan>[];
      v.forEach((v) {
        arr0.add(GetOwnerPlanDataPlan.fromJson(v));
      });
      plan = arr0;
    }
    if (json['card'] != null && (json['card'] is List)) {
      final v = json['card'];
      final arr0 = <GetOwnerPlanDataCard>[];
      v.forEach((v) {
        arr0.add(GetOwnerPlanDataCard.fromJson(v));
      });
      card = arr0;
    }
    customerData = (json['customer_data'] != null && (json['customer_data'] is Map)) ? GetOwnerPlanDataCustomerData.fromJson(json['customer_data']) : null;
    subscriptionData = (json['subscription_data'] != null && (json['subscription_data'] is Map)) ? GetOwnerPlanDataSubscriptionData.fromJson(json['subscription_data']) : null;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (plan != null) {
      final v = plan;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['plan'] = arr0;
    }
    if (card != null) {
      final v = card;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['card'] = arr0;
    }
    if (customerData != null) {
      data['customer_data'] = customerData!.toJson();
    }
    if (subscriptionData != null) {
      data['subscription_data'] = subscriptionData!.toJson();
    }
    return data;
  }
}

class GetOwnerPlan {
  String? msg;
  GetOwnerPlanData? data;
  bool? success;

  GetOwnerPlan({
    this.msg,
    this.data,
    this.success,
  });

  GetOwnerPlan.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = (json['data'] != null && (json['data'] is Map)) ? GetOwnerPlanData.fromJson(json['data']) : null;
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
