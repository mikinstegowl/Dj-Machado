import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppButtonWidget extends StatelessWidget {
  const AppButtonWidget(
      {super.key,
        this.height,
        this.width,
        this.padding,
        this.child,
        required this.onPressed,
        required this.btnName,
        this.txtColor = AppColors.white,
        this.fontSize = 16,
        this.btnColor,
        this.margin,
        this.image,
        this.isEnable = true,
        this.fontWeight = FontWeight.w700,
        this.borderRadius = 0,
        this.borderColor = AppColors.transparent,
        this.borderWidth = 1.0,
        this.shape = BoxShape.rectangle,
        this.customBorderRadius});

  final double? height;
  final double? width;
  final double borderWidth;
  final Function() onPressed;
  final String btnName;
  final Color txtColor;
  final double fontSize;
  final Color? btnColor;
  final FontWeight fontWeight;
  final double borderRadius;
  final Color borderColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool isEnable;
  final Widget? child;
  final BoxShape shape;
  final BorderRadiusGeometry? customBorderRadius;
  final DecorationImage? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isEnable ? onPressed : () {},
      splashColor: AppColors.transparent,
      child: Container(
          height: height?.h,
          width: width?.w,
          padding: padding,
          // ?? EdgeInsets.symmetric(vertical: 10.r),
          margin: margin,
          decoration: BoxDecoration(
              image: image,
              shape: shape,
              color: btnColor,
              border: Border.all(color: borderColor, width: borderWidth),
              borderRadius:
              customBorderRadius ?? BorderRadius.circular(borderRadius.r)),
          child: Center(
            child: child ??
                AppTextWidget(
                  maxLine: 3,
                  textAlign: TextAlign.center,
                  txtTitle: btnName,
                  fontSize: fontSize,
                  txtColor: txtColor,
                  fontWeight: fontWeight,
                ),
          )),
    );
  }
}
