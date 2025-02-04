import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ViewAllRecentPlayedScreen extends StatelessWidget {
  const ViewAllRecentPlayedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.darkgrey,
        bottomSheet: AudioPlayerController(),
        bottomNavigationBar: BottomBarWidget(mainScreen: false,),
        appBar:CommonAppBar(title: 'Recent Played',),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+85.h),
      
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 10.0.w,vertical: 10.h),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  if (Get.find<BaseController>().isAdLoaded)
                    SizedBox(
                      height: 60.h,
                      width: double.maxFinite,
                      child: AdWidget(ad: Get.find<BaseController>().bannerAd),
                    ),
                  20.verticalSpace,
                  GridView.builder(
                    padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisExtent: 210.w,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount:
                      Get.find<HomeController>().homeDataModel?.recentPlayed?.length,
                      itemBuilder: (context,index){
                        return  MostPlayedSongsWidget(
                          onTap: () {
                            PlayerService.instance.createPlaylist(Get.find<HomeController>().homeDataModel?.recentPlayed, index,);
                          },
                          title: Get.find<HomeController>().homeDataModel?.recentPlayed?[index]
                              .songName,
                          image: Get.find<HomeController>().homeDataModel?.recentPlayed?[index]
                              .songImage,
                          subtitle: Get.find<HomeController>().homeDataModel?.recentPlayed?[index].songArtist,
                        );
                      })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
