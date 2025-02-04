import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/AddPlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/CreatePlayListDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/ExistingPlaylistDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/YesNoDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/Models/ExplorDataModel.dart';

class HomeAlbumWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final List<Data>? data;
  final Function() onViewAllTap;

  const HomeAlbumWidget({super.key, this.trendingCategoryName, this.data, required this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(
                  txtTitle: trendingCategoryName ??
                      ''),
              InkWell(
                onTap:onViewAllTap,
                child: const AppTextWidget(
                  txtTitle: "View All",
                  fontSize: 15,
                  txtColor: AppColors.primary,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child: GridView.builder(
              padding:
              EdgeInsets.only(left: 10.w),
              itemCount: data
                  ?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                  double.maxFinite,
                  mainAxisExtent: 170.w,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return MostPlayedSongsWidget(
                    onOptionTap: (){
                      Get.dialog(AlertDialog(
                        backgroundColor: AppColors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                          Row(mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Album Image
                              Container(
                                width: 70.h,
                                height: 70.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      '${data?[index].albumsImage}', // Replace with your image URL
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              12.horizontalSpace,
                              // Song and artist name
                              AppTextWidget(
                                txtTitle: '${data?[index].albumsName}',

                                  txtColor: AppColors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,

                              ),
                            ],
                          ),
                          40.verticalSpace,

                            Center(
                                child: AppButtonWidget(
                                    width: double.maxFinite,
                                    borderColor: AppColors.white.withOpacity(0.5),
                                    borderRadius: 10.r,
                                    padding: EdgeInsets.symmetric(vertical: 12.h),
                                    onPressed: ()async  {
                                      Get.back();
                                      Get.dialog(
                                          YesNoDialog(onYesCalled: () async {

                                            // if(track?.playlistStatus??false) {
                                            //   print(track?.playListId);
                                            //   track?.playlistStatus =   await Get.find<MyLibraryController>().playListSongRemoveApi(playlistsId: track?.playListId,songId: track?.songId??0);
                                            //   Get.back();
                                            // }else{
                                            Get.dialog(AddPlaylistDialog(onCreateNewPlayList: () { Get.dialog( CreatePlayListDialog(onCreateTap: ()async{

                                                data?[index].playlistStatus=  await Get.dialog(ExistingPlaylistDialog(songId: data?[index].songId,));

                                            },)); }, onAddToExisting: ()async {

                                                data?[index].playlistStatus = await  Get.dialog(ExistingPlaylistDialog(songId: data?[index].songId,));
                                                },));
                                            // track?.playlistStatus =   await Get.find<MyLibraryController>().playListSongAddApi(playlistsId: track?.playListId,songId: track?.songId??0);
                                            // Get.back();
                                            // }
                                            // Get.find<MyLibraryController>().playListSongDataModel?.data?.removeWhere((v)=>v.playlistStatus==false);
                                          }, message:data?[index].playlistStatus??false ?"Are you sure you want to remove this song from PlayList?" : "Are you sure you want to add this song to PlayList?")
                                      );
                                    },
                                    btnName: "",
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0.w),
                                      child: Row(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: 35.h,
                                              width: 35.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.yellow,
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
                                            txtTitle: "Add To Playlist",
                                            fontSize: 15,
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
                                    onPressed: ()async {
                                     await Get.find<ArtistsController>().albumsAndTracks(albumId:data?[index]
                                          .albumsId).then((_) {
                                        // DownloadService.instance.playListDownloadAllSongs(
                                        //     tracksDataMode: Get.find<ArtistsController>().albumTrackSongData?.data
                                        // );
                                      });
                                      Get.back();
                                    },
                                    btnName: "",
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 10.0.w),
                                      child: Row(mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                              height: 35.h,
                                              width: 35.h,
                                              decoration: BoxDecoration(
                                                  color: AppColors.yellow,
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
                                            txtTitle: "Download Song",
                                            fontSize: 15,
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
                                    padding: EdgeInsets.symmetric(horizontal: 10.h,vertical: 10.h),
                                    onPressed: () {
                                      Get.back();
                                    },
                                    btnName: "Cancel")),
                        ],),
                      ));
                    },
                  onTap: (){
                    Get.find<ArtistsController>().albumsAndTracks(albumId:data?[index]
                        .albumsId).then((_){
                          Get.toNamed(RoutesName.albumTrackScreen);
                    });
                  },
                  title: data?[index]
                      .albumsName,
                  image:data?[index]
                      .albumsImage,
                  subtitle:data?[index]
                      .albumsArtist,
                );
              }),
        ),
        20.verticalSpace,
      ],
    );
  }
}
