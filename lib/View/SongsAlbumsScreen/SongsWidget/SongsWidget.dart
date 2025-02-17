import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppIcons.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongModelClass.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SongsWidget extends StatefulWidget {
  final bool? addDownload;
  final Function()? onDownloadTaped;
  final TracksDataModel? tracksDataModel;
  final bool gif;

  const SongsWidget(
      {super.key,
      required this.tracksDataModel,
      this.addDownload,
      this.onDownloadTaped,
      this.gif = false});

  @override
  State<SongsWidget> createState() => _SongsWidgetState();
}

class _SongsWidgetState extends State<SongsWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.tracksDataModel?.data?.isNotEmpty ?? false
        ? Column(
            children: [
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.tracksDataModel?.data?.length ?? 0,
                  itemBuilder: (context, index) {
                    String songName = widget.tracksDataModel?.data?[index].songName ?? '';
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          minTileHeight: 55,
                          contentPadding: EdgeInsets.all(5.h),
                          leading: Container(
                            width: 50.h,
                            height: 50.h,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: AppColors.white,
                                shape: Platform.isAndroid
                                    ? BoxShape.rectangle
                                    : BoxShape.circle),
                            child: Stack(
                              children: [
                                CachedNetworkImageWidget(
                                  image:
                                      widget.tracksDataModel?.data?[index].songImage,
                                  width: 50.h,
                                  height: 50.h,
                                  fit: Platform.isAndroid
                                      ? BoxFit.cover
                                      : BoxFit.contain,
                                ),
                                Obx(() => PlayerService.instance.currentSong.value == songName
                                    ? Positioned.fill(
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Image.asset(
                                      AppAssets.gif,
                                      height: 30.h,
                                      width: 30.w,
                                      color: AppColors.primary,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                                    : SizedBox.shrink()),
                              ],
                            ),
                          ),
                          title: AppTextWidget(
                            txtTitle:
                                widget.tracksDataModel?.data?[index].songName ?? '',
                            fontSize: 12,
                            txtColor: AppColors.white,
                          ),
                          subtitle: AppTextWidget(
                            txtTitle:
                                widget.tracksDataModel?.data?[index].songArtist ?? '',
                            fontSize: 12,
                            txtColor: AppColors.primary,
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Obx(() => Visibility(
                                  visible: Get.find<BaseController>()
                                      .progress
                                      .any((v) =>
                                          v['song_Id'] ==
                                          widget.tracksDataModel?.data?[index].songId),
                                  replacement: !Get.find<BaseController>().isDownload(
                                          songId: widget.tracksDataModel
                                              ?.data?[index].songId)
                                      ? InkWell(
                                          onTap: () async {
                                            DownloadService.instance
                                                .downloadSong(
                                              downloadSongUrl: widget.tracksDataModel
                                                      ?.data?[index].song ??
                                                  "",
                                              SongData:
                                                  widget.tracksDataModel?.data?[index],
                                            );
                                          },
                                          child: Icon(
                                            AppIcons.download, // Minus symbol
                                            color: AppColors
                                                .white, // Black minus sign
                                            size: 30.r,
                                            weight: 15, // Adjust size as needed
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                  child: AppTextWidget(
                                      txtColor: AppColors.white,
                                      txtTitle: Get.find<BaseController>()
                                              .progress
                                              .any((v) =>
                                                  v['song_Id'] ==
                                                  widget.tracksDataModel
                                                      ?.data?[index].songId)
                                          ? Get.find<BaseController>()
                                                  .progress
                                                  .firstWhere(
                                                      (v) => v['song_Id'] == widget.tracksDataModel?.data?[index].songId)['progress']
                                                  .toString() +
                                              "%"
                                          : ''))),
                              10.horizontalSpace,
                              InkWell(
                                onTap: () {
                                  Get.dialog(OptionDialog(
                                    isQueue: true,
                                    listOfTrackData:
                                        widget.tracksDataModel?.data ?? [],
                                    index: index,
                                    track: widget.tracksDataModel?.data?[index],
                                  ));
                                  // showCustomDialog(
                                  //     context, tracksDataModel.data?[index], index);
                                },
                                child: Icon(
                                  weight: 15,
                                  AppIcons.more_vert,
                                  color: AppColors.white,
                                  size: 30.r,
                                ),
                              ),
                              10.horizontalSpace,
                            ],
                          ),
                          onTap: () {
                            PlayerService.instance.createPlaylist(
                                widget.tracksDataModel?.data,
                                index: index,
                                id: widget.tracksDataModel?.data?[index].songId);
                            setState(() {
                            });
                          },
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    );
                  }),
              50.verticalSpace,
            ],
          )
        : Center(
            child: AppTextWidget(txtTitle: "No Data Found"),
          );
  }
}
