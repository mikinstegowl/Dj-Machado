import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SelectGenresScreen extends GetView<HomeController> {
  const SelectGenresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.darkgrey,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          appBar: CommonAppBar(
            showLogo: true,
            searchBarShow: false,
            title: 'Set Your Best Genres'.toUpperCase(),
          ),
          extendBodyBehindAppBar: true,
          body: Container(
            height: MediaQuery.sizeOf(context).height,
            // padding: EdgeInsets.only(top:AppBar().preferredSize.height.h),
            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(AppAssets.backGroundImage))),
            child: GetBuilder<HomeController>(
                init: controller,
                builder: (context) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      controller.genresModel?.data?.isNotEmpty ?? false
                          ? ListView.builder(
                              shrinkWrap: true,
                              physics: const ClampingScrollPhysics(),
                              itemCount: controller.genresModel?.data?.length,
                              itemBuilder: (context, index) {
                                print(controller.genresSelectedCheck);
                                return ListTile(
                                  onTap: () {
                                    controller.checked(
                                        id: controller.genresModel?.data?[index]
                                            .genresId);
                                  },
                                  leading: Transform.scale(
                                    scale: 1.35,
                                    child: Checkbox.adaptive(
                                      value: controller.genresSelectedCheck
                                          .contains(controller.genresModel
                                              ?.data?[index].genresId),
                                      checkColor: AppColors.black,
                                      activeColor: AppColors.primary,
                                      onChanged: (value) {
                                        controller.checked(
                                            id: controller.genresModel
                                                ?.data?[index].genresId);
                                      },
                                      shape: OvalBorder(),
                                    ),
                                  ),
                                  title: AppTextWidget(
                                      txtTitle: controller.genresModel
                                              ?.data?[index].genresName ??
                                          ''),
                                );
                              },
                            )
                          : const Center(
                              child: AppTextWidget(
                                txtTitle: "No Data Found !!",
                                txtColor: AppColors.white,
                              ),
                            ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AppButtonWidget(
                            onPressed: () async {
                              await controller.saveGenres();
                            },
                            btnName: 'Save'.toUpperCase(),
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            txtColor: AppColors.black,
                            image: const DecorationImage(
                                colorFilter: ColorFilter.mode(
                                  AppColors
                                      .primary, // Change this to the desired color
                                  BlendMode.srcATop,
                                ),
                                image: AssetImage(
                                  AppAssets.buttonBackgroundImage,
                                )),
                            padding: EdgeInsets.symmetric(
                                vertical: 10.h, horizontal: 25.w),
                            // btnColor: AppColors.primary,
                          ),
                          30.horizontalSpace,
                          UserPreference.getValue(key: PrefKeys.userId) != null
                              ? AppButtonWidget(
                                  onPressed: () async {
                                    Get.back();
                                  },
                                  btnName: 'Cancel'.toUpperCase(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  txtColor: AppColors.black,
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        AppColors
                                            .primary, // Change this to the desired color
                                        BlendMode.srcATop,
                                      ),
                                      image: AssetImage(
                                        AppAssets.buttonBackgroundImage,
                                      )),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 25.w),
                                  // btnColor: AppColors.primary,
                                )
                              : AppButtonWidget(
                                  onPressed: () async {
                                    Get.toNamed(RoutesName.homeScreen);
                                  },
                                  btnName: 'Not now later'.toUpperCase(),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  txtColor: AppColors.black,
                                  image: const DecorationImage(
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        AppColors
                                            .primary, // Change this to the desired color
                                        BlendMode.srcATop,
                                      ),
                                      image: AssetImage(
                                        AppAssets.buttonBackgroundImage,
                                      )),
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4.h, horizontal: 25.w),
                                  // btnColor: AppColors.primary,
                                ),
                        ],
                      )
                    ],
                  );
                }),
          ),
        ),
        Obx(() =>
            Visibility(visible: Get.find<HomeController>().isLoading.value, child: AppLoder()))
      ],
    ));
  }
}
