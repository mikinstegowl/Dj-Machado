class GoogleAdsModel {
  int? status;
  String? message;
  List<Data>? data;

  GoogleAdsModel({this.status, this.message, this.data});

  GoogleAdsModel.fromJson(Map<String, dynamic> json) {
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
  int? googleadsId;
  String? iosKey;
  String? iosInterestitial;
  String? androidKey;
  String? androidInterestitial;

  Data(
      {this.googleadsId,
        this.iosKey,
        this.iosInterestitial,
        this.androidKey,
        this.androidInterestitial});

  Data.fromJson(Map<String, dynamic> json) {
    googleadsId = json['googleads_id'];
    iosKey = json['ios_key'];
    iosInterestitial = json['ios_interestitial'];
    androidKey = json['android_key'];
    androidInterestitial = json['android_interestitial'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['googleads_id'] = this.googleadsId;
    data['ios_key'] = this.iosKey;
    data['ios_interestitial'] = this.iosInterestitial;
    data['android_key'] = this.androidKey;
    data['android_interestitial'] = this.androidInterestitial;
    return data;
  }
}
