// // import 'package:newmusicappmachado/Controller/BaseController.dart';
// // import 'package:newmusicappmachado/Controller/HomeController.dart';
// // import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
// // import 'package:newmusicappmachado/Utils/Enums.dart';
// // import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
// // import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
// // import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
// // import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
// // import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
// // import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_screenutil/flutter_screenutil.dart';
// // import 'package:get/get.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// //
// // class HomeTrendingWidgets extends StatefulWidget {
// //   final List<FirstTrendingsData>? firstTrendingData;
// //
// //
// //   const HomeTrendingWidgets({super.key, required this.firstTrendingData});
// //
// //   @override
// //   State<HomeTrendingWidgets> createState() => _HomeTrendingWidgetsState();
// // }
// //
// // class _HomeTrendingWidgetsState extends State<HomeTrendingWidgets> {
// //   @override
// //   void initState() {
// //     Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>());
// //     // TODO: implement initState
// //
// //     super.initState();
// //   }
// //
// //   @override
// //
// //   Widget build(BuildContext context) {
// //     String? categoryName;
// //     return ListView.separated(
// //       separatorBuilder: (context,index){
// //         return
// //           GetBuilder<BaseController>(
// //             init: Get.find<BaseController>(),
// //             builder: (controller) {
// //               return index == 4 && (Get.find<BaseController>().isAdLoaded)?SizedBox(
// //                 height: 70.h,
// //                 width: double.maxFinite,
// //                 child: AdWidget(ad: Get.find<BaseController>().bannerAd),
// //               ): SizedBox.shrink();
// //             }
// //           );
// //       },
// //         shrinkWrap: true,
// //         padding: EdgeInsets.zero,
// //         physics: const ClampingScrollPhysics(),
// //         itemCount: widget.firstTrendingData?.length??0,
// //         itemBuilder: (context, index) {
// //           switch (TrendingSCategoryFor.values
// //               .firstWhere((e) => e.value == widget.firstTrendingData?[index].trendingscategoryFor)) {
// //             case TrendingSCategoryFor.artists:
// //               print("artists");
// //               return Stack(
// //                 children: [
// //
// //                   HomeArtistsWidget(
// //                     onViewAll: () {
// //                       Get.find<HomeController>().viewAllDataApi(trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId, type: widget.firstTrendingData?[index].trendingscategoryFor).then((_){
// //                         Get.toNamed(RoutesName.viewAllScreen,arguments: {
// //                           "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                           "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                         });
// //                       });
// //                     },
// //                     data: widget.firstTrendingData?[index].data,
// //                     trendingCategoryName:
// //                         widget.firstTrendingData?[index].trendingscategoryName,
// //                   ),
// //                   Obx(()=> Visibility(
// //                       visible: Get.find<HomeController>().isLoading.value,
// //                       child: AppLoder())),
// //                 ],
// //               );
// //             case TrendingSCategoryFor.genres:
// //               print("genres1");
// //               return Stack(
// //                 children: [
// //
// //                   HomeGenreWidget(
// //                     onViewAllTap: () {
// //                       Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                         Get.toNamed(RoutesName.viewAllScreen,arguments:{
// //                           "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                           "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                         });
// //                       });
// //                     },
// //                     trendingCategoryName:
// //                         widget.firstTrendingData?[index].trendingscategoryName,
// //                     data: widget.firstTrendingData?[index].data,
// //                   ),
// //                   Obx(()=>Visibility(
// //                       visible: Get.find<HomeController>().isLoading.value,
// //                       child: AppLoder())),
// //                 ],
// //               );
// //
// //             case TrendingSCategoryFor.radio:
// //               print("radio");
// //               return HomeRadioWidget(
// //
// //                 onViewAllTap: () {
// //                   Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                     Get.toNamed(RoutesName.viewAllScreen,arguments: {
// //                      "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                       "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                     });
// //                   });
// //                 },
// //                 trendingCategoryName:
// //                     widget.firstTrendingData?[index].trendingscategoryName,
// //                 data: widget.firstTrendingData?[index].data,
// //               );
// //             case TrendingSCategoryFor.tracks:
// //               print("tracks");
// //               return HomeTrackWidget(
// //                 onViewAllTap: () {
// //                   Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                     Get.toNamed(RoutesName.viewAllScreen,arguments:{
// //                       "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                       "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                     });
// //                   });
// //                 },
// //
// //                 trendingCategoryName:
// //                     widget.firstTrendingData?[index].trendingscategoryName,
// //                 data: widget.firstTrendingData?[index].data,
// //               );
// //             case TrendingSCategoryFor.mixes:
// //               print("mixes");
// //               return HomeMixesWidget(
// //                 onViewAllTap: () {
// //                   Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                     Get.toNamed(RoutesName.viewAllScreen,arguments:{
// //                       "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                       "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                     });
// //                   });
// //                 },
// //                 trendingCategoryName:
// //                     widget.firstTrendingData?[index].trendingscategoryName,
// //                 data: widget.firstTrendingData?[index].data,
// //
// //               );
// //             case TrendingSCategoryFor.albums:
// //               return HomeAlbumWidget(
// //                 onViewAllTap: () {
// //                   Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                     Get.toNamed(RoutesName.viewAllScreen,arguments:{
// //                       "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                       "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                     });
// //                   });
// //                 },
// //
// //                 trendingCategoryName:
// //                     widget.firstTrendingData?[index].trendingscategoryName,
// //                 data: widget.firstTrendingData?[index].data,
// //               );
// //               case TrendingSCategoryFor.playList:
// //               return HomePlaylistWidget(
// //                 onViewAllTap: () {
// //                   Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
// //                     Get.toNamed(RoutesName.viewAllScreen,arguments:{
// //                       "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
// //                       "titleName": widget.firstTrendingData?[index].trendingscategoryName
// //                     });
// //                   });
// //                 },
// //                 trendingCategoryName:
// //                     widget.firstTrendingData?[index].trendingscategoryName,
// //                 data: widget.firstTrendingData?[index].data, onPlaylistTap: () {  },
// //               );
// //             default:
// //               return SizedBox.shrink();
// //           }
// //         });
// //   }
// // }
//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// import 'package:newmusicappmachado/Controller/BaseController.dart';
// import 'package:newmusicappmachado/Controller/HomeController.dart';
// import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
// import 'package:newmusicappmachado/Utils/Enums.dart';
// import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
// import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
// import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
// import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
// import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
// import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
//
// class HomeTrendingWidgets extends StatefulWidget {
//   final List<FirstTrendingsData>? firstTrendingData;
//
//   const HomeTrendingWidgets({super.key, required this.firstTrendingData});
//
//   @override
//   State<HomeTrendingWidgets> createState() => _HomeTrendingWidgetsState();
// }
//
// class _HomeTrendingWidgetsState extends State<HomeTrendingWidgets> {
//   @override
//   void initState() {
//     super.initState();
//     // Get.find<BaseController>().googleAdsApi(
//     //   homeChopperService: AppChopperClient().getChopperService<HomeChopperService>(),
//     // );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // Prevents crash if data is empty
//     if (widget.firstTrendingData == null || widget.firstTrendingData!.isEmpty) {
//       return Center(
//         child: Text(
//           "No trending data available",
//           style: TextStyle(fontSize: 16),
//         ),
//       );
//     }
//
//     return ListView.separated(
//       shrinkWrap: true, // Ensures the ListView sizes correctly
//       physics: NeverScrollableScrollPhysics(), // Prevents nested scroll conflicts
//       padding: EdgeInsets.zero,
//       itemCount: widget.firstTrendingData?.length ?? 0,
//       separatorBuilder: (context, index) {
//         return GetBuilder<BaseController>(
//           init: Get.find<BaseController>(),
//           builder: (controller) {
//             return (index == 4)
//                 ? CommonAdWidget()
//                 : SizedBox.shrink();
//           },
//         );
//       },
//       itemBuilder: (context, index) {
//         return _buildTrendingWidget(index);
//       },
//     );
//   }
//
//   // Extracted method for better readability
//   Widget _buildTrendingWidget(int index) {
//     final data = widget.firstTrendingData?[index].data;
//     final name = widget.firstTrendingData?[index].trendingscategoryName;
//
//     switch (TrendingSCategoryFor.values
//               .firstWhere((e) => e.value == widget.firstTrendingData?[index].trendingscategoryFor)) {
//       case TrendingSCategoryFor.artists:
//         return HomeArtistsWidget(
//           onViewAll: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.genres:
//         return HomeGenreWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.radio:
//         return HomeRadioWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.tracks:
//         return HomeTrackWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.mixes:
//         return HomeMixesWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.albums:
//         return HomeAlbumWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//         );
//       case TrendingSCategoryFor.playList:
//         return HomePlaylistWidget(
//           onViewAllTap: () => _navigateToViewAll(index),
//           data: data,
//           trendingCategoryName: name,
//           onPlaylistTap: () {},
//         );
//       default:
//         return SizedBox.shrink();
//     }
//   }
//
//   // Extracted method for navigation logic
//   void _navigateToViewAll(int index) {
//     Get.find<HomeController>()
//         .viewAllDataApi(
//       trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId,
//       type: widget.firstTrendingData?[index].trendingscategoryFor,
//     )
//         .then((_) {
//       Get.toNamed(
//         RoutesName.viewAllScreen,
//         arguments: {
//           "trendingscategoryFor": widget.firstTrendingData?[index].trendingscategoryFor,
//           "titleName": widget.firstTrendingData?[index].trendingscategoryName,
//         },
//       );
//     });
//   }
// }
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Enums.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AdWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeAlbumWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeArtistsWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeGenresWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeMixesWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomePlaylistWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeRadioWidget.dart';
import 'package:newmusicappmachado/View/HomeScreen/Widgets/HomeTrackWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:newmusicappmachado/ViewAll/ViewAllHomeScreen.dart';
import 'package:newmusicappmachado/ViewAll/ViewAllScreen.dart';

class HomeTrendingWidgets extends StatefulWidget {
  final List<FirstTrendingsData>? firstTrendingData;


  const HomeTrendingWidgets({super.key, required this.firstTrendingData});

  @override
  State<HomeTrendingWidgets> createState() => _HomeTrendingWidgetsState();
}

class _HomeTrendingWidgetsState extends State<HomeTrendingWidgets> {
  @override
  void initState() {
    Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>());
    // TODO: implement initState

    // print("this is try${widget.firstTrendingData?[0].trendingscategoryName}");
    super.initState();
  }

  @override

  Widget build(BuildContext context) {
    String? categoryName;
    return ListView.separated(
        separatorBuilder: (context,index){
          return
            GetBuilder<BaseController>(
                init: Get.find<BaseController>(),
                builder: (controller) {
                  return index == 4 ?CommonAdWidget(): SizedBox.shrink();
                }
            );
        },
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.firstTrendingData?.length??0,
        itemBuilder: (context, index) {
          print("this is try${widget.firstTrendingData?[index].data == []}");
          print("this is try${widget.firstTrendingData?[index].trendingscategoryName}");

          switch (TrendingSCategoryFor.values
              .firstWhere((e) => e.value == widget.firstTrendingData?[index].trendingscategoryFor)) {
            case TrendingSCategoryFor.artists:
              print("artists");
              return widget.firstTrendingData?[index].data?.isNotEmpty??false?HomeArtistsWidget(
                onViewAll: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId, type: widget.firstTrendingData?[index].trendingscategoryFor).then((_){
                   if(mounted){
                     Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                       trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                       title: widget.firstTrendingData?[index].trendingscategoryName,
                     )));
                   }
                  });
                },
                data: widget.firstTrendingData?[index].data,
                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.genres:
              print("genres1");
              return widget.firstTrendingData?[index].data?.isNotEmpty??false? HomeGenreWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              ):SizedBox.shrink();

            case TrendingSCategoryFor.radio:
              print("radio");
              return widget.firstTrendingData?[index].data?.isNotEmpty??false? HomeRadioWidget(

                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.tracks:
              print("tracks");
              return widget.firstTrendingData?[index].data?.isNotEmpty??false?HomeTrackWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },

                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              ):SizedBox.shrink();
            case TrendingSCategoryFor.mixes:
              print("mixes");
              return widget.firstTrendingData?[index].data?.isNotEmpty??false? HomeMixesWidget(

                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,

              ):SizedBox.shrink();
            case TrendingSCategoryFor.albums:
              return HomeAlbumWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },

                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data,
              );
            case TrendingSCategoryFor.playList:
              return widget.firstTrendingData?[index].data?.isNotEmpty??false? HomePlaylistWidget(
                onViewAllTap: () {
                  Get.find<HomeController>().paginationForTrending =1;
                  Get.find<HomeController>().viewAllDataApi(type: widget.firstTrendingData?[index].trendingscategoryFor, trendingscategoryId: widget.firstTrendingData?[index].trendingscategoryId).then((_){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> ViewAllHomeScreen(
                      trendingscategoryFor: widget.firstTrendingData?[index].trendingscategoryFor,
                      title: widget.firstTrendingData?[index].trendingscategoryName,
                    )));
                  });
                },
                trendingCategoryName:
                widget.firstTrendingData?[index].trendingscategoryName,
                data: widget.firstTrendingData?[index].data, onPlaylistTap: () {  },
              ): SizedBox.shrink();
            default:
              return SizedBox.shrink();
          }
        });
  }
}