import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/GenresModel.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/NotificationDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListAddDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ProfileDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ShareAppModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongDetaiDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ViewAllRadioDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart'as http;

class HomeController extends BaseController {
  late HomeChopperService _homeChopperService;



  HomeController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  @override
  void onInit() async {
    super.onInit();
     scrollController = ScrollController();
    scrollController.addListener((){
      scrollListener();
    });
    controllerFor.addListener((){
      scrollListenerFor();
    });
  }

  GenresModel? genresModel;

  Future<void> getAllGenres() async {
    try {
      showLoader(true);
      final queryMap = {"filter": "Genres", "limit": 50, "page": 1};
      final response =
          await _homeChopperService.getAllGenres(queryParameters: queryMap);
      if (response.body?.status == 200) {
        genresModel = response.body;
        print(UserPreference.getValue(key: PrefKeys.genresId));
        if (UserPreference.getValue(key: PrefKeys.genresId) != null) {
          genresSelectedCheck = UserPreference.getValue(key: PrefKeys.genresId)
                  .replaceAll(RegExp(r'[^\d,]'), '')
                  .split(',')
                  .map((e) => int.parse(e))
                  .toList() ??
              [];
          showLoader(false);
        } else {
          showLoader(false);
          genresSelectedCheck = [];
        }
      }
      update();
    } catch (e) {
      showLoader(false);
      log('', error: e.toString(), name: 'Genres Get Api Error');
    }
  }

  List genresSelectedCheck = [];

  void checked({int? id}) {
    if (genresSelectedCheck.contains(id)) {
      genresSelectedCheck.remove(id!);
    } else {
      genresSelectedCheck.add(id!);
    }
    update();
  }
  TracksDataModel? songsTracksDataModel;

  Future<void> selectedGenreSongsApi(int genresId) async {
    try {
      showLoader(true);

      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Genres",
        "recordtype": "Tracks",
        "genres_id": genresId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        songsTracksDataModel = response.body;
        showLoader(false);
        update();
      } else {
        songsTracksDataModel = null;
        showLoader(false);
        update();
      }
      update();
    } catch (e) {
      log('', error: e.toString(), name: "Selected Genre Api Data Error");
    }
  }

  Future<void> saveGenres() async {
    try {
      showLoader(true);
      final param = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "genres_id": genresSelectedCheck.map((e) => e.toString()).toList(),
        "device_type": Platform.isAndroid ? "Android" : "IOS"
      };
      final response = await _homeChopperService.saveGenres(param: param);
      if (response.body?.code == 200) {
        UserPreference.setValue(key: PrefKeys.genresId,value:genresSelectedCheck.toString());
        log(UserPreference.getValue(key: PrefKeys.genresId,).toString());
        Utility.showSnackBar(response.body?.message ?? '');
        Get.offNamed(RoutesName.homeScreen);
        showLoader(false);
        update();
      } else {
        showLoader(false);
        update();
        Utility.showSnackBar(response.body?.message ?? '',isError:true);
      }
    } catch (e) {
      log('', error: e.toString(), name: "Save Genres Error");
    }
  }












  int  paginationInt = 1;

  ScrollController scrollController = ScrollController();


  int? maxPages;



  Future<void> scrollListener() async {

    if (scrollController.hasClients) {
    print("ture sate ${scrollController.position.pixels == scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("max ${paginationInt < maxPages!}");
        print("max ${maxPages!}");
        if (paginationInt < maxPages!) {
          paginationInt++;
          print(paginationInt);
          await homeDataApi(); // Fetch next page
        }
      }
    }
  }


  bool openClose = true;
  HomeDataModel? homeDataModel;

  Future<void> homeDataApi() async {
    showLoader(true);
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "shuffle": openClose ? "OpenClose" : "MenuRefresh",
        "categorylimit": 30,
        "page": paginationInt
      };
      final response = await _homeChopperService.homeDataApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        if(paginationInt == 1){
          homeDataModel = response.body;
          maxPages = homeDataModel?.lastPage;
          openClose = false;
          showLoader(false);
          update();
        }
      else{
          homeDataModel?.data?.addAll(response.body?.data ?? []);
          // trendingscategoryId1 = null;
          // type1 = null;
          paginationInt =1;
          showLoader(false);
          update();
        }
      }
      showLoader(false);
      update();
    } catch (e) {
      showLoader(false);
      log('', error: e.toString(), name: "Home Data Api Error");
    }
  }
  SongDetailDataModel? songDetailDataModel;

  Future<void> songDetailsDataApi({required int songId}) async {
    try {

      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "song_id": songId,
      };
      final response = await _homeChopperService.songDetailApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        songDetailDataModel = response.body;
        recentPlayedApi(songId: songId);

      }
      update(['SongScreen']);
    } catch (e) {

      log("", error: e.toString(), name: "Song Details Api Error");
    }
  }
  TracksDataModel? albumTracksDataModel;

  Future<void> selectedGenreAlbumApi(int genresId) async {
    try {
      showLoader(true);
      Get.find<HomeController>().showLoader(true);
      Get.find<ExplorController>().showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Genres",
        "recordtype": "Albums",
        "genres_id": genresId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        albumTracksDataModel = response.body;
        showLoader(false);
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      } else {
        albumTracksDataModel = null;
        showLoader(false);
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      }
      update();
    } catch (e) {
      showLoader(false);
      Get.find<HomeController>().showLoader(false);
      Get.find<ExplorController>().showLoader(false);
      update();
      log('', error: e.toString(), name: "Selected Genre Api Data Error");
    }
  }
  int paginationForTrending = 1;
  ScrollController controllerFor = ScrollController();
  Future<void> scrollListenerFor() async {
    if (controllerFor.hasClients) {

      if (controllerFor.position.pixels == controllerFor.position.maxScrollExtent) {

        if (paginationForTrending < maxPage!) {
          paginationForTrending ++;
          print(paginationForTrending);
          await viewAllDataApi(trendingscategoryId: trendingscategoryId1,type: type1); // Fetch next page
        }
      }
    }
  }

  int? maxPage;
  int? trendingscategoryId1;
  String? type1;
ViewAllRadioDataModel? viewAllDataModel;
  Future<void> viewAllDataApi({required int? trendingscategoryId,required String?type}) async {
    try {
      Get.find<HomeController>().showLoader(true);
      final queryParameters = {
        "limit": 50,
        "trendingscategory_id":trendingscategoryId,
        'type': type,
        'page': paginationForTrending
      };
      final response = await _homeChopperService.viewAllApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
            if(paginationForTrending ==1){
          Get.back();
          viewAllDataModel = response.body;
          maxPage = viewAllDataModel?.lastPage;
          trendingscategoryId1 = trendingscategoryId;
          type1 = type;
          // Get.find<BaseController>().googleAdsApi(homeChopperService: _homeChopperService);
          Get.find<HomeController>().showLoader(false);
          update();
          // Get.find<BaseController>().update();
          }else{
              viewAllDataModel?.data?.addAll(response.body?.data??[]);
              // paginationForTrending = 1;
              Get.find<HomeController>().showLoader(false);
            update();
            }
      }else{
        viewAllDataModel = null;
        Get.find<HomeController>().showLoader(false);
        update();
      }
    } catch (e) {
      showLoader(false);
      log("", error: e.toString(), name: "View All Api Error");
    }}





  Future<void> logoutApi() async {
    try {
      final queryParameters = {
        "logout" : UserPreference.getValue(key: PrefKeys.userId)
      };
      final response = await _homeChopperService.logoutApi(
          queryParameters: queryParameters);
      if (response.body?.code == 200) {
        UserPreference.clear();
        Utility.showSnackBar(response.body?.message);
        Get.offAllNamed(RoutesName.logInScreen);
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "logout Api Error");
    }}




  ShareAppModel? shareAppModel;
  Future<void> shareAppApi() async {
    try {

      final response = await _homeChopperService.shareAppApi();
      if (response.body?.status == 200) {
        shareAppModel = response.body;
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "logout Api Error");
    }}



  User? user;
  Future<void> fetchUsers(var id) async {
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users/${id.toString()}'));
    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      Map<String,dynamic> jsonData = json.decode(response.body);
      user = User.fromJson(json.decode(response.body));
      print('User ID: ${user?.id}, Name: ${user?.name}');
      // print(user?.id);
      update(['SongScreen']);
    } else {
      print("this==========${response.statusCode}");
      // If the server did not return a 200 OK response, throw an exception
      throw Exception('Failed to load users');
    }
  }

  GeneralErrorModel? generalErrorModel;
  Future<void> recentPlayedApi({int? songId})async {
    try{
      final queryParameters={
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        'song_id':songId,
      };
    final response = await _homeChopperService.recentPlayed(queryParameters: queryParameters);
    if(response.body?.code == 200){
      generalErrorModel = response.body;
    }else{
      print(response.body?.message);
    }
    }catch(e){
      log("", error: e.toString(), name: "recent Played Song Add Api Error");
    }

  }
}
class User {
  final int id;
  final String name;
  final String username;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      email: json['email'],
    );
  }

}
