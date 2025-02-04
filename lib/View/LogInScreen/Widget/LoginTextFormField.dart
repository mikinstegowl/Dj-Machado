import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginTextFormField extends StatefulWidget {
  final TextEditingController? controller;
  final String textFiledName;
  final bool isPassword;
  final String? Function(String?)? validator;

  const LoginTextFormField(
      {super.key,
      this.controller,
      this.validator,
      this.isPassword = false,
      required this.textFiledName});

  @override
  State<LoginTextFormField> createState() => _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  bool showPassword = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: AppTextWidget(
            fontSize: 14,
            txtTitle: widget.textFiledName,
            // fontWeight: FontWeight.w700,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          width: double.maxFinite,
          color: AppColors.black,
          child: Container(
            alignment: Alignment.center,
            height: 70.h,
            padding: EdgeInsets.only(left: 10.w),
            child: AppTextFormField(
              expands: false,
              isPassword: widget.isPassword,
              maxLine: 1,
              controller: widget.controller,
              validator: widget.validator,
              isFilled: true,
              fontSize: 18,
              obscureText: widget.isPassword ? showPassword : false,
              fillColor: AppColors.newdarkgrey,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50.r),
              ),
              contentPadding: EdgeInsets.only(bottom: 25.h, left: 20.w),
              borderStyle: BorderStyle.solid,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50.r),
              ),
              hintText: '',
            ),
          ),
        ),
      ],
    );
  }
}
