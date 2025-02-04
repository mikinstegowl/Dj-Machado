import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Utils/Models/RecentSeachDataModel.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RecentSearchWidget extends StatelessWidget {
  final String title;
  final List<TrendinglistData>? trendinglistData;

  const RecentSearchWidget(
      {super.key, required this.title, this.trendinglistData});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: trendinglistData != [],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppTextWidget(
            txtTitle: title.toUpperCase(),
            txtColor: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
          ListView.builder(
              padding: EdgeInsets.zero,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: (trendinglistData?.length??0)>4?5:trendinglistData!.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(top: 10.h),
                  child: InkWell(
                    onTap: () {
                      Get.find<AdvanceSearchController>()
                          .advanceSearchController
                          .text = trendinglistData?[index].text ?? '';
                      Get.find<AdvanceSearchController>().advanceSearchApi(0);
                    },
                    child: AppTextWidget(
                        txtTitle: trendinglistData?[index].text ?? ''),
                  ),
                );
              }),
          10.verticalSpace,
        ],
      ),
    );
  }
}
