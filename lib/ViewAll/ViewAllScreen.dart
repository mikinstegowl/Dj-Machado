import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppIcons.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/AddPlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/CreatePlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/ExistingPlaylistDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/DataView.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';

class ViewAllScreen extends StatefulWidget {
  final String? title;
  final String? trendingscategoryFor;
  const ViewAllScreen({super.key, this.title, this.trendingscategoryFor});

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
                      routeName: 'Explore',
                      indx: 1,
                    ),
                    appBar: AppBar(
                      toolbarHeight: 80.h,
                      bottom: PreferredSize(
                        preferredSize:
                            Size.fromHeight(1.h), // Adjust height as needed
                        child: const Divider(
                          thickness: 2,
                        ),
                      ),
                      leadingWidth: 140.w,
                      leading: InkWell(
                        splashColor: AppColors.primary,
                        onTap: () {
                          Get.back();
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              height: 25.h,
                              width: 25.h,
                              AppAssets.backIcon,
                              // size: 28.r,
                            ),
                            5.horizontalSpace,
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
                        txtTitle: widget.title ?? '',
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
                      padding: EdgeInsets.only(top: 65.h),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.fill,
                              image: AssetImage(AppAssets.backGroundImage))),
                      child: Padding(
                        padding:
                            EdgeInsets.only(top: 10.h, left: 0.w, right: 0.w),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              CommonAdWidget(),
                              10.verticalSpace,
                              trendingSCategoryWidget(),
                              50.verticalSpace,
                            ],
                          ),
                        ),
                      ),
                    ));
              }),
        ),
        Obx(() => Visibility(
            visible: Get.find<ExplorController>().isLoading.value,
            child: AppLoder()))
      ],
    );
  }

  Widget trendingSCategoryWidget() {
    switch (TrendingSCategoryFor.values
        .firstWhere((e) => e.value == widget.trendingscategoryFor)) {
      case TrendingSCategoryFor.artists:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                isTrending: true,
                onTap: () {
                  // Get.find<ArtistsController>().trackSongApi(Get.find<ExplorController>()
                  //     .viewAllDataModel
                  //     ?.data?[index].artistsId??0).then((_){
                  //   Get.find<ArtistsController>().albumSongApi(Get.find<ExplorController>()
                  //       .viewAllDataModel
                  //       ?.data?[index].artistsId??0).then((_){
                  //     Get.toNamed(RoutesName.songsAlbumsScreen);
                  //   });
                  // });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SongsAlbumsScreen(
                          id: Get.find<ExplorController>()
                                  .viewAllDataModel
                                  ?.data?[index]
                                  .artistsId ??
                              0,
                          type: 'Artists')));
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .artistsName,
                image: Get.find<ExplorController>()
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
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                isTrending: true,
                onTap: () {
                  // Get.find<ExplorController>()
                  //     .selectedGenreAlbumApi(Get.find<ExplorController>()
                  //             .viewAllDataModel
                  //             ?.data?[index]
                  //             .genresId ??
                  //         0)
                  //     .then((_) {
                  //   Get.find<ExplorController>()
                  //       .selectedGenreSongsApi(Get.find<ExplorController>()
                  //               .viewAllDataModel
                  //               ?.data?[index]
                  //               .genresId ??
                  //           0)
                  //       .then((_) {
                  //     Get.toNamed(RoutesName.songsAlbumsScreen,
                  //         arguments: {'isGenre': true, 'homeScreen': false});
                  //   });
                  // });
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => SongsAlbumsScreen(
                          id: Get.find<ExplorController>()
                                  .viewAllDataModel
                                  ?.data?[index]
                                  .genresId ??
                              0,
                          type: 'Genres')));
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .genresName,
                image: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .genresImage,
                subtitle: "",
              );
            });

      case TrendingSCategoryFor.radio:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                isTrending: true,
                onTap: () {
                  // Get.find<ExplorController>().selectedGenreAlbumApi(Get.find<ExplorController>()
                  //     .viewAllDataModel
                  //     ?.data?[index].genresId??0).then((_){
                  //   Get.find<ExplorController>().selectedGenreSongsApi(Get.find<ExplorController>()
                  //       .viewAllDataModel
                  //       ?.data?[index].genresId??0).then((_){
                  //     Get.toNamed(RoutesName.songsAlbumsScreen,arguments: {'isGenre':true});
                  //   });
                  // });
                  PlayerService.instance.createPlaylist(
                      Get.find<HomeController>().viewAllDataModel?.data,
                      index: index,
                      type: "radio",
                      id: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songId);
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .trendingsradioName,
                image: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .trendingsradioImage,
                subtitle: "",
              );
            });
      case TrendingSCategoryFor.tracks:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onOptionTap: () {
                  Get.dialog(OptionDialog(
                    isQueue: true,
                    listOfTrackData: Get.find<ExplorController>()
                            .viewAllDataModel
                            ?.data
                            ?.map((e) => MixesTracksData(
                                  song: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .song,
                                  songId: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .songId,
                                  songImage: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .songImage,
                                  originalImage: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .originalImage,
                                  songName: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .songName,
                                  favouritesStatus: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .favouritesStatus,
                                  songArtist: Get.find<ExplorController>()
                                      .viewAllDataModel
                                      ?.data?[index]
                                      .songArtist,
                                ))
                            .toList() ??
                        [],
                    index: index,
                    track: MixesTracksData(
                      song: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .song,
                      songId: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songId,
                      songImage: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songImage,
                      originalImage: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .originalImage,
                      songName: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songName,
                      favouritesStatus: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .favouritesStatus,
                      songArtist: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songArtist,
                    ),
                  ));
                },
                onTap: () {
                  PlayerService.instance.createPlaylist(
                      Get.find<ExplorController>().viewAllDataModel?.data,
                      index: index,
                      id: Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .songId);
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songName,
                image: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songImage,
                subtitle: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .songArtist,
              );
            });

      case TrendingSCategoryFor.albums:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            // padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            // scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                onOptionTap: () async {
                  Get.dialog(AlertDialog(
                    backgroundColor: AppColors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Album Image
                            Container(
                              width: 70.h,
                              height: 70.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    '${Get.find<ExplorController>().viewAllDataModel?.data?[index].albumsImage}', // Replace with your image URL
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            12.horizontalSpace,
                            // Song and artist name
                            AppTextWidget(
                              txtTitle:
                                  '${Get.find<ExplorController>().viewAllDataModel?.data?[index].albumsName}',
                              txtColor: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                        40.verticalSpace,
                        Center(
                            child: AppButtonWidget(
                                width: double.maxFinite,
                                borderColor: AppColors.white.withOpacity(0.5),
                                borderRadius: 10.r,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                onPressed: () async {
                                  Get.back();
                                  Get.dialog(YesNoDialog(
                                      onYesCalled: () async {
                                        Get.dialog(AddPlaylistDialog(
                                          onCreateNewPlayList: () {
                                            Get.dialog(CreatePlayListDialog(
                                              onCreateTap: () async {
                                                Get.find<ExplorController>()
                                                        .viewAllDataModel
                                                        ?.data?[index]
                                                        .playlistStatus =
                                                    await Get.dialog(
                                                        ExistingPlaylistDialog(
                                                  songId: Get.find<
                                                          ExplorController>()
                                                      .viewAllDataModel
                                                      ?.data?[index]
                                                      .songId,
                                                ));
                                              },
                                            ));
                                          },
                                          onAddToExisting: () async {
                                            Get.find<ExplorController>()
                                                    .viewAllDataModel
                                                    ?.data?[index]
                                                    .playlistStatus =
                                                await Get.dialog(
                                                    ExistingPlaylistDialog(
                                              songId:
                                                  Get.find<ExplorController>()
                                                      .viewAllDataModel
                                                      ?.data?[index]
                                                      .songId,
                                            ));
                                          },
                                        ));
                                        // track?.playlistStatus =   await Get.find<MyLibraryController>().playListSongAddApi(playlistsId: track?.playListId,songId: track?.songId??0);
                                        // Get.back();
                                        // }
                                        // Get.find<MyLibraryController>().playListSongDataModel?.data?.removeWhere((v)=>v.playlistStatus==false);
                                      },
                                      message: Get.find<ExplorController>()
                                                  .viewAllDataModel
                                                  ?.data?[index]
                                                  .playlistStatus ??
                                              false
                                          ? "Are you sure you want to remove this song from PlayList?"
                                          : "Are you sure you want to add this song to PlayList?"));
                                },
                                btnName: "",
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0.w),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 35.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(30.r)),
                                          child: Center(
                                              child: Icon(
                                            Icons.playlist_add,
                                            color: AppColors.black,
                                            size: 20,
                                          ))),
                                      10.horizontalSpace,
                                      AppTextWidget(
                                        txtTitle: "Add To Playlist",
                                        fontSize: 15,
                                      ),
                                    ],
                                  ),
                                ))),
                        20.verticalSpace,
                        Center(
                            child: AppButtonWidget(
                                width: double.maxFinite,
                                borderColor: AppColors.white.withOpacity(0.5),
                                borderRadius: 10.r,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                onPressed: () async {
                                  await Get.find<ArtistsController>()
                                      .albumsAndTracks(
                                          albumId: Get.find<HomeController>()
                                              .viewAllDataModel
                                              ?.data?[index]
                                              .albumsId)
                                      .then((_) {
                                    // DownloadService.instance.playListDownloadAllSongs(
                                    //     tracksDataMode: Get.find<ArtistsController>().albumTrackSongData?.data
                                    // );
                                  });
                                  Get.back();
                                },
                                btnName: "",
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10.0.w),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                          height: 35.h,
                                          width: 35.h,
                                          decoration: BoxDecoration(
                                              color: AppColors.primary,
                                              borderRadius:
                                                  BorderRadius.circular(30.r)),
                                          child: Center(
                                              child: Icon(
                                            Icons.download,
                                            color: AppColors.black,
                                            size: 20,
                                          ))),
                                      10.horizontalSpace,
                                      AppTextWidget(
                                        txtTitle: "Download Song",
                                        fontSize: 15,
                                      ),
                                    ],
                                  ),
                                ))),
                        20.verticalSpace,
                        Center(
                            child: AppButtonWidget(
                                width: double.maxFinite,
                                borderColor: AppColors.white.withOpacity(0.5),
                                borderRadius: 10.r,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10.h, vertical: 10.h),
                                onPressed: () {
                                  Get.back();
                                },
                                btnName: "Cancel")),
                      ],
                    ),
                  ));
                },
                onTap: () {
                  Get.find<ArtistsController>()
                      .albumsAndTracks(
                          albumId: Get.find<ExplorController>()
                                  .viewAllDataModel
                                  ?.data?[index]
                                  .albumsId ??
                              0)
                      .then((_) {
                    Get.toNamed(RoutesName.albumTrackScreen);
                  });
                  // PlayerService.instance.createPlaylist(Get.find<ExplorController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsName,
                image: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsImage,
                subtitle: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .albumsArtist,
              );
            });

      case TrendingSCategoryFor.mixes:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                isTrending: true,
                onTap: () {
                  Get.find<MixesController>()
                      .mixesSubCategoryAndTracksApi(
                          mixesId: Get.find<ExplorController>()
                              .viewAllDataModel
                              ?.data?[index]
                              .mixesId)
                      .then((_) {
                    Get.toNamed(RoutesName.mixesSongScreen, arguments: {
                      'title': Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .mixesName
                    });
                  });
                  // PlayerService.instance.createPlaylist(Get.find<ExplorController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .mixesName,
                image: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .mixesImage,
                subtitle: "",
              );
            });
      case TrendingSCategoryFor.playList:
        return GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 10.w),
            itemCount:
                Get.find<ExplorController>().viewAllDataModel?.data?.length,
            scrollDirection: Axis.vertical,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisExtent: 230.w,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
            itemBuilder: (context, index) {
              return MostPlayedSongsWidget(
                isTrending: true,
                onTap: () {
                  Get.find<MixesController>()
                      .plaListTrackSongApi(
                          flowActivoPlaylistId: Get.find<ExplorController>()
                              .viewAllDataModel
                              ?.data?[index]
                              .flowactivoplaylistId)
                      .then((_) {
                    Get.toNamed(RoutesName.mixesSongScreen, arguments: {
                      'title': Get.find<ExplorController>()
                          .viewAllDataModel
                          ?.data?[index]
                          .flowactivoplaylistName
                    });
                  });
                  // PlayerService.instance.createPlaylist(Get.find<ExplorController>().viewAllDataModel?.data, index,);
                },
                title: Get.find<ExplorController>()
                    .viewAllDataModel
                    ?.data?[index]
                    .flowactivoplaylistName,
                image: Get.find<ExplorController>()
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
