import 'package:newmusicappmachado/Controller/BaseController.dart';
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
  final Function() onOptionTap;

  final List<MixesTracksData>? tracksDataModel;
  final String imageUrl;
  const SongListWidget(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onOptionTap,
      required this.imageUrl,
      required this.index,
      this.tracksDataModel,  this.songId});

  @override
  Widget build(BuildContext context) {
    print(Get.find<BaseController>()
        .progress
        .any((v) => v['song_Id'] == Get.find<BaseController>().databaseDownloadedSongList[index]['song_id']));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          onTap: () {
            PlayerService.instance.createPlaylist(
                Get.find<BaseController>().databaseDownloadedSongList, index: index,
                type: "offline",id: Get.find<BaseController>().databaseDownloadedSongList[index]['song_id']);
          },
          minLeadingWidth: 50.h,
          leading: SizedBox(
            height: 40.h,
            width: 40.h,
            child: CachedNetworkImageWidget(image: imageUrl),
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
              Center(
                child:
                //
                // Container(
                //   decoration: const BoxDecoration(
                //     color: AppColors.error, // Red background
                //     shape: BoxShape.circle, // Circular shape
                //   ),
                //   width: 25.h, // Adjust the size
                //   height: 25.h,
                //   child: Center(
                //     child: InkWell(
                //       onTap: (){
                //         Get.find<BaseController>().deleteSong(songId: Get.find<BaseController>().databaseDownloadedSongList[index],isAlbum: false,index: index);
                //       },
                //       child: Icon(
                //         Icons.remove, // Minus symbol
                //         color: Colors.black, // Black minus sign
                //         size: 22.r,
                //         weight: 15, // Adjust size as needed
                //       ),
                //     ),
                //   ),
                // ),
                GetBuilder<BaseController>(
                  init: Get.find<BaseController>(),
                  builder: (controller) {
                    return Visibility(
                        visible: Get.find<BaseController>().progress.any(
                                (v) => v['song_Id'] == Get.find<BaseController>().databaseDownloadedSongList[index]['song_id']),
                        replacement: SizedBox.shrink(),
                        child: AppTextWidget(
                          txtColor: AppColors.white,
                            txtTitle: Get.find<BaseController>().progress.any((v) =>
                        v['song_Id'] == Get.find<BaseController>().databaseDownloadedSongList[index]['song_id'])
                            ? Get.find<BaseController>()
                            .progress
                            .firstWhere((v) =>
                        v['song_Id'] ==
                            Get.find<BaseController>().databaseDownloadedSongList[index]['song_id'])['progress']
                            .toString() +
                            "%"
                            : ''));
                  }
                ),
              ),
              10.horizontalSpace,
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
