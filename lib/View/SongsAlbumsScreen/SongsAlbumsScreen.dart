import 'dart:io';
import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppIcons.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/AlbumsWidgets/AlbumWidget.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsWidget/SongsWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/Widget/MostPlayedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class SongsAlbumsScreen extends StatefulWidget {
  final int? id;
  final String? type;
  const SongsAlbumsScreen({
    super.key,  this.id,  this.type,
  });

  @override
  State<SongsAlbumsScreen> createState() => _SongsAlbumsScreenState();
}

class _SongsAlbumsScreenState extends State<SongsAlbumsScreen> {
  String view = 'Songs';
  bool isGenre = false;
  bool homeScreen = true;
  TracksDataModel? songsDataModel;
  TracksDataModel? albumDataModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      isGenre=!(widget.type?.toLowerCase()=='Artists'.toLowerCase());
      if(widget.type?.toLowerCase()=='Artists'.toLowerCase()){
      await  Get.find<ArtistsController>().trackSongApi(
            widget.id??0);
      await  Get.find<
            ArtistsController>()
            .albumSongApi(
            widget.id??0);
        setState(() {
          songsDataModel = Get.find<ArtistsController>().tracksDataModel;
          albumDataModel = Get.find<ArtistsController>().albumDataModel; });

      }else{
       await Get.find<HomeController>().selectedGenreAlbumApi(widget.id??0);
       await Get.find<HomeController>()
            .selectedGenreSongsApi(widget.id??0);
        setState(() {
          songsDataModel = Get.find<HomeController>().songsTracksDataModel;
          albumDataModel = Get.find<HomeController>().albumTracksDataModel;
        });
        print(" albumDataModel ${songsDataModel}");
        print("albumDataModel  albumDataModel ${albumDataModel}");
      }



      Get.find<BaseController>().containerHeight?.value = 0;
    });
    print("songsDataModel?.data?.first.id ${songsDataModel?.data?.first.id}");
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomSheet: AudioPlayerController(),
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.darkgrey,
        bottomNavigationBar: const BottomBarWidget(
          mainScreen: false,
        ),
        appBar: isGenre
            ? CommonAppBar(
                titleClr: AppColors.white,
                title: songsDataModel?.mixesName ?? 'null',
                searchBarShow: true,
              )
            : CommonAppBar(
                title: songsDataModel?.mixesName ?? 'null',
                image: songsDataModel?.mixesImage,
                showImage: true,
                titleClr: AppColors.white,
                searchBarShow: true,
              ),
        body: Stack(
          children: [
            Container(
              height: MediaQuery.sizeOf(context).height,
              padding:
                  EdgeInsets.only(top: AppBar().preferredSize.height.h + 50.h),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backGroundImage))),
              child: GetBuilder<ArtistsController>(

                  init: Get.find<ArtistsController>(),
                  builder: (controller) {
                    return SingleChildScrollView(
                      controller: Get.find<ArtistsController>()
                          .scrollControllerForArtistSong,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                            visible: (view == "Songs"
                                ? (songsDataModel?.mostPlayed?.isNotEmpty ??
                                false)
                                : (albumDataModel?.mostPlayed?.isNotEmpty ??
                                false)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.w,
                              ),
                              child: const AppTextWidget(
                                txtTitle: "Most Played",
                                txtColor: AppColors.white,
                              ),
                            ),
                          ),
                          20.verticalSpace,
                          Visibility(
                              visible: (view == "Songs"
                                  ? (songsDataModel?.mostPlayed?.isNotEmpty ??
                                  false)
                                  : (albumDataModel?.mostPlayed?.isNotEmpty ??
                                  false)),
                              child: view == "Songs"
                                  ? songsDataModel?.data?.isNotEmpty ?? false
                                  ? SizedBox(
                                height: 230.h,
                                child: GridView.builder(
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    padding:
                                    EdgeInsets.only(left: 10.w),
                                    itemCount: songsDataModel
                                        ?.mostPlayed?.length ??
                                        0,
                                    scrollDirection: Axis.horizontal,
                                    gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                        double.maxFinite,
                                        mainAxisExtent: 160.w,
                                        crossAxisSpacing: 10,
                                        mainAxisSpacing: 10),
                                    itemBuilder: (context, index) {
                                      return MostPlayedSongsWidget(
                                        onOptionTap: () {
                                          Get.dialog(OptionDialog(
                                            listOfTrackData:
                                            songsDataModel
                                                ?.mostPlayed
                                                ?.map((e) =>
                                                MixesTracksData(
                                                  song: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .song,
                                                  songId: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songId,
                                                  songImage: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songImage,
                                                  originalImage: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .originalImage,
                                                  songName: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songName,
                                                  favouritesStatus: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .favouritesStatus,
                                                  songArtist: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songArtist,
                                                ))
                                                .toList() ??
                                                [],
                                            index: index,
                                            track: MixesTracksData(
                                              song: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .song,
                                              songId: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .songId,
                                              songImage:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .songImage,
                                              originalImage:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .originalImage,
                                              songName: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .songName,
                                              favouritesStatus:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .favouritesStatus,
                                              songArtist:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .songArtist,
                                            ),
                                          ));
                                        },
                                        onTap: () {
                                          PlayerService.instance
                                              .createPlaylist(
                                              songsDataModel
                                                  ?.mostPlayed,
                                              index: index,
                                              id: songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .songId);
                                        },
                                        image: songsDataModel
                                            ?.mostPlayed?[index]
                                            .originalImage,
                                        title: songsDataModel
                                            ?.mostPlayed?[index]
                                            .songName ??
                                            '',
                                        subtitle: songsDataModel
                                            ?.mostPlayed?[index]
                                            .songArtist ??
                                            '',
                                      );
                                    }),
                              )
                                  : Center(
                                child: AppTextWidget(
                                  txtTitle: "No Data Found",
                                  txtColor: Colors.white,
                                ),
                              )
                                  : albumDataModel?.data?.isNotEmpty ?? false
                                  ? SizedBox(
                                height: 250.h,
                                child: GridView.builder(
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    padding:
                                    EdgeInsets.only(left: 10.w),
                                    itemCount: albumDataModel
                                        ?.mostPlayed?.length ??
                                        0,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent:
                                        double.maxFinite,
                                        mainAxisExtent: 200.w,
                                        crossAxisSpacing: 10.h,
                                        mainAxisSpacing: 10.h),
                                    itemBuilder: (context, index) {
                                      return MostPlayedWidget(
                                        onOptionTap: () {
                                          print("object");
                                          Get.dialog(OptionDialog(
                                            listOfTrackData:
                                            songsDataModel
                                                ?.mostPlayed
                                                ?.map((e) =>
                                                MixesTracksData(
                                                  song: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .song,
                                                  songId: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songId,
                                                  songImage: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songImage,
                                                  originalImage: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .originalImage,
                                                  songName: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songName,
                                                  favouritesStatus: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .favouritesStatus,
                                                  songArtist: songsDataModel
                                                      ?.mostPlayed?[index]
                                                      .songArtist,
                                                ))
                                                .toList() ??
                                                [],
                                            index: index,
                                            track: MixesTracksData(
                                              song: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .song,
                                              songId: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .songId,
                                              songImage:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .songImage,
                                              originalImage:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .originalImage,
                                              songName: songsDataModel
                                                  ?.mostPlayed?[index]
                                                  .songName,
                                              favouritesStatus:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .favouritesStatus,
                                              songArtist:
                                              songsDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .songArtist,
                                            ),
                                          ));
                                        },
                                        onTap: () async {
                                          print(Get.find<
                                              ArtistsController>()
                                              .albumDataModel
                                              ?.mostPlayed?[index]
                                              .mixesId);
                                          await Get.find<
                                              ArtistsController>()
                                              .albumTrackSongApi(
                                              artistsId: albumDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .mixesId ??
                                                  0,
                                              albumId: albumDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .albumsId ??
                                                  0,
                                              genresId:
                                              albumDataModel
                                                  ?.mostPlayed?[
                                              index]
                                                  .genresId)
                                              .then((_) {
                                            Get.toNamed(RoutesName
                                                .albumTrackScreen);
                                          });
                                        },
                                        image: albumDataModel
                                            ?.mostPlayed?[index]
                                            .albumImage ??
                                            '',
                                        title: albumDataModel
                                            ?.mostPlayed?[index]
                                            .albumsName ??
                                            '',
                                        subTitle: albumDataModel
                                            ?.mostPlayed?[index]
                                            .albumsArtist ??
                                            '',
                                      );
                                    }),
                              )
                                  : Center(
                                child: AppTextWidget(
                                  txtTitle: "No Data Found",
                                  txtColor: Colors.white,
                                ),
                              )),
                          20.verticalSpace,
                          CommonAdWidget(),
                          const Divider(
                            thickness: 2,
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: AppButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  margin: EdgeInsets.only(right: 25.w),
                                  btnColor: view == "Songs"
                                      ? AppColors.primary
                                      : AppColors.black,
                                  onPressed: () {
                                    setState(() {
                                      view = "Songs";
                                    });
                                  },
                                  btnName: "",
                                  customBorderRadius: BorderRadius.only(
                                      topRight: Radius.circular(10.r),
                                      bottomRight: Radius.circular(10.r)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        height: 25.h,
                                        width: 25.h,
                                        AppAssets.songsIcon,
                                        color: view == "Songs"
                                            ? AppColors.white
                                            : AppColors.white,
                                      ),
                                      5.horizontalSpace,
                                      AppTextWidget(
                                        fontSize: 14,
                                        txtTitle: "Songs",
                                        txtColor: view == "Songs"
                                            ? AppColors.white
                                            : AppColors.white,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: AppButtonWidget(
                                  padding: EdgeInsets.symmetric(vertical: 5.h),
                                  margin: EdgeInsets.only(left: 25.w),
                                  btnColor: view == "Albums"
                                      ? AppColors.primary
                                      : AppColors.black,
                                  onPressed: () {
                                    setState(() {
                                      view = "Albums";
                                    });
                                  },
                                  btnName: "",
                                  customBorderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.r),
                                      bottomLeft: Radius.circular(10.r)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      AppTextWidget(
                                        fontSize: 14,
                                        txtTitle: "Albums",
                                        txtColor: view == "Albums"
                                            ? AppColors.white
                                            : AppColors.white,
                                      ),
                                      5.horizontalSpace,
                                      Image.asset(
                                        height: 25.h,
                                        width: 25.h,
                                        AppAssets.albumIcon,
                                        color: view == "Albums"
                                            ? AppColors.white
                                            : AppColors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          20.verticalSpace,
                          Visibility(
                            visible: view == "Songs",
                            replacement: AlbumWidget(
                              tracksDataModel: albumDataModel,
                            ),
                            child: SongsWidget(
                              addDownload: true,
                              tracksDataModel: songsDataModel,
                            ),
                          ),
                          60.verticalSpace,
                        ],
                      ),
                    );
                  }),
            ),
            Obx(
              () => Visibility(
                  visible: Get.find<ArtistsController>().isLoading.value,
                  child: AppLoder()),
            ),
          ],
        ),
      ),
    );
  }
}
