import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';

class AdvanceSearchSongDataModel {
  int? status;
  String? message;
  List<MixesTracksData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  AdvanceSearchSongDataModel(
      {this.status,
      this.message,
      this.data,
      this.perPage,
      this.currentPage,
      this.lastPage});

  AdvanceSearchSongDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
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
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['per_page'] = this.perPage;
    data['current_page'] = this.currentPage;
    data['last_page'] = this.lastPage;
    return data;
  }
}

class AdvanceSearchSongData {
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

  AdvanceSearchSongData(
      {this.songId,
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

  AdvanceSearchSongData.fromJson(Map<String, dynamic> json) {
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
