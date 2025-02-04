import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MostPlayedSongsWidget extends StatelessWidget {
  final Function()? onTap;
  final Function()? onOptionTap;
  final String? image;
  final String? title;
  final String? subtitle;
  final bool isTrending;

  const MostPlayedSongsWidget(
      {super.key, this.onTap, this.image, this.title, this.subtitle, this.onOptionTap, this.isTrending=false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:
      Stack(
        children: [
          Column(
            children: [
              CachedNetworkImageWidget(
                image: image,
                height: 165.h,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
              Container(
                color: AppColors.newdarkgrey,
                padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: subtitle!=''?0:10.h),
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppTextWidget(
                        // fontFamily: 'Century Gothic',
                        txtTitle: title ?? '',
                        maxLine: 1,
                        fontSize: 14,
                      ),
                    ),
                    Visibility(
                      visible:subtitle!='' ,
                      child: AppTextWidget(
                        txtTitle: subtitle ?? '',
                        txtColor: AppColors.primary,
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
         isTrending?SizedBox.shrink():Positioned(
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
    );
  }
}
