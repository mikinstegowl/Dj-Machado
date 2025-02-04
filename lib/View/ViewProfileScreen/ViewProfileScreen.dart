import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/AppIcons.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/ViewProfileScreen/Widgets/ProfileTextFormFiled.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewProfileScreen extends GetView<ProfileController> {
  const ViewProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.darkgrey,
        // extendBodyBehindAppBar: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: true,
        appBar:
        // AppBar(
        //   backgroundColor: AppColors.transparent,
        //   leadingWidth: 80.w,
        //   leading: InkWell(
        //     onTap: () {
        //       Get.back();
        //     },
        //     child: Row(
        //       children: [
        //         Icon(
        //           AppIcons.navigate_before,
        //           size: 28.r,
        //           color: AppColors.black,
        //         ),
        //         const AppTextWidget(
        //           fontWeight: FontWeight.w600,
        //           txtTitle: "Back",
        //           txtColor: AppColors.black,
        //           fontSize: 18,
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        CommonAppBar(
          showLogo: true,
          showTitle: false,
          title: "this",
          searchBarShow: false,
          isHome:false,
        ),
        body: Container(
          padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+25.h),
          height: MediaQuery.sizeOf(context).height,
          // padding: EdgeInsets.only(top:AppBar().preferredSize.height.h),

          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppAssets.backGroundImage))
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
               10.verticalSpace,
                CachedNetworkImageWidget(
                  width: double.maxFinite,
                    fit: BoxFit.cover,
                    height: 150.h,
                    image: Get.find<ProfileController>()
                        .profileDataModel
                        ?.data?[0]
                        .image),
                30.verticalSpace,
                Container(
                  color: AppColors.black,
                  child: Column(
                    children: [
                      ProfileTextFormFiled(
                        controller: controller.userNameController,
                        textFiledName: 'Enter Username',
                        readOnly: true,
                      ),
                      ProfileTextFormFiled(
                        controller: controller.emailController,
                        textFiledName: 'Enter Email',
                        readOnly: true,
                      ),
                      ProfileTextFormFiled(
                        inputFormatters: [
                          PhoneNumberFormatter(),
                          LengthLimitingTextInputFormatter(12),
                        ],
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: controller.mobileController,
                        textFiledName: 'Enter Phone Number',
                        readOnly: true,
                      ),

                      ProfileTextFormFiled(
                        onTap: () async {
                          // await controller.selectDate(context);
                        },
                        controller: controller.dobController,
                        textFiledName: 'Enter DOB',
                        readOnly: true,
                      ),
                      30.verticalSpace,
                      Center(
                        child: AppButtonWidget(
                          onPressed: () async {
                            Get.toNamed(RoutesName.changePasswordScreen);
                          },
                          btnName: 'Change Password',
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          txtColor: AppColors.black,
                          image: const DecorationImage(
                              fit: BoxFit.fill,
                              colorFilter: ColorFilter.mode(
                                AppColors.primary, // Change this to the desired color
                                BlendMode.srcATop,
                              ),
                              image: AssetImage(
                                AppAssets.buttonBackgroundImage,
                              )),
                          margin: EdgeInsets.symmetric(horizontal: 50.w),
                          padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                          // btnColor: AppColors.primary,
                        ),
                      ),
                      100.verticalSpace,
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
