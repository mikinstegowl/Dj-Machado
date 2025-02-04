import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BottomBarWidget extends GetView<BaseController> {
  final bool? mainScreen;

  const BottomBarWidget({
    this.mainScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() =>controller.containerHeight!<1 ? BottomNavigationBar(
          backgroundColor: AppColors.black,
          unselectedItemColor: AppColors.white,
          fixedColor: AppColors.primary,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.homeIcon,
                  height: 30.h,
                  width: 30.h,
                  color: Get.find<BaseController>().selectedIndex.value == 0
                      ? AppColors.primary
                      : AppColors.white,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.exploreIcon,
                  height: 30.h,
                  width: 30.h,
                  color: Get.find<BaseController>().selectedIndex.value == 1
                      ? AppColors.primary
                      : AppColors.white,
                ),
                label: 'Explore'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.mixesIcon,
                  height: 30.h,
                  width: 30.h,
                  color: Get.find<BaseController>().selectedIndex.value == 2
                      ? AppColors.primary
                      : AppColors.white,
                ),
                label: 'Mixes'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.artistsIcon,
                  height: 30.h,
                  width: 30.h,
                  color: Get.find<BaseController>().selectedIndex.value == 3
                      ? AppColors.primary
                      : AppColors.white,
                ),
                label: 'Artists'),
            BottomNavigationBarItem(
                icon: Image.asset(
                  AppAssets.libraryIcon,
                  color: Get.find<BaseController>().selectedIndex.value == 4
                      ? AppColors.primary
                      : AppColors.white,
                  height: 30.h,
                  width: 30.h,
                ),

                label: 'My library'),
          ],
          currentIndex: Get.find<BaseController>().selectedIndex.value,
          // Set the current
        onTap: (index) {
            print(Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none);
          Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none ?
          Utility.showSnackBar("You're in offline mode",isError: true)
              :  Get.find<BaseController>().onItemTapped(index);
          Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none
              ?null
              :
          Get.find<BaseController>().selectedIndex.value = index;
          Get.find<BaseController>().update();
        },// Handle item tap
        ):SizedBox.shrink());
  }
}
