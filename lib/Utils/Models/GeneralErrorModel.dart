class GeneralErrorModel {
  // bool? error;
  int? code;
  String? message;
  String? data;

  GeneralErrorModel({this.message, this.code, this.data});

  factory GeneralErrorModel.fromJson(Map<String, dynamic>? json) {
    return GeneralErrorModel(
        code: json?['status'], message: json?['message'], data: json?['data']);
    // error = json['error'];
    // if (json["message"] is List) {
    // message =
    // // } else {
    // //   message = json['message'] ?? json["msg"] ?? "Something went wrong!";
    // // }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.code;
    data['message'] = this.message;
    data['data'] = this.data;
    return data;
  }
}
