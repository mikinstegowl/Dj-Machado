import 'dart:developer';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Models/ArtistsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ArtistsController extends BaseController {
  late HomeChopperService _homeChopperService;
  late TextEditingController searchController;

  ArtistsController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }

  @override
  void onInit() async {
    scrollControllerSearch.addListener(() {
      print("object");
      scrollListener4();
    });
    scrollControllerForArtistSong.addListener(() {
      print("object");
      scrollListener2();
    });
    scrollControllerForAlbumSong.addListener(() {
      print("object1");
      scrollListener3();
    });
    // TODO: implement onInit
    searchController = TextEditingController();
    await artistApi();
    scrollController.addListener(() {
      print("sdcsdvfv");
      scrollListener();
    });
    super.onInit();
  }

  @override
  dispose() {
    searchController.dispose();
    super.dispose();
  }

  int paginationInt = 1;

  ScrollController scrollController = ScrollController();

  int? maxPages;
  Future<void> scrollListener() async {
    print("client ${scrollController.hasClients}");
    if (scrollController.hasClients) {
      print(
          "ture sate ${scrollController.position.pixels == scrollController.position.maxScrollExtent}");
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        print("max ${paginationInt < maxPages!}");
        print("max ${maxPages!}");
        if (paginationInt < maxPages!) {
          paginationInt++;
          print(paginationInt);
          await artistApi(); // Fetch next page
        }
      }
    }
  }

  ArtistsDataModel? artistsDataModel;

  Future<void> artistApi() async {
    try {
      showLoader(true);
      final queryParameters = {
        "filter": "Artists",
        "limit": 50,
        "page": paginationInt
      };
      final response =
          await _homeChopperService.artistApi(queryParameters: queryParameters);
      if (response.body?.status == 200) {
            if(paginationInt ==1){
          artistsDataModel = response.body;
          maxPages = artistsDataModel?.lastPage;
          groupArtistsByFirstChar();
          showLoader(false);
        }else{
              artistsDataModel?.data?.addAll(response.body?.data??[]);
              showLoader(false);
              update();
            }
      } else {
        showLoader(false);
        Get.snackbar("Error", response.body?.message ?? '');
      }
    } catch (e) {
      showLoader(false);
      log("", name: "Mixes Api Error", error: e.toString());
    }
  }

  // Grouped artists map
  Map<String, List<PopularArtist>> groupedArtists = {};

  void groupArtistsByFirstChar() {
    // Sorting artists by name
    artistsDataModel!.data
        ?.sort((a, b) => a.artistsName!.compareTo(b.artistsName!));
    groupedArtists = {};
    // Grouping by the first letter
    for (var artist in artistsDataModel!.data!) {
      print(artist);
      String firstChar = artist.artistsName![0].toUpperCase();
      if (groupedArtists[firstChar] == null) {
        groupedArtists[firstChar] = [];
      }
      groupedArtists[firstChar]!.add(artist);
    }
  }

  int searchPage = 1;

  ScrollController scrollControllerSearch = ScrollController();
  Future<void> scrollListener4() async {
    print("client ${scrollControllerSearch.hasClients}");
    if (scrollControllerSearch.hasClients) {
      print(
          "ture sate ${scrollControllerSearch.position.pixels == scrollControllerSearch.position.maxScrollExtent}");
      if (scrollControllerSearch.position.pixels ==
          scrollControllerSearch.position.maxScrollExtent) {
        print("max ${searchPage < maxSearchPage!}");
        print("max $maxSearchPage");
        if (searchPage < maxSearchPage!) {
          searchPage++;
          print(searchPage);
          await trackSongApi(artistId1 ?? 0).then((_) async {
            await albumSongApi(artistId1 ?? 0);
          });
          // Fetch next page
        }
      }
    }
  }

  int? maxSearchPage;
  Future<void> searchArtist() async {
    try {
      final queryParameters = {
        "filter": "Artists",
        "search": searchController.text,
        "limit": 50,
        "page": paginationInt
      };
      print(queryParameters);
      final response =
          await _homeChopperService.artistApi(queryParameters: queryParameters);
      if (response.body?.status == 200) {
        artistsDataModel = response.body;
        maxPages = artistsDataModel?.lastPage;
        groupArtistsByFirstChar();
      } else {
        print("object");
        artistsDataModel = null;
        print(artistsDataModel);
        // groupArtistsByFirstChar();
        // artistsDataModel = artistsDataModel;
        // groupArtistsByFirstChar();
      }
      update();
    } catch (e) {
      log("", error: e.toString(), name: "search Artist Model");
    }
  }

  TracksDataModel? tracksDataModel;

  int paginationArtistSong = 1;

  ScrollController scrollControllerForArtistSong = ScrollController();

  int? maxPages2;
  int? artistId1;
  Future<void> scrollListener2() async {
    print("client ${scrollControllerForArtistSong.hasClients}");
    if (scrollControllerForArtistSong.hasClients) {
      print(
          "ture sate ${scrollControllerForArtistSong.position.pixels == scrollControllerForArtistSong.position.maxScrollExtent}");
      if (scrollControllerForArtistSong.position.pixels ==
          scrollControllerForArtistSong.position.maxScrollExtent) {
        print("max ${paginationArtistSong < maxPages2!}");
        print("max $maxPages2");
        if (paginationArtistSong < maxPages2!) {
          paginationArtistSong++;
          print(paginationArtistSong);
          await trackSongApi(artistId1 ?? 0).then((_) async {
            await albumSongApi(artistId1 ?? 0);
          });
          // Fetch next page
        }
      }
    }
  }

  Future<void> trackSongApi(int artistsId) async {
    try {
      Get.find<ArtistsController>().showLoader(true);
      Get.find<HomeController>().showLoader(true);
      Get.find<ExplorController>().showLoader(true);
      if(tracksDataModel?.data?.isNotEmpty??false){
        tracksDataModel?.data?.clear();
      }
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Artists",
        "recordtype": "Tracks",
        "artists_id": artistsId,
        "page": paginationArtistSong,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
            if (paginationArtistSong ==1) {
          tracksDataModel = response.body;
          update();
          maxPages2 = tracksDataModel?.lastPage;
          artistId1 = artistsId;
          // Get.find<ArtistsController>().showLoader(false);
          Get.find<HomeController>().showLoader(false);
          Get.find<ExplorController>().showLoader(false);
        }else{
              tracksDataModel?.data?.addAll(response.body?.data??[]);
              Get.find<HomeController>().showLoader(false);
              Get.find<ExplorController>().showLoader(false);
              update();
            }
      }
    } catch (e) {
      // Get.find<ArtistsController>().showLoader(false);
      Get.find<HomeController>().showLoader(false);
      Get.find<ExplorController>().showLoader(false);
      update();
      log('', error: e.toString(), name: "Artiest Track Data Model");
    }
  }

  TracksDataModel? albumDataModel;

  Future<void> albumSongApi(int artistsId) async {
    try {
      Get.find<ArtistsController>().showLoader(true);
      Get.find<HomeController>().showLoader(true);
      Get.find<ExplorController>().showLoader(true);
      if(albumDataModel?.data?.isNotEmpty??false){
        albumDataModel?.data?.clear();
      }
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 30,
        "filter": "Artists",
        "recordtype": "Albums",
        "artists_id": artistsId,
        "page": paginationArtistSong,
      };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        albumDataModel = response.body;
        update();
        maxPages2 = albumDataModel?.lastPage;
        artistId1 = artistsId;
        Get.find<ArtistsController>().showLoader(false);
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      } else {
        print("object");
        // albumDataModel = null;
        Get.find<ArtistsController>().showLoader(false);
        Get.find<HomeController>().showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      }
    } catch (e) {
      Get.find<ArtistsController>().showLoader(false);
      Get.find<ExplorController>().showLoader(false);
      Get.find<HomeController>().showLoader(false);
      log('', error: e.toString(), name: "Artiest Track Data Model");
    }
  }

  TracksDataModel? albumTrackSongData;

  int paginationAlbumSong = 1;

  ScrollController scrollControllerForAlbumSong = ScrollController();

  int? maxPages3;
  // int? artistId1;
  Future<void> scrollListener3() async {
    if (scrollControllerForAlbumSong.hasClients) {
      if (scrollControllerForAlbumSong.position.pixels ==
          scrollControllerForAlbumSong.position.maxScrollExtent) {
        if (paginationAlbumSong < maxPages3!) {
          paginationAlbumSong++;
          print(paginationAlbumSong);
          await albumTrackSongApi(
              artistsId: artistId1 ==0 ? null: artistId1, albumId: albumId1, genresId: genresId1 ==0? null:genresId1);
          // Fetch next page
        }
      }
    }
  }

  int? albumId1;
  int? genresId1;
  Future<void> albumTrackSongApi(
      {int? artistsId, int? albumId, int? genresId}) async {
    try {
      showLoader(true);
      final queryParameters = genresId != null
          ? {
              "user_id": UserPreference.getValue(key: PrefKeys.userId),
              "limit": 30,
              "filter": "Genres",
              "recordtype": "AlbumsTracks",
              "genres_id": genresId,
              "albums_id": albumId,
              "page": paginationAlbumSong,
            }
          : {
              "user_id": UserPreference.getValue(key: PrefKeys.userId),
              "limit": 30,
              "filter": "Artists",
              "recordtype": "AlbumsTracks",
              "artists_id": artistsId,
              "albums_id": albumId,
              "page": paginationAlbumSong,
            };
      final response = await _homeChopperService.mixesSubCategoryAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        if(paginationAlbumSong == 1){
          albumTrackSongData = response.body;
          maxPages3 = albumTrackSongData?.lastPage;
          artistId1 = artistsId;
          albumId1 = albumId ?? 0;
          genresId1 = genresId ?? 0;
          showLoader(false);
          update();
        }else{
          print("object");
          albumTrackSongData?.data?.addAll(response.body?.data??[]);
          print(albumTrackSongData?.data?.length);
          showLoader(false);
          // albumTrackSongData = null;
          update();
        }
      } else {
        print("object");
        // albumTrackSongData?.data?.addAll(response.body?.data??[]);
        // print(albumTrackSongData?.data?.length);
        artistsDataModel = null;
        showLoader(false);
        // albumTrackSongData = null;
        update();
      }
    } catch (e) {
      showLoader(false);
      log('', error: e.toString(), name: "Artiest Track Data Model");
    }
  }

  Future<void> albumsAndTracks({int? albumId}) async {
    try {
      Get.find<HomeController>().showLoader(true);
      Get.find<ExplorController>().showLoader(true);
      showLoader(true);
      final queryParameters = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "limit": 5,
        "filter": "AlbumsTracks",
        "albums_id": albumId,
      };
      final response = await _homeChopperService.albumsAndTracksApi(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        albumTrackSongData = response.body;
        Get.find<HomeController>().showLoader(false);
        showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      } else {
        print("object");
        albumTrackSongData = null;
        Get.find<HomeController>().showLoader(false);
        showLoader(false);
        Get.find<ExplorController>().showLoader(false);
        update();
      }
    } catch (e) {
      log('', error: e.toString(), name: "Artiest Track Data Model");
    }
  }
}
