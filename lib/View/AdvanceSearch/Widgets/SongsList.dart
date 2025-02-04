import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/SongList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SongsList extends StatelessWidget {
  final List<MixesTracksData>? data;

  const SongsList({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Visibility(
          visible: !Get.find<BaseController>().isLoading.value,
          replacement: AppLoder(),
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              // padding: EdgeInsets.zero,
              itemCount: data?.length??0,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SongListWidget(
                      index: index,
                      songId: data?[index].songId,
                      title: data?[index].songName ?? '',
                      subTitle: data?[index].songArtist ?? '',
                      onOptionTap: () {
                        Get.dialog(
                            OptionDialog(
                              isQueue: true,
                              listOfTrackData: data??[],index: index,track: data?[index],));
                      },
                      imageUrl: data?[index].songImage ?? '',
                    ),
                    10.verticalSpace
                  ],
                );
              }),
        ));
  }
}
