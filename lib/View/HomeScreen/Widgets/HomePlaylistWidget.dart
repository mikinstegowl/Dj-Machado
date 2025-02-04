import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/Models/ExplorDataModel.dart';

class HomePlaylistWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final List<Data>? data;
  final Function() onViewAllTap;
  final Function() onPlaylistTap;
  const HomePlaylistWidget({super.key, this.trendingCategoryName, this.data, required this.onViewAllTap, required this.onPlaylistTap});

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
                  isTrending: true,
                  onTap: (){
                    Get.find<MixesController>().plaListTrackSongApi(
                        flowActivoPlaylistId: data?[index].flowactivoplaylistId)
                        .then((_) {
                      Get.toNamed(RoutesName.mixesSongScreen,
                          arguments: {
                            'title': data?[index].flowactivoplaylistName
                          });
                    });
                  },
                  title: data?[index]
                      .flowactivoplaylistName,
                  image:data?[index]
                      .flowactivoplaylistImage,
                  subtitle:'',
                );
              }),
        ),
        20.verticalSpace,
      ],
    );
  }
}
