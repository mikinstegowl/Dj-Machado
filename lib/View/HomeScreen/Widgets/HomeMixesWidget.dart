import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../Utils/Models/ExplorDataModel.dart';

class HomeMixesWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final List<Data>? data;
  final Function() onViewAllTap;

  const HomeMixesWidget({super.key, this.trendingCategoryName, this.data, required this.onViewAllTap, });

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
                onTap: onViewAllTap,
                child: const AppTextWidget(
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
              EdgeInsets.only(left: 10.w),
              itemCount:data
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
                  onTap:(){
                    Get.find<MixesController>().mixesSubCategoryAndTracksApi(
                        mixesId: data?[index].mixesId)
                        .then((_) {
                      Get.toNamed(RoutesName.mixesSongScreen,
                          arguments: {
                            'title': data?[index].mixesName
                          });
                    });
                  },
                  title: data?[index]
                      .mixesName,
                  image: data?[index]
                      .mixesImage,
                  subtitle: '',
                );
              }),
        ),
        20.verticalSpace,
      ],
    );
  }
}
