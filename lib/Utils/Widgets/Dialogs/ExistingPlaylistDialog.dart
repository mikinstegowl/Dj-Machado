import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExistingPlaylistDialog extends StatelessWidget {
  final int? songId;
  final int? albumId;
  const ExistingPlaylistDialog({super.key, this.songId, this.albumId});

  @override
  Widget build(BuildContext context) {
    print("this is albumId${albumId}");
    return AlertDialog(
      backgroundColor: AppColors.black,
      insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
      title: const Center(
        child: AppTextWidget(
          txtTitle: 'Choose Playlist',
          fontWeight: FontWeight.w600,
          fontSize: 18,
          txtColor: AppColors.white,
        ),
      ),
      content: Container(
        // height: MediaQuery.sizeOf(context).height,
        width: double.maxFinite,
        constraints: BoxConstraints(
          maxHeight: 400.h,
        ),
        child: GetBuilder<MyLibraryController>(
            init: Get.find<MyLibraryController>()..playListDataApi(),
            builder: (controller) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child:controller
                  .playListDataModel
                  ?.data?.isNotEmpty??false ? ListView.builder(
                        itemCount: controller
                            .playListDataModel
                            ?.data
                            ?.length ??
                            1,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              AppButtonWidget(
                                padding: EdgeInsets.all(10.r),
                                onPressed: ()async {
                                albumId == null? await controller.playListSongAddApi(playlistsId: controller
                                      .playListDataModel
                                      ?.data?[index].playlistsId, songId: songId).then((v){
                                        print(v);
                                  }):await controller.playListAlbumAddApi(playlistsId: controller
                                    .playListDataModel
                                    ?.data?[index].playlistsId, albumId: albumId).then((v){
                                  print(v);
                                }) ;
                                },
                                width: double.maxFinite,
                                btnColor: AppColors.black,
                                btnName: controller
                                    .playListDataModel
                                    ?.data?[index]
                                    .playlistsName ??
                                    '',
                                // txtColor: AppColors.primary,
                              ),
                              if ( controller
                                  .playListDataModel?.data
                                  ?.length !=
                                  index + 1)
                                Divider()
                            ],
                          );
                        }):CircularProgressIndicator.adaptive(),
                  )
                ],
              );
            }),
      ),
      actions: [
        AppButtonWidget(
          onPressed: () {
            Get.back();
          },
          btnName: 'Cancel',

          width: double.maxFinite,
        )
      ],
    );
  }
}
