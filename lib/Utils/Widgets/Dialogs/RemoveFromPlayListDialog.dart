import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RemoveFromPlayListDialog extends StatelessWidget {
  final PlayListData? track;
  final int? index;
  const RemoveFromPlayListDialog({super.key, this.track, this.index});

  @override
  Widget build(BuildContext context) {
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
     track?.playlistImages?.isNotEmpty??false?CachedNetworkImageWidget(
        width: 50.h,
        height: 50.h,
        image: track?.playlistImages?[0].image)
              :  Image.asset(AppAssets.placeHolderImage,height: 50.h,width: 50.h,),
                12.horizontalSpace,
                // Song and artist name
                AppTextWidget(txtTitle:
                  '${track?.playlistsName}',

                    txtColor: AppColors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,

                ),
              ],
            ),
            40.verticalSpace,
            Column(
              children: [
                Center(
                    child: AppButtonWidget(
                        width: double.maxFinite,
                        borderColor: AppColors.white.withOpacity(0.5),
                        borderRadius: 10.r,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        onPressed: () {
                          Get.dialog(YesNoDialog(onYesCalled: (){
                            Get.find<MyLibraryController>().playListRemoveApi(playlistsId:  track?.playlistsId);
                            Get.back();
                          }, message:"Are you sure you want to delete this playlist!!"));

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
                                  child: const Center(
                                      child: Icon(
                                        Icons.playlist_add,
                                        color: AppColors.black,
                                        size: 20,
                                      ))),
                              10.horizontalSpace,
                             const AppTextWidget(
                                txtTitle: "Delete Playlist",
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ))),
                20.verticalSpace,

                Center(
                    child: AppButtonWidget(
                        width: double.maxFinite,
                        borderColor: AppColors.white.withOpacity(0.5),
                        borderRadius: 10.r,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        onPressed: () {
                          Get.find<MyLibraryController>()
                              .playListSongDataApi(
                              playlistsId:
                              track?.playlistsId)
                              .then((_) {
                            Get.find<MyLibraryController >().playListSongDataModel?.data?[index??0].playlistsName = track?.playlistsName;
                            Get.find<MyLibraryController >().playListSongDataModel?.data?[index??0].playlistImages = track?.playlistImages;

                                // print(Get.find<MyLibraryController>().playListSongDataModel);
                                DownloadService.instance.playListDownloadAllSongs(
                                  tracksDataMode: Get.find<MyLibraryController >().playListSongDataModel,
                                  index: index
                                );
                          });
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
                                      BorderRadius.circular(30.r)),
                                  child: Center(
                                      child: Icon(
                                        Icons.download,
                                        color: AppColors.black,
                                        size: 20,
                                      ))),
                              10.horizontalSpace,
                              AppTextWidget(
                                txtTitle: "Download Playlist",
                                fontSize: 12,
                              ),
                            ],
                          ),
                        ))),
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
                    padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 10.h),
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
