class TimezoneDataModel {
  int? status;
  String? message;
  List<Data>? data;

  TimezoneDataModel({this.status, this.message, this.data});

  TimezoneDataModel.fromJson(Map<String, dynamic> json) {
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
  int? zoneId;
  String? countryCode;
  String? zoneName;

  Data({this.zoneId, this.countryCode, this.zoneName});

  Data.fromJson(Map<String, dynamic> json) {
    zoneId = json['zone_id'];
    countryCode = json['country_code'];
    zoneName = json['zone_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['zone_id'] = this.zoneId;
    data['country_code'] = this.countryCode;
    data['zone_name'] = this.zoneName;
    return data;
  }
}
