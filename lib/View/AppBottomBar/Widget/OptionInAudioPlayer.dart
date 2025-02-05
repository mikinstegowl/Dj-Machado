import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OptionInAudioPlayer extends StatelessWidget {
  final IconData? icons;
  final String? title;
  final int? count;
  final Color? color;
  const OptionInAudioPlayer({super.key, this.icons, this.title, this.count, this.color});

  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height: 90.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
           Icon(
             size: 35.r,
            icons??Icons.cloud_outlined,
            color: color??AppColors.white,
          ),
           5.verticalSpace,
           AppTextWidget(
            txtTitle:
            title??'Download',fontSize: 13,),
          5.verticalSpace,
          AppTextWidget(
            txtColor: AppColors.white,
              fontSize: 14,
              txtTitle:
            ( count ?? Get.find<HomeController>()
                  .songDetailDataModel
                  ?.data?[0]
                  .totalDownloads
                  .toString()).toString()),
        ],
      ),
    );
  }
}
