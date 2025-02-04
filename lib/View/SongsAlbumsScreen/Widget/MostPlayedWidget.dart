import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MostPlayedWidget extends StatelessWidget {
  final Function()? onTap;
  final Function()? onOptionTap;
  final String? image;
  final String? title;
  final String? subTitle;

  const   MostPlayedWidget(
      {super.key, this.onTap, this.image, this.title, this.subTitle, this.onOptionTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey[900],
            // border: Border.all(color: Colors.white, width: 2),
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top Avatar Section
                  Expanded(
                    flex: 5,
                    child: SizedBox(
                      child: Align(
                        alignment: Alignment.center,
                        child: CachedNetworkImageWidget(
                          height: double.maxFinite,
                          width: double.maxFinite,
                          image: image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  // Title Section
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                      decoration: const BoxDecoration(
                        color: AppColors.newdarkgrey,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextWidget(
                            txtTitle: title ?? '',
                            txtColor: AppColors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                          AppTextWidget(
                            txtTitle: subTitle ?? '',
                            txtColor: AppColors.primary,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  // Label Section
                ],
              ),
              Positioned(
                  right: 5.h,
                  top: 5.h,
                  child: InkWell(
                    onTap:onOptionTap,
                    child: Container(
                      height: 25.h,
                      width: 25.h,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.black,border: Border.all(color: AppColors.white)),
                      child:  Center(child: Icon(Icons.more_horiz,color: AppColors.white,size: 20.r,)),),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
