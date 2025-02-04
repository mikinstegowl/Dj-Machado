import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/CreatePlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/RemoveFromPlayListDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlayListWidget extends StatelessWidget {
  final PlayListDataModel? playListDataModel;

  const PlayListWidget({super.key, this.playListDataModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: Get.find<MyLibraryController>().scrollController2,
      child: Column(
        children: [
          20.verticalSpace,
          InkWell(
            onTap: () {
              Get.dialog(CreatePlayListDialog());
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(5.h),
              leading: Container(
                  width: 50.h,
                  height: 50.h,
                  color: AppColors.newdarkgrey.withOpacity(0.5),
                  child: Icon(
                    Icons.add,
                    color: AppColors.white,
                  )),
              title: AppTextWidget(txtTitle: "Create Playlist"),
            ),
          ),
          // 20.verticalSpace,
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: playListDataModel?.data?.length ?? 0,
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
                        child:
                            // GridView.builder(
                            //     itemCount: 4,
                            //     padding: EdgeInsets.zero,
                            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                            //     itemBuilder: (context,index){
                            //       return Container(
                            //         decoration: BoxDecoration(border: Border.all(color: AppColors.darkgrey)),
                            //         child: CachedNetworkImageWidget(
                            //           height: double.maxFinite,
                            //           image:  playListDataModel?.data != null && index < playListDataModel!.data!.length ? playListDataModel!.data![index].playlistImages![0].image!: "", // Use the song image
                            //           fit: BoxFit.cover,
                            //         ),
                            //       );
                            //     })
                            //     GridView.builder(
                            //   itemCount: playListDataModel?.data != null
                            //       ? (playListDataModel!.data!.length > 4
                            //           ? 4
                            //           : playListDataModel!.data!.length)
                            //       : 0,
                            //   padding: EdgeInsets.zero,
                            //   gridDelegate:
                            //       const SliverGridDelegateWithFixedCrossAxisCount(
                            //     crossAxisCount: 2, // Two items per row
                            //   ),
                            //   itemBuilder: (context, index) {
                            //     final playlistItem =
                            //         playListDataModel?.data?[index];
                            //     final imageUrl = (playlistItem?.playlistImages !=
                            //                 null &&
                            //             playlistItem!.playlistImages!.isNotEmpty)
                            //         ? playlistItem.playlistImages![index].image
                            //         : ""; // Default to an empty string if no image is available
                            //
                            //     return Container(
                            //       decoration: BoxDecoration(
                            //         border: Border.all(color: AppColors.darkgrey),
                            //       ),
                            //       child: CachedNetworkImageWidget(
                            //         height: double.maxFinite,
                            //         image:
                            //         Get.find<MyLibraryController>().playListSongDataModel?.data != null && index < Get.find<MyLibraryController>().playListSongDataModel!.data!.length ? Get.find<MyLibraryController>().playListSongDataModel!.data![index].songImage: "", // Use the song image, // Use the first image of the playlist
                            //         fit: BoxFit.cover,
                            //       ),
                            //     );
                            //   },
                            // ),

                            CachedNetworkImageWidget(
                          image: playListDataModel?.data?[index].playlistImages
                                      ?.isNotEmpty ??
                                  false
                              ? playListDataModel
                                  ?.data![index].playlistImages?.first.image
                              : playListDataModel?.data![index].playlistImages1
                          // : ""
                          ,
                          width: 50.h,
                          height: 50.h,
                          fit: Platform.isAndroid
                              ? BoxFit.cover
                              : BoxFit.contain,
                        ),
                      ),
                      title: AppTextWidget(
                        txtTitle:
                            playListDataModel?.data?[index].playlistsName ??
                                'null',
                        fontSize: 12,
                        txtColor: AppColors.white,
                      ),
                      subtitle: AppTextWidget(
                        txtTitle:
                            "${playListDataModel?.data?[index].songCount.toString()} songs",
                        fontSize: 12,
                        txtColor: AppColors.primary,
                      ),
                      trailing: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          10.horizontalSpace,
                          InkWell(
                            onTap: () {
                              // print(playListDataModel?.data?[index].playlistsId);
                              Get.dialog(RemoveFromPlayListDialog(
                                track: playListDataModel?.data?[index],
                                index: index,
                              ));
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
                        if (Get.find<BaseController>().connectivityResult[0] !=
                            ConnectivityResult.none) {
                          Get.find<MyLibraryController>()
                              .playListSongDataApi(
                                  playlistsId: playListDataModel
                                      ?.data?[index].playlistsId)
                              .then((_) {
                            Get.toNamed(RoutesName.playListDetailView,
                                arguments: {
                                  "playlist_name": playListDataModel
                                      ?.data?[index].playlistsName
                                });
                          });
                        } else {
                          Get.find<MyLibraryController>()
                              .convertStringToPlayList(index: index);
                          Get.toNamed(RoutesName.playListDetailView,
                              arguments: {
                                "playlist_name": Get.find<MyLibraryController>()
                                        .databaseDownloadPlayListSongList[index]
                                    ['playlist_name'],
                                "playlist_id": Get.find<MyLibraryController>()
                                        .databaseDownloadPlayListSongList[index]
                                    ['playlist_id']
                              });
                          print(
                              "${Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['playlist_name']}");
                        }
                      },
                    ),
                    const Divider(
                      height: 1,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }
}
