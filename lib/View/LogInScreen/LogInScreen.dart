import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppConst.dart';
import 'package:newmusicappmachado/Utils/Constants/Validators.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/TermsAndPrivacyWidget.dart';
import 'package:newmusicappmachado/View/LogInScreen/Widget/LineWidget.dart';
import 'package:newmusicappmachado/View/LogInScreen/Widget/LoginTextFormField.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LogInScreen extends GetView<AuthController> {
  const LogInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(

          body: Container(
            height: MediaQuery.sizeOf(context).height,
            decoration:const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))
            ),
            child: Form(
              key: controller.loginFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    125.verticalSpace,
                    Stack(
                      children: [
                        Positioned(
                          left: 0,
                          child: InkWell(
                            onTap: () async {
                              await controller.skipUser();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 25.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  color: AppColors.black,
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(50.r),
                                      bottomRight: Radius.circular(50.r)),
                                  border: const Border(
                                      top: BorderSide(color: AppColors.white),
                                      bottom: BorderSide(color: AppColors.white),
                                      right: BorderSide(color: AppColors.white))),
                              child: const AppTextWidget(
                                txtTitle: "Skip",
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Image.asset(
                            AppAssets.logo,
                            height: 95.h,
                            width: 95.h,
                            fit: BoxFit.contain,
                          ),
                        ),

                      ],
                    ),
                    20.verticalSpace,
                    Center(
                      child: AppTextWidget(
                        textAlign: TextAlign.center,
                        txtTitle:
                            "Sign in to FlowActivo".toUpperCase(),
                        // fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    50.verticalSpace,
                    LoginTextFormField(

                      controller: controller.userNameOrEmailTextEditingController,
                      validator: (value) => isRequiredField(value: value),
                      textFiledName: "Username Or Email",
                    ),
                    20.verticalSpace,
                    LoginTextFormField(
                      controller: controller.passwordTextEditingController,
                      validator: (value) => isRequiredField(value: value),
                      textFiledName: "Password",
                      isPassword: true,
                    ),
                    20.verticalSpace,
                    Center(
                      child: AppButtonWidget(
                        onPressed: () async {
                          if (controller.loginFormKey.currentState?.validate() ??
                              false) {
                            await controller.loginApi();
                          }
                        },
                        btnName: 'Sign In',
                        fontSize: 18,
                        txtColor: AppColors.black,
                        image: const DecorationImage(
                            colorFilter: ColorFilter.mode(
                              AppColors
                                  .primary, // Change this to the desired color
                              BlendMode.srcATop,
                            ),
                            image: AssetImage(
                              AppAssets.buttonBackgroundImage,
                            )),
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 25.w),
                        // btnColor: AppColors.primary,
                      ),
                    ),
                    10.verticalSpace,
                     Center(
                        child: InkWell(
                          onTap:
                          (){
                            Get.toNamed(RoutesName.forgotPasswordScreen);
                          },
                            child: const AppTextWidget(txtTitle: "I Forgot My Password-",fontSize: 14,))),
                    10.verticalSpace,
                    const LineWidget(),
                    const Center(
                        child:
                            AppTextWidget(txtTitle: "Currently not a member?",fontSize: 14,)),
                    20.verticalSpace,
                    Center(
                      child: AppButtonWidget(
                        onPressed: () {
                          Get.toNamed(RoutesName.signUpScreen);
                          controller.clearControllers();
                        },
                        btnName: '',
                        borderRadius: 25.5,
                        // width:  double.maxFinite,
                        margin: EdgeInsets.symmetric(horizontal: 50.w),
                        padding: EdgeInsets.symmetric(
                            vertical: 15.h, horizontal: 25.w),
                        btnColor: AppColors.black,
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppTextWidget(
                              txtTitle: "Sign Up ",
                              fontSize: 12,
                              txtColor: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                            AppTextWidget(
                              txtTitle: "And Became A Member",
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ],
                        ),
                      ),
                    ),
                    20.verticalSpace,
                    const Center(
                      child: TermsAndPrivacyWidget(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Obx(() => Visibility(
            visible: controller.isLoading.value, child: const AppLoder()))
      ],
    );
  }
}
