class albumModelClass {
  int? albumId;
  String? albumName;
  String? imageUrl;
  List<int>? songId;

  albumModelClass({this.albumId, this.albumName, this.imageUrl, this.songId});

  albumModelClass.fromJson(Map<String, dynamic> json) {
    albumId = json['album_id'];
    albumName = json['album_name'];
    imageUrl = json['imageUrl'];
    songId = json['song_id'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['album_id'] = this.albumId;
    data['album_name'] = this.albumName;
    data['imageUrl'] = this.imageUrl;
    data['song_id'] = this.songId;
    return data;
  }
}
