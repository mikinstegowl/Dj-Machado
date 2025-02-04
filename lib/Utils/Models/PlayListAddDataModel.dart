class PlayListAddDataModel {
  int? status;
  String? message;
  List<Data>? data;

  PlayListAddDataModel({this.status, this.message, this.data});

  PlayListAddDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'] ?? json['meesage'] ;
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
  int? userId;
  int? playlistsId;
  String? playlistsName;
  String? createdAt;

  Data({this.userId, this.playlistsId, this.playlistsName, this.createdAt});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    playlistsId = json['playlists_id'];
    playlistsName = json['playlists_name'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['playlists_id'] = this.playlistsId;
    data['playlists_name'] = this.playlistsName;
    data['created_at'] = this.createdAt;
    return data;
  }
}
