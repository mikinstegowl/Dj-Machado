import 'dart:io';

import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/ArtistsDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ArtistsScreen/Widget/MostPopularArtistWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';

class ArtistsScreen extends GetView<ArtistsController> {
  const ArtistsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.black,
        bottomNavigationBar: const BottomBarWidget(
          routeName: 'Artists',
          mainScreen: false,
          indx: 3,
        ),
        bottomSheet: AudioPlayerController(),
        appBar: const CommonAppBar(
          title: "Artists",
          searchBarShow: true,
          showBack: false,
        ),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 15.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: Stack(
            children: [
              GetBuilder<ArtistsController>(
                  init: controller,
                  builder: (controller) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 30.0.h),
                      child: Column(
                        children: [
                          Visibility(
                            visible: controller.artistsDataModel != null,
                            child: MostPopularArtistWidget(
                              data: controller.artistsDataModel?.popularArtist,
                            ),
                          ),
                          CommonAdWidget(),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: AppTextFormField(
                              showIcons: false,
                              fillColor: AppColors.black,
                              prefixIcon: Icon(
                                Icons.search,
                                color: AppColors.primary,
                                size: 30.r,
                              ),
                              textColor: AppColors.white,
                              suffixWidget: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5.w, vertical: 3.h),
                                margin: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.darkgrey,
                                  borderRadius: BorderRadius.circular(5.r),
                                ),
                                child: AppTextWidget(
                                  txtTitle: 'Search'.toUpperCase(),
                                  fontSize: 12,
                                ),
                              ),
                              controller: controller.searchController,
                              onChanged: (value) {
                                if (value != null || value != '') {
                                  controller.searchArtist();
                                }
                              },
                              hintText: "Search by Artist",
                              hintTextColor: AppColors.white,
                              borderRadious: 5.r,
                            ),
                          ),
                          Expanded(
                            child: Visibility(
                              visible: controller.artistsDataModel != null,
                              replacement: const Center(
                                child: AppTextWidget(
                                  txtTitle: "No Artist Found",
                                  txtColor: AppColors.white,
                                  fontSize: 16,
                                ),
                              ),
                              child: ListView.builder(
                                controller: controller.scrollController,
                                padding:
                                const EdgeInsets.symmetric(vertical: 10),
                                itemCount:
                                controller.groupedArtists.keys.length,
                                itemBuilder: (context, index) {
                                  String firstChar = controller
                                      .groupedArtists.keys
                                      .elementAt(index);
                                  List<PopularArtist> artistList =
                                  controller.groupedArtists[firstChar]!;
                                  return Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      // Alphabet Header
                                      Container(
                                        width: double.maxFinite,
                                        color: Platform.isAndroid
                                            ? AppColors.primary
                                            : AppColors.transparent,
                                        margin:
                                        EdgeInsets.symmetric(vertical: 5.h),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.w, vertical: 5.h),
                                        child: AppTextWidget(
                                          txtTitle: firstChar,
                                          fontSize: 18,
                                          fontWeight: Platform.isAndroid
                                              ? FontWeight.w400
                                              : FontWeight.bold,
                                          txtColor: Platform.isIOS
                                              ? AppColors.primary
                                              : AppColors.black,
                                        ),
                                      ),
                                      // List of Artists under this alphabet header
                                      ...artistList.map((artist) {
                                        return ListTile(
                                          onTap: () async {
                                            // await Get.find<ArtistsController>()
                                            //     .trackSongApi(
                                            //     artist.artistsId ?? 0)
                                            //     .then((_) async {
                                            //   await Get.find<ArtistsController>()
                                            //       .albumSongApi(
                                            //       artist.artistsId ?? 0)
                                            //       .then((_) {
                                            //     // Get.find<BaseController>().initialListOfBool(controller.tracksDataModel?.data?.length??0);
                                            //     Get.toNamed(
                                            //         RoutesName
                                            //             .songsAlbumsScreen,
                                            //         arguments: {
                                            //           'isGenre': false,
                                            //           'homeScreen': false
                                            //         });
                                            //   });
                                            // });
                                            Navigator.of(context).push(MaterialPageRoute(builder: (_)=>SongsAlbumsScreen(id: artist.artistsId ?? 0, type: 'Artists')));
                                            // Get.find<ArtistsController>().trackSongApi(artist.artistsId ?? 0).then((_){
                                            //   Get.find<ArtistsController>().albumSongApi(artist.artistsId ?? 0).then((_){
                                            //     Get.toNamed(RoutesName.songsAlbumsScreen);
                                            //   });
                                            // });
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
                                              image: artist.originalImage ?? '',
                                              width: 50.h,
                                              height: 50.h,
                                              fit: Platform.isAndroid
                                                  ? BoxFit.cover
                                                  : BoxFit.contain,
                                            ),
                                          ),
                                          title: AppTextWidget(
                                            txtTitle: artist.artistsName ?? '',
                                            txtColor: Colors.white,
                                          ),
                                          trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              color: AppColors.primary),
                                        );
                                      }).toList(),
                                      const Divider(color: Colors.grey),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ),
                          50.verticalSpace,
                        ],
                      ),
                    );
                  }),
              Obx(() => Visibility(
                  visible: Get.find<ArtistsController>().isLoading.value,
                  child: const AppLoder()))
            ],
          ),
        ),
      ),
    );
  }
}
