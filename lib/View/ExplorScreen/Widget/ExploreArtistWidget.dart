import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';

class ExploreArtistWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final Function() onViewAll;
  final List<Data>? data;

  const ExploreArtistWidget({super.key, this.trendingCategoryName, required this.onViewAll, this.data});

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
                  txtTitle:trendingCategoryName ??
                      ''),
              InkWell(
                onTap: onViewAll,
                child:  AppTextWidget(
                  txtTitle: "View All",
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  txtColor: AppColors.primary,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 230.h,
          child: GridView.builder(
              padding:
              EdgeInsets.only(left: 10.w,right: 10.w),
              itemCount: data
                  ?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate:
              SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent:
                  double.maxFinite,
                  mainAxisExtent: 200.w,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return MostPlayedSongsWidget(
                  isTrending: true,
                  onTap: (){
                    print(data?[index].artistsId);
                    Get.find<ArtistsController>().trackSongApi(data?[index].artistsId??0).then((_){
                      Get.find<ArtistsController>().albumSongApi(data?[index].artistsId??0).then((_){
                        Get.toNamed(RoutesName.songsAlbumsScreen);
                      });
                    });
                  },
                  title: data?[index]
                      .artistsName,
                  image:
                  data?[index]
                      .artistsImage,
                  subtitle: "",
                );
              }),
        ),
        20.verticalSpace,
      ],
    );
  }
}
