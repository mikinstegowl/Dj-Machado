import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/OptionDialog.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/AlbumList.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/SongList.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/Widget/MostPlayedWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AlbumWidget extends StatelessWidget {
  final TracksDataModel? tracksDataModel;

  const AlbumWidget({super.key, required this.tracksDataModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        tracksDataModel?.data?.isNotEmpty??false? Column(
          children: [
            GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tracksDataModel?.data?.length ?? 0,
                padding: EdgeInsets.only(left: 20.w, right: 20.w,),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two items per row
                  crossAxisSpacing: 20.w, // Space between columns
                  mainAxisSpacing: 10.h, // Space between rows
                  childAspectRatio: .8, // Adjust item height/width ratio
                ),
                itemBuilder: (context, index) {
                  return MostPlayedWidget(
                    onOptionTap: (){
                      print("object${tracksDataModel?.data?[index].albumsName}");
                      Get.dialog(OptionDialog(
                        isAlbum: true,
                        listOfTrackData:tracksDataModel?.data?.map((e)=>MixesTracksData(
                        song: tracksDataModel?.data?[index].song,
                          id: tracksDataModel?.data?[index].id,
                          albumsId: tracksDataModel?.data?[index].albumsId,
                          genresId: tracksDataModel?.data?[index].genresId,
                        albumsName: tracksDataModel?.data?[index].albumsName,
                        songId: tracksDataModel?.data?[index].songId,
                        songImage: tracksDataModel?.data?[index].songImage,
                        originalImage: tracksDataModel?.data?[index].originalImage,
                        albumImage: tracksDataModel?.data?[index].albumImage,
                        songName: tracksDataModel?.data?[index].songName,
                        favouritesStatus: tracksDataModel?.data?[index].favouritesStatus,
                        songArtist: tracksDataModel?.data?[index].songArtist,
                      )).toList()??[] ,index: index,track:MixesTracksData(
                        song: tracksDataModel?.data?[index].song,
                        songId: tracksDataModel?.data?[index].songId,
                        id: tracksDataModel?.data?[index].id,
                        albumsId: tracksDataModel?.data?[index].albumsId,
                        genresId: tracksDataModel?.data?[index].genresId,
                        albumsName: tracksDataModel?.data?[index].albumsName,
                        songImage: tracksDataModel?.data?[index].songImage,
                        originalImage: tracksDataModel?.data?[index].originalImage,
                        albumImage: tracksDataModel?.data?[index].albumImage,
                        songName: tracksDataModel?.data?[index].songName,
                        favouritesStatus: tracksDataModel?.data?[index].favouritesStatus,
                        songArtist: tracksDataModel?.data?[index].songArtist,
                      ),));
                    },
                    onTap: () async {
                      Get.find<BaseController>().convertStringToList1(
                          album_id: tracksDataModel?.data?[index].albumsId);
                      await Get.find<ArtistsController>()
                          .albumTrackSongApi(
                              artistsId: tracksDataModel?.data?[index].id ?? 0,
                              albumId: tracksDataModel?.data?[index].albumsId ?? 0,
                              genresId: tracksDataModel?.data?[index].genresId)
                          .then((_) {
                        Get.toNamed(RoutesName.albumTrackScreen,
                            arguments: tracksDataModel?.data?[index].albumsId);
                      });
                    },
                    title: tracksDataModel?.data?[index].albumsName ?? '',
                    subTitle: tracksDataModel?.data?[index].albumsArtist ?? '',
                    image: tracksDataModel?.data?[index].albumsImage ?? '',
                  );
                }),
            // 20.verticalSpace,
          ],
        ): Center(child: AppTextWidget(txtTitle: "No Data Found"),),
        // Obx(()=>Visibility(
        //   visible: Get.find<ArtistsController>().isLoading.value,
        //     child: AppLoder()))
      ],
    );
  }
}
