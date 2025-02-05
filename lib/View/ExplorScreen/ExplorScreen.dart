import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/DataView.dart';
import 'package:newmusicappmachado/View/ExplorScreen/Widget/ExploreTrendingWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrendingWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExplorScreen extends GetView<ExplorController> {
  const ExplorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomSheet: AudioPlayerController(),
        bottomNavigationBar: BottomBarWidget(mainScreen: false),
        appBar: const CommonAppBar(
          title: "Explore",
          showBack: false,
        ),
        backgroundColor: AppColors.darkgrey,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 20.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: GetBuilder<ExplorController>(
              init: controller..explorScreenApi(),
              builder: (controller) {
                return Visibility(
                  visible: controller.isLoading.value,
                  replacement: SingleChildScrollView(
                    controller: controller.scrollController,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        controller.explorDataModel?.data?.isNotEmpty ?? false
                            ? ExploreTrendingWidgets(
                                firstTrendingData: controller
                                    .explorDataModel?.firstFlowactivotrendings,
                              )
                            : const SizedBox.shrink(),
                        controller.explorDataModel?.data?.isNotEmpty ?? false
                            ? ExploreTrendingWidgets(
                                firstTrendingData:
                                    controller.explorDataModel?.data,
                              )
                            : const Expanded(
                                child: Center(
                                    child: CircularProgressIndicator.adaptive(
                                  valueColor: AlwaysStoppedAnimation<Color?>(
                                      AppColors.primary),
                                )),
                              ),
                        50.verticalSpace,

                      ],
                    ),
                  ),
                  child: const AppLoder(),
                );
              }),
        ),
      ),
    );
  }
}
