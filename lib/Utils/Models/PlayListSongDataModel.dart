import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';

class PlayListSongDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;
  List<MixesTracksData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  PlayListSongDataModel(
      {this.status,
        this.message,
        this.imageAssets,
        this.data,
        this.perPage,
        this.currentPage,
        this.lastPage});

  PlayListSongDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_Assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_Assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    if (json['data'] != null) {
      data = <MixesTracksData>[];
      json['data'].forEach((v) {
        data!.add(new MixesTracksData.fromJson(v));
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
      data['image_Assets'] = this.imageAssets!.map((v) => v.toJson()).toList();
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

class Data {
  int? playlistssongsId;
  int? playlistsId;
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

  Data(
      {this.playlistssongsId,
        this.playlistsId,
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

  Data.fromJson(Map<String, dynamic> json) {
    playlistssongsId = json['playlistssongs_id'];
    playlistsId = json['playlists_id'];
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
    data['playlistssongs_id'] = this.playlistssongsId;
    data['playlists_id'] = this.playlistsId;
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
