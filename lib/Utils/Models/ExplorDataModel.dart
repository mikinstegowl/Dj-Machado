import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';

class ExplorDataModel {
  int? status;
  String? message;
  List<ImageAssets>? imageAssets;

  // List<Null>? recommendedTracks;
  List<FirstTrendingsData>? firstFlowactivotrendings;
  // List<Null>? recentPlayed;
  List<MostPlayed>? mostPlayed;
  List<FirstTrendingsData>? data;
  int? perPage;
  int? currentPage;
  int? lastPage;

  ExplorDataModel(
      {this.status,
      this.message,
      this.imageAssets,
      // this.recommendedTracks,
      this.firstFlowactivotrendings,
      // this.recentPlayed,
      this.mostPlayed,
      this.data,
      this.perPage,
      this.currentPage,
      this.lastPage});

  ExplorDataModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['image_assets'] != null) {
      imageAssets = <ImageAssets>[];
      json['image_assets'].forEach((v) {
        imageAssets!.add(new ImageAssets.fromJson(v));
      });
    }
    // if (json['recommended_tracks'] != null) {
    //   recommendedTracks = <Null>[];
    //   json['recommended_tracks'].forEach((v) {
    //     recommendedTracks!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['first_flowactivotrendings'] != null) {
      firstFlowactivotrendings = <FirstTrendingsData>[];
      json['first_flowactivotrendings'].forEach((v) {
        firstFlowactivotrendings!.add(new FirstTrendingsData.fromJson(v));
      });
    }
    // if (json['recent_played'] != null) {
    //   recentPlayed = <Null>[];
    //   json['recent_played'].forEach((v) {
    //     recentPlayed!.add(new Null.fromJson(v));
    //   });
    // }
    if (json['most_played'] != null) {
      mostPlayed = <MostPlayed>[];
      json['most_played'].forEach((v) {
        mostPlayed!.add(new MostPlayed.fromJson(v));
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
    // if (this.recommendedTracks != null) {
    //   data['recommended_tracks'] =
    //       this.recommendedTracks!.map((v) => v.toJson()).toList();
    // }
    if (this.firstFlowactivotrendings != null) {
      data['first_flowactivotrendings'] =
          this.firstFlowactivotrendings!.map((v) => v.toJson()).toList();
    }
    // if (this.recentPlayed != null) {
    //   data['recent_played'] =
    //       this.recentPlayed!.map((v) => v.toJson()).toList();
    // }
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

  MostPlayed(
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

  MostPlayed.fromJson(Map<String, dynamic> json) {
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

class ExplorData {
  int? flowactivotrendingscategoryId;
  String? flowactivotrendingscategoryImage;
  String? originalImage;
  String? flowactivotrendingscategoryName;
  String? flowactivotrendingscategoryFor;
  List<Data>? data;

  ExplorData(
      {this.flowactivotrendingscategoryId,
      this.flowactivotrendingscategoryImage,
      this.originalImage,
      this.flowactivotrendingscategoryName,
      this.flowactivotrendingscategoryFor,
      this.data});

  ExplorData.fromJson(Map<String, dynamic> json) {
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
    data['flowactivotrendingscategory_id'] = this.flowactivotrendingscategoryId;
    data['flowactivotrendingscategory_image'] =
        this.flowactivotrendingscategoryImage;
    data['original_image'] = this.originalImage;
    data['flowactivotrendingscategory_name'] =
        this.flowactivotrendingscategoryName;
    data['flowactivotrendingscategory_for'] =
        this.flowactivotrendingscategoryFor;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? flowactivotrendingscategoryFor;
  int? flowactivotrendingsgenresId;
  int? flowactivotrendingscategoryId;
  int? genresId;
  String? genresName;
  String? genresImage;
  String? originalImage;
  String? trendingscategoryFor;
  int? trendingsradioId;
  int? trendingscategoryId;
  String? trendingsradioName;
  String? trendingsradioUrl;
  String? trendingsradioImage;
  int? artistsId;
  String? artistsImage;
  String? artistsName;
  int? songId;
  String? songImage;
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
  int? albumsId;
  String? albumsName;
  String? albumsImage;
  String? albumsArtist;
  int? mixesId;
  String? mixesName;
  String? mixesImage;
  int? flowactivoplaylistId;
  String? flowactivoplaylistName;
  String? flowactivoplaylistImage;



  Data(
      {this.flowactivotrendingscategoryFor,
      this.flowactivotrendingsgenresId,
      this.flowactivotrendingscategoryId,
      this.genresId,
      this.genresName,
      this.genresImage,
      this.originalImage,
        this. trendingscategoryFor,
  this. trendingsradioId,
  this. trendingscategoryId,
  this. trendingsradioName,
  this. trendingsradioUrl,
  this. trendingsradioImage,
  this. artistsId,
  this. artistsImage,
  this. artistsName,
        this.songId,
        this.songImage,
        this.mixesId, this.mixesName, this.mixesImage,
        this.songName,
        this.songArtist,
        this.song,
        this.songDuration,
        this.favouritesCount,
        this.favouritesStatus,
        this.totalPlayed,
        this.totalDownloads,
        this.playlistCount,
        this.playlistStatus,
        this.albumsId,
        this.albumsName,
        this.albumsImage,
        this.albumsArtist,
        this.flowactivoplaylistId,
        this.flowactivoplaylistName,
        this.flowactivoplaylistImage
      });

  Data.fromJson(Map<String, dynamic> json) {
    flowactivotrendingscategoryFor = json['flowactivotrendingscategory_for'];
    flowactivotrendingsgenresId = json['flowactivotrendingsgenres_id'];
    flowactivotrendingscategoryId = json['flowactivotrendingscategory_id'];
    genresId = json['genres_id'];
    genresName = json['genres_name'];
    genresImage = json['genres_image'];
    originalImage = json['original_image'];
    trendingscategoryFor = json['trendingscategory_for'];
    trendingsradioId = json['trendingsradio_id'];
    trendingscategoryId = json['trendingscategory_id']??json['flowactivotrendingscategory_id'];
    trendingsradioName = json['trendingsradio_name']??json['flowactivotrendingsradio_name'];
    trendingsradioUrl = json['trendingsradio_url']??json['flowactivotrendingsradio_url'];
    trendingsradioImage = json['trendingsradio_image']??json['flowactivotrendingsradio_image'];
  artistsId= json['artists_id'];
   artistsImage= json['artists_image'];
    artistsName= json['artists_name'];
    songId = json['song_id'];
    songImage = json['song_image'];
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
    albumsId = json['albums_id'];
    albumsName = json['albums_name'];
    albumsImage = json['albums_image'];
    albumsArtist = json['albums_artist'];
    mixesId = json['mixes_id'];
    mixesName = json['mixes_name'];
    mixesImage = json['mixes_image'];
    flowactivoplaylistId = json['flowactivoplaylist_id']??json['flowactivoplaylist_id'];
    flowactivoplaylistName = json['flowactivoplaylist_name']??json['flowactivoplaylist_name'];
    flowactivoplaylistImage = json['flowactivoplaylist_image']??json['flowactivoplaylist_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flowactivotrendingscategory_for'] =
        this.flowactivotrendingscategoryFor;
    data['flowactivotrendingsgenres_id'] = this.flowactivotrendingsgenresId;
    data['flowactivotrendingscategory_id'] = this.flowactivotrendingscategoryId;
    data['genres_id'] = this.genresId;
    data['genres_name'] = this.genresName;
    data['genres_image'] = this.genresImage;
    data['original_image'] = this.originalImage;
    data['trendingscategory_for'] = this.trendingscategoryFor;
    data['trendingsradio_id'] = this.trendingsradioId;
    data['trendingscategory_id'] = this.trendingscategoryId;
    data['trendingsradio_name'] = this.trendingsradioName;
    data['trendingsradio_url'] = this.trendingsradioUrl;
    data['trendingsradio_image'] = this.trendingsradioImage;
    data['artists_id']=this.artistsId;
     data['artists_image']=this.artistsImage;
      data['artists_name']=this.artistsName;
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
    data['albums_id'] = this.albumsId;
    data['albums_name'] = this.albumsName;
    data['albums_image'] = this.albumsImage;
    data['albums_artist'] = this.albumsArtist;
    data['mixes_id'] = this.mixesId;
    data['mixes_name'] = this.mixesName;
    data['mixes_image'] = this.mixesImage;
    data['flowactivoplaylist_id'] = this.flowactivoplaylistId;
    data['flowactivoplaylist_name'] = this.flowactivoplaylistName;
    data['flowactivoplaylist_image'] = this.flowactivoplaylistImage;
    return data;
  }
}
