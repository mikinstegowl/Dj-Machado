class SongModelClass {
  String? url;
  String? fileName;
  int? progress;
  bool? isDownloading;
  String? filePath;
  int? id;
  String? songName;
  String? artistName;
  String? imageUrl;
  int? favourite;

  SongModelClass(
      {this.url,
        this.favourite,
        this.fileName,
        this.imageUrl,
        this.progress,
        this.isDownloading,
        this.filePath,
        this.id,
        this.songName,
        this.artistName});

  SongModelClass.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    fileName = json['fileName'];
    progress = json['progress'];
    isDownloading = json['isDownloading'];
    filePath = json['filePath'];
    id = json['song_id'];
    songName = json['song_name'];
    artistName = json['artist_name'];
    favourite = json['favourite'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    data['fileName'] = this.fileName;
    data['progress'] = this.progress;
    data['isDownloading'] = this.isDownloading;
    data['filePath'] = this.filePath;
    data['song_id'] = this.id;
    data['favourite'] = this.favourite;
    data['song_name'] = this.songName;
    data['artist_name'] = this.artistName;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}
