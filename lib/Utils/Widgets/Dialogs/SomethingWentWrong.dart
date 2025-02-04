import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SomethingWentWrongDialog extends StatelessWidget {
  const SomethingWentWrongDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(5.r)),
      actionsAlignment: MainAxisAlignment.center,
      backgroundColor: AppColors.primary,
      contentPadding: EdgeInsets.symmetric(horizontal: 20.h,vertical: 20.h),
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
        AppTextWidget(txtTitle: 'Something went wrong! Please try again.',fontSize: 16,txtColor: AppColors.black,),
        
      ],
      ),
      actionsPadding: EdgeInsets.only(top: 40.h,bottom: 30.h),
      actions: [
        AppButtonWidget(onPressed: (){
          Get.back();
        }, btnName: "Ok",padding: EdgeInsets.symmetric(horizontal: 50.w,vertical: 10.h),btnColor: AppColors.black,borderRadius: 5.r,)
      ],
    );
  }
}
