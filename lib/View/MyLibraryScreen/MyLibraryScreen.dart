import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/DownloadSong/AlbumDownloadWidget.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/DownloadSong/SongDownloadWidget.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/FavouriteWidget.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/Widgets/PlayListWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MyLibraryScreen extends StatefulWidget {
  const MyLibraryScreen({super.key});

  @override
  _MyLibraryScreenState createState() => _MyLibraryScreenState();
}

class _MyLibraryScreenState extends State<MyLibraryScreen> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onTabSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(

      child: Scaffold(
        extendBodyBehindAppBar: true,
        bottomSheet: AudioPlayerController(),
        bottomNavigationBar: BottomBarWidget(
          routeName: 'My Library',
          indx: 4,
          mainScreen: false,),
        backgroundColor: AppColors.darkgrey,
        appBar: CommonAppBar(title: "My Library",showBack: false),
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 50.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: GetBuilder<MyLibraryController>(
              init: Get.find<MyLibraryController>(),
              builder: (controller) {
                return Column(
                  children: [
                    // Custom Tab Bar
                    _buildCustomTabBar(),
      
                    // 20.verticalSpace,
                    // Page View with smooth animations
                    Expanded(
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (index) {
                          setState(() {
                            _selectedIndex = index;
                          });
                        },
                        children: [
                          DefaultTabController(
                              length: 2,
                              child: Column(mainAxisSize: MainAxisSize.min,
                                children: [
                                  TabBar(
                                      indicatorPadding:
                                          EdgeInsets.symmetric(horizontal: 5.w),
                                      indicatorWeight: 5,
                                      unselectedLabelColor: AppColors.white,
                                      indicatorColor: AppColors.primary,
                                      dividerColor: AppColors.transparent,
                                      indicatorSize: TabBarIndicatorSize.tab,
                                      labelColor: AppColors.primary,
                                      labelStyle: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16.sp),
                                      tabs: [
                                        Tab(
                                          text: 'SONGS'.toUpperCase(),
                                        ),
                                        Tab(
                                          text: 'Albums'.toUpperCase(),
                                        ),
                                      ]),
                                  const Expanded(
                                    child: TabBarView(children: [
                                      SongDownloadWidget(),
                                      AlbumDownloadWidget()
                                    ]),
                                  )
                                ],
                              )),
                          Obx(
                            () => Visibility(
                                visible: Get.find<MyLibraryController>()
                                    .isLoading
                                    .value,
                                replacement: StreamBuilder(
                                  stream: Connectivity().onConnectivityChanged,
                                  builder: (context,snap) {
                                    if (Get.find<BaseController>()
                                        .connectivityResult[0] ==
                                        ConnectivityResult.mobile ||
                                        Get.find<BaseController>()
                                            .connectivityResult[0] ==
                                            ConnectivityResult.wifi) {
                                      return PlayListWidget(
                                        playListDataModel:
                                        Get.find<MyLibraryController>()
                                            .playListDataModel,
                                      );
                                    }else {
                                      // print( Get.find<MyLibraryController>()
                                      //     .databaseDownloadPlayListSongList[0]["song_id"].toString().toIntList().toList().length);
                                      return
                                        Obx(()=> Get.find<MyLibraryController>()
                                            .databaseDownloadPlayListSongList.isNotEmpty? PlayListWidget(
                                          playListDataModel:
                                          PlayListDataModel(
                                              data: Get.find<MyLibraryController>()
                                                  .databaseDownloadPlayListSongList
                                                  .map((e) => PlayListData(
                                                songCount: e["song_id"].toString().toIntList().toList().length,
                                                playlistsName: e['playlist_name'],
                                                playlistImages1: e['imageUrl']
      
                                              ))
                                                  .toList()),
                                        ):Center(child: AppTextWidget(txtTitle: "No Data Found !")));
                                    }
                                  }
                                ),
                                child: const AppLoder()),
                          ),
                          Obx(()=>Visibility(
                              visible:
                              Get.find<MyLibraryController>().isLoading.value,
                              replacement: StreamBuilder(
                                stream: Connectivity().onConnectivityChanged,
                                builder: (context, snap) {
                                  if (Get.find<BaseController>()
                                      .connectivityResult[0] ==
                                      ConnectivityResult.mobile ||
                                      Get.find<BaseController>()
                                          .connectivityResult[0] ==
                                          ConnectivityResult.wifi) {
                                    return FavouriteWidget(
                                      favouriteSongDataModel:
                                      Get.find<MyLibraryController>()
                                          .favouriteSongDataModel,
                                    );
                                  } else {
                                    return
                                      Obx(()=>Get.find<BaseController>()
                                          .databaseFavouriteSongList.isNotEmpty? FavouriteWidget(
                                        favouriteSongDataModel:
                                        FavouriteSongDataModel(
                                            data: Get.find<BaseController>()
                                                .databaseFavouriteSongList
                                                .map((e) => MixesTracksData(
                                                favouritesStatus: e['favourite']==1?true:false,
                                                song: e['song'],
                                                songId: e['song_id'],
                                                songName: e['song_name'],
                                                songImage: e['song_image'],
                                                originalImage:
                                                e['song_image'],
                                                songArtist:
                                                e['artist_name']))
                                                .toList()),
                                      ):Center(child: AppTextWidget(txtTitle: "No Data Found !")));
                                  }
                                },
                              ),
                              child: const AppLoder())),
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Widget _buildCustomTabBar() {
    return Container(
      width: double.maxFinite,
      color: Colors.black,
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Download Tab
          _buildTabItem(
            onTap: () {},
            index: 0,
            label: 'Download',
            icon: Icons.download,
          ),
          // Playlist Tab
          _buildTabItem(
            onTap: () {
              Get.find<BaseController>().connectivityResult[0] ==
                      ConnectivityResult.none
                  ? null
                  : Get.find<MyLibraryController>().playListDataApi();
            },
            index: 1,
            label: 'Playlist',
            icon: Icons.playlist_add,
          ),
          // Favorite Tab
          _buildTabItem(
            onTap: () {
              log("message");
              Get.find<BaseController>().connectivityResult[0] ==
                      ConnectivityResult.none
                  ? null
                  : Get.find<MyLibraryController>().favouriteSongDataApi();
            },
            index: 2,
            label: 'Favorites',
            icon: Icons.favorite_border,
          ),
        ],
      ),
    );
  }

  Widget _buildTabItem({
    required int index,
    required String label,
    required Function() onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        onTap();
        _onTabSelected(index);
      },
      child: Container(
        width: 145.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Indicator Animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.maxFinite,
              height: 3,
              color:
                  _selectedIndex == index ? AppColors.primary : AppColors.black,
              margin: const EdgeInsets.only(bottom: 4),
            ),
            5.verticalSpace,
            Container(
              width: 145.w,
              // duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: _selectedIndex == index
                    ? AppColors.primary
                    : AppColors.white,
                borderRadius: BorderRadius.circular(5.r),
              ),
              child: Center(
                child: Text(
                  label,
                  style: TextStyle(
                    color: _selectedIndex == index
                        ? Colors.black
                        : AppColors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            5.verticalSpace,
            // Icon at the bottom
            Icon(
              icon,
              color: AppColors.white,
              size: 30.r,
            )
          ],
        ),
      ),
    );
  }
}
