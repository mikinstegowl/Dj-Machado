import 'package:cached_network_image/cached_network_image.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';

class CachedNetworkImageWidget extends StatelessWidget {
  final String? image;
  final double? height;
  final double? width;

  const CachedNetworkImageWidget(
      {super.key, required this.image, this.height, this.width, this.fit});

  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: image ?? '',
      height: height,
      width: width,
      errorWidget: (context, url, error) =>
           Image.asset(
            AppAssets.placeHolderImage,
            height: height,
            fit: fit ?? BoxFit.cover,
          ),
      placeholder: (
        context,
        url,
      ) =>
          Image.asset(
        AppAssets.placeHolderImage,
        height: height,
        fit: fit ?? BoxFit.cover,
      ),
      fit: fit ?? BoxFit.cover,
    );
  }
}
