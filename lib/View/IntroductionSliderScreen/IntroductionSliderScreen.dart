import 'package:carousel_slider/carousel_slider.dart';
import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class IntroductionSliderScreen extends StatefulWidget {
  const IntroductionSliderScreen({super.key});

  @override
  State<IntroductionSliderScreen> createState() => _IntroductionSliderScreenState();
}

class _IntroductionSliderScreenState extends State<IntroductionSliderScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: GetBuilder<AuthController>(
            init: Get.find<AuthController>()..introductionSlider(),
            builder: (controller) {
              return controller.introductionDataModel?.data?.isNotEmpty ??
                  false
                  ? Stack(
                children: [
                  Container(
                    constraints: const BoxConstraints.expand(),
                    width: double.maxFinite,
                    color: AppColors.black,
                    height: MediaQuery.sizeOf(context).height,
                    child: CarouselSlider(
                        carouselController: controller.carouselController,
                        options: CarouselOptions(
                            onPageChanged: (index, _) {
                              print(index);
                              index = controller.pageIndex.value;
                            },
                            aspectRatio: 0.4,
                            enableInfiniteScroll: false,
                            enlargeCenterPage: false,
                            viewportFraction: 1),
                        items: controller.introductionDataModel?.data
                            ?.map((e) => CachedNetworkImageWidget(
                          width:
                          MediaQuery.of(context).size.width,
                          fit: BoxFit.cover,
                          image: e.sliderIamge,
                        ))
                            .toList()

                      // },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: Align(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: AppButtonWidget(
                        width: 150.w,
                        height: 50.h,
                        onPressed: () {
                          print(controller.introductionDataModel?.data
                              ?.length ==
                              controller.pageIndex.value);
                          print(controller.introductionDataModel?.data
                              ?.length);
                          print(controller.pageIndex.value);
                          if (controller.introductionDataModel?.data
                              ?.length ==
                              (controller.pageIndex.value + 1)) {
                            UserPreference.setValue(
                                key: PrefKeys.firstTime, value: false);
                            Get.offAllNamed(RoutesName.logInScreen);
                          } else {
                            controller.carouselController.nextPage();
                          }
                        },
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        btnName: controller.introductionDataModel?.data
                            ?.length ==
                            (controller.pageIndex.value + 1)
                            ? 'ENTER'
                            : "NEXT",
                        btnColor: AppColors.primary,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10.w,
                    top: 10.h,
                    child: InkWell(
                      onTap: () {
                        Get.offAllNamed(RoutesName.logInScreen);
                      },
                      child: const Row(
                        children: [
                          AppTextWidget(
                            txtTitle: "SKIP INTRO",
                            txtColor: AppColors.white,
                          ),
                          Icon(
                            Icons.navigate_next,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
                  : AppLoder();
            }),
      ),
    );
  }
}
