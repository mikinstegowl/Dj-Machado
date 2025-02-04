import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/AudioPlayerController.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/BottomBarWidget.dart';
import 'package:newmusicappmachado/View/ArtistsScreen/ArtistsScreen.dart';
import 'package:newmusicappmachado/View/ExplorScreen/ExplorScreen.dart';
import 'package:newmusicappmachado/View/HomeScreen/HomeScreen.dart';
import 'package:newmusicappmachado/View/MixesScreen/MixesScreen.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/MyLibraryScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({super.key});

  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  int _selectedIndex = 0;

  // List of pages to display for each menu item

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder(
          init: Get.find<BaseController>(),
          builder: (controller) {
            return Scaffold(
              extendBody: true,
              body: controller.pages[controller.selectedIndex.value],
              bottomSheet: const AudioPlayerController(),
              // Display the selected page
              bottomNavigationBar:const BottomBarWidget(),
            );
          }),
    );
  }
}
