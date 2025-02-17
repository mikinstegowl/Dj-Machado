import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';

class ExploreGenreWidget extends StatelessWidget {
  final String? trendingCategoryName;
  final List<Data>? data;
  final Function() onViewAllTap;


  const ExploreGenreWidget({super.key, this.trendingCategoryName, this.data, required this.onViewAllTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 20.w, vertical: 10.h),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  AppTextWidget(
                      txtTitle: trendingCategoryName ??
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
                  EdgeInsets.only(left: 10.w,right: 10.w),
                  itemCount: data
                      ?.length??0,
                  scrollDirection: Axis.horizontal,
                  gridDelegate:
                  SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent:
                      double.maxFinite,
                      mainAxisExtent:300.w,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (context, index) {
                    return Container(
                        clipBehavior:
                        Clip.antiAlias,
                        decoration:
                        const BoxDecoration(
                          color:
                          AppColors.newdarkgrey,
                        ),
                        child:
                        MostPlayedSongsWidget(
                          gif:  data?[index].songName == PlayerService.instance.audioPlayer.sequenceState?.currentSource?.tag.title,
                          isTrending: true,
                          image: data?[index]
                              .genresImage,
                          title: data?[index]
                              .genresName,
                          subtitle: "",
                          onTap: () {
                            // Get.find<ExplorController>().selectedGenreAlbumApi(data?[index].genresId??0).then((_){
                            //   Get.find<ExplorController>().selectedGenreSongsApi(data?[index].genresId??0).then((_){
                            //     Get.toNamed(RoutesName.songsAlbumsScreen,arguments: {'isGenre':true,'homeScreen':false});
                            //   });
                            // });
                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SongsAlbumsScreen(id: data?[index].genresId??0, type: 'Genres')));

                          },
                        )
                    );
                  }),
            ),
            20.verticalSpace,
          ],
        ),
        // Obx(()=>Visibility(
        //     visible: Get.find<HomeController>().isLoading.value,
        //     child: AppLoder())),
      ],
    );
  }
}
