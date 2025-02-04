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

  Future<void> downloadSong(
      {String? downloadSongUrl, MixesTracksData? SongData}) async {
    isDownloading.value = true;
    try {
      Utility.showSnackBar("Download started");
      String customDirPath = await getInternalDirectory();
      String filePath = "$customDirPath/${SongData?.songName}.mp3";
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
      Get.find<BaseController>().databaseDownloadedSongList.any((test)=> test['song_id']== songLocal['song_id'] && test['isDownloaded'] == 0)? await SongDatabaseService().updateSong(int.tryParse(songLocal['song_id'].toString())??0,songLocal).then((_){
        Get.find<BaseController>().fetchDatabaseSong();
      }).then((_)async {
        await ApiService()
            .getRequest(
            downloadSongUrl: downloadSongUrl,
            filePath: filePath,
            song: songLocal)
            .then((v) {})
            .catchError((handleError) {
          print(handleError.toString());
        });
      }):
      await SongDatabaseService().insertSong(songLocal??{}).then((_){
        Get.find<BaseController>().fetchDatabaseSong();
      }).then((_)async {
        await ApiService()
            .getRequest(
            downloadSongUrl: downloadSongUrl,
            filePath: filePath,
            song: songLocal)
            .then((v) {})
            .catchError((handleError) {
          print(handleError.toString());
        });
      });

    } catch (e) {
      // setState(() {
      isDownloading.value = false;
    }
  }

  Future<String> getInternalDirectory() async {
    // Get the application's document directory
    Directory appDocDir = await getApplicationDocumentsDirectory();

    // Create a custom subdirectory
    String customPath = "${appDocDir.path}/Songs";
    Directory customDir = Directory(customPath);

    if (!customDir.existsSync()) {
      customDir.createSync(recursive: true);
    }

    return customDir.path;
  }

  Future<void> downloadAllSongs(
      {TracksDataModel? tracksDataMode, int? index}) async {
    print(tracksDataMode?.data?.length);
    Get.find<BaseController>().convertStringToList(index:index);
    for (int i = 0; i < tracksDataMode!.data!.length; i++) {
      if(Get.find<BaseController>().numbers.contains(
          tracksDataMode.data![i].songId) &&
      Get.find<BaseController>()
    .databaseDownloadedAlbumSongList
        .any((v) => v['album_id'] == tracksDataMode.data?[i].albumsId && Get.find<BaseController>().databaseDownloadedSongList.every((test)=> test['isDownloaded'] == 0 && test['song_id']== tracksDataMode.data?[index??0].songId))
      ){
        Get.find<BaseController>()
            .databaseDownloadedAlbumSongList
            .any((v) => v['album_id'] == tracksDataMode.data?[i].albumsId)
            ? Get.find<BaseController>()
            .updateDownloadSong(index: index, albumTrack: tracksDataMode)
            : Get.find<BaseController>()
            .albumDownloadSong(albumTrack: tracksDataMode, index: index);
        await downloadSong(
            downloadSongUrl: tracksDataMode.data?[i].song,
            SongData: tracksDataMode.data?[i]);
      }
      else{
      await downloadSong(
          downloadSongUrl: tracksDataMode.data?[i].song,
          SongData: tracksDataMode.data?[i]);

      Get.find<BaseController>()
              .databaseDownloadedAlbumSongList
              .any((v) => v['album_id'] == tracksDataMode.data?[i].albumsId)
          ? Get.find<BaseController>()
              .updateDownloadSong(index: index, albumTrack: tracksDataMode)
          : Get.find<BaseController>()
              .albumDownloadSong(albumTrack: tracksDataMode, index: index);
      Get.find<BaseController>().update();
    }
    }
  }



  Future<void> playListDownloadAllSongs(
      {PlayListSongDataModel? tracksDataMode, int? index}) async {
    print("length${tracksDataMode?.data!.length}");
    Get.find<MyLibraryController>().convertStringToPlayList(index:index);
    for (int i = 0; i < tracksDataMode!.data!.length; i++) {
      // print(tracksDataMode.data?[i].playlistsName);
      if(Get.find<BaseController>().numbers.contains(
          tracksDataMode.data?[i].songId
      )){}
      else{
        await downloadSong(
            downloadSongUrl: tracksDataMode.data?[i].song,
            SongData: tracksDataMode.data?[i]);

        Get.find<MyLibraryController>()
            .databaseDownloadPlayListSongList
            .any((v) => v['playlist_id'] == tracksDataMode.data?[i].playListId)
            ? Get.find<MyLibraryController>()
            .updateDownloadPlayListSong(index: index, playListTrack: tracksDataMode)
            :
        Get.find<MyLibraryController>()
            .playListDownloadSong(playListTrack: tracksDataMode, index: index);
        Get.find<BaseController>().update();
      }
    }
  }
}
