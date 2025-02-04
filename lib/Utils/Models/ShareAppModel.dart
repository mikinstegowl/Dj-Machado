class ShareAppModel {
  int? status;
  String? message;
  List<Data>? data;

  ShareAppModel({this.status, this.message, this.data});

  ShareAppModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? shareappId;
  String? shareappName;
  String? shareappAndroidLink;
  String? shareappIosLink;

  Data(
      {this.shareappId,
        this.shareappName,
        this.shareappAndroidLink,
        this.shareappIosLink});

  Data.fromJson(Map<String, dynamic> json) {
    shareappId = json['shareapp_id'];
    shareappName = json['shareapp_name'];
    shareappAndroidLink = json['shareapp_android_link'];
    shareappIosLink = json['shareapp_ios_link'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shareapp_id'] = this.shareappId;
    data['shareapp_name'] = this.shareappName;
    data['shareapp_android_link'] = this.shareappAndroidLink;
    data['shareapp_ios_link'] = this.shareappIosLink;
    return data;
  }
}
