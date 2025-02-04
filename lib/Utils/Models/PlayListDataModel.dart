import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';

class PlayListDataModel {
  int? status;
  String? message;
  List<PlayListData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  PlayListDataModel(
      {this.status,
        this.message,
        this.data,
        this.perPage,
        this.currentPage,
        this.lastPage});

  PlayListDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <PlayListData>[];
      json['data'].forEach((v) {
        data!.add(new PlayListData.fromJson(v));
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

class PlayListData {
  int? playlistsId;
  int? userId;
  String? playlistsName;
  int? songCount;
  List<PlaylistImages>? playlistImages;
  String? playlistImages1;
  String? createdAt;

  PlayListData(
      {this.playlistsId,
        this.userId,
        this.playlistImages1,
        this.playlistsName,
        this.songCount,
        this.playlistImages,
        this.createdAt});

  PlayListData.fromJson(Map<String, dynamic> json) {
    playlistsId = json['playlists_id'];
    userId = json['user_id'];
    playlistsName = json['playlists_name'];
    songCount = json['song_count'];
    if (json['playlist_images'] != null) {
      playlistImages = <PlaylistImages>[];
      json['playlist_images'].forEach((v) {
        playlistImages!.add(new PlaylistImages.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['playlists_id'] = this.playlistsId;
    data['user_id'] = this.userId;
    data['playlists_name'] = this.playlistsName;
    data['song_count'] = this.songCount;
    if (this.playlistImages != null) {
      data['playlist_images'] =
          this.playlistImages!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}
// // class PlaylistImages {
// //   String? image;
// //
// //   PlaylistImages({this.image});
// //
// //   PlaylistImages.fromJson(Map<String, dynamic> json) {
// //     image = json['image'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['image'] = this.image;
// //     return data;
// //   }
// }