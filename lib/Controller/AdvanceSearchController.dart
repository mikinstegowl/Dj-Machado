import 'dart:developer';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Models/AdvanceSearchSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/RecentSeachDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdvanceSearchController extends BaseController {
  late HomeChopperService _homeChopperService;
  TextEditingController advanceSearchController = TextEditingController();
  final Debounce debounce = Debounce(Duration(seconds: 1));
  int selectedTab = 0;

  AdvanceSearchController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  RecentSearchDataModel? recentSearchDataModel;

  @override
  void onInit() async {
    super.onInit();
    controllerFor.addListener((){
      scrollListenerFor();
    });
  }

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

  int pagination = 1;
  int maxPage = 1;
  int index1 = 0;
  ScrollController controllerFor = ScrollController();

  Rxn<AdvanceSearchSongDataModel> advanceSearchSongDataModel =
  Rxn<AdvanceSearchSongDataModel>();
  Future<void> scrollListenerFor() async {
    if (controllerFor.hasClients) {

      if (controllerFor.position.pixels == controllerFor.position.maxScrollExtent) {

        if (pagination < maxPage) {
          pagination ++;
          print(pagination);
          await advanceSearchApi(index1);
          // await viewAllDataApi(trendingscategoryId: trendingscategoryId1,type: type1); // Fetch next page
        }
      }
    }
  }


  Future<void> advanceSearchApi(int index) async {

    print(advanceSearchController.text);
    List type = ['Tracks', 'Artists', 'Albums', "Playlist"];
    try {
      showLoader(true);
      final param = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "search": advanceSearchController.text,
      };
      final queryParameters = {
        "limit": 20,
        "type": type[index],
        "page": pagination,
      };
      final response = await _homeChopperService.advanceSearchApi(
          param: param, queryParameters: queryParameters);
      if (response.body?.status == 200) {
            if(pagination ==1) {
          advanceSearchSongDataModel.value = response.body;
          index1 = index;
          maxPage =  advanceSearchSongDataModel.value?.lastPage??0;
          recentSearchDataModel =
              RecentSearchDataModel(recentList: [], trendinglistData: []);
          // advanceSearchController.clear();
          showLoader(false);
        }else{
              if (advanceSearchSongDataModel.value?.data == null) {
                advanceSearchSongDataModel.value?.data = [];
              }
              List<MixesTracksData> newData = response.body?.data ?? [];
              if (newData.isNotEmpty) {
                advanceSearchSongDataModel.value?.data?.addAll(newData);
              }
              print("this is data length ${advanceSearchSongDataModel.value?.data?.length}");
              // advanceSearchSongDataModel.value?.data?.addAll(response.body?.data??[]);
              showLoader(false);
              update();
            }
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
