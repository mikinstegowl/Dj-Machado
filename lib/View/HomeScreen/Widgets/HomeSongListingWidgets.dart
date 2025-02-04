import 'package:just_audio/just_audio.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/Utils/Widgets/MostPlayedSongsWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class HomeSongListingWidgets extends StatelessWidget {
  final String? categoryTitle;

  final List<MostPlayed>? data;

  const HomeSongListingWidgets({super.key, this.categoryTitle, this.data,});

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppTextWidget(txtTitle: categoryTitle ?? ''),
              Visibility(
                visible:categoryTitle == "Recent Played" ,
                child: InkWell(
                  onTap: (){
                    Get.toNamed(RoutesName.viewAllRecentPlayedScreen);
                  },
                  child: const AppTextWidget(
                    txtTitle: "View All",
                    fontSize: 15,
                    txtColor: AppColors.primary,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: 210.h,
          child: GridView.builder(
            shrinkWrap: true,
              padding: EdgeInsets.only(left: 10.w),
              itemCount: data?.length,
              scrollDirection: Axis.horizontal,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: double.maxFinite,
                  mainAxisExtent: 170.w,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10),
              itemBuilder: (context, index) {
                return MostPlayedSongsWidget(
                  onOptionTap: (){
                    Get.dialog(OptionDialog(
                      isQueue: true,
                      listOfTrackData:data?.map((e)=>MixesTracksData(
                      song: data?[index].song,
                      songId: data?[index].songId,
                      songImage: data?[index].songImage,
                      originalImage: data?[index].originalImage,
                      songName: data?[index].songName,
                      favouritesStatus: data?[index].favouritesStatus,
                      songArtist: data?[index].songArtist,
                    )).toList()??[] ,index: index,track:MixesTracksData(
                      song: data?[index].song,
                      songId: data?[index].songId,
                      songImage: data?[index].songImage,
                      originalImage: data?[index].originalImage,
                      songName: data?[index].songName,
                      favouritesStatus: data?[index].favouritesStatus,
                      songArtist: data?[index].songArtist,
                    ),));
                  },
                  onTap: () async {
                    if (PlayerService.instance.audioPlayer.playing) {
                      await PlayerService.instance.audioPlayer.stop();
                      await PlayerService.instance.audioPlayer.dispose();
                      PlayerService.instance.audioPlayer = AudioPlayer(); // Reinitialize
                    }
                    PlayerService.instance.createPlaylist(data, index);
                  },
                  title: data?[index].songName,
                  image: data?[index].songImage,
                  subtitle: data?[index].songArtist,
                );
              }),
        ),
      ],
    );
  }
}
