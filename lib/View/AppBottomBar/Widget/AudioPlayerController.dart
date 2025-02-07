import 'dart:io';
import 'dart:ui';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/AddPlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/CreatePlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/ExistingPlaylistDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/OptionInAudioPlayer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class AudioPlayerController extends StatefulWidget {
  const AudioPlayerController({super.key});

  @override
  State<AudioPlayerController> createState() => _AudioPlayerControllerState();
}

class _AudioPlayerControllerState extends State<AudioPlayerController> {
  bool apiHit = false;
  final CarouselSliderController _controller = CarouselSliderController();

  final PageController _pageController = PageController();
  int _currentPage = 0;
  int? lastSongId;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    PlayerService.instance.audioPlayer.sequenceStateStream
        .listen((sequenceState) {
      final currentSongId =
          int.tryParse(sequenceState?.currentSource?.tag.id ?? '');

      if (currentSongId != null && currentSongId != lastSongId) {
        lastSongId = currentSongId; // ✅ Update last song ID
        // ✅ Allow API hit only once per song
        Get.find<BaseController>().update();
        Get.find<HomeController>().update();
        print("this is song $lastSongId");
        // PlayerService.instance.songDetail(); // ✅ Call API when new song starts
      }
    });
    // PlayerService.instance.audioPlayer.sequenceStateStream.listen((sequenceState) {
    //   if (sequenceState?.currentSource != null) {
    //     String newTrackId = sequenceState!.currentSource!.tag.id ?? '';
    //
    //     if (newTrackId.isNotEmpty) {
    //       Get.find<BaseController>().updateCurrentTrack(newTrackId);
    //     }
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Obx(() => Visibility(
              visible: Get.find<BaseController>().showMusicMenu.value,
              child: GestureDetector(
                onTap: () async {
                  if (Get.find<BaseController>().containerHeight! < 1) {
                    setState(() {
                      Get.find<BaseController>().containerHeight?.value =
                          MediaQuery.sizeOf(context).height.spMax;
                      Get.find<BaseController>().update();
                    });
                  } else {}
                },
                child: GetBuilder<HomeController>(
                    id: 'SongScreen',
                    init: Get.find<HomeController>(),
                    builder: (controller) {
                      return AnimatedContainer(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        duration: const Duration(milliseconds: 500),
                        width: double.maxFinite,
                        height:
                            (Get.find<BaseController>().containerHeight?.value ??
                                        0.0) ==
                                    0
                                ? 70.h
                                : Get.find<BaseController>().containerHeight?.value,
                        decoration: BoxDecoration(
                          image: Get.find<BaseController>().containerHeight! > 1
                              ? DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(PlayerService
                                          .instance
                                          .audioPlayer
                                          .sequenceState
                                          ?.currentSource
                                          ?.tag
                                          .artUri
                                          .toString() ??
                                      ''))
                              : null,
                          color: Get.find<BaseController>().containerHeight! > 1
                              ? AppColors.black
                              : Color(0xff0f0b0b),
                          border: Get.find<BaseController>().containerHeight! > 1
                              ? null
                              : Border(
                                  top: BorderSide(
                                      color: AppColors.primary, width: 3)),
                          borderRadius: BorderRadiusDirectional.only(
                              topStart: Radius.circular(10.r),
                              topEnd: Radius.circular(10.r)),
                        ),
                        child: Get.find<BaseController>().containerHeight! > 1
                            ? BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 40.0, sigmaY: 40.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Padding(
                                      padding:
                                          EdgeInsets.only(left: 8.0.w, top: 17.h),
                                      child: Row(
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                Get.find<BaseController>()
                                                    .containerHeight
                                                    ?.value = 0;
                                              });
                                            },
                                            child: Transform.rotate(
                                              angle: 55,
                                              child: Image.asset(
                                                height: 30.h,
                                                width: 30.h,
                                                AppAssets.backIcon,
                                                // size: 30.r,
                                                // color: AppColors.white,
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          Align(
                                            alignment: Alignment.center,
                                            child: AppTextWidget(
                                              txtTitle: PlayerService
                                                      .instance
                                                      .audioPlayer
                                                      .sequenceState
                                                      ?.currentSource
                                                      ?.tag
                                                      .title ??
                                                  '',
                                              fontSize: 20,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                          const Spacer(),
                                          InkWell(
                                            onTap: () {
                                              Get.toNamed(RoutesName.cueScreen);
                                            },
                                            child: Icon(
                                              Icons.queue_music,
                                              size: 35.r,
                                              color: AppColors.white,
                                            ),
                                          ),
                                          10.horizontalSpace
                                        ],
                                      ),
                                    ),
                                    10.verticalSpace,
                                    AppTextWidget(
                                      txtTitle: Get.find<BaseController>()
                                                  .connectivityResult[0] ==
                                              ConnectivityResult.none
                                          ? ''
                                          : PlayerService.instance.audioPlayer.sequenceState?.currentSource?.tag.title !='Radio'? "${Get.find<HomeController>().songDetailDataModel?.data?[0].totalPlayed} Plays":'',
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    50.verticalSpace,
                                    CachedNetworkImageWidget(
                                      image: PlayerService
                                              .instance
                                              .audioPlayer
                                              .sequenceState
                                              ?.currentSource
                                              ?.tag
                                              .artUri
                                              .toString() ??
                                          '',
                                      height: 300.h,
                                      width: 300.h,
                                    ),
                                    30.verticalSpace,
                                    Get.find<HomeController>()
                                                    .songDetailDataModel
                                                    ?.data?[0]
                                                    .featureArtists
                                                    ?.length ==
                                                2 ||
                                            Get.find<HomeController>()
                                                    .songDetailDataModel
                                                    ?.data?[0]
                                                    .featureArtists
                                                    ?.length ==
                                                1 ||
                                            Get.find<HomeController>()
                                                    .songDetailDataModel
                                                    ?.data?[0]
                                                    .featureArtists
                                                    ?.length ==
                                                3
                                        ? Padding(
                                            padding: EdgeInsets.only(top: 10.0),
                                            child: Container(
                                              height: 150.h,
                                              child: GridView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                gridDelegate:
                                                    SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: Get.find<
                                                                  HomeController>()
                                                              .songDetailDataModel
                                                              ?.data?[0]
                                                              .featureArtists
                                                              ?.length ==
                                                          2
                                                      ? 2
                                                      : Get.find<HomeController>()
                                                                  .songDetailDataModel
                                                                  ?.data?[0]
                                                                  .featureArtists
                                                                  ?.length ==
                                                              1
                                                          ? 1
                                                          : 3, // Adjust based on your requirement
                                                ),
                                                itemCount:
                                                    Get.find<HomeController>()
                                                            .songDetailDataModel
                                                            ?.data?[0]
                                                            .featureArtists
                                                            ?.length ??
                                                        0,
                                                itemBuilder: (context, index) {
                                                  final artist =
                                                      Get.find<HomeController>()
                                                          .songDetailDataModel
                                                          ?.data?[0]
                                                          .featureArtists?[index];
                                                  return InkWell(
                                                    onTap: () async {

                                                      await Get.find<
                                                              ArtistsController>()
                                                          .trackSongApi(
                                                              artist?.artistsId ??
                                                                  0)
                                                          .then((_) async {
                                                        await Get.find<
                                                                ArtistsController>()
                                                            .albumSongApi(
                                                                artist?.artistsId ??
                                                                    0)
                                                            .then((_) {
                                                          Get.find<BaseController>()
                                                              .initialListOfBool(Get
                                                                          .find<
                                                                              ArtistsController>()
                                                                      .tracksDataModel
                                                                      ?.data
                                                                      ?.length ??
                                                                  0);
                                                          Get.toNamed(
                                                              RoutesName
                                                                  .songsAlbumsScreen,
                                                              arguments: {
                                                                'isGenre': false,
                                                                'homeScreen':false
                                                              });
                                                        });
                                                      });
                                                      setState(() {
                                                        Get.find<BaseController>()
                                                            .containerHeight
                                                            ?.value = 0;
                                                      });

                                                    },
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Container(
                                                          width: 95.h,
                                                          height: 95.h,
                                                          clipBehavior:
                                                              Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            shape: BoxShape.circle,
                                                          ),
                                                          child:
                                                              CachedNetworkImageWidget(
                                                            image: artist
                                                                    ?.originalImage ??
                                                                '',
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        5.verticalSpace,
                                                        Flexible(
                                                          child: AppTextWidget(
                                                            fontSize: 12,
                                                            textAlign:
                                                                TextAlign.center,
                                                            maxLine: 1,
                                                            txtTitle: artist
                                                                    ?.artistsName ??
                                                                '',
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              // Carousel Slider
                                              Align(
                                                alignment: Alignment
                                                    .centerLeft, // Align the carousel to the left
                                                child: CarouselSlider.builder(
                                                  itemCount:
                                                      Get.find<HomeController>()
                                                              .songDetailDataModel
                                                              ?.data?[0]
                                                              .featureArtists
                                                              ?.length ??
                                                          0,
                                                  options: CarouselOptions(
                                                    height: 150.h,
                                                    initialPage: 0,
                                                    enableInfiniteScroll: false,
                                                    viewportFraction:
                                                        0.35, // Adjust size of visible items (smaller fraction keeps items closer to the left)
                                                    enlargeCenterPage:
                                                        false, // Disable centering for active item
                                                    padEnds:
                                                        false, // Prevent extra padding at the edges
                                                    onPageChanged: (index, reason) {
                                                      setState(() {
                                                        _currentPage = index;
                                                      });
                                                    },
                                                  ),
                                                  itemBuilder:
                                                      (context, index, realIndex) {
                                                        Get.back();
                                                    final artist =
                                                        Get.find<HomeController>()
                                                            .songDetailDataModel
                                                            ?.data?[0]
                                                            .featureArtists?[index];
                                                    return InkWell(
                                                      onTap: () async {
                                                        await Get.find<
                                                                ArtistsController>()
                                                            .trackSongApi(
                                                                artist?.artistsId ??
                                                                    0)
                                                            .then((_) async {
                                                          await Get.find<
                                                                  ArtistsController>()
                                                              .albumSongApi(artist
                                                                      ?.artistsId ??
                                                                  0)
                                                              .then((_) {
                                                            Get.find<
                                                                    BaseController>()
                                                                .initialListOfBool(Get
                                                                            .find<
                                                                                ArtistsController>()
                                                                        .tracksDataModel
                                                                        ?.data
                                                                        ?.length ??
                                                                    0);
                                                            Get.toNamed(
                                                                RoutesName
                                                                    .songsAlbumsScreen,
                                                                arguments: {
                                                                  'isGenre': false,
                                                                  'homeScreen':false
                                                                });
                                                          });
                                                        });
                                                      },
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Container(
                                                            width: 80.h,
                                                            height: 80.h,
                                                            clipBehavior:
                                                                Clip.antiAlias,
                                                            decoration:
                                                                const BoxDecoration(
                                                              color:
                                                                  AppColors.white,
                                                              shape:
                                                                  BoxShape.circle,
                                                            ),
                                                            child:
                                                                CachedNetworkImageWidget(
                                                              image: artist
                                                                      ?.originalImage ??
                                                                  '',
                                                              width: 50.h,
                                                              height: 50.h,
                                                              fit: Platform
                                                                      .isAndroid
                                                                  ? BoxFit.cover
                                                                  : BoxFit.contain,
                                                            ),
                                                          ),
                                                          25.verticalSpace,
                                                          Flexible(
                                                            child: AppTextWidget(
                                                              fontSize: 12,
                                                              textAlign:
                                                                  TextAlign.center,
                                                              maxLine: 1,
                                                              txtTitle: artist
                                                                      ?.artistsName ??
                                                                  '',
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              10.verticalSpace,
                                              // Dots Indicator
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: List.generate(
                                                  Get.find<HomeController>()
                                                          .songDetailDataModel
                                                          ?.data?[0]
                                                          .featureArtists
                                                          ?.length ??
                                                      0,
                                                  (index) => Container(
                                                    width: 8.0,
                                                    height: 8.0,
                                                    margin: EdgeInsets.symmetric(
                                                        horizontal: 4.0),
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: index == _currentPage
                                                          ? Colors
                                                              .black // Active dot color
                                                          : Colors.grey.withOpacity(
                                                              0.5), // Inactive dot color
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                    10.verticalSpace,
                                    Get.find<BaseController>()
                                                .connectivityResult[0] ==
                                            ConnectivityResult.none
                                        ? SizedBox.shrink()
                                        : PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .title !=
                                                'Radio'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.dialog(
                                                          YesNoDialog(
                                                            onYesCalled: () async {
                                                              if (Get.find<
                                                                          HomeController>()
                                                                      .songDetailDataModel
                                                                      ?.data
                                                                      ?.first
                                                                      .favouritesStatus ??
                                                                  false) {
                                                                Get.find<
                                                                        HomeController>()
                                                                    .songDetailDataModel
                                                                    ?.data
                                                                    ?.first
                                                                    .favouritesStatus = await Get
                                                                        .find<
                                                                            MyLibraryController>()
                                                                    .favouriteSongRemoveApi(
                                                                        songId: Get.find<HomeController>()
                                                                                .songDetailDataModel
                                                                                ?.data?[0]
                                                                                .songId ??
                                                                            0);
                                                              } else {
                                                                Get.find<
                                                                        HomeController>()
                                                                    .songDetailDataModel
                                                                    ?.data
                                                                    ?.first
                                                                    .favouritesStatus = await Get
                                                                        .find<
                                                                            MyLibraryController>()
                                                                    .favouriteSongAddApi(
                                                                        songId: Get.find<HomeController>()
                                                                                .songDetailDataModel
                                                                                ?.data?[0]
                                                                                .songId ??
                                                                            0);
                                                              }
                                                              Get.back();
                                                              await Get.find<
                                                                      HomeController>()
                                                                  .songDetailsDataApi(
                                                                      songId: int.tryParse(PlayerService
                                                                              .instance
                                                                              .audioPlayer
                                                                              .sequenceState
                                                                              ?.currentSource
                                                                              ?.tag
                                                                              .id) ??
                                                                          0);
                                                            },
                                                            message: Get.find<
                                                                            HomeController>()
                                                                        .songDetailDataModel
                                                                        ?.data?[0]
                                                                        .favouritesStatus ??
                                                                    false
                                                                ? "Are you sure you want to remove this item from Favorites?"
                                                                : "Are you sure you want to add this item to Favorites?",
                                                          ),
                                                          barrierDismissible:
                                                              false);
                                                    },
                                                    child: OptionInAudioPlayer(
                                                      title: "Favourite",
                                                      icons: Get.find<HomeController>()
                                                                  .songDetailDataModel
                                                                  ?.data?[0]
                                                                  .favouritesStatus ??
                                                              false
                                                          ? Icons.favorite
                                                          : Icons
                                                              .favorite_border_outlined,
                                                      color: Get.find<HomeController>()
                                                                  .songDetailDataModel
                                                                  ?.data?[0]
                                                                  .favouritesStatus ??
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.white,
                                                      count:
                                                          Get.find<HomeController>()
                                                              .songDetailDataModel
                                                              ?.data?[0]
                                                              .favouritesCount,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: Get.find<
                                                                BaseController>()
                                                            .isDownload(
                                                                songId: int.tryParse(
                                                                    PlayerService
                                                                        .instance
                                                                        .audioPlayer
                                                                        .sequenceState
                                                                        ?.currentSource
                                                                        ?.tag
                                                                        .id))
                                                        ? () {}
                                                        : () async {
                                                            await DownloadService.instance
                                                                .downloadSong(
                                                                    downloadSongUrl: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[
                                                                                0]
                                                                            .song ??
                                                                        "",
                                                                    SongData: MixesTracksData(
                                                                        song: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[
                                                                                0]
                                                                            .song,
                                                                        songId: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[
                                                                                0]
                                                                            .songId,
                                                                        songImage: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[
                                                                                0]
                                                                            .songImage,
                                                                        songName: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[
                                                                                0]
                                                                            .songName,
                                                                        songArtist: Get.find<HomeController>()
                                                                            .songDetailDataModel
                                                                            ?.data?[0]
                                                                            .songArtist))
                                                                .then((_) {
                                                              Get.find<
                                                                      HomeController>()
                                                                  .downloadAPi(
                                                                      homeChopperService:
                                                                          AppChopperClient()
                                                                              .getChopperService<
                                                                                  HomeChopperService>(),
                                                                      songId: int.tryParse(PlayerService
                                                                          .instance
                                                                          .audioPlayer
                                                                          .sequenceState
                                                                          ?.currentSource
                                                                          ?.tag
                                                                          .id))
                                                                  .then((_) {});
                                                            });

                                                            Get.back();
                                                            await Get.find<
                                                                    HomeController>()
                                                                .songDetailsDataApi(
                                                                    songId: int.tryParse(PlayerService
                                                                            .instance
                                                                            .audioPlayer
                                                                            .sequenceState
                                                                            ?.currentSource
                                                                            ?.tag
                                                                            .id) ??
                                                                        0);
                                                          },
                                                    child: StreamBuilder(
                                                      stream: PlayerService
                                                          .instance
                                                          .audioPlayer.positionStream,
                                                      builder: (context,sap) {
                                                        return OptionInAudioPlayer(
                                                          title: Get.find<
                                                                      BaseController>()
                                                                  .isDownload(
                                                                      songId: int.tryParse(
                                                                          PlayerService
                                                                              .instance
                                                                              .audioPlayer
                                                                              .sequenceState
                                                                              ?.currentSource
                                                                              ?.tag
                                                                              .id))
                                                              ? "Downloaded"
                                                              : "Download",
                                                          color: Get.find<
                                                                      BaseController>()
                                                                  .isDownload(
                                                                      songId: int.tryParse(
                                                                          PlayerService
                                                                              .instance
                                                                              .audioPlayer
                                                                              .sequenceState
                                                                              ?.currentSource
                                                                              ?.tag
                                                                              .id))
                                                              ? AppColors.primary
                                                              : AppColors.white,
                                                          icons: Get.find<
                                                                      BaseController>()
                                                                  .isDownload(
                                                                      songId: int.tryParse(
                                                                          PlayerService
                                                                              .instance
                                                                              .audioPlayer
                                                                              .sequenceState
                                                                              ?.currentSource
                                                                              ?.tag
                                                                              .id))
                                                              ? Icons.cloud
                                                              : Icons.cloud_outlined,
                                                          count:
                                                              Get.find<HomeController>()
                                                                  .songDetailDataModel
                                                                  ?.data?[0]
                                                                  .totalDownloads,
                                                        );
                                                      }
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () async {
                                                      print("object");
                                                      Get.dialog(YesNoDialog(
                                                          onYesCalled: () async {
                                                            Get.dialog(
                                                                AddPlaylistDialog(
                                                              onCreateNewPlayList:
                                                                  () {
                                                                Get.dialog(
                                                                    CreatePlayListDialog(
                                                                  onCreateTap:
                                                                      () async {
                                                                    await Get.dialog(
                                                                        ExistingPlaylistDialog(
                                                                      songId: Get.find<
                                                                              HomeController>()
                                                                          .songDetailDataModel
                                                                          ?.data?[0]
                                                                          .songId,
                                                                    ));
                                                                  },
                                                                ));
                                                              },
                                                              onAddToExisting:
                                                                  () async {
                                                                await Get.dialog(
                                                                    ExistingPlaylistDialog(
                                                                  songId: Get.find<
                                                                          HomeController>()
                                                                      .songDetailDataModel
                                                                      ?.data?[0]
                                                                      .songId,
                                                                )).then((_) async {
                                                                  await Get.find<
                                                                          HomeController>()
                                                                      .songDetailsDataApi(
                                                                          songId: int.tryParse(PlayerService
                                                                                  .instance
                                                                                  .audioPlayer
                                                                                  .sequenceState
                                                                                  ?.currentSource
                                                                                  ?.tag
                                                                                  .id) ??
                                                                              0)
                                                                      .then((_) {
                                                                    setState(() {});
                                                                  });
                                                                });
                                                              },
                                                            ));
                                                          },
                                                          message:
                                                              "Are you sure you want to add this song to PlayList?"));
                                                      await Get.find<
                                                              HomeController>()
                                                          .songDetailsDataApi(
                                                              songId: int.tryParse(
                                                                      PlayerService
                                                                          .instance
                                                                          .audioPlayer
                                                                          .sequenceState
                                                                          ?.currentSource
                                                                          ?.tag
                                                                          .id) ??
                                                                  0)
                                                          .then((_) {
                                                        setState(() {});
                                                      });
                                                    },
                                                    child: OptionInAudioPlayer(
                                                      title: "Add Playlist",
                                                      color: Get.find<HomeController>()
                                                                  .songDetailDataModel
                                                                  ?.data?[0]
                                                                  .playlistStatus ??
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.white,
                                                      icons:
                                                          Icons.add_circle_outline,
                                                      count:
                                                          Get.find<HomeController>()
                                                              .songDetailDataModel
                                                              ?.data?[0]
                                                              .playlistCount,
                                                    ),
                                                  ),
                                                ],
                                              )
                                            : SizedBox.shrink(),
                                    10.verticalSpace,
                                    PlayerService.instance.audioPlayer.sequenceState
                                                ?.currentSource?.tag.title !=
                                            'Radio'
                                        ? StreamBuilder(
                                            stream: PlayerService.instance
                                                .audioPlayer.positionStream,
                                            builder: (context, snap2) {
                                              if (!snap2.hasData ||
                                                  PlayerService.instance.audioPlayer
                                                          .duration ==
                                                      null) {
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 20.w),
                                                  child: ProgressBar(
                                                    barHeight: 2.0,
                                                    progressBarColor:
                                                        AppColors.primary,
                                                    thumbColor: AppColors.grey,
                                                    baseBarColor: Colors.white,
                                                    timeLabelTextStyle: const TextStyle(
                                                        // fontFamily: 'Century Gothic',
                                                        color: Colors.white),
                                                    progress: PlayerService.instance
                                                        .audioPlayer.position,
                                                    total: PlayerService.instance
                                                            .audioPlayer.duration ??
                                                        Duration.zero,
                                                    onSeek: (progress) {
                                                      setState(() {
                                                        PlayerService
                                                            .instance.audioPlayer
                                                            .seek(progress);
                                                      });
                                                    },
                                                  ),
                                                );
                                              }
                                              final currentPosition = snap2.data!;
                                              final totalDuration = PlayerService
                                                  .instance.audioPlayer.duration!;
                                              const tolerance =
                                                  Duration(milliseconds: 1000);

                                              if (currentPosition + tolerance >=
                                                  totalDuration) {
                                                if (!apiHit) {
                                                  apiHit = true;
                                                  if (PlayerService.instance
                                                          .audioPlayer.loopMode ==
                                                      LoopMode.one) {
                                                    PlayerService.instance
                                                        .currentSongIndex++;
                                                    PlayerService.instance
                                                        .autoSongPlay();
                                                  }
                                                }
                                              } else {
                                                apiHit = false;
                                              }
                                              return Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20.0.w),
                                                child: ProgressBar(
                                                  barHeight: 2.0,
                                                  progressBarColor:
                                                      AppColors.primary,
                                                  thumbColor: AppColors.grey,
                                                  baseBarColor: Colors.white,
                                                  timeLabelTextStyle:
                                                      const TextStyle(
                                                          fontFamily:
                                                              'Century Gothic',
                                                          color: Colors.white),
                                                  progress: PlayerService.instance
                                                      .audioPlayer.position,
                                                  total: PlayerService.instance
                                                          .audioPlayer.duration ??
                                                      Duration.zero,
                                                  onSeek: (progress) {
                                                    setState(() {
                                                      PlayerService
                                                          .instance.audioPlayer
                                                          .seek(progress);
                                                    });
                                                  },
                                                ),
                                              );
                                            })
                                        : SizedBox.shrink(),
                                    20.verticalSpace,
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .title !=
                                                'Radio'
                                            ? InkWell(
                                                onTap: () {
                                                  PlayerService.instance.audioPlayer
                                                      .setShuffleModeEnabled(
                                                          PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .shuffleModeEnabled
                                                              ? false
                                                              : true);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.shuffle,
                                                  size: 35.r,
                                                  color: PlayerService
                                                          .instance
                                                          .audioPlayer
                                                          .shuffleModeEnabled
                                                      ? AppColors.primary
                                                      : AppColors.white,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .title !=
                                                'Radio'
                                            ? InkWell(
                                                onTap: () {
                                                  PlayerService.instance
                                                      .previousSong();
                                                },
                                                child: Icon(
                                                  Icons.skip_previous,
                                                  size: 35.r,
                                                  color: AppColors.white,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        StreamBuilder(
                                          stream: PlayerService.instance.audioPlayer
                                              .sequenceStateStream,
                                          builder: (context, snapState) {
                                            final sequenceState = snapState.data;
                                            final currentSource =
                                                sequenceState?.currentSource;

                                            return StreamBuilder<Duration?>(
                                                stream: PlayerService.instance
                                                    .audioPlayer.durationStream,
                                                builder: (context, snapDuration) {
                                                  print(
                                                      "is it radio? ${PlayerService.instance.audioPlayer.sequenceState?.currentSource?.tag.title}");
                                                  if (PlayerService
                                                          .instance
                                                          .audioPlayer
                                                          .sequenceState
                                                          ?.currentSource
                                                          ?.tag
                                                          .title !=
                                                      "Radio") {
                                                    if (currentSource == null ||
                                                        snapDuration.data == null ||
                                                        PlayerService
                                                                .instance
                                                                .audioPlayer
                                                                .duration ==
                                                            null) {
                                                      return CircularProgressIndicator(
                                                        color: AppColors.primary,
                                                      );
                                                    }
                                                  }
                                                  // if (currentSource == null || PlayerService.instance.audioPlayer.duration == null) {
                                                  //   return CircularProgressIndicator(
                                                  //     color: AppColors.primary,
                                                  //   );
                                                  // }
                                                  // print("${currentSource == null}");
                                                  return GetBuilder<BaseController>(
                                                    // ✅ UI will update when track changes
                                                    builder: (controller) {
                                                      return StreamBuilder<bool>(
                                                        stream: PlayerService
                                                            .instance
                                                            .audioPlayer
                                                            .playingStream,
                                                        builder:
                                                            (context, snapPlaying) {
                                                          final isPlaying =
                                                              snapPlaying.data ??
                                                                  false;
                                                          return InkWell(
                                                            onTap: () {
                                                              isPlaying
                                                                  ? PlayerService
                                                                      .instance
                                                                      .audioPlayer
                                                                      .pause()
                                                                  : PlayerService
                                                                      .instance
                                                                      .audioPlayer
                                                                      .play();
                                                              controller
                                                                  .update(); // ✅ Force UI update
                                                            },
                                                            child: Icon(
                                                              isPlaying
                                                                  ? Icons.pause
                                                                  : Icons
                                                                      .play_arrow,
                                                              size: 50.r,
                                                              color:
                                                                  AppColors.white,
                                                            ),
                                                          );
                                                        },
                                                      );
                                                    },
                                                  );
                                                });
                                          },
                                        ),
                                        PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .title !=
                                                'Radio'
                                            ? InkWell(
                                                onTap: () {
                                                  PlayerService.instance.audioPlayer
                                                      .seekToNext();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.skip_next,
                                                  size: 35.r,
                                                  color: AppColors.white,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                        PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .title !=
                                                'Radio'
                                            ? InkWell(
                                                onTap: () {
                                                  PlayerService.instance.audioPlayer
                                                      .setLoopMode(PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .loopMode ==
                                                              LoopMode.all
                                                          ? LoopMode.one
                                                          : LoopMode.all);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.repeat,
                                                  size: 35.r,
                                                  color: PlayerService
                                                              .instance
                                                              .audioPlayer
                                                              .loopMode ==
                                                          LoopMode.all
                                                      ? AppColors.white
                                                      : AppColors.primary,
                                                ),
                                              )
                                            : SizedBox.shrink(),
                                      ],
                                    ),
                                    const Spacer(
                                      flex: 2,
                                    ),
                                  ],
                                ),
                              )
                            : StreamBuilder(
                                stream: PlayerService
                                    .instance.audioPlayer.positionStream,
                                builder: (context, snap) {
                                  if (!snap.hasData ||
                                      PlayerService.instance.audioPlayer.duration ==
                                          null) {
                                    return Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0.w),
                                      child: Row(
                                        children: [
                                          Container(
                                            color: AppColors.white,
                                            child: CachedNetworkImageWidget(
                                              image: PlayerService
                                                      .instance
                                                      .audioPlayer
                                                      .sequenceState
                                                      ?.currentSource
                                                      ?.tag
                                                      .artUri
                                                      .toString() ??
                                                  '',
                                              width: 50.h,
                                              height: 50.h,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          20.horizontalSpace,
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              AppTextWidget(
                                                txtTitle: PlayerService
                                                        .instance
                                                        .audioPlayer
                                                        .sequenceState
                                                        ?.currentSource
                                                        ?.tag
                                                        .title ??
                                                    '',
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                txtColor: AppColors.white,
                                              ),
                                              Visibility(
                                                visible: PlayerService
                                                        .instance
                                                        .audioPlayer
                                                        .sequenceState
                                                        ?.currentSource
                                                        ?.tag
                                                        .artist !=
                                                    '',
                                                child: AppTextWidget(
                                                  fontWeight: FontWeight.bold,
                                                  txtTitle: PlayerService
                                                          .instance
                                                          .audioPlayer
                                                          .sequenceState
                                                          ?.currentSource
                                                          ?.tag
                                                          .artist ??
                                                      '',
                                                  fontSize: 12,
                                                  txtColor: AppColors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                          const Spacer(),
                                          Container(
                                            child: Row(
                                              children: [
                                                InkWell(
                                                  onTap: () {
                                                    PlayerService
                                                        .instance.audioPlayer
                                                        .seekToPrevious();
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.skip_previous,
                                                    size: 45.r,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                                15.horizontalSpace,
                                                StreamBuilder(
                                                    stream: PlayerService.instance
                                                        .audioPlayer.playingStream,
                                                    builder:
                                                        (context, snapPlaying) {
                                                          if (PlayerService
                                                              .instance
                                                              .audioPlayer
                                                              .sequenceState
                                                              ?.currentSource
                                                              ?.tag
                                                              .title !=
                                                              'Radio'){ if (!snapPlaying.hasData ||
                                                          PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .duration ==
                                                              null) {
                                                        return CircularProgressIndicator(
                                                          color: AppColors.primary,
                                                        );
                                                      }}
                                                      return InkWell(
                                                        onTap: () {
                                                          snapPlaying.data ?? false
                                                              ? PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .pause()
                                                              : PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .play();
                                                        },
                                                        child:  Container(
                                                          height: 50.h,
                                                          width: 50.h,
                                                          decoration:
                                                          const BoxDecoration(
                                                              color: AppColors
                                                                  .darkgrey,
                                                              shape: BoxShape
                                                                  .circle),
                                                          child: Center(
                                                            child: Icon(
                                                              PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .playing
                                                                  ? Icons.pause
                                                                  : Icons.play_arrow,
                                                              size: 40.r,
                                                              color:
                                                              AppColors.primary,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                                15.horizontalSpace,
                                                InkWell(
                                                  onTap: () {
                                                    PlayerService
                                                        .instance.audioPlayer
                                                        .seekToNext();
                                                    setState(() {});
                                                  },
                                                  child: Icon(
                                                    Icons.skip_next,
                                                    size: 45.r,
                                                    color: AppColors.white,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  }
                                  final currentPosition = snap.data!;
                                  final totalDuration =
                                      PlayerService.instance.audioPlayer.duration!;
                                  const tolerance = Duration(milliseconds: 500);
                                  if (currentPosition + tolerance >=
                                      totalDuration) {
                                    if (!apiHit) {
                                      apiHit = true;
                                      if (PlayerService
                                              .instance.audioPlayer.loopMode ==
                                          LoopMode.one) {
                                        PlayerService.instance.currentSongIndex++;
                                        PlayerService.instance.autoSongPlay();
                                      }
                                      // Get.find<HomeController>().update;
                                    }
                                  } else {
                                    apiHit = false;
                                    Get.find<HomeController>().update;
                                  }
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0.w),
                                    child: Row(
                                      children: [
                                        Container(
                                          color: AppColors.white,
                                          child: CachedNetworkImageWidget(
                                            image: PlayerService
                                                    .instance
                                                    .audioPlayer
                                                    .sequenceState
                                                    ?.currentSource
                                                    ?.tag
                                                    .artUri
                                                    .toString() ??
                                                '',
                                            width: 50.h,
                                            height: 50.h,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        20.horizontalSpace,
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            AppTextWidget(
                                              txtTitle: PlayerService
                                                      .instance
                                                      .audioPlayer
                                                      .sequenceState
                                                      ?.currentSource
                                                      ?.tag
                                                      .title ??
                                                  '',
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              txtColor: AppColors.white,
                                            ),
                                            Visibility(
                                              visible: PlayerService
                                                      .instance
                                                      .audioPlayer
                                                      .sequenceState
                                                      ?.currentSource
                                                      ?.tag
                                                      .artist !=
                                                  '',
                                              child: AppTextWidget(
                                                fontWeight: FontWeight.w700,
                                                txtTitle: PlayerService
                                                        .instance
                                                        .audioPlayer
                                                        .sequenceState
                                                        ?.currentSource
                                                        ?.tag
                                                        .artist ??
                                                    '',
                                                fontSize: 12,
                                                txtColor: AppColors.white,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Spacer(),
                                        Container(
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  PlayerService.instance.audioPlayer
                                                      .seekToPrevious();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.skip_previous,
                                                  size: 45.r,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                              15.horizontalSpace,
                                              StreamBuilder(
                                                  stream: PlayerService.instance
                                                      .audioPlayer.playingStream,
                                                  builder: (context, snapPlaying) {
                                                    if (PlayerService
                                                            .instance
                                                            .audioPlayer
                                                            .sequenceState
                                                            ?.currentSource
                                                            ?.tag
                                                            .title !=
                                                        'Radio') {
                                                      if (!snapPlaying.hasData ||
                                                          PlayerService
                                                                  .instance
                                                                  .audioPlayer
                                                                  .duration ==
                                                              null) {
                                                        return CircularProgressIndicator(
                                                          color: AppColors.primary,
                                                        );
                                                      }
                                                    }
                                                    return InkWell(
                                                      onTap: () {
                                                        snapPlaying.data ?? false
                                                            ? PlayerService.instance
                                                                .audioPlayer
                                                                .pause()
                                                            : PlayerService.instance
                                                                .audioPlayer
                                                                .play();
                                                      },
                                                      child: Container(
                                                        height: 50.h,
                                                        width: 50.h,
                                                        decoration:
                                                            const BoxDecoration(
                                                                color: AppColors
                                                                    .darkgrey,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Center(
                                                          child: Icon(
                                                            PlayerService
                                                                    .instance
                                                                    .audioPlayer
                                                                    .playing
                                                                ? Icons.pause
                                                                : Icons.play_arrow,
                                                            size: 40.r,
                                                            color:
                                                                AppColors.primary,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }),
                                              15.horizontalSpace,
                                              InkWell(
                                                onTap: () {
                                                  PlayerService.instance.audioPlayer
                                                      .seekToNext();
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.skip_next,
                                                  size: 45.r,
                                                  color: AppColors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }),
                      );
                    }),
              ))),
        ),
      ],
    );
  }
}
