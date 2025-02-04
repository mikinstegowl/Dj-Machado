class SkipUserModel {
  int? status;
  String? message;
  int? userId;
  String? fcmId;
  String? token;

  SkipUserModel(
      {this.status, this.message, this.userId, this.fcmId, this.token});

  SkipUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    fcmId = json['fcm_id'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['fcm_id'] = this.fcmId;
    data['token'] = this.token;
    return data;
  }
}
