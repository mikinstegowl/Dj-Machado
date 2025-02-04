class ArtistsDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<PopularArtist>? popularArtist;
  List<PopularArtist>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  ArtistsDataModel(
      {this.status,
      this.message,
      this.imageAssets,
      this.popularArtist,
      this.data,
      this.perPage,
      this.currentPage,
      this.lastPage});

  ArtistsDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    if (json['popular_artist'] != null) {
      popularArtist = <PopularArtist>[];
      json['popular_artist'].forEach((v) {
        popularArtist!.add(new PopularArtist.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <PopularArtist>[];
      json['data'].forEach((v) {
        data!.add(new PopularArtist.fromJson(v));
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
    if (this.popularArtist != null) {
      data['popular_artist'] =
          this.popularArtist!.map((v) => v.toJson()).toList();
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

class PopularArtist {
  int? artistsId;
  String? artistsImage;
  String? originalImage;
  String? artistsName;
  String? createdAt;

  PopularArtist(
      {this.artistsId,
      this.artistsImage,
      this.originalImage,
      this.artistsName,
      this.createdAt});

  PopularArtist.fromJson(Map<String, dynamic> json) {
    artistsId = json['artists_id'];
    artistsImage = json['artists_image'];
    originalImage = json['original_image'];
    artistsName = json['artists_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artists_id'] = this.artistsId;
    data['artists_image'] = this.artistsImage;
    data['original_image'] = this.originalImage;
    data['artists_name'] = this.artistsName;
    data['created_at'] = this.createdAt;
    return data;
  }
}