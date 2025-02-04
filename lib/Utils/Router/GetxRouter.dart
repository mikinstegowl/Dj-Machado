import 'package:newmusicappmachado/Bindings/ArtistsBinding.dart';
import 'package:newmusicappmachado/Bindings/AuthBinding.dart';
import 'package:newmusicappmachado/Bindings/BaseBindings.dart';
import 'package:newmusicappmachado/Bindings/ExplorBinding.dart';
import 'package:newmusicappmachado/Bindings/HomeBinding.dart';
import 'package:newmusicappmachado/Bindings/MixesBinding.dart';
import 'package:newmusicappmachado/Bindings/MyLibraryBinding.dart';
import 'package:newmusicappmachado/Bindings/ProfileBindings.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/View/AdvanceSearch/AdvanceSearch.dart';
import 'package:newmusicappmachado/View/AlbumTrackScreen/AlbumTrackScreen.dart';
import 'package:newmusicappmachado/View/AppBottomBar/AppBottomBar.dart';
import 'package:newmusicappmachado/View/AppBottomBar/Widget/QueueScreenWidget.dart';
import 'package:newmusicappmachado/View/ArtistsScreen/ArtistsScreen.dart';
import 'package:newmusicappmachado/View/ChangePasswordScreen/ChangePasswordScreen.dart';
import 'package:newmusicappmachado/View/EditProfileScreen/EditProfileScreen.dart';
import 'package:newmusicappmachado/View/ExplorScreen/ExplorScreen.dart';
import 'package:newmusicappmachado/View/ForgotPasswordScreen/ForgotPasswordScreen.dart';
import 'package:newmusicappmachado/View/HomeScreen/HomeScreen.dart';
import 'package:newmusicappmachado/View/IntroductionSliderScreen/IntroductionSliderScreen.dart';
import 'package:newmusicappmachado/View/LogInScreen/LogInScreen.dart';
import 'package:newmusicappmachado/View/MixesScreen/MixesScreen.dart';
import 'package:newmusicappmachado/View/MixesScreen/SubScreen/MixesSongScreen.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/MyLibraryScreen.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/SubScreen/OfflineAlbumDetailScreen.dart';
import 'package:newmusicappmachado/View/MyLibraryScreen/SubScreen/PlayListDetalView.dart';
import 'package:newmusicappmachado/View/NotificationScreen/NotificationScreen.dart';
import 'package:newmusicappmachado/View/SelectGenresScreen/SelectGenresScreen.dart';
import 'package:newmusicappmachado/View/SettingScreen/SettingScreen.dart';
import 'package:newmusicappmachado/View/SignUpScreen/SignUpScreen.dart';
import 'package:newmusicappmachado/View/SongsAlbumsScreen/SongsAlbumsScreen.dart';
import 'package:newmusicappmachado/View/TermsAndPrivacyScreen/TermsAndPrivacyScreen.dart';
import 'package:newmusicappmachado/View/ViewProfileScreen/ViewProfileScreen.dart';
import 'package:newmusicappmachado/ViewAll/ViewAllRecentPlayedScreen.dart';
import 'package:newmusicappmachado/ViewAll/ViewAllScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RoutesName.logInScreen:
      return getPageRoutes(
          routeName: RoutesName.logInScreen,
          page: () => const LogInScreen(),
          settings: settings,
          bindings: [
            AuthBinding(),
            Homebinding(),
            ExplorBinding(),
          ]);
    case RoutesName.signUpScreen:
      return getPageRoutes(
          routeName: RoutesName.signUpScreen,
          page: () => const SignUpScreen(),
          settings: settings,
          bindings: [
            AuthBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.selectGenresScreen:
      return getPageRoutes(
          routeName: RoutesName.selectGenresScreen,
          page: () => const SelectGenresScreen(),
          settings: settings,
          bindings: [
            Homebinding(),
            ArtistsBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.homeScreen:
      return getPageRoutes(
          routeName: RoutesName.homeScreen,
          page: () => const HomeScreen(),
          settings: settings,
          bindings: [
            Homebinding(),
            MixesBinding(),
            ArtistsBinding(),
            ExplorBinding(),
            ProfileBindings(),
            MyLibraryBinding(),
            BaseBindings()
          ]);
    case RoutesName.advanceSearchScreen:
      return getPageRoutes(
          routeName: RoutesName.advanceSearchScreen,
          page: () => const AdvanceSearch(),
          settings: settings,
          bindings: [
            Homebinding(),
            ArtistsBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.settingScreen:
      return getPageRoutes(
          routeName: RoutesName.settingScreen,
          page: () => const SettingScreen(),
          settings: settings,
          bindings: [
            Homebinding(),
            ArtistsBinding(),
            ExplorBinding(),
            ProfileBindings(),

          ]);
    case RoutesName.viewProfileScreen:
      return getPageRoutes(
          routeName: RoutesName.viewProfileScreen,
          page: () => const ViewProfileScreen(),
          settings: settings,
          bindings: [Homebinding(), ArtistsBinding()]);
    case RoutesName.songsAlbumsScreen:
      return getPageRoutes(
          routeName: RoutesName.songsAlbumsScreen,
          page: () => const SongsAlbumsScreen(),
          settings: settings,
          bindings: [Homebinding(), ArtistsBinding(), ExplorBinding()]);
    case RoutesName.editProfileScreen:
      return getPageRoutes(
          routeName: RoutesName.editProfileScreen,
          page: () => const EditProfileScreen(),
          settings: settings,
          bindings: [
            Homebinding(),
            ArtistsBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.mixesSongScreen:
      return getPageRoutes(
          routeName: RoutesName.mixesSongScreen,
          page: () => const MixesSongScreen(),
          settings: settings,
          bindings: [
            MixesBinding(),
            ArtistsBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.albumTrackScreen:
      return getPageRoutes(
          routeName: RoutesName.albumTrackScreen,
          page: () => const AlbumTrackScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            ExplorBinding(),
          ]);
    case RoutesName.bottomBarScreen:
      return getPageRoutes(
          routeName: RoutesName.bottomBarScreen,
          page: () => const AppBottomBar(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding(),
          ]);
    case RoutesName.offlineAlbumDetailScreen:
      return getPageRoutes(
          routeName: RoutesName.offlineAlbumDetailScreen,
          page: () => const OfflineAlbumDetailScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
          ]);
    case RoutesName.playListDetailView:
      return getPageRoutes(
          routeName: RoutesName.playListDetailView,
          page: () => const PlayListDetailView(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
          ]);
    case RoutesName.viewAllScreen:
      return getPageRoutes(
          routeName: RoutesName.viewAllScreen,
          page: () => const ViewAllScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
          ]);
    case RoutesName.exploreScreen:
      return getPageRoutes(
          routeName: RoutesName.exploreScreen,
          page: () => const ExplorScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding()
          ]);
    case RoutesName.mixesScreen:
      return getPageRoutes(
          routeName: RoutesName.mixesScreen,
          page: () => const MixesScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding()
          ]);
    case RoutesName.artistsScreen:
      return getPageRoutes(
          routeName: RoutesName.artistsScreen,
          page: () => const ArtistsScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding()
          ]);
    case RoutesName.myLibraryScreen:
      return getPageRoutes(
          routeName: RoutesName.myLibraryScreen,
          page: () => const MyLibraryScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding()
          ]);
    case RoutesName.viewAllRecentPlayedScreen:
      return getPageRoutes(
          routeName: RoutesName.viewAllRecentPlayedScreen,
          page: () => const ViewAllRecentPlayedScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
          ]);
    case RoutesName.cueScreen:
      return getPageRoutes(
          routeName: RoutesName.cueScreen,
          page: () => const QueueScreenWidget(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding(),
          ]);
    case RoutesName.changePasswordScreen:
      return getPageRoutes(
          routeName: RoutesName.changePasswordScreen,
          page: () => const ChangePasswordScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding(),
            ProfileBindings()
          ]);
    case RoutesName.notificationScreen:
      return getPageRoutes(
          routeName: RoutesName.notificationScreen,
          page: () => const NotificationScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding(),
            ProfileBindings()
          ]);
    case RoutesName.forgotPasswordScreen:
      return getPageRoutes(
          routeName: RoutesName.forgotPasswordScreen,
          page: () => const ForgotPasswordScreen(),
          settings: settings,
          bindings: [
            ArtistsBinding(),
            Homebinding(),
            ExplorBinding(),
            MixesBinding(),
            MyLibraryBinding(),
            ProfileBindings()
          ]);
    case RoutesName.termsAndPrivacyScreen:
      return getPageRoutes(
          routeName: RoutesName.termsAndPrivacyScreen,
          page: () => const TermsAndPrivacyScreen(),
          settings: settings,
          bindings: [Homebinding()]);
    case RoutesName.introScreen:
      return getPageRoutes(
          routeName: RoutesName.introScreen,
          page: () => const IntroductionSliderScreen(),
          settings: settings,
          bindings: [Homebinding(), AuthBinding()]);
    default:
      return getPageRoutes(
          routeName: RoutesName.logInScreen,
          page: () => const LogInScreen(),
          settings: settings,
          bindings: [AuthBinding()]);
  }
}

PageRoute getPageRoutes(
    {required String routeName,
    required Function page,
    required RouteSettings settings,
    List<Bindings>? bindings}) {
  return GetPageRoute(
      page: () => page(),
      routeName: routeName,
      settings: settings,
      bindings: bindings);
}
