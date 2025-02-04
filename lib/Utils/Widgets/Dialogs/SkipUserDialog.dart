import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SkipUserDialog extends StatelessWidget {
  const SkipUserDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0.r),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Custom Icon or Image
          Container(
            margin: EdgeInsets.only(bottom: 20.h),
            child:  Image.asset(
              height: 200.h,
              width: 200.h,
              AppAssets.placeHolderImage,
            ),
          ),
          // Text Content
         const  Flexible(
            child:  AppTextWidget(
              txtTitle:  "Discover the best music and mixes of today's best artist.\nBecome a member of Apophis Music App!",
              textAlign: TextAlign.center,
              txtColor: AppColors.white,
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          20.verticalSpace,
          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              AppButtonWidget(onPressed: (){
                Get.offAllNamed(RoutesName.logInScreen);

              }, btnName: "Sign in",
                borderColor: AppColors.white,
                borderRadius: 10.r,
                padding: EdgeInsets.symmetric(horizontal: 30.h,vertical: 10.w),
              ),
              AppButtonWidget(onPressed: (){
                Get.back();

              }, btnName: "Cancel",
                borderColor: AppColors.white,
                borderRadius: 10.r,
                padding: EdgeInsets.symmetric(horizontal: 30.h,vertical: 10.w),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
