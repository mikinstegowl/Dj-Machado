class CreateUserModel {
  int? status;
  String? message;
  int? userId;
  String? fcmId;
  String? userName;
  String? email;
  String? deviceType;
  String? token;

  CreateUserModel(
      {this.status,
      this.message,
      this.userId,
      this.fcmId,
      this.userName,
      this.email,
      this.deviceType,
      this.token});

  CreateUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    fcmId = json['fcm_id'];
    userName = json['user_name'];
    email = json['email'];
    deviceType = json['device_type'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['fcm_id'] = this.fcmId;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['device_type'] = this.deviceType;
    data['token'] = this.token;
    return data;
  }
}
