import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/GoogleAdsModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ProfileDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongModelClass.dart';
import 'package:newmusicappmachado/Utils/Models/TermsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/albumModelClass.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/HttpService.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:newmusicappmachado/Utils/Models/LoginResopnseModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/View/ArtistsScreen/ArtistsScreen.dart';
import 'package:newmusicappmachado/View/ExplorScreen/ExplorScreen.dart';
import 'package:newmusicappmachado/View/HomeScreen/HomeScreen.dart';
import 'package:newmusicappmachado/View/MixesScreen/MixesScreen.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/MyLibraryScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class BaseController extends GetxController {
  LoginResponseModel? loginResponseModel;
  RxBool showMusicMenu = false.obs;
  RxBool isLoading = false.obs;
  RxBool isDownloading = false.obs;
  var connectivityResult;
  // String? customFilePath;
  bool _isPlaying = false;
  RxDouble? containerHeight = 0.0.obs;
  RxDouble downloadProgress = 0.0.obs;
  RxList<Map<String,dynamic>> progress = <Map<String ,dynamic>>[].obs;
  final Map<int, String?> customFilePath = {};
  List song = [];
  List albumSong = [];
  File? file;
  RxList databaseDownloadedSongList = [].obs;
  RxList databaseFavouriteSongList = [].obs;
  RxList databaseDownloadedAlbumSongList = [].obs;
  bool isAdLoaded = false;
  late BannerAd bannerAd;
  RxList listOfDownload = [].obs;
  var test;
  final String _sampleSongUrl =
      "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3"; // Sample MP3 URL

  @override
  void onInit() {
    fetchDatabaseSong();
    fetchDatabaseAlbumSong();
    // TODO: implement onInit
    super.onInit();
  }

  var currentTrack = ''.obs; // Store current track ID or name

  void updateCurrentTrack(String track) {
    currentTrack.value = track; // Update when song changes
    update(); // Force UI rebuild
  }
  googleAd(){
    bannerAd = BannerAd(
      adUnitId: Platform.isAndroid ? (Get.find<BaseController>().googleAdsModel?.data?[0].androidKey??"") : (Get.find<BaseController>().googleAdsModel?.data?[0].iosKey??""), // Replace with `android_key`
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
            isAdLoaded = true;
          update();
        },
        onAdFailedToLoad: (ad, error) {
          print("Ad failed to load: $error");
          ad.dispose();
        },
      ),
    );

    bannerAd.load();
  }


  initialListOfBool(int length) {
    listOfDownload.value = List.generate(length, (index) => false);
    // print(listOfDownload);
  }

  fetchDatabaseSong() async {
    databaseDownloadedSongList.value = await SongDatabaseService().getSongs();

    databaseFavouriteSongList.value = databaseDownloadedSongList.where((test)=>test['favourite'] == 1).toList();

    Get.find<HomeController>().update();
    print("this is offline ${databaseDownloadedSongList}");
    update();
  }

  fetchDatabaseAlbumSong() async {
    databaseDownloadedAlbumSongList.value =
        await SongDatabaseService().getAlbums();
    print(databaseDownloadedAlbumSongList);
    update();
  }


  void showLoader(bool value) {
    isLoading.value = value;
    update;
  }

  final List<Widget> pages = [
    const HomeScreen(),
    const ExplorScreen(),
    const MixesScreen(),
    const ArtistsScreen(),
    const MyLibraryScreen(),
  ];
  RxInt selectedIndex = 0.obs;
  RxString routeNameNavi = 'homeScreen'.obs;

  void onItemTapped(int index,) {

     switch(index){
       case 0:
         Get.offAllNamed(RoutesName.homeScreen);
       case 1:
         Get.offAllNamed(RoutesName.exploreScreen);
         case 2:
         Get.offAllNamed(RoutesName.mixesScreen);
         case 3:
         Get.offAllNamed(RoutesName.artistsScreen);
         case 4:
         Get.offAllNamed(RoutesName.myLibraryScreen);
         update();
    }
  }


  // String? downloadIndex;
  // index

  Future<void> checkIfFileExists(
      int index, TracksDataModel? tracksDataModel) async {
    String appDocDir = await getInternalDirectory();
    print(appDocDir);
    print(tracksDataModel?.data?[index].songName);
    String filePath = "$appDocDir/${tracksDataModel?.data?[index].songName}";
    if (File(filePath).existsSync()) {
      print(filePath);
      // setState(() {
      //   _localFilePath = filePath;
      // });
    } else {
      print("object");
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
  bool isDownload({int? songId}) {

    final songId1 = songId;
    test = Get.find<BaseController>()
        .databaseDownloadedSongList
        .any((e) {
    return e['song_id'] == songId1 && e['isDownloaded'] == 1;
        });
    update;
    Get.find<HomeController>().update;
    return test;
  }
  Future<void> deleteSong({bool? isAlbum,dynamic songId,int? index}) async {
    print(index);
    await SongDatabaseService()
        .deleteSong(songId['song_id'])
        .whenComplete(() async {
      await deleteFile(songId['file_path'],isAlbum: isAlbum);
    });
    update();
  }
  Future<void> deleteAlbumSong ({int? songId,String? filePath,bool? isAlbum,int? albumId,dynamic number}) async {
    print(number);
    await SongDatabaseService()
        .deleteSong(songId??0)
        .whenComplete(() async {
      await deleteFile(filePath??"");
      updateDownloadSong(
        isAlbum: isAlbum,
        albumId: albumId,
        number: number.toString(),
      );
      // : null;
    });
    update();
  }


  Future<void> deleteFile(String filePath,{bool? isAlbum}) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete().then((_) {
        fetchDatabaseSong();
       isAlbum??false? fetchDatabaseAlbumSong():null;
      });
      print("File deleted: $filePath");
    } else {
      print("File does not exist: $filePath");
    }
  }

  Future<void> albumDownloadSong(
      {TracksDataModel? albumTrack, int? index}) async {
    isDownloading.value = true;
    // downloadIndex=index;
    try {
      List<int?> songIds =
          albumTrack?.data?.map((e) => e.songId).toList() ?? [];
      print("this=> ${songIds}");
      final album = {
        "album_id": albumTrack?.data?[index ?? 0].albumsId,
        "album_name": albumTrack?.albumsName,
        "imageUrl": albumTrack?.albumImage,
        "song_id": songIds.toString(),
      };
      SongDatabaseService().insertAlbum(album).then((_) {
        fetchDatabaseAlbumSong();
      });
    } catch (e) {
      isDownloading.value = false;
    }
  }
  Future<void> updateDownloadSong(
      {TracksDataModel? albumTrack, int? index, int? albumId,bool? isAlbum,dynamic number}) async {
    songIds = albumTrack?.data?.map((e) => e.songId).toList() ?? [];
    isDownloading.value = true;
    try {
      final album = {
        "album_id":   isAlbum??false ?albumId : albumTrack?.data?[index ?? 0].albumsId,
        "album_name": isAlbum??false ?databaseDownloadedAlbumSongList[index??0]['album_name']:  albumTrack?.albumsName,
        "imageUrl":isAlbum??false?databaseDownloadedAlbumSongList[index??0]['imageUrl']: albumTrack?.albumImage,
        "song_id":isAlbum??false? number: songIds.toString(),
      };
      SongDatabaseService()
          .updateAlbum(isAlbum??false ?albumId??0 :albumTrack?.data?[index ?? 0].albumsId ?? 0, album)
          .then((_) {
        fetchDatabaseAlbumSong();
      });
    } catch (e) {
      isDownloading.value = false;
    }
  }

  List<int?>? songIds;

 RxList<Map<String,dynamic>> songData = < Map<String,dynamic>>[].obs;
 RxList<Map<String,dynamic>> songData1 = < Map<String,dynamic>>[].obs;

  Future<Map<String, dynamic>?> fetchSongById(int songId) async {
    final result = await SongDatabaseService().getSongById(songId);
    return result;
  }
  // RxList numbers = [].obs;
  //
  // Future<void> convertStringToList ({int? index})async{
  //    numbers.value = List<dynamic>.from(json.decode(databaseDownloadedAlbumSongList[index??0]['song_id']??""));
  //    songData.isNotEmpty?songData.clear():null;
  //    for(int i= 0; i < numbers.length; i++){
  //    if(await fetchSongById(numbers[i])!=null){
  //   songData.add(await fetchSongById(numbers[i])??{});}
  //    update();
  //  }

  RxList<dynamic> numbers = <dynamic>[].obs;
  RxList<dynamic> numbers12 = <dynamic>[].obs;

  Future<void> convertStringToList({int? index}) async {
    // databaseDownloadedAlbumSongList[index ?? 0]['song_id'] ?? "[]"
    // Decode the JSON string and assign it to numbers as an RxList<dynamic>
    numbers.value = RxList<dynamic>.from(
      json.decode(databaseDownloadedAlbumSongList[index ?? 0]['song_id'] ?? "[]"),
    );

    // Clear songData if not empty
    if (songData.isNotEmpty) {
      songData.clear();
    }

    // Iterate through numbers and fetch song data
    for (int i = 0; i < numbers.length; i++) {
      final song = await fetchSongById(numbers[i]);
      if (song != null) {
        songData.add(song);
      }
      print(songData);
      update(); // Update observers
    }
  }
  Future<void> convertStringToList1({int? album_id}) async {
    // databaseDownloadedAlbumSongList[index ?? 0]['song_id'] ?? "[]"
    // Decode the JSON string and assign it to numbers as an RxList<dynamic>
    numbers12.value = RxList<dynamic>.from(
      json.decode(databaseDownloadedAlbumSongList.firstWhere((test)=> test['album_id'] == album_id)['song_id']),
    );

    // Clear songData if not empty
    if (songData1.isNotEmpty) {
      songData1.clear();
    }

    // Iterate through numbers and fetch song data
    for (int i = 0; i < numbers12.length; i++) {
      final song = await fetchSongById(numbers12[i]);
      if (song != null) {
        songData1.add(song);
      }
      print(songData1);
      update(); // Update observers
    }
  }

  deleteList ({int? index, String? path,int? albumId}){
    numbers.remove(index);
    songData.removeWhere((v)=>v['song_id']== index);
    deleteAlbumSong(songId: index, isAlbum: true,filePath: path,number: numbers,albumId: albumId);
    update();
  }
  TermsAndPrivacyDataModel? termsAndPrivacyDataModel;
  Future<void>termsAndPrivacy({required String value,required AuthChopperService authChopperService})async{
    try{
      final queryParameters={
        "type":value
      };
      final response=await authChopperService.termsApi(queryParameters: queryParameters);
      if(response.body?.status==200){
        termsAndPrivacyDataModel=response.body;
        Get.toNamed(RoutesName.termsAndPrivacyScreen);
      }
      update();
    }catch(e){
      log('',name: 'Terms And Privacy Api Error',error: e.toString());
    }
  }

  GoogleAdsModel? googleAdsModel;

  Future<void> googleAdsApi({required HomeChopperService homeChopperService})async {
    try{
      // if(googleAdsModel?.data?.isNotEmpty??false){
      //   bannerAd.dispose();
      // }
      final queryParameters={
        "filter": UserPreference.getValue(key: PrefKeys.userId),
      };
      final response = await homeChopperService.googleAds(queryParameters: queryParameters);
      if(response.body?.status ==200){
        googleAdsModel = response.body;
        // googleAd();
        update();
      }else{
        Utility.showSnackBar(response.body?.message);
      }
    }catch(e){
      log('',name: 'Google Ads',error: e.toString());
    }
  }
  GeneralErrorModel? generalErrorModel;
  Future<void> downloadAPi({required HomeChopperService homeChopperService,int? albumId,int? songId})async {
    try{
      final queryParameters=  albumId == null ? {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        'song_id': songId,
      }:{
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        'albums_id': albumId,
      } ;
      final response = await homeChopperService.downloadAPi(queryParameters: queryParameters);
      if(response.body?.code == 200){
        generalErrorModel = response.body;
        Utility.showSnackBar(response.body?.message);
        update();
      }else{
        Utility.showSnackBar(response.body?.message);
        update();
        Get.find<HomeController>().update();
      }
    }catch(e){
      log('',name: 'Download Ads',error: e.toString());
    }
  }
  Future<void> deleteAlbum({bool? isLibrary, int? albumId, int? index}) async {
    print(index);
    await SongDatabaseService()
        .deleteAlbum(albumId??0);
     fetchDatabaseAlbumSong();
    Get.find<BaseController>().update();
  }

}
