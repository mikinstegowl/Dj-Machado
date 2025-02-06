import 'dart:io';

import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class OfflineAlbumDetailScreen extends GetView<BaseController> {
  final int? albumId;
  const OfflineAlbumDetailScreen({super.key, this.albumId,});

  @override
  Widget build(BuildContext context) {
    print(Get.arguments);
    return GetBuilder<BaseController>(
      // init: controller..googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>()),
      builder: (controller) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          bottomSheet: AudioPlayerController(),
          backgroundColor: AppColors.darkgrey,
          bottomNavigationBar: const BottomBarWidget(
            mainScreen: false,
          ),
          appBar:
              CommonAppBar(
                title: Get.arguments['songList']['album_name'] ?? '',
              ),
          body:
          Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+45.h),

            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backGroundImage))
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      child: CachedNetworkImageWidget(
                        height: double.maxFinite,
                        image: Get.arguments['songList']['imageUrl']?? '',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                20.verticalSpace,
                Container(
                  decoration: const BoxDecoration(
                    color: AppColors.black,
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.grey,
                        width: 2
                      )
                    )
                  ),
                  padding: EdgeInsets.only(
                      right: 15.w, top: 10.h, bottom: 10.h, left: 20.w),
                  child: const Column(
                    children: [
                      Icon(
                        Icons.check
                            ,
                        color: AppColors.white,
                      ),
                      AppTextWidget(
                        txtTitle:  "Album Downloaded",
                        fontSize: 14,
                      )
                    ],
                  ),
                ),
                CommonAdWidget(),
            10.verticalSpace,
            Expanded(
              child:
              Obx(()=> ListView.builder(
                padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: Get.find<BaseController>().songData.length,
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
                              image: Get.find<BaseController>().songData[index]['imageUrl'],
                              width: 50.h,
                              height: 50.h,
                              fit: Platform.isAndroid
                                  ? BoxFit.cover
                                  : BoxFit.contain,
                            ),
                          ),
                          title: AppTextWidget(
                            txtTitle: Get.find<BaseController>().songData[index]['song_name'],
                            fontSize: 12,
                            txtColor: AppColors.white,
                          ),
                          subtitle: AppTextWidget(
                            txtTitle: Get.find<BaseController>().songData[index]['artist_name'],
                            fontSize: 12,
                            txtColor: AppColors.primary,
                          ),
                          trailing: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Center(
                                child:

                                GetBuilder<BaseController>(
                                    init: Get.find<BaseController>(),
                                    builder: (controller) {
                                      return Visibility(
                                          visible: Get.find<BaseController>().progress.any(
                                                  (v) => v['song_Id'] == Get.find<BaseController>().databaseDownloadedSongList[index]['song_id']),
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
                                                  Get.find<BaseController>().deleteList(index: Get.find<BaseController>().songData[index]['song_id'],albumId: Get.arguments['album_id'],path: Get.find<BaseController>().songData[index]['file_path']);
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

                              // 10.horizontalSpace,
                              // InkWell(
                              //   onTap: () {
                              //
                              //   },
                              //   child: Icon(
                              //     weight: 15,
                              //     Icons.more_vert,
                              //     color: AppColors.white,
                              //     size: 30.r,
                              //   ),
                              // ),
                              10.horizontalSpace,
                            ],
                          ),
                          onTap: () {
                            PlayerService.instance
                                .createPlaylist(Get.find<BaseController>().databaseDownloadedSongList, index: index,type: 'offline',id: Get.find<BaseController>().databaseDownloadedSongList[index]['song_id']);
                          },
                        ),
                        const Divider(
                          height: 1,
                        ),
                      ],
                    );
                  }),)
            ),
              ],
            ),
          ),
        );
      }
    );
  }
}
