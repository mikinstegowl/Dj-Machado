import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String textFiledName;
  final bool isPassword;
  final Function(dynamic)? onChanged;
  final Function()? onTap;
  final bool readOnly;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const SignUpTextFormField(
      {super.key,
      this.readOnly = false,
      this.onChanged,
      this.controller,
      this.inputFormatters,
      this.keyboardType,
      this.validator,
      this.onTap,
      this.isPassword = false,
      required this.textFiledName});

  @override
  State<SignUpTextFormField> createState() => _SignUpTextFormFieldState();
}

class _SignUpTextFormFieldState extends State<SignUpTextFormField> {


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: AppTextWidget(
            txtTitle: widget.textFiledName,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          width: double.maxFinite,
          color: AppColors.transparent,
          child: Container(
            alignment: Alignment.center,
            height: 65.h,
            padding: EdgeInsets.only(left: 10.w),

            child: InkWell(
              onTap: widget.onTap,
              child: AppTextFormField(
                isPassword: widget.isPassword,
                controller: widget.controller,
                onTap: widget.onTap,
                onChanged: widget.onChanged,
                expands: false,
                readOnly: widget.readOnly,
                isFilled: true,
                inputFormatters: widget.inputFormatters,
                keyboardType: widget.keyboardType,
                fontSize: 16,
                validator: widget.validator,
                obscureText: widget.isPassword,
                fillColor: AppColors.newdarkgrey,
                textColor: AppColors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.r),
                ),
                contentPadding: EdgeInsets.only(bottom: 20.h, left: 20.w,right: 10.w),
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
      ],
    );
  }
}
