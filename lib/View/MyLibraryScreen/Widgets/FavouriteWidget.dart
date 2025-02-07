import 'dart:io';

import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class FavouriteWidget extends StatelessWidget {
  final FavouriteSongDataModel?  favouriteSongDataModel;
  const FavouriteWidget({super.key, this.favouriteSongDataModel});

  @override
  Widget build(BuildContext context) {
    return favouriteSongDataModel?.data?.isNotEmpty??false? Column(
      children: [
        ListView.builder(
          controller: Get.find<MyLibraryController>().scrollController,
            // physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: favouriteSongDataModel?.data?.length??0,
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
                        image: favouriteSongDataModel?.data?[index].songImage,
                        width: 50.h,
                        height: 50.h,
                        fit: Platform.isAndroid ? BoxFit.cover : BoxFit.contain,
                      ),
                    ),
                    title: AppTextWidget(
                      txtTitle: favouriteSongDataModel?.data?[index].songName ?? '',
                      fontSize: 12,
                      txtColor: AppColors.white,
                    ),
                    subtitle: AppTextWidget(
                      txtTitle: favouriteSongDataModel?.data?[index].songArtist ?? '',
                      fontSize: 12,
                      txtColor: AppColors.primary,
                    ),
                    trailing: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       GetBuilder<BaseController>(
                    init: Get.find<BaseController>(),
                         builder: (controller) {
                           return Visibility(
                                visible: Get.find<BaseController>().progress.any((v)=>v['song_Id']==favouriteSongDataModel?.data?[index].songId),
                                replacement: !Get.find<BaseController>().isDownload(
                                  songId: favouriteSongDataModel?.data?[index].songId
                                )
                                    ? InkWell(
                                  onTap: () async {
                                    // Get.find<BaseController>().checkIfFileExists(index,tracksDataModel);
                                    DownloadService.instance.downloadSong(
                                      downloadSongUrl:
                                      favouriteSongDataModel?.data?[index].song ?? "",
                                      SongData: favouriteSongDataModel?.data?[index],
                                    );
                                  },
                                  child: Icon(
                                    Icons.download, // Minus symbol
                                    color: AppColors.white, // Black minus sign
                                    size: 30.r,
                                    weight: 15, // Adjust size as needed
                                  ),
                                )
                                    : const SizedBox.shrink(),
                                child: Text(
                                    Get.find<BaseController>().progress.any((v)=>v['song_Id']==favouriteSongDataModel?.data?[index].songId)?  Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==favouriteSongDataModel?.data?[index].songId)['progress'].toString()+"%":'' ),
                              );
                         }
                       ),

                        10.horizontalSpace,
                        InkWell(
                          onTap: () {
                            Get.dialog(OptionDialog(
                              isQueue: true,
                              listOfTrackData: favouriteSongDataModel?.data??[],index: index,track:  favouriteSongDataModel?.data?[index],));
                            // showCustomDialog(
                            //     context, tracksDataModel.data?[index], index);
                          },
                          child: Icon(
                            weight: 15,
                            Icons.more_vert,
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
                          .createPlaylist(favouriteSongDataModel?.data, index: index,id: favouriteSongDataModel?.data?[index].songId);
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
    ): const Center(child: AppTextWidget(txtTitle: "No Data Found"),);
  }
}
