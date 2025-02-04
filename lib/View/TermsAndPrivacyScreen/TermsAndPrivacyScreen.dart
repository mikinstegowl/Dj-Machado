import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

class TermsAndPrivacyScreen extends GetView<BaseController> {
  const TermsAndPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(controller.termsAndPrivacyDataModel?.data?.first.title);
    return Scaffold(
      appBar: CommonAppBar(
        searchBarShow: false,
        title: controller.termsAndPrivacyDataModel?.data?.first.title??'',
      ),
      body: Container(
        padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 20.h),
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage(AppAssets.backGroundImage))),

        child: Column(mainAxisSize: MainAxisSize.min,
          children: [
            HtmlWidget(
                controller.termsAndPrivacyDataModel?.data?.first.description??'',

            ),
          ],
        ),
      ),
    );
  }
}
