import 'package:chopper/chopper.dart';
import 'package:newmusicappmachado/Utils/Models/AdvanceSearchSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ArtistsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/GenresModel.dart';
import 'package:newmusicappmachado/Utils/Models/GoogleAdsModel.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/LoginResopnseModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/MixesTracksDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/NotificationDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListAddDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/PlayListSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ProfileDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/RecentSeachDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ShareAppModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongDetaiDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TimezoneDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ViewAllRadioDataModel.dart';

part 'HomeChopperService.chopper.dart';

@ChopperApi()
abstract class HomeChopperService extends ChopperService {
  static HomeChopperService create({ChopperClient? client}) {
    return _$HomeChopperService(client);
  }

  @Get(path: 'music/maincategories')
  Future<Response<GenresModel>> getAllGenres(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Post(path: 'appusers/savegenres')
  Future<Response<GeneralErrorModel>> saveGenres(
      {@body required Map<String, dynamic> param});

  @Get(path: 'flowactivotrendings')
  Future<Response<ExplorDataModel>> exploreApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/maincategories')
  Future<Response<MixesDataModel>> mixesApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/maincategories')
  Future<Response<ArtistsDataModel>> artistApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'profile')
  Future<Response<ProfileDataModel>> profileApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/subcategoryandtracks')
  Future<Response<TracksDataModel>> mixesSubCategoryAndTracksApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'trendings')
  Future<Response<HomeDataModel>> homeDataApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Post(path: 'recentsearch')
  Future<Response<RecentSearchDataModel>> recentSearchApi(
      {@body required Map<String, dynamic> param});

  @Post(path: 'smartsearch')
  Future<Response<AdvanceSearchSongDataModel>> advanceSearchApi(
      {@body required Map<String, dynamic> param,
      @QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'songdetail')
  Future<Response<SongDetailDataModel>> songDetailApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/favourites/add_remove/Add')
  Future<Response<GeneralErrorModel>> favouriteSongAddApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'music/favourites/add_remove/Remove')
  Future<Response<GeneralErrorModel>> favouriteSongRemoveApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/favourites')
  Future<Response<FavouriteSongDataModel>> favouriteSongDataApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/playlists')
  Future<Response<PlayListDataModel>> playListDataApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Post(path: 'music/playlists/add')
  Future<Response<PlayListAddDataModel>> playLisAddDataApi(
      {@body required Map<String, dynamic> param,
        @QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'music/playlists/playlistsongs')
  Future<Response<PlayListSongDataModel>> playListSongDataApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'music/playlists/playlistsongs/Add')
  Future<Response<GeneralErrorModel>> playListSongAddApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/playlists/playlistsongs/Remove')
  Future<Response<GeneralErrorModel>> playListSongRemoveApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'trendings/viewall')
  Future<Response<ViewAllRadioDataModel>> viewAllApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'flowactivotrendings/viewall')
  Future<Response<ViewAllRadioDataModel>> exploreViewAllApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'music/albumsAndtracks')
  Future<Response<TracksDataModel>> albumsAndTracksApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Get(path: 'music/playlists/remove')
  Future<Response<GeneralErrorModel>> removePlayList(
      {@QueryMap() required Map<String, dynamic> queryParameters});


  @Post(path: 'profile/update')
  Future<Response<ProfileDataModel>> updateUserProfile(
      {@body required Map<String, dynamic> param});
  @Post(path: 'changepassword')
  Future<Response<GeneralErrorModel>> changePassword(
      {@body required Map<String, dynamic> param});
  @Get(path: 'music/playlists/playlistalbums/Add')
  Future<Response<GeneralErrorModel>> playlistAlbumsAdd(
      {@QueryMap() required Map<String, dynamic> queryParameters});
  @Get(path: 'logout')
  Future<Response<GeneralErrorModel>> logoutApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});
  @Get(path: 'notification')
  Future<Response<NotificationsDataModel>> notification(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'googleads')
  Future<Response<GoogleAdsModel>> googleAds(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'music/recent/Add')
  Future<Response<GeneralErrorModel>> recentPlayed(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  @Get(path: 'sharemyapp')
  Future<Response<ShareAppModel>> shareAppApi();
  // http://3.223.4.130/flowactivo2.0/api/recentsearch?filter=add&user_id=2


  @Get(path: 'downloads')
  Future<Response<GeneralErrorModel>> downloadAPi(
      {@QueryMap() required Map<String, dynamic> queryParameters});

  // 'music/playlists/playlistalbums/Add?albums_id=3&user_id=1&playlists_id=1'
  @Get(path: 'countryandtimezone?type=Country')
  Future<Response<AllCountriesDataModel>> fetchCountries();
  @Get(path: 'countryandtimezone?type=Timezone')
  Future<Response<TimezoneDataModel>> fetchTimeZone(
      {@QueryMap() required Map<String, dynamic> queryParameters});
}
