import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/RemoveFromPlayListDialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PlayListList extends StatelessWidget {
  final List<MixesTracksData>? data;

  const PlayListList({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !Get.find<BaseController>().isLoading.value,
          replacement: AppLoder(),
          child: ListView.builder(
            physics: ClampingScrollPhysics(),
              controller: Get.find<AdvanceSearchController>().controllerFor,
              itemCount: data?.length??0,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: (){
                    Get.find<MyLibraryController>()
                        .playListSongDataApi(
                        playlistsId:
                        data?[index].playListId)
                        .then((_) {
                      Get.toNamed(RoutesName.playListDetailView,
                          arguments: {'playlist_name':data?[index].playlistsName});
                    });
                  },
                  leading: CachedNetworkImageWidget(
                    height: 70.h,
                    width: 70.h,
                    image: data?[index].playlistImages?[0].image,
                    fit: BoxFit.contain,
                  ),
                  title: AppTextWidget(
                    txtTitle: data?[0].playlistsName ?? '',
                    fontSize: 14,
                  ),
                  trailing: InkWell(
                    onTap: () {
                      Get.dialog(RemoveFromPlayListDialog());
                    },
                    child: Icon(
                      weight: 15,
                      Icons.more_vert,
                      color: AppColors.white,
                      size: 30.r,
                    ),
                  ),
                  subtitle: AppTextWidget(
                    txtTitle: "${data?[0].songCount} Songs",
                    fontSize: 14,
                  ),
                );
              }),
        ));
  }
}
