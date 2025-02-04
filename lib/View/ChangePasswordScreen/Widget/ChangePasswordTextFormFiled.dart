import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChangePasswordTextFormFiled extends StatefulWidget {
  final TextEditingController? controller;
  final String textFiledName;
  final String? hintText;
  final bool isPassword;
  final Function(dynamic)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const ChangePasswordTextFormFiled(
      {super.key,
        this.controller,
        this.validator,
        this.isPassword = false,
        required this.textFiledName,
        this.onChanged,
        this.onTap,
        required this.readOnly,
        this.keyboardType,
        this.inputFormatters,
        this.hintText});

  @override
  State<ChangePasswordTextFormFiled> createState() => _ChangePasswordTextFormFiledState();
}

class _ChangePasswordTextFormFiledState extends State<ChangePasswordTextFormFiled> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: widget.textFiledName != '' ? null : 50,
        // margin: EdgeInsets.symmetric(vertical: 5.h),
        color: AppColors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.textFiledName != ''
                ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 40.w,vertical: 5.h),
              child: AppTextWidget(
                txtTitle: widget.textFiledName,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            )
                : SizedBox.shrink(),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              // padding:EdgeInsets.symmetric(horizontal: 20.w),
              width: double.maxFinite,
              color: AppColors.black,
              child: Container(
                alignment: Alignment.bottomLeft,
                height: 70.h,
                padding: EdgeInsets.only(left: 10.w),
                child: InkWell(
                  onTap: widget.onTap,
                  child: Center(
                    child: AppTextFormField(
                      prefixIcon: widget.hintText != null
                          ? Padding(
                          padding:
                          EdgeInsets.only(left: 10.w, top: 9.h),
                          child: AppTextWidget(
                            txtTitle: "${widget.hintText}: ",
                            fontSize: 12,
                          ))
                          : null,
                      controller: widget.controller,
                      onTap: widget.onTap,
                      onChanged: widget.onChanged,
                      expands: false,
                      maxLine: 1,
                      readOnly: widget.readOnly,
                      isFilled: true,
                      inputFormatters: widget.inputFormatters,
                      keyboardType: widget.keyboardType,
                      fontSize: 12,

                      validator: widget.validator,
                      obscureText: widget.isPassword ? showPassword : false,
                      fillColor: AppColors.newdarkgrey,
                      textColor: AppColors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      contentPadding: EdgeInsets.only(
                        bottom: 20.h,
                        left: 20.w,
                        right: 20.w
                      ),
                      isPassword: widget.isPassword,
                      borderStyle: BorderStyle.solid,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(50.r),
                      ),
                      hintText: '',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
