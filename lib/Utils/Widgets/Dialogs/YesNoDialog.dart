import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';



class YesNoDialog extends StatelessWidget {
  final Function() onYesCalled;
  final String message;
  const YesNoDialog({super.key, required this.onYesCalled, required this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      content: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        child: Center(
          child: Padding(
            padding:  EdgeInsets.all(16.0.r),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image or Icon
                SizedBox(
                  width: 150.w,
                  height:200.h,
                  child: Image.asset(
                    AppAssets.logo, // Replace with your image URL
                    fit: BoxFit.cover,
                  ),
                ),
                20.verticalSpace,
                // Message
                AppTextWidget(
                  txtTitle: message,
                  txtColor: AppColors.white,
                  fontSize: 16,
                  textAlign: TextAlign.center,
                ),
                20.verticalSpace,
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        ),
                        onPressed: onYesCalled,
                        child: const AppTextWidget(txtTitle: "YES", txtColor: AppColors.white)),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black,
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                        ),
                        onPressed: () {
                          // Handle No action
                          Get.back(); // Close the dialog
                        },
                        child: const AppTextWidget(txtTitle: "NO", txtColor: AppColors.white)),

                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );;
  }
}
