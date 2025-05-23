class NewCardAddModel {
  String? msg;
  String? data;
  bool? success;

  NewCardAddModel({
    this.msg,
    this.data,
    this.success,
  });

  NewCardAddModel.fromJson(Map<String, dynamic> json) {
    msg = json['msg']?.toString();
    data = json['data']?.toString();
    success = json['success'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['msg'] = msg;
    data['data'] = this.data;
    data['success'] = success;
    return data;
  }
}
