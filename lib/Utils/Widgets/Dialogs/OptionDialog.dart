import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/AddPlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/CreatePlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/ExistingPlaylistDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';

class OptionDialog extends StatelessWidget {
  final MixesTracksData? track;
  final List<MixesTracksData> listOfTrackData;
  final int? index;
  bool? isAlbum;
  bool? isQueue;
  final String type;
   bool? isPlaylist;
  OptionDialog(
      {super.key,
      this.track,
        this.isPlaylist = true,
      required this.listOfTrackData,
      this.index,
      this.type = 'song',
      this.isAlbum = false,
      this.isQueue = false});

  @override
  Widget build(BuildContext context) {
    print("album name${track?.albumsName}");
    return AlertDialog(
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      content: Padding(
        padding: EdgeInsets.symmetric(horizontal: 50.0.w, vertical: 20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Album Image
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      image: NetworkImage(
                        '${track?.originalImage}', // Replace with your image URL
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                12.horizontalSpace,
                // Song and artist name
                isAlbum == false
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${track?.songName}',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${track?.songArtist}',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        '${track?.albumsName}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
            40.verticalSpace,
            Column(
              children: [
                isQueue == false? SizedBox.shrink(): isAlbum == false
                    ? Obx(
                        () => Visibility(
                          visible:
                              Get.find<BaseController>().showMusicMenu.value &&
                                  PlayerService
                                          .instance
                                          .audioPlayer
                                          .sequenceState
                                          ?.currentSource
                                          ?.tag
                                          .id ==
                                      track?.songId.toString(),
                          replacement: Center(
                              child: AppButtonWidget(
                                  width: double.maxFinite,
                                  borderColor: AppColors.white.withOpacity(0.5),
                                  borderRadius: 10.r,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  onPressed: () {
                                    PlayerService.instance.createPlaylist(
                                        listOfTrackData, index:index ?? 0,
                                        type: type);
                                    Get.back();
                                  },
                                  btnName: "",
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0.w),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: 35.h,
                                            width: 35.h,
                                            decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.r)),
                                            child: Center(
                                                child: Icon(
                                              Icons.play_arrow,
                                              color: AppColors.black,
                                              size: 20,
                                            ))),
                                        10.horizontalSpace,
                                        AppTextWidget(
                                          txtTitle: "Play Now",
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ))),
                          child: SizedBox.shrink(),
                        ),
                      )
                    : SizedBox.shrink(),
                20.verticalSpace,
                isAlbum == false
                    ? Obx(
                        () => Visibility(
                          replacement: Center(
                              child: AppButtonWidget(
                                  width: double.maxFinite,
                                  borderColor: AppColors.white.withOpacity(0.5),
                                  borderRadius: 10.r,
                                  padding: EdgeInsets.symmetric(vertical: 12.h),
                                  onPressed: () {
                                    print(PlayerService.instance.playlist.any(
                                        (v) =>
                                            (v as UriAudioSource)
                                                .uri
                                                .toString() ==
                                            track?.song.toString()));
                                    if (PlayerService.instance.playlist != [] &&
                                        !PlayerService.instance.playlist.any(
                                            (v) => ((v as UriAudioSource)
                                                    .uri
                                                    .toString() ==
                                                track?.song.toString()))) {
                                      PlayerService.instance.playlist.add(
                                          AudioSource.uri(
                                              Uri.parse(track?.song ?? ''),
                                              tag: MediaItem(
                                                id: track?.songId.toString() ??
                                                    "",
                                                title: track?.songName ?? "",
                                                artUri: Uri.tryParse(
                                                    track?.songImage ?? ""),
                                                artist: track?.songArtist,
                                              )));
                                      Get.back();
                                      Utility.showSnackBar(
                                        "This Song add to Queue",
                                      );
                                    } else {
                                      Get.back();
                                      Utility.showSnackBar(
                                          "This Song is already add to Queue",
                                          isError: true);
                                    }
                                  },
                                  btnName: "",
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 10.0.w),
                                    child: Row(
                                      children: [
                                        Container(
                                            height: 35.h,
                                            width: 35.h,
                                            decoration: BoxDecoration(
                                                color: AppColors.primary,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        30.r)),
                                            child: Center(
                                                child: Icon(
                                              Icons.queue,
                                              color: AppColors.black,
                                              size: 20,
                                            ))),
                                        10.horizontalSpace,
                                        AppTextWidget(
                                          txtTitle: PlayerService
                                                          .instance.playlist !=
                                                      [] &&
                                                  !PlayerService
                                                      .instance.playlist
                                                      .any((v) =>
                                                          ((v as UriAudioSource)
                                                                  .uri
                                                                  .toString() ==
                                                              track?.song
                                                                  .toString()))
                                              ? "Add To Queue"
                                              : 'Remove from Queue',
                                          fontSize: 12,
                                        ),
                                      ],
                                    ),
                                  ))),
                          visible:
                              Get.find<BaseController>().showMusicMenu.value &&
                                  PlayerService
                                          .instance
                                          .audioPlayer
                                          .sequenceState
                                          ?.currentSource
                                          ?.tag
                                          .id ==
                                      track?.songId.toString(),
                          child: SizedBox.shrink(),
                        ),
                      )
                    : SizedBox.shrink(),
                20.verticalSpace,
                isAlbum == false
                    ? Center(
                        child: AppButtonWidget(
                            width: double.maxFinite,
                            borderColor: AppColors.white.withOpacity(0.5),
                            borderRadius: 10.r,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            onPressed: () {
                              Get.back();
                              // log(track?.favouritesStatus.toString()??'');
                              Get.dialog(
                                  YesNoDialog(
                                    onYesCalled: () async {
                                      if (track?.favouritesStatus ?? false) {
                                        track?.favouritesStatus = Get.find<
                                                        BaseController>()
                                                    .connectivityResult[0] ==
                                                ConnectivityResult.none
                                            ? await SongDatabaseService()
                                                .updateSong(
                                                    track?.songId ?? 0, {
                                                "favourite": 0,
                                              }).then((_) {
                                                Get.back();
                                                Get.find<BaseController>()
                                                    .fetchDatabaseSong();
                                                return false;
                                              })
                                            : await Get.find<
                                                    MyLibraryController>()
                                                .favouriteSongRemoveApi(
                                                    songId: track?.songId ?? 0);
                                      } else {
                                        track?.favouritesStatus = Get.find<
                                                        BaseController>()
                                                    .connectivityResult[0] ==
                                                ConnectivityResult.none
                                            ? await SongDatabaseService()
                                                .updateSong(
                                                    track?.songId ?? 0, {
                                                "favourite": 1,
                                              }).then((_) {
                                                Get.back();
                                                Get.find<BaseController>()
                                                    .fetchDatabaseSong();
                                                return true;
                                              })
                                            : await Get.find<
                                                    MyLibraryController>()
                                                .favouriteSongAddApi(
                                                    songId: track?.songId ?? 0);
                                      }
                                    },
                                    message: track?.favouritesStatus ?? false
                                        ? "Are you sure you want to remove this item from Favorites?"
                                        : "Are you sure you want to add this item to Favorites?",
                                  ),
                                  barrierDismissible: false);
                              // _showConfirmationDialog(context: context,songData: track?.songId??0,favouriteStatus: track?.favouritesStatus??false);
                            },
                            btnName: "",
                            child: Padding(
                              padding: EdgeInsets.only(left: 10.0.w),
                              child: Row(
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
                                        Icons.favorite,
                                        color: AppColors.black,
                                        size: 20,
                                      ))),
                                  10.horizontalSpace,
                                  Flexible(
                                    child: AppTextWidget(
                                      maxLine: 2,
                                      overflow: TextOverflow.ellipsis,
                                      txtTitle: track?.favouritesStatus ?? false
                                          ? "Remove From Favorites"
                                          : "Add To Favorites",
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            )))
                    : SizedBox.shrink(),
                20.verticalSpace,
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
                                // if(track?.playlistStatus??false) {
                                //   print(track?.playListId);
                                //   track?.playlistStatus =   await Get.find<MyLibraryController>().playListSongRemoveApi(playlistsId: track?.playListId,songId: track?.songId??0);
                                //   Get.back();
                                // }else{
                                print(track?.playListId);
                                print(track?.songId);
                                print(track?.playlistStatus);
                                !(track?.playlistStatus??false)?
                                Get.dialog(AddPlaylistDialog(
                                  onCreateNewPlayList: () {
                                    Get.dialog(CreatePlayListDialog(
                                      onCreateTap: () async {
                                        track?.playlistStatus =
                                            await Get.dialog(
                                                ExistingPlaylistDialog(
                                          songId: track?.songId,
                                        ));
                                      },
                                    ));
                                  },
                                  onAddToExisting: () async {
                                    track?.playlistStatus =
                                        await Get.dialog(ExistingPlaylistDialog(
                                      songId: track?.songId,
                                    ));
                                  },
                                )): Get.find<MyLibraryController>().playListSongRemoveApi(playlistsId: track?.playListId??0,songId: track?.songId);
                                // track?.playlistStatus =   await Get.find<MyLibraryController>().playListSongAddApi(playlistsId: track?.playListId,songId: track?.songId??0);
                                // Get.back();
                                // }
                                // Get.find<MyLibraryController>().playListSongDataModel?.data?.removeWhere((v)=>v.playlistStatus==false);
                              },
                              message: track?.playlistStatus ?? false
                                  ? "Are you sure you want to remove this song from PlayList?"
                                  : "Are you sure you want to add this song to PlayList?"));
                        },
                        btnName: "",
                        child: Padding(
                          padding: EdgeInsets.only(left: 10.0.w),
                          child: Row(
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
                                txtTitle: track?.playlistStatus??false? 'Remove from Playlist': "Add To Playlist",
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ))),
                20.verticalSpace,
                isQueue == false
                    ? const SizedBox.shrink()
                    : isAlbum == false
                        ? Obx(
                            () => Visibility(
                                visible: Get.find<BaseController>()
                                    .databaseDownloadedSongList
                                    .any((test) =>
                                        test['song_id'] == track?.songId &&
                                        test['isDownloaded'] == 1),
                                replacement: Center(
                                    child: AppButtonWidget(
                                        width: double.maxFinite,
                                        borderColor:
                                            AppColors.white.withOpacity(0.5),
                                        borderRadius: 10.r,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        onPressed: () {
                                          Get.back();
                                          DownloadService.instance.downloadSong(
                                              downloadSongUrl: track?.song,
                                              SongData: track);
                                          Get.back();
                                        },
                                        btnName: "",
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10.0.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 35.h,
                                                  width: 35.h,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.r)),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.download,
                                                    color: AppColors.black,
                                                    size: 20,
                                                  ))),
                                              10.horizontalSpace,
                                              AppTextWidget(
                                                txtTitle: "Download Song",
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ))),
                                child: Center(
                                    child: AppButtonWidget(
                                        width: double.maxFinite,
                                        borderColor:
                                            AppColors.white.withOpacity(0.5),
                                        borderRadius: 10.r,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        onPressed: () {
                                          Get.find<BaseController>().deleteSong(
                                              songId: Get.find<BaseController>()
                                                  .databaseDownloadedSongList
                                                  .firstWhere((v) =>
                                                      v['song_id'] ==
                                                      track?.songId),
                                              isAlbum: false,
                                              index: index);
                                          Get.back();
                                        },
                                        btnName: "",
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10.0.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 35.h,
                                                  width: 35.h,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.r)),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.download,
                                                    color: AppColors.black,
                                                    size: 20,
                                                  ))),
                                              10.horizontalSpace,
                                              Flexible(
                                                child: AppTextWidget(
                                                  txtTitle:
                                                      "Remove Download Song",
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )))),
                          )
                        : Obx(
                            () => Visibility(
                                visible: Get.find<BaseController>()
                                    .databaseDownloadedSongList
                                    .any((test) =>
                                        test['song_id'] == track?.songId &&
                                        test['isDownloaded'] == 1),
                                replacement: Center(
                                    child: AppButtonWidget(
                                        width: double.maxFinite,
                                        borderColor:
                                            AppColors.white.withOpacity(0.5),
                                        borderRadius: 10.r,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        onPressed: () async
                                        {
                                          await Get.find<ArtistsController>()
                                              .albumTrackSongApi(
                                                  artistsId: track?.id ?? 0,
                                                  albumId: track?.albumsId ?? 0,
                                                  genresId: track?.genresId)
                                              .then((_) {
                                            Get.back();
                                            DownloadService.instance
                                                .downloadAllSongs(
                                                    tracksDataMode: Get.find<
                                                            ArtistsController>()
                                                        .albumTrackSongData);
                                          });
                                          print(
                                              "this is id${track?.id}, this is album id ${track?.albumsId},this is genereid ${track?.genresId}");
                                          // DownloadService.instance.downloadAllSongs(tracksDataMode:);
                                          Get.back();
                                        },
                                        btnName: "",
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10.0.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 35.h,
                                                  width: 35.h,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.primary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.r)),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.download,
                                                    color: AppColors.black,
                                                    size: 20,
                                                  ))),
                                              10.horizontalSpace,
                                              AppTextWidget(
                                                txtTitle: "Download Album",
                                                fontSize: 12,
                                              ),
                                            ],
                                          ),
                                        ))),
                                child: Center(
                                    child: AppButtonWidget(
                                        width: double.maxFinite,
                                        borderColor:
                                            AppColors.white.withOpacity(0.5),
                                        borderRadius: 10.r,
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        onPressed: () {
                                          Get.find<BaseController>().deleteSong(
                                              songId: Get.find<BaseController>()
                                                  .databaseDownloadedSongList
                                                  .firstWhere((v) =>
                                                      v['song_id'] ==
                                                      track?.songId),
                                              isAlbum: false,
                                              index: index);
                                          Get.back();
                                        },
                                        btnName: "",
                                        child: Padding(
                                          padding:
                                              EdgeInsets.only(left: 10.0.w),
                                          child: Row(
                                            children: [
                                              Container(
                                                  height: 35.h,
                                                  width: 35.h,
                                                  decoration: BoxDecoration(
                                                      color: AppColors.yellow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30.r)),
                                                  child: Center(
                                                      child: Icon(
                                                    Icons.download,
                                                    color: AppColors.black,
                                                    size: 20,
                                                  ))),
                                              10.horizontalSpace,
                                              Flexible(
                                                child: AppTextWidget(
                                                  txtTitle:
                                                      "Remove Download Album",
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )))),
                          ),
                20.verticalSpace,
              ],
            ),
            // })
            // Cancel Button
            Center(
                child: AppButtonWidget(
                    width: double.maxFinite,
                    borderColor: AppColors.white.withOpacity(0.5),
                    borderRadius: 10.r,
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    onPressed: () {
                      Get.back();
                    },
                    btnName: "Cancel")),
          ],
        ),
      ),
    );
  }
}