import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/AlbumList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlbumDownloadWidget extends StatelessWidget {
  const AlbumDownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Get.find<BaseController>().databaseDownloadedAlbumSongList.isNotEmpty? GridView.builder(
        itemCount: Get.find<BaseController>().databaseDownloadedAlbumSongList.length,
        padding: EdgeInsets.only(
            left: 20.w, right: 20.w, top: 10.h),
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Two items per row
          crossAxisSpacing:
          20.w, // Space between columns
          mainAxisSpacing: 10.h, // Space between rows
          childAspectRatio:
          0.75, // Adjust item height/width ratio
        ),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: (){
              // print(Get.find<BaseController>().databaseDownloadedAlbumSongList[index]);
              Get.find<BaseController>().convertStringToList(index: index);

              // Get.find<BaseController>().fetchSongById(int.parse(Get.find<BaseController>().databaseDownloadedAlbumSongList[index]['song_id']));
              Get.toNamed(RoutesName.offlineAlbumDetailScreen,arguments: {
                'songList': Get.find<BaseController>()
                    .databaseDownloadedAlbumSongList[
                index],
                "album_id" : Get.find<BaseController>().databaseDownloadedAlbumSongList[index]['album_id']
              });
            },
            child: AlbumListWidget(
              title: Get.find<BaseController>().databaseDownloadedAlbumSongList[index]['album_name'],
              imageUrl: Get.find<BaseController>().databaseDownloadedAlbumSongList[index]['imageUrl'],
              dataLength: '',
            ),
          );
        }):Center(child: AppTextWidget(txtTitle: "No Albums Downloaded !"));
  }
}
