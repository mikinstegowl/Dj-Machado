class LoginResponseModel {
  int? status;
  String? message;
  int? userId;
  String? userName;
  String? email;
  String? fcmId;
  int? notificationCount;
  bool? loginStatus;
  bool? genresSelected;
  dynamic genresId;
  String? token;

  LoginResponseModel(
      {this.status,
      this.message,
      this.userId,
      this.userName,
      this.email,
      this.fcmId,
      this.notificationCount,
      this.loginStatus,
      this.genresSelected,
      this.genresId,
      this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    userId = json['user_id'];
    userName = json['user_name'];
    email = json['email'];
    fcmId = json['fcm_id'];
    notificationCount = json['notification_count'];
    loginStatus = json['login_status'];
    genresSelected = json['genres_selected'];
    genresId = json['genres_id'] != null ? json['genres_id'] : [];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    data['user_id'] = this.userId;
    data['user_name'] = this.userName;
    data['email'] = this.email;
    data['fcm_id'] = this.fcmId;
    data['notification_count'] = this.notificationCount;
    data['login_status'] = this.loginStatus;
    data['genres_selected'] = this.genresSelected;
    data['genres_id'] = this.genresId;
    data['token'] = this.token;
    return data;
  }
}
