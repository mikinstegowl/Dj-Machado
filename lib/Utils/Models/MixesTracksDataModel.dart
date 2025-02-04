class TracksDataModel {
  int? status;
  String? message;
  String? genresName;
  String? mixesName;
  String? albumsName;
  String? albumImage;
  String? mixesImage;
  List<ImageAssets>? imageAssets;
  List<MostPlayed>? mostPlayed;
  List<MixesTracksData>? data;
  dynamic perPage;
  int? currentPage;
  int? lastPage;

  TracksDataModel(
      {this.status,
        this.message,
        this.mixesName,
        this.mixesImage,
        this.imageAssets,
        this.mostPlayed,
        this.data,
        this.perPage,
        this.currentPage,
        this.lastPage});

  TracksDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['genres_name'] != null) {
      genresName = json['genres_name'];
    }
    if (json['genres_name'] != null) {
      mixesName = json['genres_name'];
    }
    if (json['artists_name'] != null) {
      mixesName = json['artists_name'];
    }
    if (json['albums_name'] != null) {
      albumsName = json['albums_name'];
    }
    if (json['albums_image'] != null) {
      albumImage = json['albums_image'];
    }
    mixesImage = json['mixes_image'] != null
        ? json['mixes_image']
        : json['artists_image'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    if (json['most_played'] != null) {
      mostPlayed = <MostPlayed>[];
      json['most_played'].forEach((v) {
        mostPlayed!.add(new MostPlayed.fromJson(v));
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
    data['mixes_name'] = this.mixesName;
    data['mixes_image'] = this.mixesImage;
    if (this.imageAssets != null) {
      data['image_assets'] = this.imageAssets!.map((v) => v.toJson()).toList();
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

class MostPlayed {
  int? mixesId;
  int? genresId;
  int? albumsId;
  int? songId;
  String? songImage;
  String? albumImage;
  String? artistsImage;
  String? artistsName;
  int? playlistsId;
  int? userId;
  String? playlistsName;
  int? songCount;
  String? songArtist;
  List<PlaylistImages>? playlistImages;
  String? albumsName;
  String? albumsArtist;
  String? originalImage;
  String? songName;
  String? song;
  String? songDuration;
  int? favouritesCount;
  bool? favouritesStatus;
  int? totalPlayed;
  int? totalDownloads;
  int? playlistCount;
  bool? playlistStatus;

  MostPlayed(
      {
        this.mixesId,
        this.songId,
        this.genresId,
        this.songImage,
        this.artistsImage,
        this.artistsName,
        this.originalImage,
        this.songName,
        this.userId,
        this.playlistImages,
        this.playlistsName,
        this.playlistsId,
        this.songCount,
        this.albumImage,
        this.albumsArtist,
        this.albumsName,
        this.songArtist,
        this.song,
        this.songDuration,
        this.favouritesCount,
        this.favouritesStatus,
        this.totalPlayed,
        this.totalDownloads,
        this.playlistCount,
        this.playlistStatus
      });

  MostPlayed.fromJson(Map<String, dynamic> json) {
    mixesId = json['mixes_id'] != null ? json['mixes_id'] : json['artists_id'];
    albumsId = json['albums_id'];
    genresId=json['genres_id'];
    artistsImage = json['artists_image'];
    artistsName = json['artists_name'];
    songId = json['song_id'];
    songImage = json['song_image'];
    playlistsId = json['playlists_id'];
    userId = json['user_id'];
    playlistsName = json['playlists_name'];
    songCount = json['song_count'];
    if (json['playlist_images'] != null) {
      playlistImages = <PlaylistImages>[];
      json['playlist_images'].forEach((v) {
        playlistImages?.add(new PlaylistImages.fromJson(v));
      });
    }
    originalImage = json['original_image'];
    songName = json['song_name'];
    albumsArtist = json['albums_artist'];
    albumsName = json['albums_name'];
    albumImage = json['albums_image'];
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
    data['mixes_id'] = this.mixesId;
    data['genres_id']=this.genresId;
    data['albums_id'] = this.albumsId;
    data['artists_image'] = this.artistsImage;
    data['artists_name'] = this.artistsName;
    data['song_id'] = this.songId;
    data['song_image'] = this.songImage;
    data['original_image'] = this.originalImage;
    data['song_name'] = this.songName;
    data['albums_image'] = this.albumImage;
    data['albums_name'] = this.albumsName;
    data['albums_artist'] = this.albumsArtist;
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

class MixesTracksData {
  int? id;
  int? albumsId;
  int? songId;
  int? genresId;
  int? favouritesId;
  String? songImage;
  String? originalImage;
  String? albumsImage;
  String? songName;
  String? songArtist;
  String? song;
  String? songDuration;
  String? albumsName;
  String? albumsArtist;
  int? favouritesCount;
  bool? favouritesStatus;
  int? totalPlayed;
  int? totalDownloads;
  int? playlistCount;
  int? playListId;
  bool? playlistStatus;
  int? mixesId;
  String? albumImage;
  String? artistsImage;
  String? artistsName;
  int? userId;
  String? playlistsName;
  int? songCount;
  List<PlaylistImages>? playlistImages;


  MixesTracksData(
      {this.id,
        this.playListId,
        this.favouritesId,
        this.songId,
        this.songImage,
        this.originalImage,
        this.songName,
        this.songArtist,
        this.song,
        this.genresId,
        this.songDuration,
        this.favouritesCount,
        this.favouritesStatus,
        this.totalPlayed,
        this.totalDownloads,
        this.playlistCount,
        this.playlistStatus,
        this.mixesId,
        this.albumsId,
        this.artistsImage,
        this.artistsName,
        this.userId,
        this.playlistImages,
        this.playlistsName,
        this.songCount,
        this.albumImage,
        this.albumsArtist,
        this.albumsName,


      });

  MixesTracksData.fromJson(Map<String, dynamic> json) {
    id = json['mixes_id'] != null ? json['mixes_id'] : json['artists_id'];
    albumsId = json['albums_id'];
    favouritesId = json['favourites_id'];
    playListId = json['playlists_id'];
    songId = json['song_id'];
    genresId=json['genres_id'];
    albumsImage = json["albums_image"];
    albumsName = json['albums_name'];
    albumsArtist = json["albums_artist"];
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
    mixesId = json['mixes_id'] != null ? json['mixes_id'] : json['artists_id'];
    albumsId = json['albums_id'];
    artistsImage = json['artists_image'];
    artistsName = json['artists_name'];
    userId = json['user_id'];
    playlistsName = json['playlists_name'];
    songCount = json['song_count'];
    if (json['playlist_images'] != null) {
      playlistImages = <PlaylistImages>[];
      json['playlist_images'].forEach((v) {
        playlistImages?.add(new PlaylistImages.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mixes_id'] != null ? data['mixes_id'] : data['artists_id'] = this.id;
    data['albums_id'] = this.albumsId;

    data['favourites_id'] = this.favouritesId;
   data['playList_id'] =this.playListId;
    data['genres_id']=this.genresId;
    data['song_id'] = this.songId;
    data['song_image'] = this.songImage;
    data['original_image'] = this.originalImage;
    data['song_name'] = this.songName;
    data['albums_image'] = this.albumsImage;
    data['albums_name'] = this.albumsName;
    data["albums_artist"] = this.albumsArtist;
    data['song_artist'] = this.songArtist;
    data['song'] = this.song;
    data['song_duration'] = this.songDuration;
    data['favourites_count'] = this.favouritesCount;
    data['favourites_status'] = this.favouritesStatus;
    data['total_played'] = this.totalPlayed;
    data['total_downloads'] = this.totalDownloads;
    data['playlist_count'] = this.playlistCount;
    data['playlist_status'] = this.playlistStatus;
    data['mixes_id'] = this.mixesId;
    data['albums_id'] = this.albumsId;
    data['artists_image'] = this.artistsImage;

    return data;
  }
}

class PlaylistImages {
  String? image;

  PlaylistImages({this.image});

  PlaylistImages.fromJson(Map<String, dynamic> json) {
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    return data;
  }
}
