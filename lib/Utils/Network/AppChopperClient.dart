import 'package:chopper/chopper.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Models/AdvanceSearchSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ArtistsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/CreateUserModel.dart';
import 'package:newmusicappmachado/Utils/Models/ExplorDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/FavouriteSongDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/GenresModel.dart';
import 'package:newmusicappmachado/Utils/Models/GoogleAdsModel.dart';
import 'package:newmusicappmachado/Utils/Models/HomeDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/IntroductionDataModel.dart';
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
import 'package:newmusicappmachado/Utils/Models/SkipUserModel.dart';
import 'package:newmusicappmachado/Utils/Models/SongDetaiDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TermsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TimezoneDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ViewAllRadioDataModel.dart';
import 'Utils/Convertors/JsonToTypeConverter.dart';
import 'Utils/Interceptors/ApplyHeaderInterceptor.dart';
import 'Utils/Interceptors/RequestLogger.dart';
import 'Utils/Interceptors/ResponseLogger.dart';

class AppChopperClient {
  static final AppChopperClient _singleton = AppChopperClient._internal();

  factory AppChopperClient() {
    return _singleton;
  }

  AppChopperClient._internal() {
    createChopperClient();
  }

  ChopperClient? _client;

  T getChopperService<T extends ChopperService>() {
    return _client!.getService<T>();
  }

  void createChopperClient() {
    if (_client != null) {
      return;
    }
    _client = ChopperClient(
        baseUrl: Uri.parse(
          // "https://theapophis.com/apophis/api/",
          //   "https://djmachadoapp.com/apophis/api/"
            'http://52.54.230.239/djmachado/api'
        ),
        services: [
          AuthChopperService.create(),
          HomeChopperService.create(),
        ],
        interceptors: [
          RequestLogger(),
          ResponseLogger(),
          ApplyHeaderInterceptor(),
        ],
        converter: const JsonToTypeConverter(
          jsonConvertorMap: {
            GeneralErrorModel: GeneralErrorModel.fromJson,
            LoginResponseModel: LoginResponseModel.fromJson,
            CreateUserModel: CreateUserModel.fromJson,
            GenresModel: GenresModel.fromJson,
            SkipUserModel: SkipUserModel.fromJson,
            ExplorDataModel: ExplorDataModel.fromJson,
            MixesDataModel: MixesDataModel.fromJson,
            ArtistsDataModel: ArtistsDataModel.fromJson,
            ProfileDataModel: ProfileDataModel.fromJson,
            TracksDataModel: TracksDataModel.fromJson,
            HomeDataModel: HomeDataModel.fromJson,
            RecentSearchDataModel: RecentSearchDataModel.fromJson,
            AdvanceSearchSongDataModel: AdvanceSearchSongDataModel.fromJson,
            SongDetailDataModel : SongDetailDataModel.fromJson,
            FavouriteSongDataModel: FavouriteSongDataModel.fromJson,
            PlayListDataModel : PlayListDataModel.fromJson,
            PlayListAddDataModel: PlayListAddDataModel.fromJson,
            PlayListSongDataModel: PlayListSongDataModel.fromJson,
            ViewAllRadioDataModel: ViewAllRadioDataModel.fromJson,
            NotificationsDataModel:NotificationsDataModel.fromJson,
            ShareAppModel: ShareAppModel.fromJson,
            IntroductionDataModel: IntroductionDataModel.fromJson,
            AllCountriesDataModel:AllCountriesDataModel.fromJson,
            GoogleAdsModel: GoogleAdsModel.fromJson,
            TimezoneDataModel: TimezoneDataModel.fromJson,
            TermsAndPrivacyDataModel:TermsAndPrivacyDataModel.fromJson,
          },
        ),
        errorConverter: const JsonToTypeConverter(
            jsonConvertorMap: {GeneralErrorModel: GeneralErrorModel.fromJson}));
  }
}
// flutter packages pub run build_runner build --delete-conflicting-outputs
