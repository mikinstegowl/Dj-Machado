class MixesDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<MixesData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  MixesDataModel(
      {this.status,
      this.message,
      this.imageAssets,
      this.data,
      this.perPage,
      this.currentPage,
      this.lastPage});

  MixesDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <MixesData>[];
      json['data'].forEach((v) {
        data!.add(new MixesData.fromJson(v));
      });
    }
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
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
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
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

class MixesData {
  int? mixesId;
  String? mixesImage;
  String? originalImage;
  String? mixesName;
  String? createdAt;

  MixesData(
      {this.mixesId,
      this.mixesImage,
      this.originalImage,
      this.mixesName,
      this.createdAt});

  MixesData.fromJson(Map<String, dynamic> json) {
    mixesId = json['mixes_id'];
    mixesImage = json['mixes_image'];
    originalImage = json['original_image'];
    mixesName = json['mixes_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mixes_id'] = this.mixesId;
    data['mixes_image'] = this.mixesImage;
    data['original_image'] = this.originalImage;
    data['mixes_name'] = this.mixesName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
