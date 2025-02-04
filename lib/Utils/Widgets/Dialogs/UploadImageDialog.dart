import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class UploadImageDialog extends StatelessWidget {
  const UploadImageDialog({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(BaseController());
    return AlertDialog.adaptive(
      backgroundColor: AppColors.black,
      title: const Center(
        child: AppTextWidget(
          txtColor: AppColors.white,
          txtTitle: 'Select the Action',
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: EdgeInsets.zero,
      actions: [
        Column(
          children: [
            AppButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              onPressed: () async {
                await Get.find<ProfileController>().getFile();
                Get.back();
              },
              btnName: "Select Photo From Gallery",
              txtColor: AppColors.white,
            ),
            AppButtonWidget(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              onPressed: () async {
                await Get.find<ProfileController>().getCameraImage();
                Get.back();
              },
              btnName: "Capture Photo From Camera",
              txtColor: AppColors.white,
            ),
            AppButtonWidget(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                onPressed: () {
                  Get.back();
                },
                txtColor: AppColors.white,
                btnName: "Cancel"),
          ],
        ),
      ],
    );
  }
}