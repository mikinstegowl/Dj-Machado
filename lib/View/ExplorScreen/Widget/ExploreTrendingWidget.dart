import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExploreTrendingWidgets extends StatelessWidget {
  final List<FirstTrendingsData>? firstTrendingData;


  const ExploreTrendingWidgets({super.key, required this.firstTrendingData});

  @override

  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: firstTrendingData?.length,
        itemBuilder: (context, index) {
          switch (TrendingSCategoryFor.values
              .firstWhere((e) => e.value == firstTrendingData?[index].trendingscategoryFor)) {
            case TrendingSCategoryFor.artists:
              print("artists");
              return HomeArtistsWidget(
                onViewAll: () {
                  Get.find<HomeController>().exploreViewAllDataApi(flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId, type: firstTrendingData?[index].trendingscategoryFor).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments: {
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                data: firstTrendingData?[index].data,
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
              );
            case TrendingSCategoryFor.genres:
              print("genres1");
              return HomeGenreWidget(
                onViewAllTap: () {
                  print(firstTrendingData?[index].trendingscategoryId);
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:  {
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              );

            case TrendingSCategoryFor.radio:
              print("radio");
              return HomeRadioWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments: {
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.tracks:
              print("tracks");
              return HomeTrackWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.mixes:
              print("mixes");
              return HomeMixesWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.albums:
              return HomeAlbumWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.playList:
              return HomePlaylistWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": firstTrendingData?[index].trendingscategoryFor,
                      "titleName": firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data, onPlaylistTap: () {  },
              );
            default:
              return SizedBox.shrink();
          }
        });
  }
}
