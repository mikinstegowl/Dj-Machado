import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';

class QueueScreenWidget extends StatefulWidget {
  const QueueScreenWidget({super.key});

  @override
  State<QueueScreenWidget> createState() => _QueueScreenWidgetState();
}

class _QueueScreenWidgetState extends State<QueueScreenWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // backgroundColor: AppColors.black,
      appBar: const CommonAppBar(
        title: "Queue",
        searchBarShow: false,
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 60.h),
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppAssets.backGroundImage))),
        child: GetBuilder<BaseController>(
            init: Get.find<BaseController>(),
            builder: (context) {
              return Column(
                children: [
                  ReorderableListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: PlayerService.instance.playlist.length ?? 0,
                      onReorder: (int oldIndex, int newIndex) {
                        if (newIndex > oldIndex) {
                          newIndex -=
                              1; // Adjust for the shift caused by the removal
                        }
                        if (newIndex >= 0 &&
                            newIndex < PlayerService.instance.playlist.length) {
                          final response = PlayerService.instance.playlist
                              .removeAt(oldIndex);
                          PlayerService.instance.playlist
                              .insert(newIndex, response);
                          setState(() {});
                        }
                      },
                      itemBuilder: (context, index) {
                        return ReorderableDragStartListener(
                          key:  ValueKey((PlayerService
                              .instance.playlist[index].sequence.first.tag.title + index.toString())),
                          // enabled: true,
                          index: index,
                          child: Container(
                            margin:  EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 10.w),
                            padding:  EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
                            decoration: BoxDecoration(
                              color: AppColors.black,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [

                                // Thumbnail
                                CachedNetworkImageWidget(
                                  image: PlayerService.instance.playlist[index]
                                          .sequence.first.tag.artUri
                                          .toString() ??
                                      '',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                ),

                                10.horizontalSpace,

                                // Title and Artist
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      AppTextWidget(
                                        txtTitle: PlayerService
                                                .instance
                                                .playlist[index]
                                                .sequence
                                                .first
                                                .tag
                                                .title ??
                                            '',
                                        txtColor: AppColors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                      5.verticalSpace,
                                      AppTextWidget(
                                        txtTitle: PlayerService
                                                .instance
                                                .playlist[index]
                                                .sequence
                                                .first
                                                .tag
                                                .artist ??
                                            '',
                                        txtColor: AppColors.primary,
                                        fontSize: 14,
                                      ),
                                    ],
                                  ),
                                ),

                                // Download Button

                                Visibility(
                                    visible: Get.find<BaseController>()
                                        .progress
                                        .any((v) =>
                                            v['song_Id'] ==
                                            PlayerService
                                                .instance
                                                .playlist[index]
                                                .sequence
                                                .first
                                                .tag
                                                .id),
                                    replacement: !Get.find<BaseController>()
                                            .isDownload(
                                                songId: int.tryParse(PlayerService
                                                    .instance
                                                    .playlist[index]
                                                    .sequence
                                                    .first
                                                    .tag
                                                    .id))
                                        ? InkWell(
                                            onTap: () async {
                                              DownloadService.instance
                                                  .downloadSong(
                                                downloadSongUrl: (PlayerService
                                                            .instance
                                                            .playlist[index]
                                                        as UriAudioSource)
                                                    .uri
                                                    .toString(),
                                                SongData: MixesTracksData(
                                                  songId: int.parse(
                                                    PlayerService
                                                            .instance
                                                            .playlist[index]
                                                            .sequence
                                                            .first
                                                            .tag
                                                            .id ??
                                                        '',
                                                  ),
                                                  song: (PlayerService.instance
                                                              .playlist[index]
                                                          as UriAudioSource)
                                                      .uri
                                                      .toString(),
                                                  songName: PlayerService
                                                      .instance
                                                      .playlist[index]
                                                      .sequence
                                                      .first
                                                      .tag
                                                      .title,
                                                  songArtist: PlayerService
                                                      .instance
                                                      .playlist[index]
                                                      .sequence
                                                      .first
                                                      .tag
                                                      .artist,
                                                  songImage: PlayerService
                                                          .instance
                                                          .playlist[index]
                                                          .sequence
                                                          .first
                                                          .tag
                                                          .artUri
                                                          .toString() ??
                                                      '',
                                                ),
                                              );
                                            },
                                            child: Icon(
                                              Icons.download, // Minus symbol
                                              color: AppColors
                                                  .white, // Black minus sign
                                              size: 30.r,
                                              weight:
                                                  15, // Adjust size as needed
                                            ),
                                          )
                                        : const SizedBox.shrink(),
                                    child: Text(
                                        Get.find<BaseController>().progress.any((v) => v['song_Id'] == PlayerService.instance.playlist[index].sequence.first.tag.id) ? Get.find<BaseController>().progress.firstWhere((v) => v['song_Id'] == PlayerService.instance.playlist[index].sequence.first.tag.id)['progress'].toString() + "%" : '')),
                                // Options Button
                                AppButtonWidget(
                                  btnName: '',
                                  child: const Icon(Icons.more_vert,
                                      color: AppColors.white),
                                  onPressed: () {
                                    Get.dialog(
                                      OptionDialog(
                                        // type: "offline",
                                        index: index,
                                        listOfTrackData: PlayerService
                                            .instance.playlist
                                            .map((v) => MixesTracksData(
                                                  songId: int.parse(
                                                      v.sequence.first.tag.id ??
                                                          ''),
                                                  originalImage: v.sequence
                                                          .first.tag.artUri
                                                          .toString() ??
                                                      '',
                                                  songArtist: v.sequence.first
                                                      .tag.artist,
                                                  songName: v
                                                      .sequence.first.tag.title,
                                                  songImage: v.sequence.first
                                                          .tag.artUri
                                                          .toString() ??
                                                      '',
                                                  song: (v as UriAudioSource)
                                                      .uri
                                                      .toString(),
                                                ))
                                            .toList(),
                                        track: MixesTracksData(
                                          songId: int.parse(
                                            PlayerService
                                                    .instance
                                                    .playlist[index]
                                                    .sequence
                                                    .first
                                                    .tag
                                                    .id ??
                                                '',
                                          ),
                                          song: (PlayerService
                                                      .instance.playlist[index]
                                                  as UriAudioSource)
                                              .uri
                                              .toString(),
                                          originalImage: PlayerService
                                                  .instance
                                                  .playlist[index]
                                                  .sequence
                                                  .first
                                                  .tag
                                                  .artUri
                                                  .toString() ??
                                              '',
                                          songName: PlayerService
                                              .instance
                                              .playlist[index]
                                              .sequence
                                              .first
                                              .tag
                                              .title,
                                          songArtist: PlayerService
                                              .instance
                                              .playlist[index]
                                              .sequence
                                              .first
                                              .tag
                                              .artist,
                                          songImage: PlayerService
                                                  .instance
                                                  .playlist[index]
                                                  .sequence
                                                  .first
                                                  .tag
                                                  .artUri
                                                  .toString() ??
                                              '',
                                        ),
                                      ),
                                    );
                                  },
                                ),

                                // Drag Handle
                              ],
                            ),
                          ),
                        );
                      }),
                ],
              );
            }),
      ),
    );
  }
}
