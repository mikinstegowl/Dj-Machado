import 'dart:ui';

import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

/*
Changes : Interchanged suffix icon and suffix widget
 */
class AppTextFormField extends StatefulWidget {
  const AppTextFormField(
      {Key? key,
      this.onChanged,
      this.hintTextColor = AppColors.white,
      this.maxLine = 1,
      this.label,
      required this.hintText,
      this.txtAlign = TextAlign.start,
      this.obscureText = false,
      this.suffixWidget,
      this.controller,
      this.focusNode,
        this.isPassword = false,
      this.sideButton,
      this.validator,
      this.suffixStyle,
      this.suffixIcon,
      this.autoFocus = false,
      this.textInputAction = TextInputAction.go,
      this.textCapitalization = TextCapitalization.words,
      this.onEditingComplete,
      this.onFieldSubmitted,
      this.autoCorrect = false,
      this.isFilled,
      this.errorTxt,
      this.inputFormatters,
      this.keyboardType,
      this.fontSize = 12,
      this.fontWeight = FontWeight.w500,
      this.cursorColor,
      this.borderRadious,
      this.prefixIcon,
      this.expands = false,
      this.fillColor = AppColors.white,
      this.borderWidth = 1.0,
      this.borderStyle = BorderStyle.solid,
      this.readOnly = false,
      this.maxLength,
      this.contentPadding,
      this.isValid,
      this.textColor = AppColors.white,
      this.border,
      this.enabledBorder,
      this.focusedBorder,
      this.onTap,
      this.borderColor,
      this.ontapOutside,
        this.showIcons=true,
      this.hintTextSize = 14,})
      : super(key: key);

  final Function(dynamic val)? onChanged;
  final String hintText;
  final bool showIcons;
  final double hintTextSize;
  final TextInputType? keyboardType;
  final Function()? onEditingComplete;
  final Function()? onTap;
  final bool isPassword;
  final Function(String val)? onFieldSubmitted;
  final Function(PointerDownEvent val)? ontapOutside;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign txtAlign;
  final bool obscureText;
  final bool autoCorrect;
  final String? label;
  final bool expands;
  final bool autoFocus;
  final bool? isFilled;
  final Widget? suffixWidget;
  final Widget? suffixIcon;
  final String? errorTxt;
  final TextStyle? suffixStyle;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? sideButton;
  final String? Function(String?)? validator;
  final double fontSize;
  final int? maxLength;
  final FontWeight fontWeight;
  final Color? cursorColor;
  final Color? hintTextColor;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Color fillColor;
  final double borderWidth;
  final Color? borderColor;
  final BorderStyle borderStyle;
  final bool readOnly;
  final Color textColor;
  final EdgeInsets? contentPadding;
  final bool? isValid;
  final int? maxLine;
  final InputBorder? border;
  final InputBorder? enabledBorder;
  final InputBorder? focusedBorder;
  final double? borderRadious;

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField>with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  String? _errorMessage;
  bool showPassword = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Smooth animation
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String? _validate(String? value) {
    String? errorMessage = widget.validator != null?widget.validator!(value):''; // Get the error message from the validator

    // Use addPostFrameCallback to avoid calling setState during the build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _errorMessage = errorMessage; // Update the error message
        if (_errorMessage != null && (_errorMessage?.isNotEmpty??false)) {
          _animationController.forward(); // Show error animation
        } else {
          _animationController.reverse(); // Hide error animation
        }
      });
    });

    return null; // Prevent default error message rendering
  }

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          height: 45.h,
          child: Row(crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex:4,
                child: TextFormField(
                  onTap: widget.onTap,
                  expands: widget.expands,
                  textAlign: widget.txtAlign,
                  enabled: !widget.readOnly,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  obscureText: widget.obscureText?showPassword: false,
                  focusNode: widget.focusNode,
                  autofocus: widget.autoFocus,
                  cursorColor: widget.cursorColor,
                  maxLength: widget.maxLength,
                  maxLines: widget.maxLine,
                  style: TextStyle(
                      color: widget.textColor,
                      fontSize: widget.fontSize.sp,
                      fontWeight: widget.fontWeight,
                      overflow: TextOverflow.ellipsis),
                  textInputAction: widget.textInputAction,
                  textCapitalization: widget.textCapitalization,
                  readOnly: widget.readOnly,
                  cursorHeight: 25.sp,
                  decoration: InputDecoration(
                    constraints: BoxConstraints(minHeight: 35.h),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    counterText: "",
                    errorBorder: widget.border,
                    enabledBorder: widget.border ?? _getOutlineBorder(),
                    border: widget.border ?? _getOutlineBorder(),
                    focusedBorder: widget.border ?? _getOutlineBorder(),
                    // errorStyle: TextStyle(
                    //   decorationStyle: TextDecorationStyle.double,
                    //   fontWeight: FontWeight.w600,
                    //   fontSize: 12.sp,
                    //   height: 0.1,
                    //
                    // ),
                    prefixIcon: widget.isValid != null
                        ? (widget.isValid!
                            ? const Icon(
                                Icons.check,
                                color: AppColors.success,
                              )
                            : const Icon(
                                Icons.close,
                                color: AppColors.error,
                              ))
                        : widget.prefixIcon,
                    contentPadding:
                        widget.contentPadding ?? EdgeInsets.only(top: 0, bottom: 15.h, left: 20.w,right:15.w),
                
                    // isDense: true,
                    // errorText: widget.errorTxt,
                    icon: widget.sideButton,
                    suffix: widget.suffixWidget,
                    // previously it was suffixIcon
                    suffixIcon: widget.suffixIcon,
                    // previously it was suffixWidget
                    suffixStyle: widget.suffixStyle,
                    filled: true,
                    alignLabelWithHint: true,
                    hintText: widget.hintText.tr,
                    // label: AppTextWidget(
                    //   txtTitle: label ?? hintText,
                    //   fontSize: 12,
                    //   txtColor: hintTextColor ?? AppColors.hintText,
                    // ),
                    // floatingLabelAlignment: FloatingLabelAlignment.start,
                    // floatingLabelBehavior: FloatingLabelBehavior.auto,
                    // hintText: hintText,
                    hintStyle: TextStyle(
                        color: widget.hintTextColor ?? AppColors.black,
                        fontSize: widget.hintTextSize,
                        fontWeight: FontWeight.w400),
                    fillColor: widget.fillColor,
                  ),
                  onChanged: widget.onChanged,
                  onEditingComplete: widget.onEditingComplete,
                  onFieldSubmitted: widget.onFieldSubmitted,
                  autocorrect: widget.autoCorrect,
                  validator:_validate,
                  inputFormatters: widget.inputFormatters,
                  onTapOutside: widget.ontapOutside ??
                      (value) {
                        FocusScope.of(context).unfocus();
                      },
                ),
              ),
              widget.showIcons?
              widget.isPassword
                  ? Flexible(
                child: Center(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showPassword = !showPassword;
                      });
                    },
                    child: Transform.flip(
                      flipY: true,
                      child: Icon(
                        showPassword
                            ? Icons.visibility_off
                            : Icons.remove_red_eye,
                        color: AppColors.darkgrey,
                        size: 30.r,
                      ),
                    ),
                  ),
                ),
              )
                  : Flexible(
                  child: Center(
                      child: SvgPicture.asset(
                        AppAssets.editIcon,
                        color: AppColors.white,
                        height: 25.h,
                        width: 25.h,
                      ))):SizedBox.shrink()
            ],
          ),
        ),

        _errorMessage != null?SizeTransition(
            sizeFactor: _sizeAnimation,
            axisAlignment: -1.0,
            child:Row(
              children: [
                Icon(Icons.error, color: Colors.red, size: 20.r),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    _errorMessage??'',
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ],
            )

        ):SizedBox.shrink(),
        _errorMessage !=null?5.verticalSpace:0.verticalSpace
      ],
    );
  }

  InputBorder _getOutlineBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(widget.borderRadious ?? 25.r),
        borderSide: BorderSide(
            style: widget.borderStyle,
            color: widget.borderColor ?? widget.fillColor,
            width: widget.borderWidth));
  }

  InputBorder _getOutlineFocuseBorder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide(
            style: widget.borderStyle,
            color: widget.borderColor ?? AppColors.black.withOpacity(0.1),
            width: widget.borderWidth));
  }
}
