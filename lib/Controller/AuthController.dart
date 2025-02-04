import 'dart:convert';
import 'dart:developer';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/CreateUserModel.dart';
import 'package:newmusicappmachado/Utils/Models/IntroductionDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TermsDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TimezoneDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/SomethingWentWrong.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'dart:io';

import 'package:get/get_rx/get_rx.dart';
import 'package:newmusicappmachado/main.dart';

class AuthController extends BaseController {
  late AuthChopperService _authChopperService;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  GlobalKey<FormState> forgotFormKey = GlobalKey<FormState>();

  TextEditingController userNameOrEmailTextEditingController =
      TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController createPasswordController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController countryController = TextEditingController();

  CarouselSliderController carouselController=CarouselSliderController();

  IntroductionDataModel? introductionDataModel;
  CreateUserModel? createUserModel;
  AllCountriesDataModel? allCountriesDataModel;
  TimezoneDataModel? timezoneDataModel;
  var selectCountry;

  var selectedDate = Rx<DateTime?>(null);

  int countryId = -1;
  RxInt pageIndex=0.obs;

  AuthController({required AuthChopperService authChopperService}) {
    _authChopperService = authChopperService;
  }

  void openDatePicker(BuildContext context) {
    BottomPicker.date(
      dismissable: true,
      backgroundColor: AppColors.black,
      titleAlignment: Alignment.center,
      buttonStyle: BoxDecoration(
        image: const DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors.primary, // Change this to the desired color
              BlendMode.srcATop,
            ),
            image: AssetImage(
              AppAssets.buttonBackgroundImage,
            )),
      ),
      displayCloseIcon: false,
      buttonContent: AppButtonWidget(
        onPressed: () async {
          // Format the date as needed, here using 'yyyy-MM-dd'
          dobController.text = "${selectedDate.value?.toFormattedDate()}";
          Get.back();
          update();
        },

        btnName: 'Select',
        fontSize: 16,
        fontWeight: FontWeight.w900,
        txtColor: AppColors.black,
        image: const DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors.primary, // Change this to the desired color
              BlendMode.srcATop,
            ),
            image: AssetImage(
              AppAssets.buttonBackgroundImage,
            )),

        // btnColor: AppColors.primary,
      ),
      pickerTitle: const Text(
        'Set your DOB',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: AppColors.white,
        ),
      ),
      dateOrder: DatePickerDateOrder.mdy,
      initialDateTime: selectedDate.value ?? DateTime.now(),
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(1900),
      pickerTextStyle: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
      onChange: (index) {
        print(index.runtimeType);
        selectedDate.value = index;
      },
      onSubmit: (index) {
        selectedDate.value = index;
        // Format the date as needed, here using 'yyyy-MM-dd'
      },
    ).show(context);
  }

  Future<void> skipUser() async {
    try {
      String? fcm = '';
      if (Platform.isIOS) {
        fcm = await FirebaseMessaging.instance.getAPNSToken();
        print(fcm);
        fcm = await FirebaseMessaging.instance.getToken();
      } else {
        fcm = await FirebaseMessaging.instance.getToken();
        print(fcm);
      }
      final param = {
        "type": 0,
        "fcm_id": fcm,
        "device_type": Platform.isAndroid ? "Android" : "IOS"
      };
      final response = await _authChopperService.skipUser(param: param);
      if (response.body?.status == 200) {
        loginResponseModel = response.body;
        UserPreference.clear();

        UserPreference.setValue(
            key: PrefKeys.genresId, value: response.body?.genresId.toString());

        UserPreference.setValue(key: PrefKeys.skipUser, value: true);

        UserPreference.setValue(key: PrefKeys.firstTime,value: false);
        UserPreference.setValue(
            key: PrefKeys.logInToken, value: loginResponseModel?.token);
        UserPreference.setValue(
            key: PrefKeys.userId, value: loginResponseModel?.userId);
        // print(UserPreference.getValue(key: PrefKeys.genresId));
        await Get.find<HomeController>().getAllGenres();
        Get.offNamed(RoutesName.homeScreen);
        await _logButtonClick(userName: '',deviceType:Platform.isAndroid ? "Android" : "IOS",type: 'Skip' );

      }
    } catch (e) {
      Utility.showSnackBar(e.toString(), isError: true);
      Get.dialog(SomethingWentWrongDialog());
      log('', error: e.toString(), name: 'Skip User Api Error');
    }
  }

  Future<void> loginApi() async {
    showLoader(true);
    try {
      String? fcm = '';
      if (Platform.isIOS) {
        fcm = await FirebaseMessaging.instance.getAPNSToken();
        print(fcm);
        fcm = await FirebaseMessaging.instance.getToken();
      } else {
        fcm = await FirebaseMessaging.instance.getToken();
        print(fcm);
      }
      final param = {
        "login_id": userNameOrEmailTextEditingController.text,
        "login_password": passwordTextEditingController.text,
        "fcm_id": fcm,
        "device_type": Platform.isAndroid ? "Android" : "IOS"
      };
      final response = await _authChopperService.loginUser(param: param);
      if (response.body?.status == 200) {
        loginResponseModel = response.body;
        UserPreference.clear();
        response.body?.genresId != ''
            ? UserPreference.setValue(
                key: PrefKeys.genresId,
                value: response.body?.genresId.toString())
            : null;
        UserPreference.setValue(
            key: PrefKeys.logInToken, value: loginResponseModel?.token);
        UserPreference.setValue(key: PrefKeys.skipUser, value: false);
        UserPreference.setValue(key: PrefKeys.firstTime,value: false);
        UserPreference.setValue(
            key: PrefKeys.userId, value: loginResponseModel?.userId);
        if (response.body?.genresSelected ?? false) {
          Get.offNamed(RoutesName.homeScreen);
        } else {
          await Get.find<HomeController>().getAllGenres();
          Get.offNamed(RoutesName.selectGenresScreen);
        }
        await  _logButtonClick(userName: userNameOrEmailTextEditingController.text,type: 'not Skip',deviceType: Platform.isAndroid ? "Android" : "IOS");

        clearControllers();
      } else {
        Utility.showSnackBar(response.body?.message, isError: true);
      }
      showLoader(false);
      update();
    } catch (e) {
      Utility.showSnackBar(e.toString(), isError: true);
      showLoader(false);
      log("", name: "Login Error", error: e.toString());
    }
  }


  Future<void> _logButtonClick({String? userName, String? type,String? deviceType}) async {
    await  MyApp.analytics.logEvent(
      name: 'User_detail',
      parameters: {
        'user_name': userName??"",
        'type': type??"",
        'device_type': deviceType??'',
      },
    ).then((_){
      print("Button click event logged: $userName, $type");
    });

  }


  Future<void> createUserApi() async {
    showLoader(true);
    // if(Platform.isIOS){
    //   await FirebaseMessaging.instance.getAPNSToken();
    // }
    try {
      String? fcm = '';
      if (Platform.isIOS) {
        fcm = await FirebaseMessaging.instance.getAPNSToken();
        print(fcm);
        fcm = await FirebaseMessaging.instance.getToken();
      } else {
        fcm = await FirebaseMessaging.instance.getToken();
        print(fcm);
      }
      final param = {
        "type": 1,
        "fcm_id": fcm,
        "name": userNameController.text.split(' ')[0],
        "contact": phoneNumberController.text.replaceAll('-', ''),
        "user_name": userNameController.text,
        "password": confirmPasswordController.text,
        "birthdate": dobController.text,
        "email": emailController.text,
        "country": countryId,
        "timezone": timezoneDataModel?.data?[0].zoneName,
        "device_type": Platform.isAndroid ? "Android" : "IOS"
      };
      final response = await _authChopperService.createUser(param: param);
      if (response.body?.status == 200) {
        createUserModel = response.body;
        UserPreference.setValue(
            key: PrefKeys.logInToken, value: createUserModel?.token);
        UserPreference.setValue(
            key: PrefKeys.userId, value: createUserModel?.userId);
        UserPreference.setValue(key: PrefKeys.genresId, value: []);
        UserPreference.setValue(key: PrefKeys.skipUser, value: false);
        UserPreference.setValue(
            key: PrefKeys.userId, value: loginResponseModel?.userId);

        UserPreference.setValue(key: PrefKeys.firstTime,value: false);
        await Get.find<HomeController>().getAllGenres().then((_){
          Get.toNamed(RoutesName.selectGenresScreen);
        });
        clearControllers();
      } else {
        Utility.showSnackBar(response.body?.message, isError: true);
      }
      showLoader(false);
      update();
    } catch (e) {
      showLoader(false);
      Utility.showSnackBar(e.toString(), isError: true);
      Get.dialog(const SomethingWentWrongDialog());
      log("", name: "Create User Error", error: e.toString());
    }
  }

  void clearControllers() {
    userNameController.clear();
    passwordTextEditingController.clear();
    emailController.clear();
    dobController.clear();
    passwordTextEditingController.clear();
    confirmPasswordController.clear();
    userNameOrEmailTextEditingController.clear();
    phoneNumberController.clear();
    countryController.clear();
    selectedDate = Rx<DateTime?>(null);
    update();
  }



  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
      // Format the date as needed, here using 'yyyy-MM-dd'
      dobController.text = "${picked.toFormattedDate()}";
      print(dobController.text);
      update();
    }
  }

  Future<void> forgotPasswordApi() async {
    try {
      final param = {"email": emailController.text};
      final response = await _authChopperService.forgotPassword(param: param);
      if (response.body?.code == 200) {
        Get.back();
        Utility.showSnackBar(response.body?.message ?? '');
      } else {
        Utility.showSnackBar(response.body?.message ?? '', isError: true);
      }
    } catch (e) {
      Get.dialog(const SomethingWentWrongDialog());
      log('', error: e.toString(), name: "Forgot Api Error");
    }
  }

  Map<String, dynamic> counties = {
    "status": 200,
    "message": "Available countries.",
    "data": [
      {
        "country_id": 1,
        "country_code": "AF",
        "name": "Afghanistan",
        "phonecode": 93
      },
      {
        "country_id": 2,
        "country_code": "AL",
        "name": "Albania",
        "phonecode": 355
      },
      {
        "country_id": 3,
        "country_code": "DZ",
        "name": "Algeria",
        "phonecode": 213
      },
      {
        "country_id": 4,
        "country_code": "AS",
        "name": "American Samoa",
        "phonecode": 1684
      },
      {
        "country_id": 5,
        "country_code": "AD",
        "name": "Andorra",
        "phonecode": 376
      },
      {
        "country_id": 6,
        "country_code": "AO",
        "name": "Angola",
        "phonecode": 244
      },
      {
        "country_id": 7,
        "country_code": "AI",
        "name": "Anguilla",
        "phonecode": 1264
      },
      {
        "country_id": 8,
        "country_code": "AQ",
        "name": "Antarctica",
        "phonecode": 0
      },
      {
        "country_id": 9,
        "country_code": "AG",
        "name": "Antigua And Barbuda",
        "phonecode": 1268
      },
      {
        "country_id": 10,
        "country_code": "AR",
        "name": "Argentina",
        "phonecode": 54
      },
      {
        "country_id": 11,
        "country_code": "AM",
        "name": "Armenia",
        "phonecode": 374
      },
      {
        "country_id": 12,
        "country_code": "AW",
        "name": "Aruba",
        "phonecode": 297
      },
      {
        "country_id": 13,
        "country_code": "AU",
        "name": "Australia",
        "phonecode": 61
      },
      {
        "country_id": 14,
        "country_code": "AT",
        "name": "Austria",
        "phonecode": 43
      },
      {
        "country_id": 15,
        "country_code": "AZ",
        "name": "Azerbaijan",
        "phonecode": 994
      },
      {
        "country_id": 16,
        "country_code": "BS",
        "name": "Bahamas The",
        "phonecode": 1242
      },
      {
        "country_id": 17,
        "country_code": "BH",
        "name": "Bahrain",
        "phonecode": 973
      },
      {
        "country_id": 18,
        "country_code": "BD",
        "name": "Bangladesh",
        "phonecode": 880
      },
      {
        "country_id": 19,
        "country_code": "BB",
        "name": "Barbados",
        "phonecode": 1246
      },
      {
        "country_id": 20,
        "country_code": "BY",
        "name": "Belarus",
        "phonecode": 375
      },
      {
        "country_id": 21,
        "country_code": "BE",
        "name": "Belgium",
        "phonecode": 32
      },
      {
        "country_id": 22,
        "country_code": "BZ",
        "name": "Belize",
        "phonecode": 501
      },
      {
        "country_id": 23,
        "country_code": "BJ",
        "name": "Benin",
        "phonecode": 229
      },
      {
        "country_id": 24,
        "country_code": "BM",
        "name": "Bermuda",
        "phonecode": 1441
      },
      {
        "country_id": 25,
        "country_code": "BT",
        "name": "Bhutan",
        "phonecode": 975
      },
      {
        "country_id": 26,
        "country_code": "BO",
        "name": "Bolivia",
        "phonecode": 591
      },
      {
        "country_id": 27,
        "country_code": "BA",
        "name": "Bosnia and Herzegovina",
        "phonecode": 387
      },
      {
        "country_id": 28,
        "country_code": "BW",
        "name": "Botswana",
        "phonecode": 267
      },
      {
        "country_id": 29,
        "country_code": "BV",
        "name": "Bouvet Island",
        "phonecode": 0
      },
      {
        "country_id": 30,
        "country_code": "BR",
        "name": "Brazil",
        "phonecode": 55
      },
      {
        "country_id": 31,
        "country_code": "IO",
        "name": "British Indian Ocean Territory",
        "phonecode": 246
      },
      {
        "country_id": 32,
        "country_code": "BN",
        "name": "Brunei",
        "phonecode": 673
      },
      {
        "country_id": 33,
        "country_code": "BG",
        "name": "Bulgaria",
        "phonecode": 359
      },
      {
        "country_id": 34,
        "country_code": "BF",
        "name": "Burkina Faso",
        "phonecode": 226
      },
      {
        "country_id": 35,
        "country_code": "BI",
        "name": "Burundi",
        "phonecode": 257
      },
      {
        "country_id": 36,
        "country_code": "KH",
        "name": "Cambodia",
        "phonecode": 855
      },
      {
        "country_id": 37,
        "country_code": "CM",
        "name": "Cameroon",
        "phonecode": 237
      },
      {
        "country_id": 38,
        "country_code": "CA",
        "name": "Canada",
        "phonecode": 1
      },
      {
        "country_id": 39,
        "country_code": "CV",
        "name": "Cape Verde",
        "phonecode": 238
      },
      {
        "country_id": 40,
        "country_code": "KY",
        "name": "Cayman Islands",
        "phonecode": 1345
      },
      {
        "country_id": 41,
        "country_code": "CF",
        "name": "Central African Republic",
        "phonecode": 236
      },
      {
        "country_id": 42,
        "country_code": "TD",
        "name": "Chad",
        "phonecode": 235
      },
      {
        "country_id": 43,
        "country_code": "CL",
        "name": "Chile",
        "phonecode": 56
      },
      {
        "country_id": 44,
        "country_code": "CN",
        "name": "China",
        "phonecode": 86
      },
      {
        "country_id": 45,
        "country_code": "CX",
        "name": "Christmas Island",
        "phonecode": 61
      },
      {
        "country_id": 46,
        "country_code": "CC",
        "name": "Cocos (Keeling) Islands",
        "phonecode": 672
      },
      {
        "country_id": 47,
        "country_code": "CO",
        "name": "Colombia",
        "phonecode": 57
      },
      {
        "country_id": 48,
        "country_code": "KM",
        "name": "Comoros",
        "phonecode": 269
      },
      {
        "country_id": 49,
        "country_code": "CG",
        "name": "Republic Of The Congo",
        "phonecode": 242
      },
      {
        "country_id": 50,
        "country_code": "CD",
        "name": "Democratic Republic Of The Congo",
        "phonecode": 242
      },
      {
        "country_id": 51,
        "country_code": "CK",
        "name": "Cook Islands",
        "phonecode": 682
      },
      {
        "country_id": 52,
        "country_code": "CR",
        "name": "Costa Rica",
        "phonecode": 506
      },
      {
        "country_id": 53,
        "country_code": "CI",
        "name": "Cote D'Ivoire (Ivory Coast)",
        "phonecode": 225
      },
      {
        "country_id": 54,
        "country_code": "HR",
        "name": "Croatia (Hrvatska)",
        "phonecode": 385
      },
      {"country_id": 55, "country_code": "CU", "name": "Cuba", "phonecode": 53},
      {
        "country_id": 56,
        "country_code": "CY",
        "name": "Cyprus",
        "phonecode": 357
      },
      {
        "country_id": 57,
        "country_code": "CZ",
        "name": "Czech Republic",
        "phonecode": 420
      },
      {
        "country_id": 58,
        "country_code": "DK",
        "name": "Denmark",
        "phonecode": 45
      },
      {
        "country_id": 59,
        "country_code": "DJ",
        "name": "Djibouti",
        "phonecode": 253
      },
      {
        "country_id": 60,
        "country_code": "DM",
        "name": "Dominica",
        "phonecode": 1767
      },
      {
        "country_id": 61,
        "country_code": "DO",
        "name": "Dominican Republic",
        "phonecode": 1809
      },
      {
        "country_id": 62,
        "country_code": "TP",
        "name": "East Timor",
        "phonecode": 670
      },
      {
        "country_id": 63,
        "country_code": "EC",
        "name": "Ecuador",
        "phonecode": 593
      },
      {
        "country_id": 64,
        "country_code": "EG",
        "name": "Egypt",
        "phonecode": 20
      },
      {
        "country_id": 65,
        "country_code": "SV",
        "name": "El Salvador",
        "phonecode": 503
      },
      {
        "country_id": 66,
        "country_code": "GQ",
        "name": "Equatorial Guinea",
        "phonecode": 240
      },
      {
        "country_id": 67,
        "country_code": "ER",
        "name": "Eritrea",
        "phonecode": 291
      },
      {
        "country_id": 68,
        "country_code": "EE",
        "name": "Estonia",
        "phonecode": 372
      },
      {
        "country_id": 69,
        "country_code": "ET",
        "name": "Ethiopia",
        "phonecode": 251
      },
      {
        "country_id": 70,
        "country_code": "XA",
        "name": "External Territories of Australia",
        "phonecode": 61
      },
      {
        "country_id": 71,
        "country_code": "FK",
        "name": "Falkland Islands",
        "phonecode": 500
      },
      {
        "country_id": 72,
        "country_code": "FO",
        "name": "Faroe Islands",
        "phonecode": 298
      },
      {
        "country_id": 73,
        "country_code": "FJ",
        "name": "Fiji Islands",
        "phonecode": 679
      },
      {
        "country_id": 74,
        "country_code": "FI",
        "name": "Finland",
        "phonecode": 358
      },
      {
        "country_id": 75,
        "country_code": "FR",
        "name": "France",
        "phonecode": 33
      },
      {
        "country_id": 76,
        "country_code": "GF",
        "name": "French Guiana",
        "phonecode": 594
      },
      {
        "country_id": 77,
        "country_code": "PF",
        "name": "French Polynesia",
        "phonecode": 689
      },
      {
        "country_id": 78,
        "country_code": "TF",
        "name": "French Southern Territories",
        "phonecode": 0
      },
      {
        "country_id": 79,
        "country_code": "GA",
        "name": "Gabon",
        "phonecode": 241
      },
      {
        "country_id": 80,
        "country_code": "GM",
        "name": "Gambia The",
        "phonecode": 220
      },
      {
        "country_id": 81,
        "country_code": "GE",
        "name": "Georgia",
        "phonecode": 995
      },
      {
        "country_id": 82,
        "country_code": "DE",
        "name": "Germany",
        "phonecode": 49
      },
      {
        "country_id": 83,
        "country_code": "GH",
        "name": "Ghana",
        "phonecode": 233
      },
      {
        "country_id": 84,
        "country_code": "GI",
        "name": "Gibraltar",
        "phonecode": 350
      },
      {
        "country_id": 85,
        "country_code": "GR",
        "name": "Greece",
        "phonecode": 30
      },
      {
        "country_id": 86,
        "country_code": "GL",
        "name": "Greenland",
        "phonecode": 299
      },
      {
        "country_id": 87,
        "country_code": "GD",
        "name": "Grenada",
        "phonecode": 1473
      },
      {
        "country_id": 88,
        "country_code": "GP",
        "name": "Guadeloupe",
        "phonecode": 590
      },
      {
        "country_id": 89,
        "country_code": "GU",
        "name": "Guam",
        "phonecode": 1671
      },
      {
        "country_id": 90,
        "country_code": "GT",
        "name": "Guatemala",
        "phonecode": 502
      },
      {
        "country_id": 91,
        "country_code": "XU",
        "name": "Guernsey and Alderney",
        "phonecode": 44
      },
      {
        "country_id": 92,
        "country_code": "GN",
        "name": "Guinea",
        "phonecode": 224
      },
      {
        "country_id": 93,
        "country_code": "GW",
        "name": "Guinea-Bissau",
        "phonecode": 245
      },
      {
        "country_id": 94,
        "country_code": "GY",
        "name": "Guyana",
        "phonecode": 592
      },
      {
        "country_id": 95,
        "country_code": "HT",
        "name": "Haiti",
        "phonecode": 509
      },
      {
        "country_id": 96,
        "country_code": "HM",
        "name": "Heard and McDonald Islands",
        "phonecode": 0
      },
      {
        "country_id": 97,
        "country_code": "HN",
        "name": "Honduras",
        "phonecode": 504
      },
      {
        "country_id": 98,
        "country_code": "HK",
        "name": "Hong Kong S.A.R.",
        "phonecode": 852
      },
      {
        "country_id": 99,
        "country_code": "HU",
        "name": "Hungary",
        "phonecode": 36
      },
      {
        "country_id": 100,
        "country_code": "IS",
        "name": "Iceland",
        "phonecode": 354
      },
      {
        "country_id": 101,
        "country_code": "IN",
        "name": "India",
        "phonecode": 91
      },
      {
        "country_id": 102,
        "country_code": "ID",
        "name": "Indonesia",
        "phonecode": 62
      },
      {
        "country_id": 103,
        "country_code": "IR",
        "name": "Iran",
        "phonecode": 98
      },
      {
        "country_id": 104,
        "country_code": "IQ",
        "name": "Iraq",
        "phonecode": 964
      },
      {
        "country_id": 105,
        "country_code": "IE",
        "name": "Ireland",
        "phonecode": 353
      },
      {
        "country_id": 106,
        "country_code": "IL",
        "name": "Israel",
        "phonecode": 972
      },
      {
        "country_id": 107,
        "country_code": "IT",
        "name": "Italy",
        "phonecode": 39
      },
      {
        "country_id": 108,
        "country_code": "JM",
        "name": "Jamaica",
        "phonecode": 1876
      },
      {
        "country_id": 109,
        "country_code": "JP",
        "name": "Japan",
        "phonecode": 81
      },
      {
        "country_id": 110,
        "country_code": "XJ",
        "name": "Jersey",
        "phonecode": 44
      },
      {
        "country_id": 111,
        "country_code": "JO",
        "name": "Jordan",
        "phonecode": 962
      },
      {
        "country_id": 112,
        "country_code": "KZ",
        "name": "Kazakhstan",
        "phonecode": 7
      },
      {
        "country_id": 113,
        "country_code": "KE",
        "name": "Kenya",
        "phonecode": 254
      },
      {
        "country_id": 114,
        "country_code": "KI",
        "name": "Kiribati",
        "phonecode": 686
      },
      {
        "country_id": 115,
        "country_code": "KP",
        "name": "Korea North",
        "phonecode": 850
      },
      {
        "country_id": 116,
        "country_code": "KR",
        "name": "Korea South",
        "phonecode": 82
      },
      {
        "country_id": 117,
        "country_code": "KW",
        "name": "Kuwait",
        "phonecode": 965
      },
      {
        "country_id": 118,
        "country_code": "KG",
        "name": "Kyrgyzstan",
        "phonecode": 996
      },
      {
        "country_id": 119,
        "country_code": "LA",
        "name": "Laos",
        "phonecode": 856
      },
      {
        "country_id": 120,
        "country_code": "LV",
        "name": "Latvia",
        "phonecode": 371
      },
      {
        "country_id": 121,
        "country_code": "LB",
        "name": "Lebanon",
        "phonecode": 961
      },
      {
        "country_id": 122,
        "country_code": "LS",
        "name": "Lesotho",
        "phonecode": 266
      },
      {
        "country_id": 123,
        "country_code": "LR",
        "name": "Liberia",
        "phonecode": 231
      },
      {
        "country_id": 124,
        "country_code": "LY",
        "name": "Libya",
        "phonecode": 218
      },
      {
        "country_id": 125,
        "country_code": "LI",
        "name": "Liechtenstein",
        "phonecode": 423
      },
      {
        "country_id": 126,
        "country_code": "LT",
        "name": "Lithuania",
        "phonecode": 370
      },
      {
        "country_id": 127,
        "country_code": "LU",
        "name": "Luxembourg",
        "phonecode": 352
      },
      {
        "country_id": 128,
        "country_code": "MO",
        "name": "Macau S.A.R.",
        "phonecode": 853
      },
      {
        "country_id": 129,
        "country_code": "MK",
        "name": "Macedonia",
        "phonecode": 389
      },
      {
        "country_id": 130,
        "country_code": "MG",
        "name": "Madagascar",
        "phonecode": 261
      },
      {
        "country_id": 131,
        "country_code": "MW",
        "name": "Malawi",
        "phonecode": 265
      },
      {
        "country_id": 132,
        "country_code": "MY",
        "name": "Malaysia",
        "phonecode": 60
      },
      {
        "country_id": 133,
        "country_code": "MV",
        "name": "Maldives",
        "phonecode": 960
      },
      {
        "country_id": 134,
        "country_code": "ML",
        "name": "Mali",
        "phonecode": 223
      },
      {
        "country_id": 135,
        "country_code": "MT",
        "name": "Malta",
        "phonecode": 356
      },
      {
        "country_id": 136,
        "country_code": "XM",
        "name": "Man (Isle of)",
        "phonecode": 44
      },
      {
        "country_id": 137,
        "country_code": "MH",
        "name": "Marshall Islands",
        "phonecode": 692
      },
      {
        "country_id": 138,
        "country_code": "MQ",
        "name": "Martinique",
        "phonecode": 596
      },
      {
        "country_id": 139,
        "country_code": "MR",
        "name": "Mauritania",
        "phonecode": 222
      },
      {
        "country_id": 140,
        "country_code": "MU",
        "name": "Mauritius",
        "phonecode": 230
      },
      {
        "country_id": 141,
        "country_code": "YT",
        "name": "Mayotte",
        "phonecode": 269
      },
      {
        "country_id": 142,
        "country_code": "MX",
        "name": "Mexico",
        "phonecode": 52
      },
      {
        "country_id": 143,
        "country_code": "FM",
        "name": "Micronesia",
        "phonecode": 691
      },
      {
        "country_id": 144,
        "country_code": "MD",
        "name": "Moldova",
        "phonecode": 373
      },
      {
        "country_id": 145,
        "country_code": "MC",
        "name": "Monaco",
        "phonecode": 377
      },
      {
        "country_id": 146,
        "country_code": "MN",
        "name": "Mongolia",
        "phonecode": 976
      },
      {
        "country_id": 147,
        "country_code": "MS",
        "name": "Montserrat",
        "phonecode": 1664
      },
      {
        "country_id": 148,
        "country_code": "MA",
        "name": "Morocco",
        "phonecode": 212
      },
      {
        "country_id": 149,
        "country_code": "MZ",
        "name": "Mozambique",
        "phonecode": 258
      },
      {
        "country_id": 150,
        "country_code": "MM",
        "name": "Myanmar",
        "phonecode": 95
      },
      {
        "country_id": 151,
        "country_code": "NA",
        "name": "Namibia",
        "phonecode": 264
      },
      {
        "country_id": 152,
        "country_code": "NR",
        "name": "Nauru",
        "phonecode": 674
      },
      {
        "country_id": 153,
        "country_code": "NP",
        "name": "Nepal",
        "phonecode": 977
      },
      {
        "country_id": 154,
        "country_code": "AN",
        "name": "Netherlands Antilles",
        "phonecode": 599
      },
      {
        "country_id": 155,
        "country_code": "NL",
        "name": "Netherlands The",
        "phonecode": 31
      },
      {
        "country_id": 156,
        "country_code": "NC",
        "name": "New Caledonia",
        "phonecode": 687
      },
      {
        "country_id": 157,
        "country_code": "NZ",
        "name": "New Zealand",
        "phonecode": 64
      },
      {
        "country_id": 158,
        "country_code": "NI",
        "name": "Nicaragua",
        "phonecode": 505
      },
      {
        "country_id": 159,
        "country_code": "NE",
        "name": "Niger",
        "phonecode": 227
      },
      {
        "country_id": 160,
        "country_code": "NG",
        "name": "Nigeria",
        "phonecode": 234
      },
      {
        "country_id": 161,
        "country_code": "NU",
        "name": "Niue",
        "phonecode": 683
      },
      {
        "country_id": 162,
        "country_code": "NF",
        "name": "Norfolk Island",
        "phonecode": 672
      },
      {
        "country_id": 163,
        "country_code": "MP",
        "name": "Northern Mariana Islands",
        "phonecode": 1670
      },
      {
        "country_id": 164,
        "country_code": "NO",
        "name": "Norway",
        "phonecode": 47
      },
      {
        "country_id": 165,
        "country_code": "OM",
        "name": "Oman",
        "phonecode": 968
      },
      {
        "country_id": 166,
        "country_code": "PK",
        "name": "Pakistan",
        "phonecode": 92
      },
      {
        "country_id": 167,
        "country_code": "PW",
        "name": "Palau",
        "phonecode": 680
      },
      {
        "country_id": 168,
        "country_code": "PS",
        "name": "Palestinian Territory Occupied",
        "phonecode": 970
      },
      {
        "country_id": 169,
        "country_code": "PA",
        "name": "Panama",
        "phonecode": 507
      },
      {
        "country_id": 170,
        "country_code": "PG",
        "name": "Papua new Guinea",
        "phonecode": 675
      },
      {
        "country_id": 171,
        "country_code": "PY",
        "name": "Paraguay",
        "phonecode": 595
      },
      {
        "country_id": 172,
        "country_code": "PE",
        "name": "Peru",
        "phonecode": 51
      },
      {
        "country_id": 173,
        "country_code": "PH",
        "name": "Philippines",
        "phonecode": 63
      },
      {
        "country_id": 174,
        "country_code": "PN",
        "name": "Pitcairn Island",
        "phonecode": 0
      },
      {
        "country_id": 175,
        "country_code": "PL",
        "name": "Poland",
        "phonecode": 48
      },
      {
        "country_id": 176,
        "country_code": "PT",
        "name": "Portugal",
        "phonecode": 351
      },
      {
        "country_id": 177,
        "country_code": "PR",
        "name": "Puerto Rico",
        "phonecode": 1787
      },
      {
        "country_id": 178,
        "country_code": "QA",
        "name": "Qatar",
        "phonecode": 974
      },
      {
        "country_id": 179,
        "country_code": "RE",
        "name": "Reunion",
        "phonecode": 262
      },
      {
        "country_id": 180,
        "country_code": "RO",
        "name": "Romania",
        "phonecode": 40
      },
      {
        "country_id": 181,
        "country_code": "RU",
        "name": "Russia",
        "phonecode": 70
      },
      {
        "country_id": 182,
        "country_code": "RW",
        "name": "Rwanda",
        "phonecode": 250
      },
      {
        "country_id": 183,
        "country_code": "SH",
        "name": "Saint Helena",
        "phonecode": 290
      },
      {
        "country_id": 184,
        "country_code": "KN",
        "name": "Saint Kitts And Nevis",
        "phonecode": 1869
      },
      {
        "country_id": 185,
        "country_code": "LC",
        "name": "Saint Lucia",
        "phonecode": 1758
      },
      {
        "country_id": 186,
        "country_code": "PM",
        "name": "Saint Pierre and Miquelon",
        "phonecode": 508
      },
      {
        "country_id": 187,
        "country_code": "VC",
        "name": "Saint Vincent And The Grenadines",
        "phonecode": 1784
      },
      {
        "country_id": 188,
        "country_code": "WS",
        "name": "Samoa",
        "phonecode": 684
      },
      {
        "country_id": 189,
        "country_code": "SM",
        "name": "San Marino",
        "phonecode": 378
      },
      {
        "country_id": 190,
        "country_code": "ST",
        "name": "Sao Tome and Principe",
        "phonecode": 239
      },
      {
        "country_id": 191,
        "country_code": "SA",
        "name": "Saudi Arabia",
        "phonecode": 966
      },
      {
        "country_id": 192,
        "country_code": "SN",
        "name": "Senegal",
        "phonecode": 221
      },
      {
        "country_id": 193,
        "country_code": "RS",
        "name": "Serbia",
        "phonecode": 381
      },
      {
        "country_id": 194,
        "country_code": "SC",
        "name": "Seychelles",
        "phonecode": 248
      },
      {
        "country_id": 195,
        "country_code": "SL",
        "name": "Sierra Leone",
        "phonecode": 232
      },
      {
        "country_id": 196,
        "country_code": "SG",
        "name": "Singapore",
        "phonecode": 65
      },
      {
        "country_id": 197,
        "country_code": "SK",
        "name": "Slovakia",
        "phonecode": 421
      },
      {
        "country_id": 198,
        "country_code": "SI",
        "name": "Slovenia",
        "phonecode": 386
      },
      {
        "country_id": 199,
        "country_code": "XG",
        "name": "Smaller Territories of the UK",
        "phonecode": 44
      },
      {
        "country_id": 200,
        "country_code": "SB",
        "name": "Solomon Islands",
        "phonecode": 677
      },
      {
        "country_id": 201,
        "country_code": "SO",
        "name": "Somalia",
        "phonecode": 252
      },
      {
        "country_id": 202,
        "country_code": "ZA",
        "name": "South Africa",
        "phonecode": 27
      },
      {
        "country_id": 203,
        "country_code": "GS",
        "name": "South Georgia",
        "phonecode": 0
      },
      {
        "country_id": 204,
        "country_code": "SS",
        "name": "South Sudan",
        "phonecode": 211
      },
      {
        "country_id": 205,
        "country_code": "ES",
        "name": "Spain",
        "phonecode": 34
      },
      {
        "country_id": 206,
        "country_code": "LK",
        "name": "Sri Lanka",
        "phonecode": 94
      },
      {
        "country_id": 207,
        "country_code": "SD",
        "name": "Sudan",
        "phonecode": 249
      },
      {
        "country_id": 208,
        "country_code": "SR",
        "name": "Suriname",
        "phonecode": 597
      },
      {
        "country_id": 209,
        "country_code": "SJ",
        "name": "Svalbard And Jan Mayen Islands",
        "phonecode": 47
      },
      {
        "country_id": 210,
        "country_code": "SZ",
        "name": "Swaziland",
        "phonecode": 268
      },
      {
        "country_id": 211,
        "country_code": "SE",
        "name": "Sweden",
        "phonecode": 46
      },
      {
        "country_id": 212,
        "country_code": "CH",
        "name": "Switzerland",
        "phonecode": 41
      },
      {
        "country_id": 213,
        "country_code": "SY",
        "name": "Syria",
        "phonecode": 963
      },
      {
        "country_id": 214,
        "country_code": "TW",
        "name": "Taiwan",
        "phonecode": 886
      },
      {
        "country_id": 215,
        "country_code": "TJ",
        "name": "Tajikistan",
        "phonecode": 992
      },
      {
        "country_id": 216,
        "country_code": "TZ",
        "name": "Tanzania",
        "phonecode": 255
      },
      {
        "country_id": 217,
        "country_code": "TH",
        "name": "Thailand",
        "phonecode": 66
      },
      {
        "country_id": 218,
        "country_code": "TG",
        "name": "Togo",
        "phonecode": 228
      },
      {
        "country_id": 219,
        "country_code": "TK",
        "name": "Tokelau",
        "phonecode": 690
      },
      {
        "country_id": 220,
        "country_code": "TO",
        "name": "Tonga",
        "phonecode": 676
      },
      {
        "country_id": 221,
        "country_code": "TT",
        "name": "Trinidad And Tobago",
        "phonecode": 1868
      },
      {
        "country_id": 222,
        "country_code": "TN",
        "name": "Tunisia",
        "phonecode": 216
      },
      {
        "country_id": 223,
        "country_code": "TR",
        "name": "Turkey",
        "phonecode": 90
      },
      {
        "country_id": 224,
        "country_code": "TM",
        "name": "Turkmenistan",
        "phonecode": 7370
      },
      {
        "country_id": 225,
        "country_code": "TC",
        "name": "Turks And Caicos Islands",
        "phonecode": 1649
      },
      {
        "country_id": 226,
        "country_code": "TV",
        "name": "Tuvalu",
        "phonecode": 688
      },
      {
        "country_id": 227,
        "country_code": "UG",
        "name": "Uganda",
        "phonecode": 256
      },
      {
        "country_id": 228,
        "country_code": "UA",
        "name": "Ukraine",
        "phonecode": 380
      },
      {
        "country_id": 229,
        "country_code": "AE",
        "name": "United Arab Emirates",
        "phonecode": 971
      },
      {
        "country_id": 230,
        "country_code": "GB",
        "name": "United Kingdom",
        "phonecode": 44
      },
      {
        "country_id": 231,
        "country_code": "US",
        "name": "United States",
        "phonecode": 1
      },
      {
        "country_id": 232,
        "country_code": "UM",
        "name": "United States Minor Outlying Islands",
        "phonecode": 1
      },
      {
        "country_id": 233,
        "country_code": "UY",
        "name": "Uruguay",
        "phonecode": 598
      },
      {
        "country_id": 234,
        "country_code": "UZ",
        "name": "Uzbekistan",
        "phonecode": 998
      },
      {
        "country_id": 235,
        "country_code": "VU",
        "name": "Vanuatu",
        "phonecode": 678
      },
      {
        "country_id": 236,
        "country_code": "VA",
        "name": "Vatican City State (Holy See)",
        "phonecode": 39
      },
      {
        "country_id": 237,
        "country_code": "VE",
        "name": "Venezuela",
        "phonecode": 58
      },
      {
        "country_id": 238,
        "country_code": "VN",
        "name": "Vietnam",
        "phonecode": 84
      },
      {
        "country_id": 239,
        "country_code": "VG",
        "name": "Virgin Islands (British)",
        "phonecode": 1284
      },
      {
        "country_id": 240,
        "country_code": "VI",
        "name": "Virgin Islands (US)",
        "phonecode": 1340
      },
      {
        "country_id": 241,
        "country_code": "WF",
        "name": "Wallis And Futuna Islands",
        "phonecode": 681
      },
      {
        "country_id": 242,
        "country_code": "EH",
        "name": "Western Sahara",
        "phonecode": 212
      },
      {
        "country_id": 243,
        "country_code": "YE",
        "name": "Yemen",
        "phonecode": 967
      },
      {
        "country_id": 244,
        "country_code": "YU",
        "name": "Yugoslavia",
        "phonecode": 38
      },
      {
        "country_id": 245,
        "country_code": "ZM",
        "name": "Zambia",
        "phonecode": 260
      },
      {
        "country_id": 246,
        "country_code": "ZW",
        "name": "Zimbabwe",
        "phonecode": 263
      }
    ]
  };



  Future<void> fetchCountriesApi() async {
    try {
      final response = await _authChopperService.fetchCountries();
      if (response.body?.status == 200) {
        allCountriesDataModel = response.body;
      } else {}
      update();
    } catch (e) {
      update();
      log('', name: 'All countries Fetch Api Error', error: e.toString());
    }
  }


  Future<void> getTimeZone({CountriesData? data}) async {
    try {
      final queryParameters = {'countrycode': data?.countryCode ?? ''};
      final response = await _authChopperService.fetchTimeZone(
          queryParameters: queryParameters);
      if (response.body?.status == 200) {
        countryId = data?.countryId ?? -1;
        countryController.text = data?.name ?? '';
        timezoneDataModel = response.body;
        Get.back();
      }
      update();
    } catch (e) {
      countryController.text = data?.name ?? '';
      Get.back();
      log('', name: 'Time Zone Api Error', error: e.toString());
    }
  }


  Future<void> introductionSlider()async{
    try{
      final response=await _authChopperService.introSliderApi();
      if(response.body?.status==200){
        introductionDataModel=response.body;
      }
      update();
    }catch(e){
      log('', name: 'Introduction Slider Api Error', error: e.toString());
    }
  }

}
