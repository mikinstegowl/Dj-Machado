class ProfileDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<Data>? data;

  ProfileDataModel({this.status, this.message, this.imageAssets, this.data});

  ProfileDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
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
    if (this.imageAssets != null) {
      data['image_assets'] = this.imageAssets!.map((v) => v.toJson()).toList();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ImageAssets {
  String? displayType;
  String? imageType;
  ImageSize? imageSize;

  ImageAssets({this.displayType, this.imageType, this.imageSize});

  ImageAssets.fromJson(Map<String, dynamic> json) {
    displayType = json['display_type'];
    imageType = json['image_type'];
    imageSize = json['image_size'] != null
        ? new ImageSize.fromJson(json['image_size'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['display_type'] = this.displayType;
    data['image_type'] = this.imageType;
    if (this.imageSize != null) {
      data['image_size'] = this.imageSize!.toJson();
    }
    return data;
  }
}

class ImageSize {
  String? height;
  String? width;

  ImageSize({this.height, this.width});

  ImageSize.fromJson(Map<String, dynamic> json) {
    height = json['height'];
    width = json['width'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['height'] = this.height;
    data['width'] = this.width;
    return data;
  }
}

class Data {
  String? fcmId;
  int? notificationCount;
  String? image;
  String? userName;
  String? name;
  String? email;
  String? contact;
  String? birthdate;
  int? country;
  int? countryId;
  String? timezone;

  Data(
      {this.fcmId,
      this.notificationCount,
      this.image,
      this.userName,
      this.name,
      this.email,
      this.contact,
      this.birthdate,
      this.country,
      this.countryId,
      this.timezone});

  Data.fromJson(Map<String, dynamic> json) {
    fcmId = json['fcm_id'];
    notificationCount = json['notification_count'];
    image = json['image'];
    userName = json['user_name'];
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
    birthdate = json['birthdate'];
    country = json['country'];
    countryId = json['country_id'];
    timezone = json['timezone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fcm_id'] = this.fcmId;
    data['notification_count'] = this.notificationCount;
    data['image'] = this.image;
    data['user_name'] = this.userName;
    data['name'] = this.name;
    data['email'] = this.email;
    data['contact'] = this.contact;
    data['birthdate'] = this.birthdate;
    data['country'] = this.country;
    data['country_id'] = this.countryId;
    data['timezone'] = this.timezone;
    return data;
  }
}
