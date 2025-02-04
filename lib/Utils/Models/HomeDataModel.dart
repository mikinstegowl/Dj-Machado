
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart' as mx;

class HomeDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<mx.MostPlayed>? recommendedTracks;
  List<FirstTrendingsData>? firstTrendingsData;
  List<mx.MostPlayed>? recentPlayed;
  List<mx.MostPlayed>? mostPlayed;
  List<FirstTrendingsData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  HomeDataModel(
      {this.status,
      this.message,
      this.imageAssets,
      this.recommendedTracks,
      this.firstTrendingsData,
      this.recentPlayed,
      this.mostPlayed,
      this.data,
      this.perPage,
      this.currentPage,
      this.lastPage});

  HomeDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    if (json['recommended_tracks'] != null) {
      recommendedTracks = <mx.MostPlayed>[];
      json['recommended_tracks'].forEach((v) {
        recommendedTracks!.add(new mx.MostPlayed.fromJson(v));
      });
    }
    if (json['first_trendings_data'] != null) {
      firstTrendingsData = <FirstTrendingsData>[];
      json['first_trendings_data'].forEach((v) {
        firstTrendingsData!.add(new FirstTrendingsData.fromJson(v));
      });
    }
    if (json['recent_played'] != null) {
      recentPlayed = <mx.MostPlayed>[];
      json['recent_played'].forEach((v) {
        recentPlayed!.add(new mx.MostPlayed.fromJson(v));
      });
    }
    if (json['most_played'] != null) {
      mostPlayed = <mx.MostPlayed>[];
      json['most_played'].forEach((v) {
        mostPlayed!.add(new mx.MostPlayed.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <FirstTrendingsData>[];
      json['data'].forEach((v) {
        data!.add(new FirstTrendingsData.fromJson(v));
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
    if (this.recommendedTracks != null) {
      data['recommended_tracks'] =
          this.recommendedTracks!.map((v) => v.toJson()).toList();
    }
    if (this.firstTrendingsData != null) {
      data['first_trendings_data'] =
          this.firstTrendingsData!.map((v) => v.toJson()).toList();
    }
    if (this.recentPlayed != null) {
      data['recent_played'] =
          this.recentPlayed!.map((v) => v.toJson()).toList();
    }
    if (this.mostPlayed != null) {
      data['most_played'] = this.mostPlayed!.map((v) => v.toJson()).toList();
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

class RecommendedTracks {
  String? recommendedId;
  int? genresId;
  int? songId;
  String? songImage;
  String? originalImage;
  String? songName;
  String? songArtist;
  String? song;
  String? songDuration;
  int? favouritesCount;
  bool? favouritesStatus;
  int? totalPlayed;
  int? totalDownloads;
  int? playlistCount;
  bool? playlistStatus;

  RecommendedTracks(
      {this.recommendedId,
      this.genresId,
      this.songId,
      this.songImage,
      this.originalImage,
      this.songName,
      this.songArtist,
      this.song,
      this.songDuration,
      this.favouritesCount,
      this.favouritesStatus,
      this.totalPlayed,
      this.totalDownloads,
      this.playlistCount,
      this.playlistStatus});

  RecommendedTracks.fromJson(Map<String, dynamic> json) {
    recommendedId = json['recommended_id'];
    genresId = json['genres_id'];
    songId = json['song_id'];
    songImage = json['song_image'];
    originalImage = json['original_image'];
    songName = json['song_name'];
    songArtist = json['song_artist'];
    song = json['song'];
    songDuration = json['song_duration'];
    favouritesCount = json['favourites_count'];
    favouritesStatus = json['favourites_status'];
    totalPlayed = json['total_played'];
    totalDownloads = json['total_downloads'];
    playlistCount = json['playlist_count'];
    playlistStatus = json['playlist_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recommended_id'] = this.recommendedId;
    data['genres_id'] = this.genresId;
    data['song_id'] = this.songId;
    data['song_image'] = this.songImage;
    data['original_image'] = this.originalImage;
    data['song_name'] = this.songName;
    data['song_artist'] = this.songArtist;
    data['song'] = this.song;
    data['song_duration'] = this.songDuration;
    data['favourites_count'] = this.favouritesCount;
    data['favourites_status'] = this.favouritesStatus;
    data['total_played'] = this.totalPlayed;
    data['total_downloads'] = this.totalDownloads;
    data['playlist_count'] = this.playlistCount;
    data['playlist_status'] = this.playlistStatus;
    return data;
  }
}

class RecentPlayed {
  int? recentId;
  int? songId;
  String? songImage;
  String? originalImage;
  String? songName;
  String? songArtist;
  String? song;
  String? songDuration;
  int? favouritesCount;
  bool? favouritesStatus;
  int? totalPlayed;
  int? totalDownloads;
  int? playlistCount;
  bool? playlistStatus;

  RecentPlayed(
      {this.recentId,
      this.songId,
      this.songImage,
      this.originalImage,
      this.songName,
      this.songArtist,
      this.song,
      this.songDuration,
      this.favouritesCount,
      this.favouritesStatus,
      this.totalPlayed,
      this.totalDownloads,
      this.playlistCount,
      this.playlistStatus});

  RecentPlayed.fromJson(Map<String, dynamic> json) {
    recentId = json['recent_id'];
    songId = json['song_id'];
    songImage = json['song_image'];
    originalImage = json['original_image'];
    songName = json['song_name'];
    songArtist = json['song_artist'];
    song = json['song'];
    songDuration = json['song_duration'];
    favouritesCount = json['favourites_count'];
    favouritesStatus = json['favourites_status'];
    totalPlayed = json['total_played'];
    totalDownloads = json['total_downloads'];
    playlistCount = json['playlist_count'];
    playlistStatus = json['playlist_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['recent_id'] = this.recentId;
    data['song_id'] = this.songId;
    data['song_image'] = this.songImage;
    data['original_image'] = this.originalImage;
    data['song_name'] = this.songName;
    data['song_artist'] = this.songArtist;
    data['song'] = this.song;
    data['song_duration'] = this.songDuration;
    data['favourites_count'] = this.favouritesCount;
    data['favourites_status'] = this.favouritesStatus;
    data['total_played'] = this.totalPlayed;
    data['total_downloads'] = this.totalDownloads;
    data['playlist_count'] = this.playlistCount;
    data['playlist_status'] = this.playlistStatus;
    return data;
  }
}

class TrendingsCategoryData {
  int? trendingscategoryId;
  String? trendingscategoryImage;
  String? originalImage;
  String? trendingscategoryName;
  String? trendingscategoryFor;
  List<Data>? data;

  TrendingsCategoryData(
      {this.trendingscategoryId,
      this.trendingscategoryImage,
      this.originalImage,
      this.trendingscategoryName,
      this.trendingscategoryFor,
      this.data});

  TrendingsCategoryData.fromJson(Map<String, dynamic> json) {
    trendingscategoryId = json['trendingscategory_id'];
    trendingscategoryImage = json['trendingscategory_image'];
    originalImage = json['original_image'];
    trendingscategoryName = json['trendingscategory_name'];
    trendingscategoryFor = json['trendingscategory_for'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trendingscategory_id'] = this.trendingscategoryId;
    data['trendingscategory_image'] = this.trendingscategoryImage;
    data['original_image'] = this.originalImage;
    data['trendingscategory_name'] = this.trendingscategoryName;
    data['trendingscategory_for'] = this.trendingscategoryFor;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FirstTrendingsData {
  int? trendingscategoryId;
  String? trendingscategoryImage;
  String? originalImage;
  String? trendingscategoryName;
  String? trendingscategoryFor;
  int? flowactivotrendingscategoryId;
  String? flowactivotrendingscategoryImage;
  String? flowactivotrendingscategoryName;
  String? flowactivotrendingscategoryFor;
  List<Data>? data;

  FirstTrendingsData(
      {this.trendingscategoryId,
      this.trendingscategoryImage,
        this.flowactivotrendingscategoryId,
        this.flowactivotrendingscategoryImage,
        this.originalImage,
        this.flowactivotrendingscategoryName,
        this.flowactivotrendingscategoryFor,
      this.trendingscategoryName,
      this.trendingscategoryFor,
      this.data});

  FirstTrendingsData.fromJson(Map<String, dynamic> json) {
    trendingscategoryId = json['trendingscategory_id']??json['flowactivotrendingscategory_id'];
    trendingscategoryImage = json['trendingscategory_image']?? json['flowactivotrendingscategory_image'];
    originalImage = json['original_image'];
    trendingscategoryName = json['trendingscategory_name']??json['flowactivotrendingscategory_name'];
    trendingscategoryFor = json['trendingscategory_for']??json['flowactivotrendingscategory_for'];
    flowactivotrendingscategoryId = json['flowactivotrendingscategory_id'];
    flowactivotrendingscategoryImage =
    json['flowactivotrendingscategory_image'];
    originalImage = json['original_image'];
    flowactivotrendingscategoryName = json['flowactivotrendingscategory_name'];
    flowactivotrendingscategoryFor = json['flowactivotrendingscategory_for'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['trendingscategory_id'] = this.trendingscategoryId;
    data['trendingscategory_image'] = this.trendingscategoryImage;
    data['flowactivotrendingscategory_id'] = this.flowactivotrendingscategoryId;
    data['flowactivotrendingscategory_image'] =
        this.flowactivotrendingscategoryImage;
    data['original_image'] = this.originalImage;
    data['flowactivotrendingscategory_name'] =
        this.flowactivotrendingscategoryName;
    data['flowactivotrendingscategory_for'] =
        this.flowactivotrendingscategoryFor;
    data['trendingscategory_name'] = this.trendingscategoryName;
    data['trendingscategory_for'] = this.trendingscategoryFor;

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
