import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Constants/Validators.dart';
import 'package:newmusicappmachado/Utils/Models/AllCountriesDataModel.dart';
import 'package:newmusicappmachado/Utils/Router/RouteName.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextFormField.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CachedNetworkImageWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/Dialogs/UploadImageDialog.dart';
import 'package:newmusicappmachado/View/EditProfileScreen/Widget/EditProfileTextFromFiled.dart';
import 'package:newmusicappmachado/View/ViewProfileScreen/Widgets/ProfileTextFormFiled.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditProfileScreen extends GetView<ProfileController> {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: controller,
      builder: (controller) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: AppColors.black,
                child:
                // ListTile(
                //   leading: InkWell(
                //     onTap: () {
                //       Get.back();
                //     },
                //     child: const AppTextWidget(
                //       txtTitle: 'Cancel',
                //       fontSize: 14,
                //       fontWeight: FontWeight.w500,
                //     ),
                //   ),
                //   title: const Center(
                //       child: AppTextWidget(
                //     txtTitle: "EDIT ACCOUNT",
                //     fontWeight: FontWeight.bold,
                //   )),
                //   trailing: AppButtonWidget(
                //     onPressed: () async {
                //       if(controller.mobileController.text.isNotEmpty && controller.mobileController.text.length==12){
                //         await controller.updateUserProfile();
                //       }
                //       Utility.showSnackBar("Please enter correct phone number",isError: true);
                //     },
                //     btnName: 'Save',
                //
                //     fontSize: 12,
                //     fontWeight: FontWeight.w900,
                //     txtColor: AppColors.black,
                //     image: const DecorationImage(
                //         fit: BoxFit.fill,
                //         colorFilter: ColorFilter.mode(
                //           AppColors.primary, // Change this to the desired color
                //           BlendMode.srcATop,
                //         ),
                //         image: AssetImage(
                //           AppAssets.buttonBackgroundImage,
                //         )),
                //     padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                //     // btnColor: AppColors.primary,
                //   ),
                // ),
                ListTile(
                  leading: InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const AppTextWidget(
                      txtTitle: 'Cancel',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  title: const Center(
                    child: AppTextWidget(
                      txtTitle: "EDIT ACCOUNT",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: SizedBox(
                    height: 30,
                    width: 100, // Adjust the width as per your requirement
                    child: AppButtonWidget(
                      onPressed: () async {
                        if (controller.mobileController.text.isNotEmpty &&
                            controller.mobileController.text.length == 12) {
                          await controller.updateUserProfile();
                        } else {
                          Utility.showSnackBar("Please enter correct phone number", isError: true);
                        }
                      },
                      btnName: 'Save',
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                      txtColor: AppColors.black,
                      image: const DecorationImage(
                        fit: BoxFit.fill,
                        colorFilter: ColorFilter.mode(
                          AppColors.primary,
                          BlendMode.srcATop,
                        ),
                        image: AssetImage(
                          AppAssets.buttonBackgroundImage,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 20.w),
                    ),
                  ),
                ),

              ),
              Container(
                height: 200.h,
                decoration: BoxDecoration(color: AppColors.black),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        CachedNetworkImageWidget(
                          image:  controller.profileDataModel?.data?[0].image,
                          height: 170.h,
                          width: double.maxFinite,
                        ),
                        Container(
                          height: 30.h,
                          color: AppColors.black.withOpacity(0.3),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              AppTextWidget(
                                txtTitle: 'Tap the fields to edit',
                                fontSize: 14.h,
                              ),
                              10.horizontalSpace
                            ],
                          ),
                        )
                      ],
                    ),
                    Positioned(
                        bottom: 20.h,
                        left: 10.w,
                        child: InkWell(
                          onTap: (){
                            Get.dialog(UploadImageDialog());
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: AppColors.darkgrey, shape: BoxShape.circle),
                            padding: EdgeInsets.all(5.r),
                            child: Icon(
                              Icons.camera_alt_rounded,
                              size: 40.r,
                              color: AppColors.white,
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Container(
                color: AppColors.black,
                child: Column(
                  children: [
                    ProfileTextFormFiled(
                      controller: controller.userNameController,
                      textFiledName: 'Enter Username',
                      readOnly: true,

                    ),
                    10.verticalSpace,
                    ProfileTextFormFiled(
                      controller: controller.emailController,
                      textFiledName: 'Enter Email',
                      readOnly: true,
                    ),
                    10.verticalSpace,
                    ProfileTextFormFiled(
                      inputFormatters: [
                        PhoneNumberFormatter(),
                        LengthLimitingTextInputFormatter(12),
                      ],
                      validator: (value) =>
                          mobileNoValidation(value),
                      keyboardType: const TextInputType.numberWithOptions(),
                      controller: controller.mobileController,
                      textFiledName: 'Enter Phone Number',
                      readOnly: false,
                    ),
                    10.verticalSpace,
                    ProfileTextFormFiled(
                      onTap: () async {
                         controller.openDatePicker(context);
                      },
                      controller: controller.dobController,
                      textFiledName: 'Enter DOB',
                      readOnly: true,
                    ),
                    ProfileTextFormFiled(
                        onTap: () async {
                          Get.bottomSheet(
                              isScrollControlled: false,
                              Container(
                                height: 300.h,
                                padding: EdgeInsets.only(top: 10.h),
                                color:  AppColors.black,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const  AppTextWidget(txtTitle: "Tap on country you want to select",txtColor: AppColors.white,),
                                    Center(
                                      child: SizedBox(
                                        height: 250.h,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: CupertinoPicker(
                                                itemExtent: 35.h,
                                                scrollController:FixedExtentScrollController(
                                                    initialItem:controller.allCountriesDataModel?.data?.indexOf(controller.allCountriesDataModel?.data?.firstWhere((v)=>v.name==controller.countryController.text)??CountriesData())??0
                                                ),
                                                backgroundColor:
                                                AppColors.black,
                                                onSelectedItemChanged:
                                                    (int value) {
                                                  print(controller.allCountriesDataModel?.data?[value].name);
                                                  controller.selectCountry = controller.allCountriesDataModel?.data?[value];
                                                  // controller.getTimeZone(data: controller.allCountriesDataModel?.data?[value]);
                                                },
                                                selectionOverlay: Container(
                                                  color: AppColors.white.withOpacity(0.3),
                                                ),
                                                children: controller.allCountriesDataModel?.data?.map((e)=>Center(child: InkWell(
                                                    onTap:(){
                                                      // controller.getTimeZone(data:e);

                                                    },child: AppTextWidget(txtTitle: e.name??'',)),
                                                )).toList()??[const SizedBox()],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 0,
                                              child: AppButtonWidget(
                                                padding: EdgeInsets.symmetric(horizontal: 20.w),
                                                onPressed: () async {
                                                  controller.getTimeZone(data:controller.selectCountry ?? controller.allCountriesDataModel?.data?[0]);
                                                  // Format the date as needed, here using 'yyyy-MM-dd'
                                                  // dobController.text = "${selectedDate.value?.toFormattedDate()}";
                                                  // Get.back();
                                                  // update();
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
                                            ),
                                            20.verticalSpace,
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ));

                          // controller.openSimpleItemPicker(context, controller.countryList);
                        },
                        readOnly: true,
                        textFiledName: 'Select Country',
                        controller: controller.countryController),

                    30.verticalSpace,
                    Center(
                      child: AppButtonWidget(
                        onPressed: () async {
                          Get.toNamed(RoutesName.changePasswordScreen);
                        },
                        btnName: 'Change Password',
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        txtColor: AppColors.black,
                        image: const DecorationImage(
                            fit: BoxFit.fill,
                            colorFilter: ColorFilter.mode(
                              AppColors.primary, // Change this to the desired color
                              BlendMode.srcATop,
                            ),
                            image: AssetImage(
                              AppAssets.buttonBackgroundImage,
                            )),
                        margin: EdgeInsets.symmetric(horizontal: 50.w),
                        padding:
                            EdgeInsets.symmetric(vertical: 5.h, horizontal: 20.w),
                        // btnColor: AppColors.primary,
                      ),
                    ),
                    100.verticalSpace,
                  ],
                ),
              )
            ],
          ),
        );
      }
    );
  }
}
