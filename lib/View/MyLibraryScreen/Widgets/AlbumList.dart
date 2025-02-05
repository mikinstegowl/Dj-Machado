import 'package:newmusicappmachado/Utils/Services/DatabaseService.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AlbumListWidget extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String dataLength;

  final Function() onMoreTap;
  const AlbumListWidget(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.dataLength,  required this.onMoreTap});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[900],
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Avatar Section
                Expanded(
                  flex: 5,
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: CachedNetworkImageWidget(
                            height: double.maxFinite,
                              width: double.maxFinite,
                              image: imageUrl),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: InkWell(
                            onTap: onMoreTap,
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(4),
                              child: const Icon(
                                Icons.more_horiz,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Title Section
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                    decoration: const BoxDecoration(
                        color: Colors.black,
                        border: Border(
                            top: BorderSide(color: AppColors.white, width: 2))),
                    child: AppTextWidget(
                      txtTitle: title,
                      txtColor: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.center,
                    )),
                // Label Section
              ],
            ),
          ),
        ),
      ],
    );
  }
}
