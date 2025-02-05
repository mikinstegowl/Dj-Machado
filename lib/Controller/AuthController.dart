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
      showLoader(true);
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

        showLoader(false);
        update();
      }
    } catch (e) {
      showLoader(false);
      update();
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
