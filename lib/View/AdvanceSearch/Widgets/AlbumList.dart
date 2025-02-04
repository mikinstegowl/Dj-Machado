import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/Widget/MostPlayedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlbumList extends StatelessWidget {
  final List<MixesTracksData>? data;

  const AlbumList({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !Get.find<BaseController>().isLoading.value,
          replacement: AppLoder(),
          child: GridView.builder(
              itemCount: data?.length??0,
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                // Two items per row
                crossAxisSpacing: 20.w,
                // Space between columns
                mainAxisSpacing: 10.h,
                // Space between rows
                childAspectRatio: 0.75, // Adjust item height/width ratio
              ),
              itemBuilder: (context, index) {
                return MostPlayedWidget(
                  onTap: () async {
                    print(data?.length);
                    await Get.find<ArtistsController>()
                        .albumsAndTracks(
                           albumId:  data?[index].albumsId ?? 0)
                        .then((_) {
                          Get.find<ArtistsController>().albumTrackSongData?.albumImage = data?[index].albumsImage ?? '';
                      Get.toNamed(RoutesName.albumTrackScreen);
                    });
                  },
                  title: data?[index].albumsName ?? '',
                  subTitle: data?[index].albumsArtist ?? '',
                  image: data?[index].albumsImage ?? '',
                );
              }),
        ));
  }
}
