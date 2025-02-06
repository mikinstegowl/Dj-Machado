import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MixesScreen extends GetView<MixesController> {
  const MixesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(bottomNavigationBar: BottomBarWidget(mainScreen: false,routeName: 'Mixes',indx: 2,),
            extendBodyBehindAppBar: true,
            bottomSheet: AudioPlayerController(),
            // bottomSheet: AudioPlayerController(),
            appBar: const CommonAppBar(title: "Mixes",showBack: false,),
            body: GetBuilder<MixesController>(
              id: 'mixes',
                init: controller..mixesApi(),
                builder: (controller) {
                  return Container(
                    height: MediaQuery.sizeOf(context).height,
                    padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+30.h),
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(AppAssets.backGroundImage))
                    ),
                    child: Column(
                      children: [
                        controller.mixesDataModel?.data?.isNotEmpty ?? false
                            ? Expanded(
                                child: ListView.builder(
                                  controller: controller.scrollController,
                                  padding: EdgeInsets.zero,
                                    itemCount: controller.mixesDataModel?.data?.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap: () async {
                                          await controller
                                              .mixesSubCategoryAndTracksApi(
                                                  mixesId: controller.mixesDataModel
                                                      ?.data?[index].mixesId)
                                              .then((_) {
                                            Get.toNamed(RoutesName.mixesSongScreen,
                                                arguments: {
                                                  'title': controller.mixesDataModel
                                                      ?.data?[index].mixesName
                                                });
                                          });
                                        },
                                        child: Container(
                                          margin: EdgeInsets.only(
                                              top: 10.h, left: 5.w, right: 5.w,bottom: 20.h),
                                          height: 200.h,
                                          width: double.maxFinite,
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: BoxDecoration(
                                              color: AppColors.error,
                                              borderRadius:
                                                  BorderRadius.circular(20.r)),
                                          child: CachedNetworkImageWidget(
                                              image: controller.mixesDataModel
                                                  ?.data?[index].originalImage),
                                        ),
                                      );
                                    }),
                              )
                            : const Expanded(
                                child: Center(
                                    child: AppTextWidget(txtTitle: "No Data Found!!")),
                              ),

                      ],
                    ),
                  );
                }),
          ),
        ),
        Obx(()=> Visibility(
            visible: Get.find<MixesController>().isLoading.value,
            child: AppLoder())),
      ],
    );
  }
}
