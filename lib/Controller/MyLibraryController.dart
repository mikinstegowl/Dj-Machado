import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListAddDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MyLibraryController extends BaseController{
  late HomeChopperService _homeChopperService;
  final TextEditingController textController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RxList databaseDownloadPlayListSongList = [].obs;

  MyLibraryController({required HomeChopperService homeChopperService}){
    _homeChopperService = homeChopperService;
  }



  @override
  void onInit() {

    fetchDatabasePlayListSong();
    scrollController.addListener((){
      print("sdcsdvfv");
      scrollListener();
    });
    scrollController2.addListener((){
      print("sdcsdvfv");
      scrollListener2();
    });
    scrollController3.addListener((){
      print("sdcsdvfv");
      scrollListener3();
    });
    // TODO: implement onInit
    super.onInit();
  }

  fetchDatabasePlayListSong() async {
    databaseDownloadPlayListSongList.value =
    await SongDatabaseService().getPlaylists();
    print("this=============$databaseDownloadPlayListSongList");
    update();
  }

  Future<bool?> favouriteSongAddApi({required int songId,}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),

        "song_id": songId,
      };
      final response = await _homeChopperService.favouriteSongAddApi(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        Get.find<ExplorController>().update();
        Get.back();
        await SongDatabaseService().updateSong(songId,{
          "favourite": 1
        }).then((_){
          Get.find<BaseController>().fetchDatabaseSong();
          Get.find<HomeController>().homeDataApi();
        });
        Utility.showSnackBar(response.body?.message??'');
        update();
        return true;
      }
    } catch (e) {
      log("", error: e.toString(), name: "Favourite Add Api Error");
    }

  }
  Future<bool?> favouriteSongRemoveApi({required int songId}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "song_id": songId,
      };
      final response = await _homeChopperService.favouriteSongRemoveApi(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        Get.back();
        await SongDatabaseService().updateSong(songId,{
          "favourite": 0
        }).then((_){
          Get.find<BaseController>().fetchDatabaseSong();
          Get.find<HomeController>().homeDataApi();
        });
        Utility.showSnackBar(response.body?.message??'');

        update();
        return false;
      }
    } catch (e) {
      log("", error: e.toString(), name: "Favourite Remove Api Error");
    }}

  int  paginationInt = 1;

  ScrollController scrollController = ScrollController();



  int? maxPages;
  Future<void> scrollListener() async {
    print("client ${scrollController.hasClients}");
    if (scrollController.hasClients) {
      print("ture sate ${scrollController.position.pixels == scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("max ${paginationInt < maxPages!}");
        print("max ${maxPages!}");
        if (paginationInt < maxPages!) {
          paginationInt++;
          print(paginationInt);
          await favouriteSongDataApi(); // Fetch next page
        }
      }
    }
  }
  FavouriteSongDataModel? favouriteSongDataModel;
  Future<void> favouriteSongDataApi() async {
    showLoader(true);
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "page": paginationInt
      };
      final response = await _homeChopperService.favouriteSongDataApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        favouriteSongDataModel = response.body;
        maxPages = favouriteSongDataModel?.lastPage;
        showLoader(false);
        update();
      }
    } catch (e) {
      showLoader(false);
      update();
      log("", error: e.toString(), name: "Favourite Details Api Error");
    }}


  int  paginationPlaylist = 1;

  ScrollController scrollController2 = ScrollController();



  int? maxPagesPlaylist;
  Future<void> scrollListener2() async {
    print("client ${scrollController2.hasClients}");
    if (scrollController2.hasClients) {
      print("ture sate ${scrollController2.position.pixels == scrollController2.position.maxScrollExtent}");
      if (scrollController2.position.pixels == scrollController2.position.maxScrollExtent) {
        print("max ${paginationPlaylist < maxPagesPlaylist!}");
        print("max ${maxPagesPlaylist!}");
        if (paginationPlaylist < maxPagesPlaylist!) {
          paginationPlaylist++;
          print(paginationPlaylist);
          await playListDataApi(); // Fetch next page
        }
      }
    }
  }
  PlayListDataModel? playListDataModel;

  Future<void> playListDataApi() async {
    showLoader(true);
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "page": paginationPlaylist
      };
      final response = await _homeChopperService.playListDataApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        playListDataModel = response.body;
        maxPagesPlaylist = playListDataModel?.lastPage;
        showLoader(false);
        print(playListDataModel);
        update();
      }
    } catch (e) {
      showLoader(false);
      update();
      log("", error: e.toString(), name: "PlayList Details Api Error");
    }}



  PlayListAddDataModel? playListAddDataModel;
  Future<void> playListDataAddApi({required String? playName}) async {
    try {
      final param = {
        "playlists_name": playName,
      };
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
      };
      final response = await _homeChopperService.playLisAddDataApi(
          param: param,
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        Get.back();
        playListAddDataModel = response.body;
        playListDataApi();
        textController.clear();
        Utility.showSnackBar(response.body?.message);
        update();
      }else{
        // Get.back();
        // textController.clear();

        Utility.showSnackBar(response.body?.message,isError: true);
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Create Add Api Error");
    }}


  int  paginationPlaylist3 = 1;

  ScrollController scrollController3 = ScrollController();



  int? maxPagesPlaylist3;
  Future<void> scrollListener3() async {
    print("client ${scrollController3.hasClients}");
    if (scrollController3.hasClients) {
      print("ture sate ${scrollController3.position.pixels == scrollController3.position.maxScrollExtent}");
      if (scrollController3.position.pixels == scrollController3.position.maxScrollExtent) {
        print("max ${paginationPlaylist3 < maxPagesPlaylist3!}");
        print("max ${maxPagesPlaylist3!}");
        if (paginationPlaylist3 < maxPagesPlaylist3!) {
          paginationPlaylist3++;
          print(paginationPlaylist3);
          await playListSongDataApi(playlistsId: playlistsId3); // Fetch next page
        }
      }
    }
  }

  int? playlistsId3;
  PlayListSongDataModel? playListSongDataModel;

  Future<void> playListSongDataApi({required int? playlistsId}) async {
    try {
      showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "playlists_id": playlistsId,
        "page": paginationPlaylist3
      };
      final response = await _homeChopperService.playListSongDataApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        Get.back();
        playListSongDataModel = response.body;
        maxPagesPlaylist3 = playListSongDataModel?.lastPage;
        playlistsId3 = playlistsId;
        print(playListSongDataModel);
        showLoader(false);
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Create Add Api Error");
    }}


  GeneralErrorModel? generalErrorModel;
  Future<bool?> playListSongAddApi({required int? playlistsId, required int? songId}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        'song_id':songId,
        "playlists_id":playlistsId,
      };
      final response = await _homeChopperService.playListSongAddApi(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        // Get.back(result: true);
        playListDataApi();
        update();
        Get.back();
        Get.back();
        Get.back();
        Utility.showSnackBar(response.body?.message??'');
        return true;
      }else{
        Get.back();
        Get.back();
        Get.back();
        Utility.showSnackBar(response.body?.message??'',isError: true);
        return false;
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Song Add Api Error");
      return false;
    }}
  Future<bool?> playListSongRemoveApi({required int? playlistsId,songId}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "playlists_id":playlistsId,
        'song_id': songId,
        "page": 1
      };
      final response = await _homeChopperService.playListSongRemoveApi(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        // Get.back();
        playListDataApi();
        playListSongDataApi(playlistsId: playlistsId);
        update();
        return false;
      }else{
        return true;
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Song Remove Api Error");
      return true;
    }}
  Future<void> playListRemoveApi({required int? playlistsId}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "playlists_id":playlistsId,
      };
      final response = await _homeChopperService.removePlayList(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        playListDataApi();
        Get.back();
        Utility.showSnackBar(response.body?.message);
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Song Add Api Error");
    }}

  List<int> numbers1 = [];
  RxList<Map<String,dynamic>> playListSongData = < Map<String,dynamic>>[].obs;
  Future<void> convertStringToPlayList ({int? index})async{
    numbers1 = List<int>.from(json.decode(databaseDownloadPlayListSongList[index??0]['song_id']??""));
    playListSongData.isNotEmpty?playListSongData.clear():null;
    for(int i= 0; i < numbers1.length; i++){
      if(await fetchSongById(numbers1[i])!=null){
        playListSongData.add(await fetchSongById(numbers1[i])??{});}
    }
    update();
  }
  Future<void> deletePlayListSong ({int? songId,String? filePath,bool? playList12,int? playListId,dynamic number1}) async {
    print("after  ${number1}");
    print("after12  ${playListId}");
    await SongDatabaseService()
        .deleteSong(songId??0)
        .whenComplete(() async {
      await deleteFile1(filePath??"");
      updateDownloadPlayListSong(
        playList12: playList12,
        playlistId: playListId,
        number1: number1.toString(),
      );
      // : null;
    });
    update();
  }

  Future<void> playListDownloadSong(
      {PlayListSongDataModel? playListTrack, int? index}) async {
    isDownloading.value = true;
    // downloadIndex=index;
    try {
      List<int?> songIds =
          playListTrack?.data?.map((e) => e.songId).toList() ?? [];
      final playList = {
        "playlist_id": playListTrack?.data?[index??0].playListId,
        "playlist_name": playListTrack?.data?[index??0].playlistsName,
        "imageUrl": playListTrack?.data?[index??0].playlistImages?[0].image.toString(),
        "song_id": songIds.toString(),
      };
      print("playList${playList}");
      SongDatabaseService().insertPlaylist(playList).then((_) {
        fetchDatabasePlayListSong();
      });
    } catch (e) {
      isDownloading.value = false;
    }
  }
  Future<void> updateDownloadPlayListSong(
      {PlayListSongDataModel? playListTrack, int? index, int? playlistId,bool? playList12,dynamic number1}) async {
    songIds = playListTrack?.data?.map((e) => e.songId).toList() ?? [];
    isDownloading.value = true;

    try {
      final playList = {
        // "playlist_id":   playList12??false ?playlistId : playListTrack?.data?[index ?? 0].playListId,
        // "playlist_name": playList12??false ?databaseDownloadPlayListSongList[index??0]['playlist_name']:  playListTrack?.data?[index??0].playlistsName,
        // "imageUrl":playList12??false?databaseDownloadedAlbumSongList[index??0]['imageUrl'].toString(): playListTrack?.data?[index??0].playlistImages?[0].image.toString(),
        "song_id":playList12??false? number1: songIds.toString(),
      };
      print("Update playList  $playList");
      SongDatabaseService()
          .updatePlaylist(playList12??false ?playlistId??0 :playListTrack?.data?[index ?? 0].playListId ?? 0, playList)
          .then((_) {
        fetchDatabasePlayListSong();
      });
    } catch (e) {
      print(e.toString());
      isDownloading.value = false;
    }
  }
  Future<void> deleteFile1(String filePath,{bool? isAlbum}) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete().then((_) {
         fetchDatabasePlayListSong();
      });
      print("File deleted: $filePath");
    } else {
      print("File does not exist: $filePath");
    }
  }
  deletePlayList ({int? index, String? path,int? playListId}){
    print("this ===========jhjhjh${numbers1}");
    print("this ===========jhjhjhpaly${playListId}");
    numbers1.remove(index);
    print("this ===========jhjhjhakefnqejf${numbers1}");
    Get.find<MyLibraryController>().playListSongData.removeWhere((v)=>v['song_id']== index);
    deletePlayListSong(songId: index, playList12: true,filePath: path,number1: numbers1,playListId: playListId);
    Get.find<MyLibraryController>().update();

  }
  Future<bool?> playListAlbumAddApi({required int? albumId,required int? playlistsId}) async {
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        // 'song_id':songId,
        "albums_id":albumId,
        "playlists_id":playlistsId
      };
      final response = await _homeChopperService.playlistAlbumsAdd(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        // Get.back(result: true);
        Get.find<MyLibraryController>().playListDataApi();
        update();
        Get.back();
        Get.back();
        Get.back();
        Utility.showSnackBar(response.body?.message??'');
        return true;
      }else{
        Get.back();
        Get.back();
        Get.back();
        Utility.showSnackBar(response.body?.message??'',isError: true);
        return false;
      }
    } catch (e) {
      log("", error: e.toString(), name: "PlayList Song Add Api Error");
      return false;
    }}
}