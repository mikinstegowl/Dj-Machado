import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
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

class SongsWidget extends StatelessWidget {
  final bool? addDownload;
  final Function()? onDownloadTaped;
  final TracksDataModel? tracksDataModel;

  const SongsWidget(
      {super.key,
      required this.tracksDataModel,
      this.addDownload,
      this.onDownloadTaped});

  @override
  Widget build(BuildContext context) {
    return
      tracksDataModel?.data?.isNotEmpty??false? Column(
        children: [
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount:
            tracksDataModel?.data?.length??0,
            itemBuilder: (context, index) {
              // Get.find<BaseController>().isDownload(tracksDataModel: tracksDataModel,index: index);
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
                      child: CachedNetworkImageWidget(
                        image: tracksDataModel?.data?[index].songImage,
                        width: 50.h,
                        height: 50.h,
                        fit: Platform.isAndroid ? BoxFit.cover : BoxFit.contain,
                      ),
                    ),
                    title: AppTextWidget(
                      txtTitle: tracksDataModel?.data?[index].songName ?? '',
                      fontSize: 12,
                      txtColor: AppColors.white,
                    ),
                    subtitle: AppTextWidget(
                      txtTitle: tracksDataModel?.data?[index].songArtist ?? '',
                      fontSize: 12,
                      txtColor: AppColors.primary,
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(()=>Visibility(
                            visible: Get.find<BaseController>().progress.any((v)=>v['song_Id']==tracksDataModel?.data?[index].songId),
                            replacement: !Get.find<BaseController>().isDownload(
                                songId: tracksDataModel?.data?[index].songId)
                                ? InkWell(
                              onTap: () async {
                                DownloadService.instance.downloadSong(
                                  downloadSongUrl:
                                  tracksDataModel?.data?[index].song ?? "",
                                  SongData: tracksDataModel?.data?[index],
                                );

                              },
                              child: Icon(
                                AppIcons.download, // Minus symbol
                                color: AppColors.white, // Black minus sign
                                size: 30.r,
                                weight: 15, // Adjust size as needed
                              ),
                            )
                                : const SizedBox.shrink(),
                            child: AppTextWidget(
                              txtColor: AppColors.white,
                               txtTitle:  Get.find<BaseController>().progress.any((v)=>v['song_Id']==tracksDataModel?.data?[index].songId)?  Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==tracksDataModel?.data?[index].songId)['progress'].toString()+"%":'' )
                        )),

                        10.horizontalSpace,
                        InkWell(
                          onTap: () {
                            Get.dialog(OptionDialog(
                              isQueue: true,
                              listOfTrackData: tracksDataModel?.data??[],index: index,track:tracksDataModel?.data?[index] ,));
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
                      // print(Get.find<BaseController>()
                      //     .databaseDownloadedSongList
                      //     .any((e) => e['song_id'] ==  tracksDataModel.data?[index].songId));
                      PlayerService.instance
                          .createPlaylist(tracksDataModel?.data, index: index,id: tracksDataModel?.data?[index].songId);
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
      ):Center(child: AppTextWidget(txtTitle: "No Data Found"),);
  }
}
