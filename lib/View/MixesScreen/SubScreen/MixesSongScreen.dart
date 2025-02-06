import 'dart:io';

import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/MixesScreen/MixesScreen.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsWidget/SongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class MixesSongScreen extends StatefulWidget {
  const MixesSongScreen({super.key});

  @override
  State<MixesSongScreen> createState() => _MixesSongScreenState();
}

class _MixesSongScreenState extends State<MixesSongScreen> {
  String? title='';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>());
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if( Get.arguments!=null&& Get.arguments!=''){
        setState(() {
          title=Get.arguments['title'] ?? '';

        });
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    print( Get.find<MixesController>().mixesTracksDataModel?.mostPlayed);
    return Stack(
      children: [
        Obx(()=> Visibility(
          visible: Get.find<BaseController>().isLoading.value,
            child: AppLoder())),
        SafeArea(
          child: Stack(
            children: [
              Scaffold(
                bottomSheet: const AudioPlayerController(),
                bottomNavigationBar: const BottomBarWidget(
                  mainScreen: false,
                ),
                appBar:CommonAppBar(title: title??'',searchBarShow: true,),
                extendBodyBehindAppBar: true,
                backgroundColor: AppColors.darkgrey,
                body: GetBuilder<BaseController>(
                  init: Get.find<BaseController>(),
                  builder: (bController) {
                    return Container(
                      height: MediaQuery.sizeOf(context).height,
                      padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+25.h),
                      decoration: const BoxDecoration(
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage(AppAssets.backGroundImage))
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Visibility(
                            visible:
                                Get.find<MixesController>().mixesTracksDataModel?.mostPlayed?.isNotEmpty ??
                                    false,
                            replacement: SizedBox.shrink(),
                            child: Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                              child: const AppTextWidget(txtTitle: "Most Played"),
                            ),
                          ),
                          Visibility(
                            replacement: SizedBox.shrink(),
                            visible:
                                 Get.find<MixesController>().mixesTracksDataModel?.mostPlayed?.isNotEmpty ??
                                    false,
                            child: SizedBox(
                              height: 210.h,
                              child: GridView.builder(
                                  padding: EdgeInsets.only(left: 10.w),
                                  itemCount:
                                       Get.find<MixesController>().mixesTracksDataModel?.mostPlayed?.length,
                                  scrollDirection: Axis.horizontal,
                                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: double.maxFinite,
                                      mainAxisExtent: 150.w,
                                      crossAxisSpacing: 10.h,
                                      mainAxisSpacing: 10.h),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        PlayerService.instance.createPlaylist(
                                             Get.find<MixesController>()..mixesTracksDataModel?.mostPlayed,
                                           index:  index,id: Get.find<MixesController>().mixesTracksDataModel
                                            ?.mostPlayed?[index].songId);
                                      },
                                      child: Container(
                                        color: AppColors.black,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            CachedNetworkImageWidget(
                                              image:  Get.find<MixesController>().mixesTracksDataModel
                                                  ?.mostPlayed?[index].originalImage,
                                              height: 165.h,
                                              width: double.maxFinite,
                                              fit: BoxFit.cover,
                                            ),
                                            const Spacer(),
                                            Container(
                                              color: AppColors.grey,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10.w, vertical: 5.h),
                                              width: double.maxFinite,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  AppTextWidget(
                                                    txtTitle:  Get.find<MixesController>()
                                                            .mixesTracksDataModel
                                                            ?.mostPlayed?[index]
                                                            .songName ??
                                                        '',
                                                    fontSize: 11,
                                                  ),
                                                  AppTextWidget(
                                                    txtTitle:  Get.find<MixesController>()
                                                            .mixesTracksDataModel
                                                            ?.mostPlayed?[index]
                                                            .songArtist ??
                                                        '',
                                                    txtColor: AppColors.primary,
                                                    fontSize: 11,
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                         CommonAdWidget(),
                          Expanded(
                              child: SongsWidget(
                            addDownload: false,

                            tracksDataModel:  Get.find<MixesController>().mixesTracksDataModel!,
                          ))
                        ],
                      ),
                    );
                  }
                ),
              ),
              Obx(() => Visibility(
                  visible:  Get.find<MixesController>().isLoading.value, child: AppLoder()))
            ],
          ),
        ),
      ],
    );
  }
}
