import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newmusicappmachado/Bindings/BaseBindings.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Services/PlayerService.dart';
import 'package:newmusicappmachado/Utils/Services/firebase_notification_service.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Router/GetxRouter.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/MyLibraryScreen.dart';
import 'package:newmusicappmachado/firebase_options.dart';
//
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
MobileAds.instance.initialize();
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.example.just_audio.channel.audio',
    androidNotificationChannelName: 'Music Playback',
    androidNotificationOngoing: false,
     // androidNotificationIcon: 'drawable/ic_icon'
    // Customizing notification actions (removing "remove song" button
  );
  Get.lazyPut(()=> BaseController(),fenix: true);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await  FirebaseNotificationManager().init();
  // final a = await FirebaseMessaging.instance.getAPNSToken();
  // print("this is apns token${a}");
  await UserPreference.initSharedPrefs();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget{
  const MyApp({super.key});
  static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static  FirebaseAnalyticsObserver getAnalyticObserver()=> FirebaseAnalyticsObserver(analytics: analytics);


  @override
  State<MyApp> createState() => _MyAppState();
}


class _MyAppState extends State<MyApp>  with WidgetsBindingObserver{

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    MyApp.analytics.setAnalyticsCollectionEnabled(true);
    _logAppOpen();
    // TODO: implement initState
    super.initState();
  }
  Future<void> _logAppOpen() async {
    await MyApp.analytics.logAppOpen(parameters: {
      'app_open': "yes"
    }).then((_){
      print("App open event logged.");
    });

  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // TODO: implement dispose
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {

      // Stop audio playback explicitly when the app is killed
      PlayerService.instance.audioPlayer.stop();
    }
  }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ConnectivityResult>>(
      stream: Connectivity().onConnectivityChanged,
      builder: (context1, snapshot) {
        // Check the network status
        if (snapshot.hasData) {
          Get.find<BaseController>().connectivityResult = snapshot.data!;
          print(Get.find<BaseController>().connectivityResult[0]);
          if (Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.mobile ||
              Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.wifi) {
            // Online screen
            return ScreenUtilInit(
                designSize: const Size(448, 973.3333333333334),
                builder: (_, child) {
                  return GetMaterialApp(
                    initialBinding: BaseBindings(),
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: generateRoute,
                    defaultTransition: Transition.noTransition,
                    navigatorObservers: [
                      MyApp.getAnalyticObserver()
                    ],
                    initialRoute:
                    UserPreference.getValue(key: PrefKeys.firstTime)==null?RoutesName.introScreen :
                        UserPreference.getValue(key: PrefKeys.logInToken) !=
                                null
                            ? RoutesName.homeScreen
                            : RoutesName.logInScreen,
                  );
                });
          } else {
            Get.find<BaseController>().selectedIndex.value = 4;
            return
              ScreenUtilInit(
                designSize: const Size(448, 973.3333333333334),
                builder: (_, child) {
                  return GetMaterialApp(
                    initialBinding: BaseBindings(),
                    debugShowCheckedModeBanner: false,
                    onGenerateRoute: generateRoute,
                    builder: (context, child) {
                      Future.microtask(() {
                        if (Get.find<BaseController>().connectivityResult[0] == ConnectivityResult.none) {
                          Get.offAllNamed(RoutesName.myLibraryScreen);
                        }
                        Get.dialog(
                            AlertDialog(
                              backgroundColor: Colors.black,

                              content: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(AppAssets.logo),
                                  30.verticalSpace,
                                  AppTextWidget(txtTitle: "Try Again",txtColor: AppColors.primary,),
                                  30.verticalSpace,
                                  AppTextWidget(txtTitle: "You are not connected to the Internet and can only play download music.",textAlign: TextAlign.center,),
                                  30.verticalSpace,
                                  AppButtonWidget(
                                    // width: 250.w,
                                    padding: EdgeInsets.symmetric(vertical: 10.h),
                                    onPressed: (){
                                      Get.back();
                                      // Get.offAllNamed(RoutesName.myLibraryScreen);
                                      Get.find<BaseController>().update();
                                      // RoutesName.bottomBarScreen;
                                    }, btnName: "",
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.download,color: AppColors.white,),
                                        10.horizontalSpace,
                                        AppTextWidget(txtTitle: "GO TO OFFLINE MUSIC")
                                      ],
                                    ),
                                    btnColor: AppColors.primary,
                                  )
                                ],
                              ),
                            )
                        );
                      });
                      return child!;
                    },
                    initialRoute:RoutesName.myLibraryScreen,
                  );
                });
          }
        } return SizedBox.shrink();
      },
    );
  }
}
// class MyApp extends StatefulWidget {
//   const MyApp({super.key});
//   static final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
//   static FirebaseAnalyticsObserver getAnalyticObserver() =>
//       FirebaseAnalyticsObserver(analytics: analytics);
//
//   @override
//   State<MyApp> createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//   final BaseController baseController = Get.find<BaseController>();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     MyApp.analytics.setAnalyticsCollectionEnabled(true);
//     _logAppOpen();
//   }
//
//   Future<void> _logAppOpen() async {
//     await MyApp.analytics.logAppOpen(parameters: {'app_open': "yes"}).then((_) {
//       print("App open event logged.");
//     });
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.detached) {
//       PlayerService.instance.audioPlayer.stop();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<ConnectivityResult>>(
//       stream: Connectivity().onConnectivityChanged,
//       builder: (context1, snapshot) {
//         if (snapshot.hasData) {
//           Get.find<BaseController>().connectivityResult = [snapshot.data!];
//
//           if (snapshot.data == ConnectivityResult.mobile || snapshot.data == ConnectivityResult.wifi) {
//             // Online screen
//             return ScreenUtilInit(
//               designSize: const Size(448, 973.3333333333334),
//               builder: (_, child) {
//                 return GetMaterialApp(
//                   initialBinding: BaseBindings(),
//                   debugShowCheckedModeBanner: false,
//                   onGenerateRoute: generateRoute,
//                   initialRoute: UserPreference.getValue(key: PrefKeys.firstTime) == null
//                       ? RoutesName.introScreen
//                       : UserPreference.getValue(key: PrefKeys.logInToken) != null
//                       ? RoutesName.homeScreen
//                       : RoutesName.logInScreen,
//                 );
//               },
//             );
//           } else {
//             // Offline screen
//             Get.find<BaseController>().selectedIndex.value = 4;
//             return ScreenUtilInit(
//               designSize: const Size(448, 973.3333333333334),
//               builder: (_, child) {
//                 return GetMaterialApp(
//                   initialBinding: BaseBindings(),
//                   debugShowCheckedModeBanner: false,
//                   onGenerateRoute: generateRoute,
//                   initialRoute: RoutesName.myLibraryScreen,
//                   builder: (context, child) {
//                     Future.microtask(() {
//                       if (snapshot.data == ConnectivityResult.none) {
//                         Get.offAllNamed(RoutesName.myLibraryScreen);
//                       }
//                       Get.dialog(
//                         AlertDialog(
//                           backgroundColor: Colors.black,
//                           content: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Image.asset(AppAssets.logo),
//                               30.verticalSpace,
//                               AppTextWidget(txtTitle: "Try Again", txtColor: AppColors.primary),
//                               30.verticalSpace,
//                               AppTextWidget(
//                                 txtTitle:
//                                 "You are not connected to the Internet and can only play downloaded music.",
//                                 textAlign: TextAlign.center,
//                               ),
//                               30.verticalSpace,
//                               AppButtonWidget(
//                                 padding: EdgeInsets.symmetric(vertical: 10.h),
//                                 onPressed: () {
//                                   Get.back();
//                                   Get.offAllNamed(RoutesName.myLibraryScreen);
//                                   Get.find<BaseController>().update();
//                                 },
//                                 btnName: "",
//                                 child: Row(
//                                   mainAxisSize: MainAxisSize.min,
//                                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                   children: [
//                                     Icon(Icons.download, color: AppColors.white),
//                                     10.horizontalSpace,
//                                     AppTextWidget(txtTitle: "GO TO OFFLINE MUSIC")
//                                   ],
//                                 ),
//                                 btnColor: AppColors.primary,
//                               ),
//                             ],
//                           ),
//                         ),
//                         barrierDismissible: false,
//                       );
//                     });
//                     return child!;
//                   },
//                 );
//               },
//             );
//           }
//         }
//         return const Center(child: CircularProgressIndicator());
//       },
//     );
//
//   }
// }
