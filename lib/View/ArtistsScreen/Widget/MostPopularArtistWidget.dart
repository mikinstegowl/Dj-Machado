import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/ArtistsDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';

class MostPopularArtistWidget extends GetView<ArtistsController> {
  final List<PopularArtist>? data;

  const MostPopularArtistWidget({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: const AppTextWidget(txtTitle: "Most Popular Artist"),
        ),
        SizedBox(
          height: 230.h,
          child: GridView.builder(
              padding: EdgeInsets.only(left: 10.w),
              itemCount: data?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: double.maxFinite,
                  mainAxisExtent: 140.w,
                  crossAxisSpacing: 10.h,
                  mainAxisSpacing: 10.h),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    // await controller
                    //     .trackSongApi(data?[index].artistsId ?? 0)
                    //     .then((_) async {
                    //   await controller
                    //       .albumSongApi(data?[index].artistsId ?? 0)
                    //       .then((_) {
                    //     Get.toNamed(RoutesName.songsAlbumsScreen,
                    //         arguments: {"isGenre": false,'homeScreen':false});
                    //   });
                    // });
                    Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SongsAlbumsScreen(id: data?[index].artistsId??0, type: 'Artists')));

                  },
                  child: Container(
                    color: AppColors.black,
                    child: Stack(
                      children: [
                        CachedNetworkImageWidget(
                          image: data?[index].originalImage ?? '',
                          width: double.maxFinite,
                          height: double.maxFinite,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                              decoration:
                                  const BoxDecoration(color:AppColors.newdarkgrey,),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.h, horizontal: 10.w),
                              width: double.maxFinite,
                              child: AppTextWidget(
                                fontSize: 14,
                                txtTitle: data?[index].artistsName ?? '',
                                txtColor: AppColors.white,
                              )),
                        )
                      ],
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
