import 'dart:developer';
import 'dart:io';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class ExplorController extends BaseController {
  late HomeChopperService _homeChopperService;

  ExplorController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  ExplorDataModel? explorDataModel;
  bool shuffle = false;
  int  paginationInt = 1;

  ScrollController scrollController = ScrollController();
  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener((){
      scrollListener();
    });
  }


  int? maxPages;
  Future<void> scrollListener() async {
    print("client ${scrollController.hasClients}");
    if (scrollController.hasClients) {
      print("ture sate ${scrollController.position.pixels == scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        print("max ${paginationInt < maxPages!}");
        print("max ${maxPages!}");
        if (paginationInt < maxPages!) {
          paginationInt++;
          print(paginationInt);
          await explorScreenApi(); // Fetch next page
        }
      }
    }
  }

  Future<void> explorScreenApi() async {
    showLoader(true);
    try {
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "shuffle": shuffle ? "MenuRefresh" : "OpenClose",
        "categorylimit": 30,
        "page": paginationInt
      };
      final response = await _homeChopperService.exploreApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        shuffle = true;
        explorDataModel = response.body;
        maxPages = explorDataModel?.lastPage;
        showLoader(false);
        update();
      } else {
        showLoader(false);
        update();
        Get.snackbar('Error', response.body?.message ?? '');
      }
    } catch (e) {
      showLoader(false);
      update();
      log('', name: "Explor Api Error", error: e.toString());
    }
  }

  TracksDataModel? songsTracksDataModel;

  Future<void> selectedGenreSongsApi(int genresId) async {
    try {
      showLoader(true);

      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Genres",
        "recordtype": "Tracks",
        "genres_id": genresId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        songsTracksDataModel = response.body;
        showLoader(false);
        update();
      } else {
        songsTracksDataModel = null;
        showLoader(false);
        update();
      }
      update();
    } catch (e) {
      log('', error: e.toString(), name: "Selected Genre Api Data Error");
    }
  }

  TracksDataModel? albumTracksDataModel;

  Future<void> selectedGenreAlbumApi(int genresId) async {
    try {
      showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Genres",
        "recordtype": "Albums",
        "genres_id": genresId,
        "page": 1,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        albumTracksDataModel = response.body;
        showLoader(false);
        update();
      } else {
        albumTracksDataModel = null;
        showLoader(false);
        update();
      }
      update();
    } catch (e) {
      showLoader(false);
      update();
      log('', error: e.toString(), name: "Selected Genre Api Data Error");
    }
  }
  // Future<String> getInternalDirectory() async {
  //   // Get the application's document directory
  //   Directory appDocDir = await getApplicationDocumentsDirectory();
  //
  //   // Create a custom subdirectory
  //   String customPath = "${appDocDir.path}/Songs";
  //   Directory customDir = Directory(customPath);
  //
  //   if (!customDir.existsSync()) {
  //     customDir.createSync(recursive: true);
  //   }
  //
  //   return customDir.path;
  // }

  // Future<void> downloadSong() async {
  //
  //     isDownloading = true;
  //
  //
  //   try {
  //     // Get the internal directory path
  //     String customDirPath = await getInternalDirectory();
  //     String filePath = "$customDirPath/$_fileName";
  //
  //     // Make an HTTP request and download the file
  //     final response = await http.get(Uri.parse(_sampleSongUrl));
  //
  //     // Check if the response is successful
  //     if (response.statusCode == 200) {
  //       final file = File(filePath);
  //       // Save the file
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       // setState(() {
  //         _customFilePath = filePath;
  //         _isDownloading = false;
  //       // });
  //
  //       // Optionally, play the song after downloading
  //       // _playSong(filePath);
  //
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text("Download complete: $filePath")),
  //       // );
  //     } else {
  //       // setState(() {
  //         _isDownloading = false;
  //       // });
  //       // ScaffoldMessenger.of(context).showSnackBar(
  //       //   SnackBar(content: Text("Failed to download file")),
  //       // );
  //     }
  //   } catch (e) {
  //     // setState(() {
  //       _isDownloading = false;
  //     // });
  //     // ScaffoldMessenger.of(context).showSnackBar(
  //     //   SnackBar(content: Text("Error downloading file: $e")),
  //     // );
  //   }
  // }
}
