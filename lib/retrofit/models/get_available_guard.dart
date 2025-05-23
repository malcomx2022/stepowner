class GetAvailableGuardData {
  int? id;
  int? ownerId;
  String? spaceId;
  String? name;
  String? email;
  String? phoneNo;
  String? image;
  String? password;
  int? status;
  String? createdAt;
  String? updatedAt;
  String? imageUri;
  bool isCheck = false;

  GetAvailableGuardData({
    this.id,
    this.ownerId,
    this.spaceId,
    this.name,
    this.email,
    this.phoneNo,
    this.image,
    this.password,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.imageUri,
    required this.isCheck,
  });

  GetAvailableGuardData.fromJson(Map<String, dynamic> json) {
    id = json['id']?.toInt();
    ownerId = json['owner_id']?.toInt();
    spaceId = json['space_id']?.toString();
    name = json['name']?.toString();
    email = json['email']?.toString();
    phoneNo = json['phone_no']?.toString();
    image = json['image']?.toString();
    password = json['password']?.toString();
    status = json['status']?.toInt();
    createdAt = json['created_at']?.toString();
    updatedAt = json['updated_at']?.toString();
    imageUri = json['imageUri']?.toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['owner_id'] = ownerId;
    data['space_id'] = spaceId;
    data['name'] = name;
    data['email'] = email;
    data['phone_no'] = phoneNo;
    data['image'] = image;
    data['password'] = password;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['imageUri'] = imageUri;
    return data;
  }
}

class GetAvailableGuard {
  String? msg;
  List<GetAvailableGuardData?>? data;
  bool? success;

  GetAvailableGuard({
    this.msg,
    this.data,
    this.success,
  });

  GetAvailableGuard.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    if (json['data'] != null) {
      final v = json['data'];
      final arr0 = <GetAvailableGuardData>[];
      v.forEach((v) {
        arr0.add(GetAvailableGuardData.fromJson(v));
      });
      data = arr0;
    }
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    if (this.data != null) {
      final v = this.data;
      final arr0 = [];
      for (var v in v!) {
        arr0.add(v!.toJson());
      }
      data['data'] = arr0;
    }
    data['success'] = success;
    return data;
  }
}
