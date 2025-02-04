class SongDetailDataModel {
  int? status;
  String? message;
  List<Data>? data;

  SongDetailDataModel({this.status, this.message, this.data});

  SongDetailDataModel.fromJson(Map<String, dynamic> json) {
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
  int? songId;
  String? songImage;
  String? originalImage;
  String? songName;
  String? songArtist;
  String? song;
  String? songDuration;
  List<FeatureArtists>? featureArtists;
  int? favouritesCount;
  bool? favouritesStatus;
  int? totalPlayed;
  int? totalDownloads;
  int? playlistCount;
  bool? playlistStatus;

  Data(
      {this.songId,
        this.songImage,
        this.originalImage,
        this.songName,
        this.songArtist,
        this.song,
        this.songDuration,
        this.featureArtists,
        this.favouritesCount,
        this.favouritesStatus,
        this.totalPlayed,
        this.totalDownloads,
        this.playlistCount,
        this.playlistStatus});

  Data.fromJson(Map<String, dynamic> json) {
    songId = json['song_id'];
    songImage = json['song_image'];
    originalImage = json['original_image'];
    songName = json['song_name'];
    songArtist = json['song_artist'];
    song = json['song'];
    songDuration = json['song_duration'];
    if (json['feature_artists'] != null) {
      featureArtists = <FeatureArtists>[];
      json['feature_artists'].forEach((v) {
        featureArtists!.add(new FeatureArtists.fromJson(v));
      });
    }
    favouritesCount = json['favourites_count'];
    favouritesStatus = json['favourites_status'];
    totalPlayed = json['total_played'];
    totalDownloads = json['total_downloads'];
    playlistCount = json['playlist_count'];
    playlistStatus = json['playlist_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['song_id'] = this.songId;
    data['song_image'] = this.songImage;
    data['original_image'] = this.originalImage;
    data['song_name'] = this.songName;
    data['song_artist'] = this.songArtist;
    data['song'] = this.song;
    data['song_duration'] = this.songDuration;
    if (this.featureArtists != null) {
      data['feature_artists'] =
          this.featureArtists!.map((v) => v.toJson()).toList();
    }
    data['favourites_count'] = this.favouritesCount;
    data['favourites_status'] = this.favouritesStatus;
    data['total_played'] = this.totalPlayed;
    data['total_downloads'] = this.totalDownloads;
    data['playlist_count'] = this.playlistCount;
    data['playlist_status'] = this.playlistStatus;
    return data;
  }
}

class FeatureArtists {
  int? artistsId;
  String? artistsName;
  String? artistsImage;
  String? originalImage;

  FeatureArtists(
      {this.artistsId,
        this.artistsName,
        this.artistsImage,
        this.originalImage});

  FeatureArtists.fromJson(Map<String, dynamic> json) {
    artistsId = json['artists_id'];
    artistsName = json['artists_name'];
    artistsImage = json['artists_image'];
    originalImage = json['original_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['artists_id'] = this.artistsId;
    data['artists_name'] = this.artistsName;
    data['artists_image'] = this.artistsImage;
    data['original_image'] = this.originalImage;
    return data;
  }
}
