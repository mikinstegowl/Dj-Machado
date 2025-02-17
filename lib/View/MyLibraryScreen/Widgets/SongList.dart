import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SongListWidget extends StatelessWidget {
  final String title;
  final int index;
  final String subTitle;
  final int? songId;
  final bool gif;
  final Function() onOptionTap;
  final bool online;

  final List<MixesTracksData>? tracksDataModel;
  final String imageUrl;
  const SongListWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onOptionTap,
      required this.imageUrl,
      required this.index,
      this.tracksDataModel,
      this.songId,  this.online = true,  this.gif = false});

  @override
  Widget build(BuildContext context) {
    print(Get.find<BaseController>().progress.any((v) =>
        v['song_Id'] ==
        Get.find<BaseController>().databaseDownloadedSongList[index]
            ['song_id']));
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () {
            // Get.find<BaseController>().connectivityResult[0] ==
            //         ConnectivityResult.none
            //     ?
            online == false?
            PlayerService.instance.createPlaylist(
                    Get.find<BaseController>().databaseDownloadedSongList,
                    index: index,
                    type: "offline",
                    id: Get.find<BaseController>()
                        .databaseDownloadedSongList[index]['song_id'])
                :
            PlayerService.instance.createPlaylist(tracksDataModel,
                    index: index, id: tracksDataModel?[index].songId);
          },
          // minLeadingWidth: 50.h,
          leading: Stack(
            children: [
              SizedBox(
                height: 40.h,
                width: 40.h,
                child: CachedNetworkImageWidget(image: imageUrl),
              ),
            online ?
              Obx(() => PlayerService.instance.currentSong.value == tracksDataModel?[index].songName
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
                  : SizedBox.shrink()): Obx(() => PlayerService.instance.currentSong.value == Get.find<BaseController>()
                  .databaseDownloadedSongList[index]['song_name']
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
          contentPadding: EdgeInsets.only(left: 10.w),
          title: AppTextWidget(
              txtTitle: title,
              fontWeight: FontWeight.w800,
              fontSize: 18,
              txtColor: AppColors.white),
          subtitle: AppTextWidget(
            txtTitle: subTitle,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            txtColor: AppColors.primary,
          ),
          trailing: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: onOptionTap,
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
          minVerticalPadding: 0,
        ),
        // 10.verticalSpace,
        const Divider(
          height: 1,
        )
      ],
    );
  }
}
