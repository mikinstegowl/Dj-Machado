import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/DownloadService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeSongListingWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlayListDetailView extends StatelessWidget {

  const PlayListDetailView({super.key,});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            backgroundColor: AppColors.darkgrey,
            bottomSheet: AudioPlayerController(),
            bottomNavigationBar: BottomBarWidget(mainScreen: false,),
            appBar: AppBar(
              toolbarHeight: 80.h,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.h), // Adjust height as needed
                child: const Divider(
                  thickness: 2,
                ),
              ),
              leadingWidth: 140.w,
              leading: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Row(
                  children: [
                    Image.asset(
                      height: 25.h,
                      width: 25.h,
                      AppAssets.backIcon,
                      color: AppColors.white,
                    ),
                    5.horizontalSpace,
                    const AppTextWidget(
                      fontWeight: FontWeight.w600,
                      txtTitle: "Back",
                      txtColor: AppColors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              ),
              backgroundColor: AppColors.transparent,
              centerTitle: true,
              title: AppTextWidget(
                txtTitle:  Get.arguments['playlist_name']
                ??
                    '',
                txtColor: AppColors.white,
                fontSize: 18,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(RoutesName.advanceSearchScreen);
                    },
                    child: Icon(
                      Icons.search,
                      size: 35.r,
                      color: AppColors.primary,
                    ),
                  ),
                )
              ],
            ),

            body: Container(
              height: MediaQuery.sizeOf(context).height,
              padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+35.h),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backGroundImage))
              ),
              child: GetBuilder<MyLibraryController>(
                init: Get.find<MyLibraryController>(),
                builder: (controller) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 100.verticalSpace,
                      // Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none?
                      // Get.find<MyLibraryController>().playListSongDataModel?.data?.isEmpty??false?
                      SizedBox(
                        child: Align(
                          alignment: Alignment.center,
                          child:  Container(
                            height: 225.h,
                            width: 225.h,
                            margin: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: GridView.builder(
                              itemCount: 4,
                                padding: EdgeInsets.zero,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                                itemBuilder: (context,index){
                                    return Container(
                                      decoration: BoxDecoration(border: Border.all(color: AppColors.darkgrey)),
                                      child: CachedNetworkImageWidget(
                                        height: double.maxFinite,
                                        image:   Get.find<MyLibraryController>().playListSongDataModel?.data != null && index < Get.find<MyLibraryController>().playListSongDataModel!.data!.length ? Get.find<MyLibraryController>().playListSongDataModel!.data![index].songImage: "", // Use the song image
                                        fit: BoxFit.cover,
                                      ),
                                    );
                            })
                          ),
                        ),
                      ),
                      //     :Center(
                      //   child: Container(
                      //     child: AppTextWidget(
                      //       txtTitle: "No Data Found",
                      //     ),
                      //   ),
                      // ) ,
                     20.verticalSpace,
                      const Divider(
                        thickness: 2,
                        height: 1,
                      ),
                      Get.find<BaseController>().connectivityResult[0] != ConnectivityResult.none?  Get.find<MyLibraryController>().playListSongDataModel?.data?.isEmpty ??true?  Center(
                        child: Container(
                          child: AppTextWidget(
                            txtTitle: "No Data Found",
                          ),
                        ),
                      ) :    Expanded(
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              controller: Get.find<MyLibraryController>().scrollController3 ,
                              // physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: Get.find<MyLibraryController>().playListSongDataModel?.data?.length,
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
                                          image: Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songImage,
                                          width: 50.h,
                                          height: 50.h,
                                          fit: Platform.isAndroid
                                              ? BoxFit.cover
                                              : BoxFit.contain,
                                        ),
                                      ),
                                      title: AppTextWidget(
                                        txtTitle: Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songName??"",
                                        fontSize: 12,
                                        txtColor: AppColors.white,
                                      ),
                                      subtitle: AppTextWidget(
                                        txtTitle: Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songArtist??"",
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
                                                  visible:Get.find<BaseController>().progress.any((v)=>v['song_Id']==Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId),
                                                  replacement: !Get.find<BaseController>().isDownload(
                                                      songId: Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId)
                                                      ? InkWell(
                                                    onTap: () async {
                                                      DownloadService.instance.downloadSong(
                                                      downloadSongUrl:
                                                      Get.find<MyLibraryController>().playListSongDataModel?.data?[index].song ?? "",
                                                      SongData: Get.find<MyLibraryController>().playListSongDataModel?.data?[index],
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
                                                    style: TextStyle(
                                                      color: AppColors.white
                                                    ),
                                                      Get.find<BaseController>().progress.any((v)=>v['song_Id']==Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId)?  Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId)['progress'].toString()+"%":'' )
                                                );
                                             }
                                           ),


                                          10.horizontalSpace,
                                          InkWell(
                                            onTap: () {
                                              print(Get.find<MyLibraryController>().playListSongDataModel?.data?[index].playListId);
                                              Get.dialog(OptionDialog(listOfTrackData:Get.find<MyLibraryController>().playListSongDataModel?.data??[],index: index,track: Get.find<MyLibraryController>().playListSongDataModel?.data?[index],));
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
                                        Get.find<BaseController>().connectivityResult[0] ==
                                            ConnectivityResult.none
                                            ? PlayerService.instance.createPlaylist(
                                            Get.find<MyLibraryController>().databaseDownloadPlayListSongList,
                                            index: index,
                                            type: "offline",
                                            id: Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['song_id'])
                                            :
                                        PlayerService.instance
                                            .createPlaylist(Get.find<MyLibraryController>().playListSongDataModel?.data, index: index,type: 'song',id: Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId);
                                      },
                                    ),
                                    const Divider(
                                      height: 1,
                                    ),
                                  ],
                                );
                              }),) : Get.find<MyLibraryController>().playListSongData.isEmpty ? Center(
                        child: Container(
                          child: AppTextWidget(
                            txtTitle: "No Data Found",
                          ),
                        ),
                      ) :  Expanded(
                        child:
                       GetBuilder<BaseController>(
                         init: Get.find<BaseController>(),
                           builder: (context){
                         return  ListView.builder(
                             padding: EdgeInsets.zero,
                             physics: const ClampingScrollPhysics(),
                             shrinkWrap: true,
                             itemCount: Get.find<MyLibraryController>().playListSongData.length,
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
                                         image: Get.find<MyLibraryController>().playListSongData[index]['imageUrl'],
                                         width: 50.h,
                                         height: 50.h,
                                         fit: Platform.isAndroid
                                             ? BoxFit.cover
                                             : BoxFit.contain,
                                       ),
                                     ),
                                     title: AppTextWidget(
                                       txtTitle: Get.find<MyLibraryController>().playListSongData[index]['song_name']??"",
                                       fontSize: 12,
                                       txtColor: AppColors.white,
                                     ),
                                     subtitle: AppTextWidget(
                                       txtTitle: Get.find<MyLibraryController>().playListSongData[index]['artist_name']??"",
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
                                                   visible: Get.find<BaseController>().progress.any(
                                                           (v) => v['song_Id'] == Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['song_id']),
                                                   replacement: Container(
                                                     decoration: const BoxDecoration(
                                                       color: AppColors.error, // Red background
                                                       shape: BoxShape.circle, // Circular shape
                                                     ),
                                                     width: 25.h, // Adjust the size
                                                     height: 25.h,
                                                     child: Center(
                                                       child: InkWell(
                                                         onTap: (){
                                                           Get.find<MyLibraryController>().deletePlayList(index: Get.find<MyLibraryController>().playListSongData[index]['song_id'],playListId: Get.arguments['playlist_id'],path: Get.find<MyLibraryController>().playListSongData[index]['file_path']);
                                                         },
                                                         child: Icon(
                                                           Icons.remove, // Minus symbol
                                                           color: Colors.black, // Black minus sign
                                                           size: 22.r,
                                                           weight: 15, // Adjust size as needed
                                                         ),
                                                       ),
                                                     ),
                                                   ),
                                                   child: Text(Get.find<BaseController>().progress.any((v) =>
                                                   v['song_Id'] == Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['song_id'])
                                                       ? Get.find<BaseController>()
                                                       .progress
                                                       .firstWhere((v) =>
                                                   v['song_Id'] ==
                                                       Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['song_id'])['progress']
                                                       .toString() +
                                                       "%"
                                                       : ''));
                                             }
                                         ),
                                         // GetBuilder<BaseController>(
                                         //     init: Get.find<BaseController>(),
                                         //     builder: (controller) {
                                         //       return Visibility(
                                         //           visible:Get.find<BaseController>().progress.any((v)=>v['song_Id']==Get.find<BaseController>().playListSongData[index]['song_id']),
                                         //           replacement: !Get.find<BaseController>().isDownload(
                                         //               songId:Get.find<BaseController>().playListSongData[index]['song_id'])
                                         //               ? InkWell(
                                         //             onTap: () async {
                                         //               DownloadService.instance.downloadSong(
                                         //                 downloadSongUrl:
                                         //                 Get.find<MyLibraryController>().playListSongDataModel?.data?[index].song ?? "",
                                         //                 SongData: Get.find<MyLibraryController>().playListSongDataModel?.data?[index],
                                         //               );
                                         //             },
                                         //             child: Icon(
                                         //               Icons.download, // Minus symbol
                                         //               color: AppColors.white, // Black minus sign
                                         //               size: 30.r,
                                         //               weight: 15, // Adjust size as needed
                                         //             ),
                                         //           )
                                         //               : const SizedBox.shrink(),
                                         //           child: Text(
                                         //               Get.find<BaseController>().progress.any((v)=>v['song_Id']==Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId)?  Get.find<BaseController>().progress.firstWhere((v)=>v['song_Id']==Get.find<MyLibraryController>().playListSongDataModel?.data?[index].songId)['progress'].toString()+"%":'' )
                                         //       );
                                         //     }
                                         // ),
                                         10.horizontalSpace,
                                         InkWell(
                                           onTap: () {
                                             // print(Get.find<MyLibraryController>().playListSongDataModel?.data?[index].playListId);
                                             // Get.dialog(OptionDialog(listOfTrackData:  Get.find<BaseController>().playListSongData as List<MixesTracksData> ??[],index: index,track: Get.find<BaseController>().playListSongData[index] as MixesTracksData,));
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
                                       PlayerService.instance
                                           .createPlaylist(Get.find<MyLibraryController>().playListSongDataModel?.data, index: index,type: 'song',id:Get.find<MyLibraryController>().databaseDownloadPlayListSongList[index]['song_id']);
                                     },
                                   ),
                                   const Divider(
                                     height: 1,
                                   ),
                                 ],
                               );
                             });
                       }),)
                    ],
                  );
                }
              ),
            ),
          ),
        ),
        Obx(()=>Visibility(
          visible: Get.find<BaseController>().isLoading.value,
            child: AppLoder())),
      ],
    );
  }
}
