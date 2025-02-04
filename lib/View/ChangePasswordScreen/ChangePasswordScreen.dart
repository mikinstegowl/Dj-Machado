import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/Validators.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/ChangePasswordScreen/Widget/ChangePasswordTextFormFiled.dart';
import 'package:newmusicappmachado/View/ViewProfileScreen/Widgets/ProfileTextFormFiled.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChangePasswordScreen extends GetView<ProfileController> {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkgrey,
        appBar: const CommonAppBar(title: 'Change Password',),
        extendBodyBehindAppBar: true,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+70.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppAssets.backGroundImage))
          ),
          child: Form(
            key: controller.changeFormKey,
            child: Column(
              children: [
                ChangePasswordTextFormFiled(
                  keyboardType: TextInputType.text,
                  validator: (value) => isRequiredField(value: value),
                  isPassword:true,
                  controller: controller.currentPasswordController,
                  textFiledName: 'Enter your current password',
                  readOnly: false,
                ),ChangePasswordTextFormFiled(
                  keyboardType: TextInputType.text,
                  isPassword:true,
                  controller: controller.newPasswordController,
                  validator: (value)=>validatePassword(value),
                  textFiledName: 'Enter your new password',
                  readOnly: false,
                ),ChangePasswordTextFormFiled(
                  keyboardType: TextInputType.text,
                  isPassword:true,
                  controller: controller.confirmNewPasswordController,
                  validator: (value)=>validateConfirmPassword(value,controller.newPasswordController.text),
                  textFiledName: 'Confirm your new password',
                  readOnly: false,
                ),
                50.verticalSpace,
                Center(
                  child: AppButtonWidget(
                    onPressed: ()async {
                      if(controller.changeFormKey.currentState?.validate()??false){
                    await controller.changePasswordApi();}
                    },
                    btnName: '',
                    borderRadius: 25.5,
                    padding: EdgeInsets.symmetric(
                        vertical: 15.h, horizontal: 25.w),
                    image: const DecorationImage(
                        colorFilter: ColorFilter.mode(
                          AppColors
                              .primary, // Change this to the desired color
                          BlendMode.srcATop,
                        ),
                        image: AssetImage(
                          AppAssets.buttonBackgroundImage,
                        )),
                    child: const AppTextWidget(
                      txtTitle: "Submit",
                      txtColor: AppColors.black,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
