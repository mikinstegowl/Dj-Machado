import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
///Custom SnackBar
class Utility {
  static void showSnackBar(String? msg, {bool isError = false}) {
    Get.showSnackbar(
      GetSnackBar(
        maxWidth: 600.w,
        messageText: AppTextWidget(
            txtTitle: msg ?? '',
            fontWeight: FontWeight.w400,
            fontSize: 14,
            maxLine: 3,
            txtColor: AppColors.white),
        borderRadius: 10,
        duration: const Duration(milliseconds: 2500),
        margin: const EdgeInsets.all(6),
        dismissDirection: DismissDirection.horizontal,
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        backgroundColor: Color(isError ? 0xffF72A1E : 0xff5BDF6F),
      ),
    );
  }
}
