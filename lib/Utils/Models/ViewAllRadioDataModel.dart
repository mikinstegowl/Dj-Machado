import 'ExplorDataModel.dart';

class ViewAllRadioDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<Data>? data;
  int? perPage;
  int? currentPage;

  int? lastPage;

  ViewAllRadioDataModel(
      {this.status,
        this.message,
        this.imageAssets,
        this.data,
        this.perPage,
        this.currentPage,
        this.lastPage});

  ViewAllRadioDataModel.fromJson(Map<String, dynamic> json) {
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

class Data1 {
  String? trendingscategoryFor;
  int? trendingsradioId;
  int? trendingscategoryId;
  String? trendingsradioName;
  String? trendingsradioUrl;
  String? trendingsradioImage;
  String? originalImage;
  int? genresId;
  String? genresName;
  String? genresImage;
  int? trendingsgenresId;

  Data1(
      {this.trendingscategoryFor,
        this.trendingsradioId,
        this.trendingscategoryId,
        this.trendingsradioName,
        this.trendingsradioUrl,
        this.trendingsgenresId,
        this.genresId,
        this.genresName,
        this.genresImage,
        this.trendingsradioImage,
        this.originalImage});

  Data1.fromJson(Map<String, dynamic> json) {
    trendingscategoryFor = json['trendingscategory_for'];
    trendingsradioId = json['trendingsradio_id'];
    trendingscategoryId = json['trendingscategory_id'];
    trendingsradioName = json['trendingsradio_name'];
    trendingsradioUrl = json['trendingsradio_url'];
    trendingsradioImage = json['trendingsradio_image'];
    trendingsgenresId = json['trendingsgenres_id'];
    genresId = json['genres_id'];
    genresName = json['genres_name'];
    genresImage = json['genres_image'];
    originalImage = json['original_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trendingscategory_for'] = this.trendingscategoryFor;
    data['trendingsradio_id'] = this.trendingsradioId;
    data['trendingscategory_id'] = this.trendingscategoryId;
    data['trendingsradio_name'] = this.trendingsradioName;
    data['trendingsradio_url'] = this.trendingsradioUrl;
    data['trendingsradio_image'] = this.trendingsradioImage;
    data['original_image'] = this.originalImage;
    data['trendingsgenres_id'] = this.trendingsgenresId;
    data['genres_id'] = this.genresId;
    data['genres_name'] = this.genresName;
    data['genres_image'] = this.genresImage;
    return data;
  }
}
