import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/SongList.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SongDownloadWidget extends StatelessWidget {
  const SongDownloadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // print("this is songs${Get.find<BaseController>().databaseDownloadedSongList.any((test)=> test['isDownloaded'] == 1)}");
    print("this is songs${Get.find<BaseController>().databaseDownloadedSongList.length}");
    return  Obx(()=>Get.find<BaseController>().databaseDownloadedSongList.isNotEmpty && Get.find<BaseController>().databaseDownloadedSongList.any((test)=> test['isDownloaded'] == 1)?  ListView.builder(
      padding: EdgeInsets.zero,
        shrinkWrap: true,
        itemCount: Get.find<BaseController>().databaseDownloadedSongList.length,
        itemBuilder: (context,index){
          return  SongListWidget(
            index: index,
            title: Get.find<BaseController>().databaseDownloadedSongList[index]['song_name'],
            subTitle: Get.find<BaseController>().databaseDownloadedSongList[index]['artist_name'],
            onOptionTap: () {
              Get.dialog(
                  OptionDialog(
                    isQueue: true,
                track: MixesTracksData(
                  favouritesStatus: Get.find<BaseController>().databaseDownloadedSongList[index]['favourite']==1?true:false,
                  songId: Get.find<BaseController>().databaseDownloadedSongList[index]['song_id'],
                  songImage: Get.find<BaseController>().databaseDownloadedSongList[index]['imageUrl'],
                  originalImage: Get.find<BaseController>().databaseDownloadedSongList[index]['imageUrl'],
                  songArtist: Get.find<BaseController>().databaseDownloadedSongList[index]['artist_name'],
                  songName: Get.find<BaseController>().databaseDownloadedSongList[index]['song_name'],
                ),
                  listOfTrackData: Get.find<BaseController>().databaseDownloadedSongList.map((e)=> MixesTracksData(songId: e['song_id'],song: e['file_path'],songName: e['song_name'],songArtist: e['song_artist'])).toList()));
            },
            imageUrl: Get.find<BaseController>().databaseDownloadedSongList[index]['imageUrl'],
          );
        }):const Center(child: AppTextWidget(txtTitle: "No Data Found!")),);
  }
}
