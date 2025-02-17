import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
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
    print({"this is ListView length${data?.length}"});
    return Obx(() => Visibility(
          visible: !Get.find<BaseController>().isLoading.value,
          replacement: AppLoder(),
          child: SingleChildScrollView(
            controller: Get.find<AdvanceSearchController>().controllerFor,
            child: Column(
              children: [
                Padding(
                  padding:  EdgeInsets.only(bottom: 60.0),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // padding: EdgeInsets.zero,
                      itemCount: data?.length??0,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SongListWidget(
                              online:  Get.find<BaseController>().connectivityResult[0] ==
                                  ConnectivityResult.none? false: true,
                              index: index,
                              songId: data?[index].songId,
                              title: data?[index].songName ?? '',
                              subTitle: data?[index].songArtist ?? '',
                              tracksDataModel: data,
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
                ),
              ],
            ),
          ),
        ));
  }
}
