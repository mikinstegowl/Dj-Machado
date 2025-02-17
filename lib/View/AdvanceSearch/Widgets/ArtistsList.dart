import 'dart:io';

import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';

class ArtistsList extends StatelessWidget {
  final List<MixesTracksData>? data;

  const ArtistsList({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !Get.find<ArtistsController>().isLoading.value,
          replacement: AppLoder(),
          child: ListView.builder(
            controller: Get.find<AdvanceSearchController>().controllerFor,
              physics: const ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: data?.length ?? 0,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () async {
                        // await Get.find<ArtistsController>()
                        //     .trackSongApi(
                        //     data?[index].id ?? 0)
                        //     .then((_) async {
                        //   await Get.find<ArtistsController>()
                        //       .albumSongApi(
                        //       data?[index].id  ??
                        //           0)
                        //       .then((_) {
                        //     Get.toNamed(
                        //       RoutesName.songsAlbumsScreen,
                        //     );
                        //   });
                        // });
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (_) => SongsAlbumsScreen(
                                id: data?[index].id ?? 0, type: 'Artists')));
                      },
                      leading: Container(
                        width: 50.h,
                        height: 50.h,
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            color: AppColors.white,
                            shape: Platform.isAndroid
                                ? BoxShape.rectangle
                                : BoxShape.circle),
                        child: CachedNetworkImageWidget(
                          image: data?[index].originalImage,
                          width: 50.h,
                          height: 50.h,
                          fit: Platform.isAndroid
                              ? BoxFit.cover
                              : BoxFit.contain,
                        ),
                      ),
                      title: AppTextWidget(
                        txtTitle: data?[index].artistsName ?? '',
                        txtColor: Colors.white,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios,
                          color: AppColors.primary),
                    ),
                    Divider(
                      height: 1,
                    )
                  ],
                );
              }),
        ));
  }
}
