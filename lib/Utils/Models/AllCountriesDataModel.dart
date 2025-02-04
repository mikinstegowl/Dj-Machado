class AllCountriesDataModel {
  dynamic status;
  String? message;
  List<CountriesData>? data;

  AllCountriesDataModel({this.status, this.message, this.data});

  AllCountriesDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CountriesData>[];
      json['data'].forEach((v) {
        data!.add(new CountriesData.fromJson(v));
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

class CountriesData {
  dynamic countryId;
  String? countryCode;
  String? name;
  dynamic phonecode;

  CountriesData({this.countryId, this.countryCode, this.name, this.phonecode});

  CountriesData.fromJson(Map<String, dynamic> json) {
    countryId = json['country_id'];
    countryCode = json['country_code'];
    name = json['name'];
    phonecode = json['phonecode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['country_id'] = this.countryId;
    data['country_code'] = this.countryCode;
    data['name'] = this.name;
    data['phonecode'] = this.phonecode;
    return data;
  }
}
