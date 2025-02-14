import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/ExploreArtistWidget.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/ExploreGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/ViewAll/ViewAllScreen.dart';

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
              return ExploreArtistWidget(
                onViewAll: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId, type: firstTrendingData?[index].trendingscategoryFor).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                data: firstTrendingData?[index].data,
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
              );
            case TrendingSCategoryFor.genres:
              print("genres1");
              return firstTrendingData?[index].data?.isNotEmpty??false? ExploreGenreWidget(
                onViewAllTap: () {
                  print(firstTrendingData?[index].trendingscategoryId);
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              ):SizedBox.shrink();

            case TrendingSCategoryFor.radio:
              print("radio");
              return  firstTrendingData?[index].data?.isNotEmpty??false? HomeRadioWidget(
                onViewAllTap: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.tracks:
              print("tracks");
              return  firstTrendingData?[index].data?.isNotEmpty??false? HomeTrackWidget(
                onViewAllTap: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.mixes:
              print("mixes");
              return  firstTrendingData?[index].data?.isNotEmpty??false? HomeMixesWidget(
                onViewAllTap: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.albums:
              return firstTrendingData?[index].data?.isNotEmpty??false? HomeAlbumWidget(
                onViewAllTap: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.playList:
              return firstTrendingData?[index].data?.isNotEmpty??false? HomePlaylistWidget(
                onViewAllTap: () {
                  Get.find<ExplorController>().exploreViewAllDataApi(type: firstTrendingData?[index].trendingscategoryFor, flowavtivotrendingscategoryId: firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllScreen(
                      trendingscategoryFor: firstTrendingData?[index].trendingscategoryFor,
                      title: firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                firstTrendingData?[index].trendingscategoryName,
                data: firstTrendingData?[index].data, onPlaylistTap: () {  },
              ):SizedBox.shrink();
            default:
              return SizedBox.shrink();
          }
        });
  }
}
