import 'dart:developer';
import 'dart:io';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newmusicappmachado/Controller/HomeController.dart';

import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ViewAllRadioDataModel.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ExplorController extends BaseController {
  late HomeChopperService _homeChopperService;

  ExplorController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  ExplorDataModel? explorDataModel;
  bool shuffle = false;
  int  paginationInt = 1;

  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener((){
      scrollListener();
    });
  }

  ViewAllRadioDataModel? viewAllDataModel;
  Future<void> exploreViewAllDataApi({required int? flowavtivotrendingscategoryId,required String?type}) async {
    try {
     showLoader(true);
      final queryParameters = {
        "limit": 50,
        "flowactivotrendingscategory_id":flowavtivotrendingscategoryId,
        'type': type,
      };
      final response = await _homeChopperService.exploreViewAllApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        viewAllDataModel = response.body;
        showLoader(false);
        update();
      }
    } catch (e) {
      log("", error: e.toString(), name: "View All Api Error");
    }}

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
          await explorScreenApi(); // Fetch next page
        }
      }
    }
  }

  Future<void> explorScreenApi() async {
    showLoader(true);
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "shuffle": shuffle ? "MenuRefresh" : "OpenClose",
        "categorylimit": 30,
        "page": paginationInt
      };
      final response = await _homeChopperService.exploreApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
            if(paginationInt ==1) {
          shuffle = true;
          explorDataModel = response.body;
          maxPages = explorDataModel?.lastPage;
          showLoader(false);
          update();
        }else{
              explorDataModel?.data?.addAll(response.body?.data??[]);
              paginationInt =1;
              showLoader(false);
              update();
            }
      } else {
        showLoader(false);
        update();
        Get.snackbar('Error', response.body?.message ?? '');
      }
    } catch (e) {
      showLoader(false);
      update();
      log('', name: "Explor Api Error", error: e.toString());
    }
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

  TracksDataModel? albumTracksDataModel;

  Future<void> selectedGenreAlbumApi(int genresId) async {
    try {
      showLoader(true);
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
         showLoader(true);
        update();
      } else {
        albumTracksDataModel = null;
        showLoader(true);
        update();
      }
      update();
    } catch (e) {
      showLoader(true);
      update();
      log('', error: e.toString(), name: "Selected Genre Api Data Error");
    }
  }

}
