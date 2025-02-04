import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bottom_picker/bottom_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/NotificationDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/ProfileDataModel.dart';
import 'package:newmusicappmachado/Utils/Models/TimezoneDataModel.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/PrefKeys.dart';
import 'package:newmusicappmachado/Utils/SharedPreferences/shared_preferences.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart'as http;

class ProfileController extends BaseController{


  late HomeChopperService _homeChopperService;
   TextEditingController userNameController=TextEditingController();
   TextEditingController dobController=TextEditingController();
   TextEditingController emailController=TextEditingController();
   TextEditingController mobileController=TextEditingController();
   TextEditingController textController = TextEditingController();
   GlobalKey<FormState> formKey = GlobalKey<FormState>();
   GlobalKey<FormState> changeFormKey = GlobalKey<FormState>();
  TextEditingController countryController = TextEditingController();
  TextEditingController currentPasswordController=TextEditingController();
  TextEditingController newPasswordController=TextEditingController();
  TextEditingController confirmNewPasswordController=TextEditingController();
  AllCountriesDataModel? allCountriesDataModel;
  TimezoneDataModel? timezoneDataModel;
  int countryId = -1;

  ProfileController({required HomeChopperService homeChopperService}) {
    _homeChopperService = homeChopperService;
  }
  var selectCountry;
  int page =1;
  int? maxPages;



  @override
  void onInit() async {
    super.onInit();
    scrollController.addListener((){
      scrollListener();
    });
  }


  Future<void> updateUserProfile() async {
    try {
      final param = {
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "name":  userNameController.text,
        "user_name": userNameController.text,
        "contact": mobileController.text,
        "birthdate": dobController.text,
        "email": emailController.text,
        "image":  profileDataModel?.data?[0].image,
        "country": countryId,
        "timezone": timezoneDataModel?.data?[0].zoneName,
      };
      final response = await _homeChopperService.updateUserProfile(
          param: param);
      if (response.body?.status == 200) {
        profileDataModel = response.body;
        userNameController =
            TextEditingController(text: response.body?.data?[0].userName ?? '');
        emailController =
            TextEditingController(text: response.body?.data?[0].email ?? '');
        mobileController = TextEditingController(
            text: response.body?.data?[0].contact
                ?.toString()
                .toPhoneNumberFormat() ??
                '');
        dobController = TextEditingController(
            text: response.body?.data?[0].birthdate ?? '');
       Get.back();
        getProfileData();
        Utility.showSnackBar(response.body?.message);
        update();
      } else {
        Get.snackbar('Error', response.body?.message ?? '');
      }
      update;
    } catch (e) {
      Get.snackbar('Error', e.toString() ?? '');
      log('', error: e.toString(), name: "Get Profile Data Error");
    }
  }

  ScrollController scrollController = ScrollController();

  Future<void> scrollListener() async {
    if (scrollController.hasClients) {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        if (page < maxPages!) {
          page++;
          await notificationApi(); // Fetch next page
        }
      }
    }
  }


  NotificationsDataModel? notificationsDataModel;
  Future<void>notificationApi()async{
    try{
      final queryParameters={
        "filter":UserPreference.getValue(key: PrefKeys.userId)
        ,"limit":50,
        "page": page,
      };
      final response=await _homeChopperService.notification(queryParameters: queryParameters);
      if(response.body?.status==200){
        if(page ==1){
          notificationsDataModel=response.body;
          maxPages = notificationsDataModel?.lastPage;
        }else{
          notificationsDataModel?.data?.addAll(response.body?.data??[]);
        }

      }else{
        notificationsDataModel?.data=[];
      }
      update();
    }catch(e){
      log("", error: e.toString(), name: "Notification Api Error");
    }
  }



  ProfileDataModel? profileDataModel;

  Future<void> getProfileData() async {
    try {
      final queryParameters = {
        "filter": UserPreference.getValue(key: PrefKeys.userId)
      };
      final response = await _homeChopperService.profileApi(
          queryParameters: queryParameters);

      if (response.body?.status == 200) {
       await fetchCountriesApi();
        profileDataModel = response.body;
        userNameController =
            TextEditingController(text: response.body?.data?[0].userName ?? '');
        emailController =
            TextEditingController(text: response.body?.data?[0].email ?? '');
        mobileController = TextEditingController(
            text: response.body?.data?[0].contact
                ?.toString()
                .toPhoneNumberFormat() ??
                '');
        dobController = TextEditingController(
            text: response.body?.data?[0].birthdate ?? '');
        countryController=TextEditingController(text:
        allCountriesDataModel?.data?.firstWhere((v)=>v.countryId== response.body?.data?[0].countryId).name??'');
        update();
        notificationApi();
      } else {
        Get.snackbar('Error', response.body?.message ?? '');
      }
      update;
    } catch (e) {
      Get.snackbar('Error', e.toString() ?? '');
      log('', error: e.toString(), name: "Get Profile Data Error");
    }
  }


  Future<void> getFile() async {
    var status = await Permission.mediaLibrary.status;
    if (status.isDenied) {
      status = await Permission.mediaLibrary.request();
    }
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (result != null) {
      File files = File(result.files.single.path ?? '');

      final croppedFile = await ImageCropper()
          .cropImage(sourcePath: files.path ?? '',
          uiSettings: [
        AndroidUiSettings(lockAspectRatio: false),
      ]);
      file = File(croppedFile?.path ?? '');
      await imageUpload();
      print(file);
      update();
    } else {
      // User canceled the picker
      // You can show snackbar or fluttertoast
      // here like this to show warning to user
      // ignore: use_build_context_synchronously
      Utility.showSnackBar("error in picking file", isError: true);
    }
  }

  Future<void> getCameraImage() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    // FilePickerResult? result = await FilePicker.platform
    //     .pickFiles(type: FileType.image, withData: true);
    XFile? result = await ImagePicker.platform.getImageFromSource(
      source: ImageSource.camera,
    );
    print(result);
    if (result != null) {
      File files = File(result.path ?? '');

      final croppedFile = await ImageCropper()
          .cropImage(sourcePath: files.path ?? '',
      //     aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ],
          uiSettings: [
        AndroidUiSettings(lockAspectRatio: false),
      ]);
      file = File(croppedFile?.path ?? '');
      await imageUpload();
      print(file);
      update();
    } else {
      // User canceled the picker
      // You can show snackbar or fluttertoast
      // here like this to show warning to user
      // ignore: use_build_context_synchronously
      Utility.showSnackBar("error in picking file", isError: true);
    }
  }
  Future<void> imageUpload() async {
    try {
      if (file?.path != null) {
        final response = http.MultipartRequest(
            "POST",
            Uri.parse(
                "https://theapophis.com/apophis/api/uploads"));
        response.files.add(await http.MultipartFile.fromPath(
          'image',
          file?.path ?? '',
        ));
        final streamedResponse = await response.send();
        if (streamedResponse.statusCode == 200) {
          final responseString =
          await streamedResponse.stream.transform(utf8.decoder).join();
          final decodedBody = jsonDecode(responseString);
          Get.find<ProfileController>().profileDataModel?.data?[0].image = decodedBody['image'];


          // Get.find<HomeController>().getProfileData();
          update();
          Get.find<HomeController>().update();
        }
      } else {
        Get.back();
        Utility.showSnackBar('Something went wrong in Upload Image',
            isError: true);
      }
    } catch (e) {
      rethrow;
    }
  }
  void openDatePicker(BuildContext context) {
    BottomPicker.date(
      dismissable: true,
      backgroundColor: AppColors.black,
      titleAlignment: Alignment.center,
      buttonStyle: BoxDecoration(
        image: const DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors
                  .primary, // Change this to the desired color
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
          dobController.text = dobController.text;
          Get.back();
          update();
        },
        btnName: 'Select',
        fontSize: 16,
        fontWeight: FontWeight.w900,
        txtColor: AppColors.black,
        image: const DecorationImage(
            colorFilter: ColorFilter.mode(
              AppColors
                  .primary, // Change this to the desired color
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
      initialDateTime:dobController.text!=''? DateFormat("MMMM dd, yyyy").parse(dobController.text) : DateTime.now(),
      maxDateTime: DateTime.now(),
      minDateTime: DateTime(1900),
      pickerTextStyle: const TextStyle(
        color: AppColors.white,
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),

      onChange: (index) {
        print(index.runtimeType);
        dobController.text = (index as DateTime).toFormattedDate();
      },
      onSubmit: (index) {
        dobController.text = (index as DateTime).toFormattedDate();
        // Format the date as needed, here using 'yyyy-MM-dd'
      },

    ).show(context);
  }


  Future<void> selectDate(BuildContext context) async {
    String cleanedDate = dobController.text.replaceAll(RegExp(r'(st|nd|rd|th)'), '');
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.tryParse(DateFormat("MMMM d, yyyy")
          .parse(cleanedDate)
          .toIso8601String()) ??
          DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.tryParse(dobController.text)) {
      // selectedDate.value = picked;
      // Format the date as needed, here using 'yyyy-MM-dd'
      dobController.text = "${picked.toFormattedDate()}";
      print(dobController.text);
      update();
    }
  }

  Future<void> changePasswordApi()async{
    try{
      final param={
        "user_id": UserPreference.getValue(key: PrefKeys.userId),
        "current_password":currentPasswordController.text,
        "new_password": newPasswordController.text,
        "confirm_password": confirmNewPasswordController.text

      };

      final response=await _homeChopperService.changePassword(param: param);
      if(response.body?.code==200){
        Get.back();
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmNewPasswordController.clear();
        Utility.showSnackBar(response.body?.message);
      }else{
        Utility.showSnackBar(response.body?.message,isError: true);
      }
    }catch(e){ log("", error: e.toString(), name: "Change password Api Error");}
  }


  Future<void> fetchCountriesApi() async {
    try {
      final response = await _homeChopperService.fetchCountries();
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
      final response = await _homeChopperService.fetchTimeZone(
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

}