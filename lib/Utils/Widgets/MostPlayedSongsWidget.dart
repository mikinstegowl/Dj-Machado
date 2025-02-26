import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
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
final bool gif;
  const MostPlayedSongsWidget(
      {super.key, this.onTap, this.image, this.title, this.subtitle, this.onOptionTap, this.isTrending=false, this.gif =false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:
      Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  CachedNetworkImageWidget(
                    image: image,
                    height: 165.h,
                    width: double.maxFinite,
                    fit: BoxFit.cover,
                  ),
                  gif
                      ? Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        AppAssets.gif,
                        height: 80.h,
                        width: 80.w,
                        color: AppColors.primary,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                      : SizedBox.shrink(),
                ],
              ),

              Container(
                height: 50.h,
                color: AppColors.newdarkgrey,
                padding: EdgeInsets.symmetric(horizontal: 10.w,),
                width: double.maxFinite,
                child: Column(
                  // mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      child: AppTextWidget(
                        fontWeight: FontWeight.bold,
                        // fontFamily: 'Century Gothic',
                        txtTitle: title ?? '',
                        maxLine: 1,
                        letterSpacing: 1,
                        fontSize: 14,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    subtitle != ''? Flexible(
                      child: AppTextWidget(
                        // fontFamily: 'Century Gothic',
                        txtTitle: subtitle != ''? subtitle??"" :'',
                        maxLine: 1,
                        letterSpacing: 1,
                        fontSize: 14,
                        txtColor: AppColors.primary,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ): SizedBox.shrink(),
                    // Visibility(
                    //   visible:subtitle!='' ,
                    //   child: AppTextWidget(
                    //     txtTitle: subtitle ?? '',
                    //     txtColor: AppColors.primary,
                    //     fontSize: 14,
                    //   ),
                    // )
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
