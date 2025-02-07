import 'dart:developer';

import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Models/MixesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MixesController extends BaseController {
  late HomeChopperService _homeChopperService;

  MixesController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  int  paginationInt = 1;

  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener((){
      scrollListener();
    });
  }


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
          await mixesApi(); // Fetch next page
        }
      }
    }
  }
  MixesDataModel? mixesDataModel;

  Future<void> mixesApi() async {
    try {
      showLoader(true);
      final queryParameters = {"filter": "Mixes", "limit": 50, "page": 1};
      final response =
          await _homeChopperService.mixesApi(queryParameters: queryParameters);
      if (response.body?.status == 200) {
        mixesDataModel = response.body;
        maxPages = mixesDataModel?.lastPage;
        showLoader(false);

        update(['mixes']);
        update();
      } else {
        showLoader(false);
        update();
        Get.snackbar("Error", response.body?.message ?? '');
      }
    } catch (e) {
      showLoader(false);
      log("", name: "Mixes Api Error", error: e.toString());
    }
  }

  TracksDataModel? mixesTracksDataModel;

  Future<void> mixesSubCategoryAndTracksApi({int? mixesId}) async {
    try {
      Get.find<HomeController>().
      showLoader(true);
      Get.find<ExplorController>().
      showLoader(true);
      showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Mixes",
        "recordtype": "Tracks",
        "mixes_id": mixesId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        mixesTracksDataModel = response.body;
        print(mixesTracksDataModel?.mostPlayed?.length);
      } else {
        mixesTracksDataModel = null;
      }
      Get.find<HomeController>().
      showLoader(false);
      Get.find<ExplorController>().
      showLoader(false);
      showLoader(false);
      update();
    } catch (e) {
      Get.find<HomeController>().
      showLoader(false);
      Get.find<ExplorController>().
      showLoader(false);
      showLoader(false);
      log("",
          error: e.toString(), name: "Mixes SubCategory And Tracks Api Error");
    }
  }
  Future<void> plaListTrackSongApi({int? flowActivoPlaylistId}) async {
    try {
      Get.find<HomeController>().showLoader(true);
      Get.find<ExplorController>().showLoader(true);
      showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter":"FlowActivoPlaylist",
        "recordtype": "Tracks",
        "flowactivoplaylist_id": flowActivoPlaylistId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        mixesTracksDataModel = response.body;
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        showLoader(false);
        update();
      } else {
        print("object");
        mixesTracksDataModel = null;
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        showLoader(false);

        update();
      }
    } catch (e) {
      Get.find<HomeController>().showLoader(false);
      Get.find<ExplorController>().showLoader(false);
      showLoader(false);

      log('', error: e.toString(), name: "Artiest Track Data Model");
    }
  }
}
