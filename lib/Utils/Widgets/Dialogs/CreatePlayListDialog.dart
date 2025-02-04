import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CreatePlayListDialog extends StatelessWidget {
  final Function()? onCreateTap;
  const CreatePlayListDialog ({super.key, this.onCreateTap});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: AppColors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        title: Form(
          key: Get
              .find<MyLibraryController>()
              .formKey,
          child: Focus(
            child: AppTextFormField(
              showIcons: false,
              fillColor: AppColors.black,
              border: const UnderlineInputBorder(
                  borderSide: BorderSide(width: 1,color: AppColors.grey)
              ),
              txtAlign: TextAlign.center,
              validator: (value) {
                if (value == null || value
                    .trim()
                    .isEmpty) {
                  return 'Please enter a playlist name';
                }
                return null;
              },
              hintText: 'Playlist Name',
              textColor: AppColors.grey,
              hintTextColor: AppColors.grey,

              controller: Get.find<MyLibraryController>().textController,
            ),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButtonWidget(
              borderRadius: 5.r,
              width: double.maxFinite,
              height: 35.h,
              btnName: "Create Playlist",
              txtColor: AppColors.black,
              btnColor: AppColors.primary,
              onPressed: () {
                if (Get
                    .find<MyLibraryController>()
                    .formKey
                    .currentState
                    ?.validate() ?? false) {
                  // Handle playlist creation logic
                  Get
                      .find<MyLibraryController>().playListDataAddApi(playName: Get
                      .find<MyLibraryController>().textController.text).then((_){
                    onCreateTap!();
                  });
                }

              },
              // child: const AppTextWidget(txtTitle: 'Create Playlist',txtColor: AppColors.black,),
            ),
            20.verticalSpace,
            AppButtonWidget(
              borderRadius: 5.r,
              width: double.maxFinite,
              height: 35.h,
              btnName: "Cancel",
              txtColor: AppColors.black,
              btnColor: AppColors.primary,
              onPressed: () {
                Get.back();
                // if (Get
                //     .find<MyLibraryController>()
                //     .formKey
                //     .currentState
                //     ?.validate() ?? false) {
                //   // Handle playlist creation logic
                //   Get
                //       .find<MyLibraryController>().playListDataAddApi(playName: Get
                //       .find<MyLibraryController>().textController.text);

              },
              // child: const AppTextWidget(txtTitle: 'Create Playlist',txtColor: AppColors.black,),
            ),
          ],
        )

    );
  }
}
