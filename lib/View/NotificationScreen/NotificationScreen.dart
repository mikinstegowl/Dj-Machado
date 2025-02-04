import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Styling/AppDateFormatter.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class NotificationScreen extends GetView<ProfileController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(title: "Notifications",searchBarShow: false,),
      body: GetBuilder<ProfileController>(
        init: controller..notificationApi(),
        builder: (controller) {
          return Container(
            height: MediaQuery.sizeOf(context).height,
            padding: EdgeInsets.only(top:AppBar().preferredSize.height.h+70.h),

            decoration: const BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(AppAssets.backGroundImage))
            ),
            child: SingleChildScrollView(
              child: Column(children: [
                ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(top: 10.h),
                  shrinkWrap: true,
                  physics:const ClampingScrollPhysics(),
                  itemCount: controller.notificationsDataModel?.data?.length,
                    itemBuilder: (context,index){
                  return
                  Container(
                    decoration: BoxDecoration(color: AppColors.newdarkgrey,borderRadius: BorderRadius.circular(10.r)),
                    margin: EdgeInsets.symmetric(horizontal: 5.h,vertical: 5.h),
                    padding: EdgeInsets.symmetric(horizontal: 15.h,vertical: 5.h),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppTextWidget(txtTitle: controller.notificationsDataModel?.data?[index].notificationsTitle??'',txtColor: AppColors.primary,) ,
                      AppTextWidget(txtTitle: controller.notificationsDataModel?.data?[index].notificationsMessage??'',fontSize: 14,),
                      AppTextWidget(txtTitle:AppDateFormatter.dateTimeText( date:controller.notificationsDataModel?.data?[index].createdAt??''),fontSize: 14,),
                    ],),);
                })
              ],),
            ),
          );
        }
      ),
    );
  }
}
