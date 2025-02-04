import 'dart:developer';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Models/AdvanceSearchSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/RecentSeachDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvanceSearchController extends BaseController {
  late HomeChopperService _homeChopperService;
  TextEditingController advanceSearchController = TextEditingController();
  final Debounce debounce = Debounce(Duration(seconds: 3));
  int selectedTab = 0;

  AdvanceSearchController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  RecentSearchDataModel? recentSearchDataModel;

  Future<void> recentSearch() async {
    try {
      final param = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "filter": "recentlist"
      };
      final response = await _homeChopperService.recentSearchApi(param: param);
      if (response.body?.status == 200) {
        recentSearchDataModel = response.body;
        advanceSearchSongDataModel.value = null;
      }
      update();
    } catch (e) {
      log('', error: e.toString(), name: "Recent Search Api Error");
    }
  }

  Rxn<AdvanceSearchSongDataModel> advanceSearchSongDataModel =
  Rxn<AdvanceSearchSongDataModel>();

  Future<void> advanceSearchApi(int index) async {
    showLoader(true);
    print(advanceSearchController.text);
    List type = ['Tracks', 'Artists', 'Albums', "Playlist"];
    try {
      final param = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "search": advanceSearchController.text,
      };
      final queryParameters = {
        "limit": 20,
        "type": type[index],
        "page": 1,
      };
      final response = await _homeChopperService.advanceSearchApi(
          param: param, queryParameters: queryParameters);
      if (response.body?.status == 200) {
        advanceSearchSongDataModel.value = response.body;
        recentSearchDataModel =
            RecentSearchDataModel(recentList: [], trendinglistData: []);
        // advanceSearchController.clear();
        showLoader(false);
      } else {
        recentSearchDataModel =
            RecentSearchDataModel(recentList: [], trendinglistData: []);
        showLoader(false);
      }

      update();
    } catch (e) {
      showLoader(false);
      log("", error: e.toString(), name: "advance Seach Api Error");
    }
  }
}
