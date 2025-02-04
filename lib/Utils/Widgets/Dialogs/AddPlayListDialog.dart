import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AddPlaylistDialog extends StatelessWidget {
  final Function() onCreateNewPlayList;

  final Function() onAddToExisting;

  const AddPlaylistDialog({super.key, required this.onCreateNewPlayList, required this.onAddToExisting});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.w),
      child: AlertDialog(
        backgroundColor: AppColors.black,
        shape: const RoundedRectangleBorder(),
        contentPadding: EdgeInsets.zero,
        insetPadding: EdgeInsets.zero,
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppButtonWidget(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  onPressed: onCreateNewPlayList,
                  txtColor: AppColors.white,
                  btnName: "Create New PlayList".toUpperCase()),
              Divider(),
              AppButtonWidget(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  onPressed: onAddToExisting,
                  txtColor: AppColors.white,
                  btnColor: AppColors.transparent,
                  btnName: "Existing PlayList".toUpperCase()),
              Divider(),
              AppButtonWidget(
                width: double.maxFinite,
                 margin: EdgeInsets.symmetric(horizontal: 10.w),
                 padding: EdgeInsets.symmetric(vertical: 10.h),
                  txtColor: AppColors.black,
                  btnColor: AppColors.white,
                  onPressed: () {
                    Get.back();
                  },
                  btnName: "Cancel".toUpperCase()),
            ],
          ),
        ),
      ),
    );
  }
}
