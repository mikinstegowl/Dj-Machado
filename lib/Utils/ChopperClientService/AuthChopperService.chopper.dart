// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'AuthChopperService.dart';

// **************************************************************************
// ChopperGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
final class _$AuthChopperService extends AuthChopperService {
  _$AuthChopperService([ChopperClient? client]) {
    if (client == null) return;
    this.client = client;
  }

  @override
  final Type definitionType = AuthChopperService;

  @override
  Future<Response<LoginResponseModel>> loginUser(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('appusers/login');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<LoginResponseModel, LoginResponseModel>($request);
  }

  @override
  Future<Response<LoginResponseModel>> skipUser(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('appusers/signup');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<LoginResponseModel, LoginResponseModel>($request);
  }

  @override
  Future<Response<CreateUserModel>> createUser(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('appusers/signup');
    final $body = param;
    final Request $request = Request(
      'POST',
      $url,
      client.baseUrl,
      body: $body,
    );
    return client.send<CreateUserModel, CreateUserModel>($request);
  }

  @override
  Future<Response<GeneralErrorModel>> forgotPassword(
      {required Map<String, dynamic> param}) {
    final Uri $url = Uri.parse('forgotpassword');
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

  @override
  Future<Response<TermsAndPrivacyDataModel>> termsApi(
      {required Map<String, dynamic> queryParameters}) {
    final Uri $url = Uri.parse('termsandpolicies');
    final Map<String, dynamic> $params = queryParameters;
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
      parameters: $params,
    );
    return client
        .send<TermsAndPrivacyDataModel, TermsAndPrivacyDataModel>($request);
  }

  @override
  Future<Response<IntroductionDataModel>> introSliderApi() {
    final Uri $url = Uri.parse('introslider');
    final Request $request = Request(
      'GET',
      $url,
      client.baseUrl,
    );
    return client.send<IntroductionDataModel, IntroductionDataModel>($request);
  }
}
