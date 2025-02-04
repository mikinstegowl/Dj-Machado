import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppTextWidget extends StatelessWidget {
  const AppTextWidget(
      {Key? key,
      required this.txtTitle,
      this.txtColor = AppColors.white,
      this.fontWeight = FontWeight.w400,
      this.fontStyle = FontStyle.normal,
      this.fontSize = 18,
      this.maxLine = 10,
      this.textAlign = TextAlign.left,
      this.overflow = TextOverflow.ellipsis,
      this.decoration = TextDecoration.none,
      this.fontFamily,
      this.letterSpacing})
      : super(key: key);

  final String txtTitle;
  final Color txtColor;
  final FontWeight fontWeight;

  // String fontFamily = AppTheme.robotoRegular,
  final FontStyle fontStyle;
  final double fontSize;
  final int maxLine;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final TextDecoration decoration;
  final String? fontFamily;
  final double? letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Text(
      txtTitle.tr,
      maxLines: maxLine,
      style: TextStyle(
        letterSpacing: letterSpacing,
        color: txtColor,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize.sp,
        decoration: decoration,
        decorationColor: AppColors.white,
        decorationThickness: 2,
        fontFamily: fontFamily,
      ),
      overflow: overflow,
      textAlign: textAlign,
    );
  }
}
