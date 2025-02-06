import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';

class CommonAdWidget extends StatefulWidget {
  const CommonAdWidget({super.key});

  @override
  State<CommonAdWidget> createState() => _CommonAdWidgetState();
}

class _CommonAdWidgetState extends State<CommonAdWidget> {
  BannerAd? _bannerAd;

  @override
  void initState() {
    super.initState();
    Get.find<BaseController>().googleAdsApi(homeChopperService: AppChopperClient().getChopperService<HomeChopperService>()).then((_){
      _initializeAd();
    });
  }

  void _initializeAd() {
    final controller = Get.find<BaseController>();

    // Dispose existing ad before creating a new one
    _bannerAd?.dispose();
    _bannerAd = BannerAd(
      size: AdSize.banner,
      adUnitId: controller.googleAdsModel?.data?.first.androidKey??"", // Use your Ad Unit ID
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        },
      ),
      request: AdRequest(),
    );
    _bannerAd?.load();
    print("this ad ${_bannerAd?.adUnitId}");
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd == null
        ? SizedBox.shrink() // Hide if ad is not available
        : SizedBox(
      height: 70,
      width: double.infinity,
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
