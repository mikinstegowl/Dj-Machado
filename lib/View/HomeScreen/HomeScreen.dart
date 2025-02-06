import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/SkipUserDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/DataView.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeSongListingWidgets.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrendingWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'Widgets/HomeRadioWidget.dart';
import 'Widgets/HomeTrackWidget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        bottomSheet: AudioPlayerController(),
        bottomNavigationBar: BottomBarWidget(
          routeName: 'Home',
          indx: 0,
          mainScreen: false,
        ),
        backgroundColor: AppColors.darkgrey,
        appBar: CommonAppBar(
          showLogo: true,
          showTitle: false,
          title: "this",
          isHome: true,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 25.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: Stack(
            children: [
              GetBuilder<HomeController>(
                  init: Get.find<BaseController>().connectivityResult !=
                          ConnectivityResult.none
                      ? (Get.find<HomeController>()..homeDataApi())
                      : null,
                  builder: (controller) {
                    return Visibility(
                      visible: Get.find<HomeController>().isLoading.value,
                      replacement: SingleChildScrollView(
                        controller: Get.find<HomeController>().scrollController,
                        child: Column(
                          children: [
                            controller.homeDataModel?.recentPlayed
                                        ?.isNotEmpty ??
                                    false
                                ? 20.verticalSpace
                                : 0.verticalSpace,
                            if (controller
                                    .homeDataModel?.recentPlayed?.isNotEmpty ??
                                false)
                              HomeSongListingWidgets(
                                categoryTitle: "Recent Played",
                                data: controller.homeDataModel?.recentPlayed,
                              ),
                            controller.homeDataModel?.firstTrendingsData
                                        ?.isNotEmpty ??
                                    false
                                ? 20.verticalSpace
                                : 0.verticalSpace,
                            if (controller.homeDataModel?.firstTrendingsData
                                    ?.isNotEmpty ??
                                false)
                              HomeTrendingWidgets(
                                firstTrendingData: controller
                                    .homeDataModel?.firstTrendingsData,
                              ),
                            controller.homeDataModel?.firstTrendingsData
                                        ?.isNotEmpty ??
                                    false
                                ? 20.verticalSpace
                                : 0.verticalSpace,
                            if (!UserPreference.getValue(
                                key: PrefKeys.skipUser))
                              HomeSongListingWidgets(
                                categoryTitle: "Recommended",
                                data:
                                    controller.homeDataModel?.recommendedTracks,
                              ),
                            20.verticalSpace,
                            HomeSongListingWidgets(
                              categoryTitle: "Most Played",
                              data: controller.homeDataModel?.mostPlayed,
                            ),
                            controller.homeDataModel?.data?.isNotEmpty ?? false
                                ? 20.verticalSpace
                                : 0.verticalSpace,
                            controller.homeDataModel?.data?.isNotEmpty ?? false
                                ? HomeTrendingWidgets(
                                    firstTrendingData:
                                        controller.homeDataModel?.data,
                                  )
                                : const SizedBox.shrink(),
                            50.verticalSpace,
                          ],
                        ),
                      ),
                      child: const AppLoder(),
                    );
                  }),
              Obx(() => Visibility(
                  visible: Get.find<HomeController>().isLoading.value,
                  child: AppLoder())),
            ],
          ),
        ),
      ),
    );
  }
}
