import 'package:chopper/chopper.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/CreateUserModel.dart';
import 'package:newmusicappmachado/Utils/Models/GeneralErrorModel.dart';
import 'package:newmusicappmachado/Utils/Models/IntroductionDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/LoginResopnseModel.dart';
import 'package:newmusicappmachado/Utils/Models/TermsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TimezoneDataModel.dart';

part 'AuthChopperService.chopper.dart';

@ChopperApi()
abstract class AuthChopperService extends ChopperService {
  static AuthChopperService create({ChopperClient? client}) {
    return _$AuthChopperService(client);
  }

  @Post(
    path: 'appusers/login',
  )
  Future<Response<LoginResponseModel>> loginUser(
      {@body required Map<String, dynamic> param});
  @Post(
    path: 'appusers/signup',
  )
  Future<Response<LoginResponseModel>> skipUser(
      {@body required Map<String, dynamic> param});
  @Post(path: 'appusers/signup')
  Future<Response<CreateUserModel>> createUser(
      {@body required Map<String, dynamic> param});
  @Post(path: 'forgotpassword')
  Future<Response<GeneralErrorModel>> forgotPassword(
      {@body required Map<String, dynamic> param});
  @Get(path: 'countryandtimezone?type=Country')
  Future<Response<AllCountriesDataModel>> fetchCountries();
  @Get(path: 'countryandtimezone?type=Timezone')
  Future<Response<TimezoneDataModel>> fetchTimeZone(
      {@QueryMap() required Map<String, dynamic> queryParameters});
  @Get(path: 'termsandpolicies')
  Future<Response<TermsAndPrivacyDataModel>> termsApi(
      {@QueryMap() required Map<String, dynamic> queryParameters});
  @Get(path: 'introslider')
  Future<Response<IntroductionDataModel>> introSliderApi();
}
