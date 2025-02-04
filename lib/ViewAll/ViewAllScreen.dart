import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppIcons.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/DataView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ViewAllScreen extends StatefulWidget {

  const ViewAllScreen({super.key});

  @override
  State<ViewAllScreen> createState() => _ViewAllScreenState();
}

class _ViewAllScreenState extends State<ViewAllScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

      // Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>());


  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: GetBuilder<BaseController>(
            init: Get.find<BaseController>(),
            builder: (controller) {
              return Scaffold(
                  backgroundColor: AppColors.darkgrey,
                  extendBodyBehindAppBar: true,
                  bottomSheet: AudioPlayerController(),
                  bottomNavigationBar: BottomBarWidget(
                    mainScreen: false,
                  ),
                  appBar: AppBar(
                    toolbarHeight: 80.h,
                    bottom: PreferredSize(
                      preferredSize: Size.fromHeight(1.h), // Adjust height as needed
                      child: const Divider(
                        thickness: 2,
                      ),
                    ),
                    leadingWidth: 140.w,
                    leading: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Row(
                        children: [
                          Icon(
                            AppIcons.navigate_before,
                            size: 28.r,
                            color: AppColors.white,
                          ),
                          const AppTextWidget(
                            fontWeight: FontWeight.w600,
                            txtTitle: "Back",
                            txtColor: AppColors.white,
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                    backgroundColor: AppColors.transparent,
                    centerTitle: true,
                    title: AppTextWidget(
                      txtTitle: Get.arguments['titleName'] ?? '',
                      txtColor: AppColors.white,
                      fontSize: 18,
                    ),
                    actions: [
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed(RoutesName.advanceSearchScreen);
                          },
                          child: Icon(
                            AppIcons.search,
                            size: 30.r,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  body: Container(
                    height: MediaQuery.sizeOf(context).height,
                    padding: EdgeInsets.only(top:65.h),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(AppAssets.backGroundImage))
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (Get.find<BaseController>().isAdLoaded)
                              SizedBox(
                                height: 60.h,
                                width: double.maxFinite,
                                child: AdWidget(ad: Get.find<BaseController>().bannerAd),
                              ),
                            trendingSCategoryWidget(),
                          ],
                        ),
                      ),
                    ),
                  ));
            }
          ),
        ),
        Obx(()=> Visibility(
          visible: Get.find<BaseController>().isLoading.value,
            child: AppLoder()))
      ],
    );
  }

  Widget trendingSCategoryWidget() {
    switch (TrendingSCategoryFor.values
        .firstWhere((e) => e.value == Get.arguments['trendingscategoryFor'])) {
      case TrendingSCategoryFor.artists:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  Get.find<ArtistsController>().trackSongApi(Get.find<HomeController>()
                      .viewAllDataModel
                      ?.data?[index].artistsId??0).then((_){
                    Get.find<ArtistsController>().albumSongApi(Get.find<HomeController>()
                        .viewAllDataModel
                        ?.data?[index].artistsId??0).then((_){
                      Get.toNamed(RoutesName.songsAlbumsScreen);
                    });
                  });
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .artistsName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .artistsImage,
                subtitle: "",
              );
            });

      case TrendingSCategoryFor.genres:
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  Get.find<ExplorController>().selectedGenreAlbumApi(Get.find<HomeController>()
                      .viewAllDataModel
                      ?.data?[index].genresId??0).then((_){
                    Get.find<ExplorController>().selectedGenreSongsApi(Get.find<HomeController>()
                        .viewAllDataModel
                        ?.data?[index].genresId??0).then((_){
                      Get.toNamed(RoutesName.songsAlbumsScreen,arguments: {'isGenre':true});
                    });
                  });

                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .genresName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .genresImage,
                subtitle: "",
              );
            });

      case TrendingSCategoryFor.radio:
       return  GridView.builder(
         physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  // Get.find<ExplorController>().selectedGenreAlbumApi(Get.find<HomeController>()
                  //     .viewAllDataModel
                  //     ?.data?[index].genresId??0).then((_){
                  //   Get.find<ExplorController>().selectedGenreSongsApi(Get.find<HomeController>()
                  //       .viewAllDataModel
                  //       ?.data?[index].genresId??0).then((_){
                  //     Get.toNamed(RoutesName.songsAlbumsScreen,arguments: {'isGenre':true});
                  //   });
                  // });
                  PlayerService.instance.createPlaylist(Get.find<HomeController>().viewAllDataModel?.data, index: index,type: "radio",id: Get.find<HomeController>()
                      .viewAllDataModel
                      ?.data?[index]
                      .songId);
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .trendingsradioName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .trendingsradioImage,
                subtitle: "",
              );
            });
      case TrendingSCategoryFor.tracks:

        return  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  // Get.find<ExplorController>().selectedGenreAlbumApi(Get.find<HomeController>()
                  //     .viewAllDataModel
                  //     ?.data?[index].genresId??0).then((_){
                  //   Get.find<ExplorController>().selectedGenreSongsApi(Get.find<HomeController>()
                  //       .viewAllDataModel
                  //       ?.data?[index].genresId??0).then((_){
                  //     Get.toNamed(RoutesName.songsAlbumsScreen,arguments: {'isGenre':true});
                  //   });
                  // });
                  PlayerService.instance.createPlaylist(Get.find<HomeController>().viewAllDataModel?.data, index: index,id: Get.find<HomeController>()
                      .viewAllDataModel
                      ?.data?[index]
                      .songId);
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songImage,
                subtitle: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songArtist,
              );
            });

      case TrendingSCategoryFor.albums:
        return  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            // padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  Get.find<ArtistsController>().albumsAndTracks(albumId:Get.find<HomeController>()
                      .viewAllDataModel
                      ?.data?[index].albumsId??0).then((_){
                      Get.toNamed(RoutesName.albumTrackScreen);
                  });
                  // PlayerService.instance.createPlaylist(Get.find<HomeController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsImage,
                subtitle: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsArtist,
              );
            });

      case TrendingSCategoryFor.mixes:
        return  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  Get.find<MixesController>().mixesSubCategoryAndTracksApi(
                      mixesId: Get.find<HomeController>().viewAllDataModel
                          ?.data?[index].mixesId)
                      .then((_) {
                    Get.toNamed(RoutesName.mixesSongScreen,
                        arguments: {
                          'title': Get.find<HomeController>().viewAllDataModel
                              ?.data?[index].mixesName
                        });
                  });
                  // PlayerService.instance.createPlaylist(Get.find<HomeController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .mixesName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .mixesImage,
                subtitle: "",
              );
            });
      case TrendingSCategoryFor.playList:
        return  GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
            Get.find<HomeController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 210.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onTap: () {
                  Get.find<MixesController>().plaListTrackSongApi(
                      flowActivoPlaylistId: Get.find<HomeController>().viewAllDataModel
                          ?.data?[index].flowactivoplaylistId)
                      .then((_) {
                    Get.toNamed(RoutesName.mixesSongScreen,
                        arguments: {
                          'title': Get.find<HomeController>().viewAllDataModel
                              ?.data?[index].flowactivoplaylistName
                        });
                  });
                  // PlayerService.instance.createPlaylist(Get.find<HomeController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .flowactivoplaylistName,
                image: Get.find<HomeController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .flowactivoplaylistImage,
                subtitle: "",
              );
            });

      default:
        return Container();
    }
  }
}
