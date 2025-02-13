import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/SkipUserDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final String? image;
  final bool searchBarShow;
  final bool showLogo;
  final bool showImage;
  final bool showTitle;
  final bool isHome;
  final bool showBack;
  final Color? titleClr;

  const CommonAppBar(
      {super.key, this.title, this.image, this.searchBarShow = true, this.showLogo=false, this.showImage=false, this.showTitle=true, this.isHome=false, this.showBack=true, this.titleClr});

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppBar(
        leadingWidth:isHome?null: 140.w,
        leading:
            isHome?InkWell(
              splashColor: AppColors.primary,
              onTap: () async {
                await Get.find<AdvanceSearchController>()
                    .recentSearch()
                    .then((_) {
                  Get.toNamed(RoutesName.advanceSearchScreen);
                });
              },
              child: Icon(
                Icons.search_rounded,
                size: 30.r,
                color: AppColors.primary,
              ),
            ):
       showBack? InkWell(
         splashColor: AppColors.primary,
          onTap: () {
            Get.back();
          },
          child: Row(
            children: [
              Image.asset(
                height: 25.h,
                width: 25.h,
                AppAssets.backIcon,
                // size: 28.r,
                // color: AppColors.white,
              ),
              5.horizontalSpace,
              const AppTextWidget(
                fontWeight: FontWeight.w600,
                txtTitle: "Back",
                txtColor: AppColors.white,
                fontSize: 18,
              )
            ],
          ),
        ):SizedBox.shrink(),
        toolbarHeight: 80.h,
        backgroundColor: AppColors.transparent,
        centerTitle: true,
        bottom:showLogo||showImage?null:PreferredSize(preferredSize: Size.fromHeight(1.h), child: Divider(height: 1,)),
        flexibleSpace:showLogo||showImage? Column(mainAxisSize: MainAxisSize.min,
          children: [
            10.verticalSpace,
           showLogo? Image.asset(
             fit: BoxFit.cover,
             AppAssets.logo,height: 50.h,
              width: 50.h,):const SizedBox.shrink(),
            showImage? CachedNetworkImageWidget(image: image,height: 40.h,width: 50.h,):SizedBox.shrink(),
            showTitle?  6.verticalSpace:0.verticalSpace,
          showTitle?  AppTextWidget(
              txtTitle: title??'',
            txtColor: titleClr??AppColors.primary,
            // fontSize: 17,
            ):SizedBox.shrink(),
            10.verticalSpace,
            Divider(height: 1,)
          ],
        ):null,
        title:showLogo||showImage?null: AppTextWidget(
          txtTitle: title??'',
        ),

        actions: [
       isHome?InkWell(
         onTap: () {
           UserPreference.getValue(key: PrefKeys.skipUser)!= null &&  UserPreference.getValue(key: PrefKeys.skipUser)? Get.dialog(
               const SkipUserDialog()
           ):
           Get.find<ProfileController>().getProfileData().then((value) {
             Get.toNamed(RoutesName.settingScreen);
           });
         },
         child: Padding(
           padding: EdgeInsets.only(right: 20.w),
           child: Icon(
             Icons.settings,
             size: 30.r,
             color: AppColors.primary,
           ),
         ),
       ):searchBarShow?   Padding(
            padding: const EdgeInsets.only(right: 20),
            child: InkWell(
              onTap: () async {
                Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none ?
                Utility.showSnackBar("You're in offline mode",isError: true)  :   await Get.find<AdvanceSearchController>()
                    .recentSearch()
                    .then((_) {
                  Get.toNamed(RoutesName.advanceSearchScreen);
                });
              },
              child: Icon(
                Icons.search,
                size: 30.r,
                color: AppColors.primary,
              ),
            ),
          ):SizedBox.shrink()
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize =>  Size.fromHeight(showLogo||showImage?showTitle?105.h:80.h:80.h);
}
