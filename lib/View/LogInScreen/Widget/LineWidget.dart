import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LineWidget extends StatelessWidget {
  const LineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 70.w,
        height: 40,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Divider(
              thickness: 2,
              height: 8,
              color: AppColors.newdarkgrey,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                height: 8,
                thickness: 2,
                color: AppColors.newdarkgrey,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 2,
                color: AppColors.newdarkgrey,
                height: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
