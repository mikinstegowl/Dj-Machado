import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Models/AdvanceSearchSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/RecentSeachDataModel.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/RecentSearchWidget.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/Widgets/AlbumList.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/Widgets/ArtistsList.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/Widgets/PlaylistList.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/Widgets/SongsList.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AdvanceSearch extends GetView<AdvanceSearchController> {
  const AdvanceSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // extendBody: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: AppColors.transparent,
          title: const AppTextWidget(
            txtTitle: "Search",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
          leadingWidth: 120.w,
          leading: Row(
            children: [
              InkWell(
                onTap: () {
                  controller.advanceSearchController.clear();
                  controller.advanceSearchSongDataModel.value =
                      AdvanceSearchSongDataModel(data: []);
                  controller.recentSearchDataModel = RecentSearchDataModel(
                      recentList: [], trendinglistData: []);
                  controller.update();
                  Get.back();
                },
                child: Row(
                  children: [
                    Image.asset(
                      height: 25.h,
                      width: 25.h,
                      AppAssets.backIcon,
                      // size: 28.r,
                      color: AppColors.white,
                    ),
                    const AppTextWidget(
                      fontWeight: FontWeight.w600,
                      txtTitle: "Back",
                      txtColor: AppColors.white,
                      fontSize: 18,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: const BottomBarWidget(
          mainScreen: false,
        ),
        extendBodyBehindAppBar: true,
        backgroundColor: AppColors.darkgrey,
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 10.h),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(AppAssets.backGroundImage))),
          child: GetBuilder<AdvanceSearchController>(
              init: controller,
              builder: (controller) {
                return SingleChildScrollView(
                  primary: true,
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 10.h),
                        child: AppTextFormField(
                          showIcons: false,
                          fillColor: AppColors.black,
                          textColor: AppColors.white,
                          controller: controller.advanceSearchController,
                          prefixIcon: Icon(
                            Icons.search,
                            color: AppColors.primary,
                            size: 30.r,
                          ),
                          suffixWidget: InkWell(
                            onTap: () {
                              if (controller
                                  .advanceSearchController.text.isNotEmpty) {
                                // controller.advanceSearchController.clear();
                                controller.advanceSearchSongDataModel.value =
                                    null;
                                controller.recentSearch();
                                controller.update();
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5.w, vertical: 3.h),
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.darkgrey,
                                borderRadius: BorderRadius.circular(5.r),
                              ),
                              child: AppTextWidget(
                                txtTitle:
                                    controller.advanceSearchController.text !=
                                            ''
                                        ? "Clear".toUpperCase()
                                        : 'Search'.toUpperCase(),
                                fontSize: 12,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (value != '') {
                              controller.debounce(
                                () async {
                                  controller.showLoader(true);
                                  await controller
                                      .advanceSearchApi(0)
                                      .then((_) {
                                    controller.showLoader(false);
                                  });
                                },
                              );
                            } else {
                              controller.advanceSearchSongDataModel.value =
                                  null;
                              controller.recentSearch();
                            }
                          },
                          hintText: "Search",
                          hintTextColor: AppColors.white,
                          borderRadious: 5.r,
                        ),
                      ),
                      10.verticalSpace,
                      Obx(() => Visibility(
                            visible:
                                controller.advanceSearchSongDataModel.value ==
                                    null,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10.w, vertical: 10.h),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  RecentSearchWidget(
                                    title: "Recent Search",
                                    trendinglistData: controller
                                        .recentSearchDataModel?.recentList,
                                  ),
                                  RecentSearchWidget(
                                    title: "Trending Search",
                                    trendinglistData: controller
                                        .recentSearchDataModel
                                        ?.trendinglistData,
                                  ),
                                ],
                              ),
                            ),
                          )),
                      Obx(() => Visibility(
                          visible:
                              controller.advanceSearchSongDataModel.value !=
                                  null,
                          child: DefaultTabController(
                            length: 4,
                            initialIndex: 0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TabBar(
                                    onTap: (value) async {
                                      await controller.advanceSearchApi(value);
                                    },
                                    indicatorPadding:
                                        EdgeInsets.symmetric(horizontal: 5.w),
                                    indicatorWeight: 5,
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
                                        text: 'Artists'.toUpperCase(),
                                      ),
                                      Tab(
                                        text: 'Albums'.toUpperCase(),
                                      ),
                                      Tab(
                                        text: 'Playlist'.toUpperCase(),
                                      ),
                                    ]),
                                SizedBox(
                                    height: double.maxFinite,
                                    child: TabBarView(
                                      children: [
                                        controller.advanceSearchSongDataModel
                                                    .value?.data?.isNotEmpty ??
                                                false
                                            ? SongsList(
                                                data: controller
                                                    .advanceSearchSongDataModel
                                                    .value
                                                    ?.data,
                                              )
                                            : const Align(
                                                alignment: Alignment.topCenter,
                                                child: AppTextWidget(
                                                    txtTitle: "No Data Found"),
                                              ),
                                        controller.advanceSearchSongDataModel
                                                    .value?.data?.isNotEmpty ??
                                                false
                                            ? ArtistsList(
                                                data: controller
                                                    .advanceSearchSongDataModel
                                                    .value
                                                    ?.data,
                                              )
                                            : const Align(
                                                alignment: Alignment.topCenter,
                                                child: AppTextWidget(
                                                    txtTitle: "No Data Found"),
                                              ),
                                        controller.advanceSearchSongDataModel
                                                    .value?.data?.isNotEmpty ??
                                                false
                                            ? AlbumList(
                                                data: controller
                                                    .advanceSearchSongDataModel
                                                    .value
                                                    ?.data,
                                              )
                                            : const Align(
                                                alignment: Alignment.topCenter,
                                                child: AppTextWidget(
                                                    txtTitle: "No Data Found"),
                                              ),
                                        controller.advanceSearchSongDataModel
                                                    .value?.data?.isNotEmpty ??
                                                false
                                            ? PlayListList(
                                                data: controller
                                                    .advanceSearchSongDataModel
                                                    .value
                                                    ?.data,
                                              )
                                            : const Align(
                                                alignment: Alignment.topCenter,
                                                child: AppTextWidget(
                                                    txtTitle: "No Data Found"),
                                              ),
                                      ],
                                    )),
                                10.verticalSpace
                              ],
                            ),
                          ))),
                    ],
                  ),
                );
              }),
        ),
      ),
    );
  }
}
