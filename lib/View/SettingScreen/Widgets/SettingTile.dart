import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final bool isEditAccount;
  final String? imageUrl;
  final Function() onTap;
  const SettingTile(
      {super.key,
      this.title,
      this.subtitle,
      this.isEditAccount = false,
      required this.onTap,
      this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ListTile(
        onTap: onTap,
        leading: isEditAccount
            ? CachedNetworkImageWidget(
                image: imageUrl,
                height: 50.h,
                width: 50.h,
              )
            : AppTextWidget(
          fontSize: 15,
                txtTitle: title ?? '',
                fontWeight: FontWeight.w500,
              ),
        title: isEditAccount
            ? AppTextWidget(
                txtTitle: title ?? '',
                fontWeight: FontWeight.w500,
              )
            : null,
        subtitle: isEditAccount
            ? AppTextWidget(
                txtTitle: subtitle ?? '',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                txtColor: AppColors.primary,
              )
            : null,
        trailing: isEditAccount
            ? const Icon(
                Icons.settings,
                size: 35,
                color: AppColors.primary,
              )
            : Icon(
                Icons.navigate_next,
                size: 30,
                color: AppColors.darkgrey,
              ));
  }
}
