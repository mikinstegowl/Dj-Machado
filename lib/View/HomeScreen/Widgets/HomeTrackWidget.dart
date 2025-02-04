import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';

import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeTrackWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final List<Data>? data;
  final Function() onViewAllTap;

  const HomeTrackWidget({super.key, this.trendingCategoryName, this.data, required this.onViewAllTap,});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(
                  txtTitle: trendingCategoryName ??
                      ''),
              InkWell(
                onTap:onViewAllTap,
                child: const AppTextWidget(
                  txtTitle: "View All",
                  fontSize: 15,
                  txtColor: AppColors.primary,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child: GridView.builder(
              padding:
              EdgeInsets.only(left: 10.w),
              itemCount: data
                  ?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                  double.maxFinite,
                  mainAxisExtent: 170.w,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return MostPlayedSongsWidget(
                  onTap: (){

                    PlayerService.instance.createPlaylist(data, index);
                  },
                  title: data?[index]
                      .songName,
                  image:data?[index]
                      .songImage,
                  subtitle:data?[index]
                      .songArtist,
                );
              }),
        ),
        20.verticalSpace,
      ],
    );
  }
}
