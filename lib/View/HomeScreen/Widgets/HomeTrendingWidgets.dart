import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeTrendingWidgets extends StatefulWidget {
  final List<FirstTrendingsData>? firstTrendingData;


  const HomeTrendingWidgets({super.key, required this.firstTrendingData});

  @override
  State<HomeTrendingWidgets> createState() => _HomeTrendingWidgetsState();
}

class _HomeTrendingWidgetsState extends State<HomeTrendingWidgets> {
  @override
  void initState() {
    Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>());
    // TODO: implement initState

    super.initState();
  }
  @override
  void dispose() {
    Get.find<BaseController>().bannerAd.dispose();
    super.dispose();
  }
  @override

  Widget build(BuildContext context) {
    String? categoryName;
    return ListView.separated(
      separatorBuilder: (context,index){
        return
          GetBuilder<BaseController>(
            init: Get.find<BaseController>(),
            builder: (controller) {
              return index == 4 && (Get.find<BaseController>().isAdLoaded)?SizedBox(
                height: 70.h,
                width: double.maxFinite,
                child: AdWidget(ad: Get.find<BaseController>().bannerAd),
              ): SizedBox.shrink();
            }
          );
      },
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.firstTrendingData?.length??0,
        itemBuilder: (context, index) {
          switch (TrendingSCategoryFor.values
              .firstWhere((e) => e.value == widget.firstTrendingData?[index].trendingscategoryFor)) {
            case TrendingSCategoryFor.artists:
              print("artists");
              return Stack(
                children: [

                  HomeArtistsWidget(
                    onViewAll: () {
                      Get.find<HomeController>().viewAllDataApi(trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId, type: widget.firstTrendingData?[index].trendingscategoryFor).then((_){
                        Get.toNamed(RoutesName.viewAllScreen,arguments: {
                          "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                          "titleName": widget.firstTrendingData?[index].trendingscategoryName
                        });
                      });
                    },
                    data: widget.firstTrendingData?[index].data,
                    trendingCategoryName:
                        widget.firstTrendingData?[index].trendingscategoryName,
                  ),
                  Obx(()=> Visibility(
                      visible: Get.find<HomeController>().isLoading.value,
                      child: AppLoder())),
                ],
              );
            case TrendingSCategoryFor.genres:
              print("genres1");
              return Stack(
                children: [

                  HomeGenreWidget(
                    onViewAllTap: () {
                      Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                        Get.toNamed(RoutesName.viewAllScreen,arguments:{
                          "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                          "titleName": widget.firstTrendingData?[index].trendingscategoryName
                        });
                      });
                    },
                    trendingCategoryName:
                        widget.firstTrendingData?[index].trendingscategoryName,
                    data: widget.firstTrendingData?[index].data,
                  ),
                  Obx(()=>Visibility(
                      visible: Get.find<HomeController>().isLoading.value,
                      child: AppLoder())),
                ],
              );

            case TrendingSCategoryFor.radio:
              print("radio");
              return HomeRadioWidget(

                onViewAllTap: () {
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments: {
                     "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                      "titleName": widget.firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                    widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.tracks:
              print("tracks");
              return HomeTrackWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                      "titleName": widget.firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },

                trendingCategoryName:
                    widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.mixes:
              print("mixes");
              return HomeMixesWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                      "titleName": widget.firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                    widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,

              );
            case TrendingSCategoryFor.albums:
              return HomeAlbumWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                      "titleName": widget.firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },

                trendingCategoryName:
                    widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              );
              case TrendingSCategoryFor.playList:
              return HomePlaylistWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Get.toNamed(RoutesName.viewAllScreen,arguments:{
                      "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
                      "titleName": widget.firstTrendingData?[index].trendingscategoryName
                    });
                  });
                },
                trendingCategoryName:
                    widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data, onPlaylistTap: () {  },
              );
            default:
              return SizedBox.shrink();
          }
        });
  }
}
