import 'dart:io';

import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
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
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlbumTrackScreen extends GetView<ArtistsController> {
  const AlbumTrackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final albumId = Get.arguments;
    print("this is s ${albumId}");
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkgrey,
        bottomNavigationBar: const BottomBarWidget(
          mainScreen: false,
        ),
        extendBodyBehindAppBar: true,
        bottomSheet: const AudioPlayerController(),
        appBar: AppBar(
          backgroundColor: AppColors.transparent,
          centerTitle: true,
          title: AppTextWidget(
            txtTitle: controller.albumTrackSongData?.albumsName ?? '',
          ),
          leadingWidth: 120.w,
          leading: Row(
            children: [
              InkWell(
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
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: InkWell(
                onTap: () {
                  Get.toNamed(RoutesName.advanceSearchScreen);
                },
                child: Icon(
                  Icons.search,
                  size: 30.r,
                  color: AppColors.primary,
                ),
              ),
            )
          ],
        ),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 35.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: SingleChildScrollView(
            controller:
                Get.find<ArtistsController>().scrollControllerForAlbumSong,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 225.h,
                  width: 225.h,
                  margin: EdgeInsets.symmetric(vertical: 10.h),
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: CachedNetworkImageWidget(
                    height: double.maxFinite,
                    image: controller.albumTrackSongData?.albumImage ?? '',
                    fit: BoxFit.cover,
                  ),
                ),
                20.verticalSpace,
                Container(
                  color: AppColors.black,
                  padding: EdgeInsets.only(
                      right: 15.w, top: 10.h, bottom: 10.h, left: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                        onTap: () {
                          DownloadService.instance.downloadAllSongs(
                              tracksDataMode: controller.albumTrackSongData);
                        },
                        child: Column(
                          children: [
                            Obx(
                              () => Icon(
                                controller.albumTrackSongData?.data?.length ==
                                            Get.find<BaseController>()
                                                .songData1
                                                .length &&
                                        Get.find<BaseController>()
                                            .databaseDownloadedSongList
                                            .every((test) =>
                                                test['isDownloaded'] == 1)
                                    ? Icons.check
                                    : Icons.download,
                                color: AppColors.white,
                              ),
                            ),
                            Obx(() => AppTextWidget(
                                  txtTitle: controller.albumTrackSongData?.data
                                                  ?.length ==
                                              Get.find<BaseController>()
                                                  .songData1
                                                  .length &&
                                          Get.find<BaseController>()
                                              .databaseDownloadedSongList
                                              .every((test) =>
                                                  test['isDownloaded'] == 1)
                                      ? 'Album Downloaded'
                                      : "Download Album",
                                  fontSize: 14,
                                )),
                          ],
                        ),
                      ),
                      20.horizontalSpace,
                      InkWell(
                        onTap: () {
                          Get.dialog(YesNoDialog(
                              onYesCalled: () {
                                Get.dialog(
                                    AddPlaylistDialog(onCreateNewPlayList: () {
                                  CreatePlayListDialog(
                                    onCreateTap: () {},
                                  );
                                }, onAddToExisting: () {
                                  print("this is albumId ${albumId}");
                                  Get.dialog(
                                      ExistingPlaylistDialog(albumId: albumId));
                                }));
                              },
                              message:
                                  'Are you sure you want to add this item to Playlist?'));
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.album,
                              color: AppColors.white,
                            ),
                            AppTextWidget(
                              txtTitle: "Add Album to Playlist",
                              fontSize: 14,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(
                  height: 1,
                ),
                Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: controller.albumTrackSongData?.data?.length,
                        itemBuilder: (context, index) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                minTileHeight: 55,
                                contentPadding: EdgeInsets.only(
                                    top: 5.h, bottom: 5.h, right: 5.h),
                                minLeadingWidth: 90.w,
                                leading: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width: 40.w,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: AppColors.black,
                                          borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10.r),
                                              bottomRight: Radius.circular(10.r))),
                                      child:
                                          AppTextWidget(txtTitle: "${index + 1}"),
                                    ),
                                    10.horizontalSpace,
                                    Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: AppColors.white,
                                          shape: Platform.isAndroid
                                              ? BoxShape.rectangle
                                              : BoxShape.circle),
                                      child: CachedNetworkImageWidget(
                                        image: controller.albumTrackSongData
                                                ?.data?[index].originalImage ??
                                            '',
                                        width: 50.h,
                                        height: 50.h,
                                        fit: Platform.isAndroid
                                            ? BoxFit.cover
                                            : BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                                title: AppTextWidget(
                                  txtTitle: controller.albumTrackSongData
                                          ?.data?[index].songName ??
                                      '',
                                  fontSize: 11,
                                  txtColor: AppColors.white,
                                ),
                                subtitle: AppTextWidget(
                                  txtTitle: controller.albumTrackSongData
                                          ?.data?[index].songArtist ??
                                      '',
                                  fontSize: 11,
                                  txtColor: AppColors.primary,
                                ),
                                trailing: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    GetBuilder<BaseController>(
                                        init: Get.find<BaseController>(),
                                        builder: (bcontroller) {
                                          return Visibility(
                                              visible: Get.find<BaseController>()
                                                  .progress
                                                  .any((v) =>
                                                      v['song_Id'] ==
                                                      controller.albumTrackSongData
                                                          ?.data?[index].songId),
                                              replacement: !Get.find<BaseController>()
                                                      .isDownload(
                                                          songId: controller
                                                              .albumTrackSongData
                                                              ?.data?[index]
                                                              .songId)
                                                  ? InkWell(
                                                      onTap: () async {
                                                        // print(tracksDataModel
                                                        //     .data?[index].song);
                                                        // print(index);
                                                        // Get.find<BaseController>().checkIfFileExists(index,tracksDataModel);
                                                        DownloadService.instance
                                                            .downloadSong(
                                                          downloadSongUrl: controller
                                                                  .albumTrackSongData
                                                                  ?.data?[index]
                                                                  .song ??
                                                              "",
                                                          SongData: controller
                                                              .albumTrackSongData
                                                              ?.data?[index],
                                                        );
                                                        Get.find<BaseController>()
                                                                .listOfDownload[
                                                            index] = true;

                                                        print(controller
                                                            .albumTrackSongData
                                                            ?.data?[index]
                                                            .song);
                                                      },
                                                      child: Icon(
                                                        Icons
                                                            .download, // Minus symbol
                                                        color: Colors
                                                            .white, // Black minus sign
                                                        size: 25.r,
                                                        weight:
                                                            15, // Adjust size as needed
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                              child: Obx(() => Text(
                                                  style: TextStyle(
                                                      color: AppColors.white),
                                                  Get.find<BaseController>().progress.any((v) => v['song_Id'] == controller.albumTrackSongData?.data?[index].songId)
                                                      ? Get.find<BaseController>()
                                                              .progress
                                                              .firstWhere(
                                                                  (v) => v['song_Id'] == controller.albumTrackSongData?.data?[index].songId)['progress']
                                                              .toString() +
                                                          "%"
                                                      : '')));
                                        }),
                                    10.horizontalSpace,
                                    InkWell(
                                      onTap: () {
                                        Get.dialog(OptionDialog(
                                          listOfTrackData:
                                              controller.albumTrackSongData?.data ??
                                                  [],
                                          track: controller
                                              .albumTrackSongData?.data?[index],
                                          index: index,
                                        ));
                                      },
                                      child: Icon(
                                        weight: 15,
                                        Icons.more_vert,
                                        color: AppColors.white,
                                        size: 25.r,
                                      ),
                                    ),
                                    10.horizontalSpace,
                                  ],
                                ),
                                onTap: () {
                                  PlayerService.instance.createPlaylist(
                                      controller.albumTrackSongData?.data, index: index,id:controller
                                      .albumTrackSongData?.data?[index].songId );
                                },
                              ),
                              const Divider(
                                height: 1,
                              ),
                            ],
                          );
                        }),
                    20.verticalSpace,
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
