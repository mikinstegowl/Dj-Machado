import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExplorDataView extends StatelessWidget {
  final String title;
  final List<Data>? data;
  final Function()? onTap;

  const ExplorDataView({
    super.key,
    this.data,
    required this.title, this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(txtTitle: title),
              InkWell(
                onTap: onTap,
                child: const AppTextWidget(
                  txtTitle: "View All",
                  txtColor: AppColors.primary,
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child:
          GridView.builder(
              padding: EdgeInsets.only(left: 10.w),
              itemCount: data?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: double.maxFinite,
                  mainAxisExtent: 190.w,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    if (data?[index].trendingsradioUrl != null) {
                      PlayerService.instance.createPlaylist(data, index: index,id: data?[index].songId);
                    } else {
                      await Get.find<ExplorController>()
                          .selectedGenreSongsApi(data?[index].genresId ?? 0)
                          .then((_) {
                        Get.find<ExplorController>()
                            .selectedGenreAlbumApi(data?[index].genresId ?? 0)
                            .then((_) {
                          Get.find<BaseController>().initialListOfBool(Get.find<ExplorController>()
                            .songsTracksDataModel?.data?.length??0);
                          Get.toNamed(RoutesName.songsAlbumsScreen, arguments: {
                            'title': data?[index].genresName,
                            "isGenre": true
                          });
                        });
                      });
                    }
                  },
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                      color: AppColors.newdarkgrey,
                    ),
                    child: MostPlayedSongsWidget(
                      image: data?[index].genresImage,
                      title: data?[index].genresName,
                      subtitle: "",
                      onTap: (){

                      },
                    )

                    // Stack(
                    //   children: [
                    //     Column(
                    //       crossAxisAlignment: CrossAxisAlignment.start,
                    //       children: [
                    //         Stack(
                    //           children: [
                    //             CachedNetworkImageWidget(
                    //               image: data?[index].originalImage,
                    //               width: double.maxFinite,
                    //               height: 200.h,
                    //               fit: BoxFit.cover,
                    //             ),
                    //             Positioned(
                    //               bottom: 0,
                    //               left: 0,
                    //               right: 0,
                    //               child: Container(
                    //                 padding: EdgeInsets.symmetric(
                    //                     horizontal: 10.w, vertical: 10.h),
                    //                 width: double.maxFinite,
                    //                 decoration: const BoxDecoration(
                    //                     color: AppColors.newdarkgrey),
                    //                 child:
                    //                 AppTextWidget(
                    //                   txtTitle: data?[index].genresName != null
                    //                       ? data![index].genresName ?? ''
                    //                       : data?[index].trendingsradioName ??
                    //                           '',
                    //                   fontSize: 14,
                    //                 ),
                    //               ),
                    //             )
                    //           ],
                    //         ),
                    //       ],
                    //     ),
                    //     Positioned(
                    //         right: 10,
                    //         top: 10,
                    //         child: Container(
                    //           decoration: BoxDecoration(
                    //               color: AppColors.error,
                    //               border: Border.all(
                    //                 color: AppColors.white,
                    //               ),
                    //               shape: BoxShape.circle),
                    //           child: const Icon(
                    //             Icons.more_horiz,
                    //             color: AppColors.white,
                    //           ),
                    //         ))
                    //   ],
                    // ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
