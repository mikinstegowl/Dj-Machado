import 'dart:developer';

import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/EditProfileScreen/EditProfileScreen.dart';
import 'package:newmusicappmachado/View/SettingScreen/Widgets/SettingTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class SettingScreen extends GetView<ProfileController> {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CommonAppBar(title: "Settings".toUpperCase(),showLogo: true,),
        backgroundColor: AppColors.darkgrey,
        extendBodyBehindAppBar: true,
        body: Container(
          height: MediaQuery.sizeOf(context).height.spMax,
          padding: EdgeInsets.only(top:AppBar().preferredSize.height.spMax+70.h),
      
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))
          ),
          child: GetBuilder<ProfileController>(
            init: controller,
            builder: (controller) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: AppColors.black,
                      child: Column(
                        children: [
                          SettingTile(
                            onTap: () {
                              Get.bottomSheet(const EditProfileScreen(),
                                  isDismissible: false, isScrollControlled: true);
                              // Get.toNamed(RoutesName.editProfileScreen);
                            },
                            title: controller.profileDataModel?.data?[0].userName,
                            imageUrl: controller.profileDataModel?.data?[0].image ?? '',
                            subtitle: "Edit Account",
                            isEditAccount: true,
                          ),
                          SettingTile(
                            onTap: () {
                              Get.toNamed(RoutesName.viewProfileScreen);
                            },
                            title: "View Your Profile",
                          ),
                          SettingTile(
                            onTap: () {
                              Get.toNamed(RoutesName.notificationScreen);
                            },
                            title: "Notification",
                          ),
                          SettingTile(
                            onTap: () {
                              Get.find<HomeController>().getAllGenres().then((value) {
                                Get.toNamed(RoutesName.selectGenresScreen);
                              });
                            },
                            title: "Set Default Genre",
                          ),
                          SettingTile(
                            onTap: () {
                              Get.find<HomeController>().shareAppApi().then((_)async {
                                await Share.share("${Get.find<HomeController>().shareAppModel?.data?[0].shareappName}\nAndroid: ${Get.find<HomeController>().shareAppModel?.data?[0].shareappAndroidLink}\nIos: ${Get.find<HomeController>().shareAppModel?.data?[0].shareappIosLink}");
                              });
                            },
                            title: "Share This App",
                          ),
                          SettingTile(
                            onTap: () {},
                            title: "Rate This App",
                          ),
                          SettingTile(
                            onTap: () async{
                             await controller.termsAndPrivacy(value: "privacy",authChopperService: AppChopperClient().getChopperService<AuthChopperService>());
                            },
                            title: "Privacy Policy",
                          ),
                        ],
                      ),
                    ),
                    20.verticalSpace,
                    Center(
                      child: AppButtonWidget(
                        onPressed: () async {
                          Get.find<HomeController>().logoutApi();                    },
                        btnName: 'Sign out',
                        fontSize: 18,
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
                        padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 30.w),
                        // btnColor: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
