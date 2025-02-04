import 'dart:io';

import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppLoder extends StatelessWidget {
  const AppLoder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: double.maxFinite,
        width: double.maxFinite,
        color: Colors.black.withOpacity(0.3),
        child:  Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // CircularProgressIndicator()
              Platform.isIOS? const  CupertinoActivityIndicator(
                color: AppColors.primary,
              ):
             const CircularProgressIndicator.adaptive(
                valueColor: AlwaysStoppedAnimation<Color?>(AppColors.primary),
              )
            ]));
  }
}
