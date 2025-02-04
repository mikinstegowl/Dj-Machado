import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/Validators.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/View/ChangePasswordScreen/Widget/ChangePasswordTextFormFiled.dart';
import 'package:newmusicappmachado/View/LogInScreen/Widget/LoginTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends GetView<AuthController> {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor:AppColors.darkgrey.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        leadingWidth: 75.w,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Icon(
                Icons.navigate_before,
                size: 28.r,
                color: AppColors.white,
              ),
              const AppTextWidget(
                fontWeight: FontWeight.w600,
                txtTitle: "Back",
                txtColor: AppColors.white,
                fontSize: 18,
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(bottom:AppBar().preferredSize.height.h),
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppAssets.backGroundImage))
        ),
        child: Form(
          key: controller.forgotFormKey,
          child: Column(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Image.asset(
                  AppAssets.logo,
                  height: 200.h,
                  width: 200.w,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.w),
                child: const AppTextWidget(
                  txtTitle:
                      "Please provide your registered Email ID where you want to get the temporary Password",
                  textAlign: TextAlign.center,
                ),
              ),
              ChangePasswordTextFormFiled(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => validateEmail(value: value),
                  textFiledName: "Enter Email",
                  readOnly: false),
              50.verticalSpace,
              Center(
                child: AppButtonWidget(
                  onPressed: ()async {
                    if (controller.forgotFormKey.currentState?.validate() ??
                        false) {
                      await controller.forgotPasswordApi();
                    } else {
                      null;
                    }
                  },
                  btnName: '',
                  borderRadius: 25.5,
                  padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 25.w),
                  image: const DecorationImage(
                      colorFilter: ColorFilter.mode(
                        AppColors.primary, // Change this to the desired color
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
    );
  }
}
