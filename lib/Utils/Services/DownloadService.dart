import 'dart:io';

import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongModelClass.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Services/HttpService.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class DownloadService extends GetxService {
  static final DownloadService _singleton = DownloadService._internal();

  factory DownloadService() {
    return _singleton;
  }

  DownloadService._internal();

  static DownloadService get instance => _singleton;

  RxBool isDownloading = false.obs;
  List<SongModelClass> song = [];

  /// Downloads a song and saves it to the device.
  ///
  /// [downloadSongUrl] is the URL of the song to download.
  /// [SongData] is the data for the song to be downloaded.
  Future<void> downloadSong(
      {String? downloadSongUrl, MixesTracksData? SongData}) async {
    isDownloading.value = true;
    try {
      // Show snack bar indicating that download has started
      Utility.showSnackBar("Download started");

      // Get the directory where the song will be saved
      String customDirPath = await getInternalDirectory();
      String filePath = "$customDirPath/${SongData?.songName}.mp3";

      // Add song to the list to track download progress
      song.add(
        SongModelClass(
            filePath: filePath,
            isDownloading: false,
            progress: 0,
            url: downloadSongUrl,
            favourite: 0,
            id: SongData?.songId,
            artistName: SongData?.songArtist,
            songName: SongData?.songName,
            imageUrl: SongData?.originalImage),
      );

      // Prepare song data to be inserted or updated in the database
      final songLocal = {
        "song_id": SongData?.songId,
        "song_name": SongData?.songName,
        'artist_name': SongData?.songArtist,
        'favourite': 0,
        'file_path': filePath,
        "isDownloaded": 0,
        'imageUrl': SongData?.songImage,
      };

      print(songLocal['song_id']);

      // Check if song is already in the database and update if needed
      if (Get.find<BaseController>()
          .databaseDownloadedSongList
          .any((test) =>
      test['song_id'] == songLocal['song_id'] &&
          test['isDownloaded'] == 0)) {
        // Update existing song if not downloaded yet
        await SongDatabaseService()
            .updateSong(int.tryParse(songLocal['song_id'].toString()) ?? 0, songLocal)
            .then((_) {
          Get.find<BaseController>().fetchDatabaseSong();
        }).then((_) async {
          // Start downloading the song
          await ApiService()
              .getRequest(
            downloadSongUrl: downloadSongUrl,
            filePath: filePath,
            song: songLocal,
          )
              .then((v) {})
              .catchError((handleError) {
            print(handleError.toString());
          });
        });
      } else {
        // Insert the song if not already in the database
        await SongDatabaseService()
            .insertSong(songLocal ?? {})
            .then((_) {
          Get.find<BaseController>().fetchDatabaseSong();
        }).then((_) async {
          // Start downloading the song
          await ApiService()
              .getRequest(
            downloadSongUrl: downloadSongUrl,
            filePath: filePath,
            song: songLocal,
          )
              .then((v) {})
              .catchError((handleError) {
            print(handleError.toString());
          });
        });
      }
    } catch (e) {
      // In case of any error, stop the download and reset the state
      isDownloading.value = false;
    }
  }

  /// Gets the directory path where the songs are stored locally.
  ///
  /// Returns the path to the song directory.
  Future<String> getInternalDirectory() async {
    // Get the application's document directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create a custom subdirectory for storing songs
    String customPath = "${appDocDir.path}/Songs";
    Directory customDir = Directory(customPath);

    // If the directory doesn't exist, create it
    if (!customDir.existsSync()) {
      customDir.createSync(recursive: true);
    }

    return customDir.path;
  }

  /// Downloads all songs in a given track model.
  ///
  /// [tracksDataMode] is the list of tracks to be downloaded.
  /// [index] is the index of the current track to be processed.
  Future<void> downloadAllSongs(
      {TracksDataModel? tracksDataMode, int? index}) async {
    print(tracksDataMode?.data?.length);

    // Process the tracks for downloading
    Get.find<BaseController>().convertStringToList(index: index);

    for (int i = 0; i < tracksDataMode!.data!.length; i++) {
      // Check if the song has already been downloaded
      if (Get.find<BaseController>().numbers.contains(
          tracksDataMode.data![i].songId) &&
          Get.find<BaseController>()
              .databaseDownloadedAlbumSongList
              .any((v) =>
          v['album_id'] == tracksDataMode.data?[i].albumsId &&
              Get.find<BaseController>()
                  .databaseDownloadedSongList
                  .every((test) =>
              test['isDownloaded'] == 0 &&
                  test['song_id'] == tracksDataMode.data?[index ?? 0].songId))) {

        // If the song is part of an album, update or download it
        Get.find<BaseController>()
            .databaseDownloadedAlbumSongList
            .any((v) => v['album_id'] == tracksDataMode.data?[i].albumsId)
            ? Get.find<BaseController>().updateDownloadSong(index: index, albumTrack: tracksDataMode)
            : Get.find<BaseController>().albumDownloadSong(albumTrack: tracksDataMode, index: index);

        // Proceed to download the song
        await downloadSong(
            downloadSongUrl: tracksDataMode.data?[i].song,
            SongData: tracksDataMode.data?[i]);
      } else {
        // Download the song if it's not in the downloaded list
        await downloadSong(
            downloadSongUrl: tracksDataMode.data?[i].song,
            SongData: tracksDataMode.data?[i]);

        // Update or download the album's songs
        Get.find<BaseController>()
            .databaseDownloadedAlbumSongList
            .any((v) => v['album_id'] == tracksDataMode.data?[i].albumsId)
            ? Get.find<BaseController>().updateDownloadSong(index: index, albumTrack: tracksDataMode)
            : Get.find<BaseController>().albumDownloadSong(albumTrack: tracksDataMode, index: index);

        // Trigger an update
        Get.find<BaseController>().update();
      }
    }
  }

  /// Downloads all songs in a given playlist.
  ///
  /// [tracksDataMode] is the playlist data model containing the songs to download.
  /// [index] is the index of the current playlist to be processed.
  Future<void> playListDownloadAllSongs(
      {PlayListSongDataModel? tracksDataMode, int? index}) async {
    print("length ${tracksDataMode?.data!.length}");

    // Process the playlist for downloading
    Get.find<MyLibraryController>().convertStringToPlayList(index: index);

    for (int i = 0; i < tracksDataMode!.data!.length; i++) {
      // If the song is not already downloaded, proceed to download it
      if (!Get.find<BaseController>().numbers.contains(tracksDataMode.data?[i].songId)) {
        await downloadSong(
            downloadSongUrl: tracksDataMode.data?[i].song,
            SongData: tracksDataMode.data?[i]);

        // Update or download the playlist's songs
        Get.find<MyLibraryController>()
            .databaseDownloadPlayListSongList
            .any((v) => v['playlist_id'] == tracksDataMode.data?[i].playListId)
            ? Get.find<MyLibraryController>().updateDownloadPlayListSong(index: index, playListTrack: tracksDataMode)
            : Get.find<MyLibraryController>().playListDownloadSong(playListTrack: tracksDataMode, index: index);

        // Trigger an update
        Get.find<BaseController>().update();
      }
    }
  }
}
