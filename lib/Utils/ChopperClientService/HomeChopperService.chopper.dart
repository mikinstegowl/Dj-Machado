// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeChopperService.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$HomeChopperService extends HomeChopperService {
  _$HomeChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = HomeChopperService;

  @override
  Future<Response<GenresModel>> getAllGenres(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/maincategories');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GenresModel, GenresModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> saveGenres(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('appusers/savegenres');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<ExplorDataModel>> exploreApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('flowactivotrendings');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ExplorDataModel, ExplorDataModel>($request);
  }

  @override
  Future<Response<MixesDataModel>> mixesApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/maincategories');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<MixesDataModel, MixesDataModel>($request);
  }

  @override
  Future<Response<ArtistsDataModel>> artistApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/maincategories');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ArtistsDataModel, ArtistsDataModel>($request);
  }

  @override
  Future<Response<ProfileDataModel>> profileApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('profile');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ProfileDataModel, ProfileDataModel>($request);
  }

  @override
  Future<Response<TracksDataModel>> mixesSubCategoryAndTracksApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/subcategoryandtracks');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<TracksDataModel, TracksDataModel>($request);
  }

  @override
  Future<Response<HomeDataModel>> homeDataApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('trendings');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<HomeDataModel, HomeDataModel>($request);
  }

  @override
  Future<Response<RecentSearchDataModel>> recentSearchApi(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('recentsearch');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<RecentSearchDataModel, RecentSearchDataModel>($request);
  }

  @override
  Future<Response<AdvanceSearchSongDataModel>> advanceSearchApi({
    required Map<String, dynamic> param,
    required Map<String, dynamic> queryParameters,
  }) {
    final Uri $url = Uri.parse('smartsearch');
    final Map<String, dynamic> $params = queryParameters;
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client
        .send<AdvanceSearchSongDataModel, AdvanceSearchSongDataModel>($request);
  }

  @override
  Future<Response<SongDetailDataModel>> songDetailApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('songdetail');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<SongDetailDataModel, SongDetailDataModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> favouriteSongAddApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/favourites/add_remove/Add');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> favouriteSongRemoveApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/favourites/add_remove/Remove');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<FavouriteSongDataModel>> favouriteSongDataApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/favourites');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<FavouriteSongDataModel, FavouriteSongDataModel>($request);
  }

  @override
  Future<Response<PlayListDataModel>> playListDataApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<PlayListDataModel, PlayListDataModel>($request);
  }

  @override
  Future<Response<PlayListAddDataModel>> playLisAddDataApi({
    required Map<String, dynamic> param,
    required Map<String, dynamic> queryParameters,
  }) {
    final Uri $url = Uri.parse('music/playlists/add');
    final Map<String, dynamic> $params = queryParameters;
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
      parameters: $params,
    );
    return client.send<PlayListAddDataModel, PlayListAddDataModel>($request);
  }

  @override
  Future<Response<PlayListSongDataModel>> playListSongDataApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists/playlistsongs');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<PlayListSongDataModel, PlayListSongDataModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> playListSongAddApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists/playlistsongs/Add');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> playListSongRemoveApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists/playlistsongs/Remove');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<ViewAllRadioDataModel>> viewAllApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('trendings/viewall');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ViewAllRadioDataModel, ViewAllRadioDataModel>($request);
  }

  @override
  Future<Response<ViewAllRadioDataModel>> exploreViewAllApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('flowactivotrendings/viewall');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<ViewAllRadioDataModel, ViewAllRadioDataModel>($request);
  }

  @override
  Future<Response<TracksDataModel>> albumsAndTracksApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/albumsAndtracks');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<TracksDataModel, TracksDataModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> removePlayList(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists/remove');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<ProfileDataModel>> updateUserProfile(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('profile/update');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<ProfileDataModel, ProfileDataModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> changePassword(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('changepassword');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> playlistAlbumsAdd(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/playlists/playlistalbums/Add');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> logoutApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('logout');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<NotificationsDataModel>> notification(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('notification');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<NotificationsDataModel, NotificationsDataModel>($request);
  }

  @override
  Future<Response<GoogleAdsModel>> googleAds(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('googleads');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GoogleAdsModel, GoogleAdsModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> recentPlayed(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('music/recent/Add');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<ShareAppModel>> shareAppApi() {
    final Uri $url = Uri.parse('sharemyapp');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<ShareAppModel, ShareAppModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> downloadAPi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('downloads');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<GeneralErrorModel, GeneralErrorModel>($request);
  }

  @override
  Future<Response<AllCountriesDataModel>> fetchCountries() {
    final Uri $url = Uri.parse('countryandtimezone?type=Country');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<AllCountriesDataModel, AllCountriesDataModel>($request);
  }

  @override
  Future<Response<TimezoneDataModel>> fetchTimeZone(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('countryandtimezone?type=Timezone');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client.send<TimezoneDataModel, TimezoneDataModel>($request);
  }
}
