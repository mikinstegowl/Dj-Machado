import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/Constants/AppAssets.dart';
import 'package:newmusicappmachado/Utils/Constants/AppConst.dart';
import 'package:newmusicappmachado/Utils/Constants/AppExtension.dart';
import 'package:newmusicappmachado/Utils/Constants/CustomSnackBar.dart';
import 'package:newmusicappmachado/Utils/Constants/Validators.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppButtonWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppLoder.dart';
import 'package:newmusicappmachado/Utils/Widgets/AppTextWidget.dart';
import 'package:newmusicappmachado/Utils/Widgets/CommonAppBar.dart';
import 'package:newmusicappmachado/Utils/Widgets/TermsAndPrivacyWidget.dart';
import 'package:newmusicappmachado/View/SignUpScreen/Widget/SignUpTextFormField.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends GetView<AuthController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBodyBehindAppBar: true,
            appBar: CommonAppBar(
              showLogo: true,
              searchBarShow: false,
              image: AppAssets.logo,
              title: "Create A Free Account",
            ),
            body: Container(
              padding: EdgeInsets.only(top: AppBar().preferredSize.height.h + 50.h),
              height: MediaQuery.sizeOf(context).height,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage(AppAssets.backGroundImage))),
              child: SingleChildScrollView(
                child: GetBuilder<AuthController>(
                    init: controller,
                    initState: (controllerState){
                      controller.fetchCountriesApi();
                    },
                    builder: (controller) {
                      return Column(
                        children: [
                          10.verticalSpace,
                          Container(
                              color: AppColors.black,
                              child: Form(
                                key: controller.signUpFormKey,
                                child: Column(
                                  children: [
                                    10.verticalSpace,
                                    SignUpTextFormField(
                                      validator: (value) =>
                                          isRequiredField(value: value),
                                      controller: controller.userNameController,
                                      textFiledName: 'Enter Username',
                                    ),
                                    30.verticalSpace,
                                    SignUpTextFormField(
                                      validator: (value) =>
                                          validateEmail(value: value),
                                      textFiledName: 'Enter Email',
                                      controller: controller.emailController,
                                    ),
                                    30.verticalSpace,
                                    SignUpTextFormField(
                                      validator: (value) =>
                                          mobileNoValidation(value),
                                      textFiledName: 'Enter Phone Number',
                                      inputFormatters: [
                                        PhoneNumberFormatter(),
                                        LengthLimitingTextInputFormatter(12),
                                      ],
                                      keyboardType: TextInputType.number,
                                      controller: controller.phoneNumberController,
                                    ),
                                    30.verticalSpace,
                                    SignUpTextFormField(
                                        onTap: ()  {
                                           controller.openDatePicker(context);
                                        },
                                        readOnly: true,
                                        textFiledName: 'Enter DOB',
                                        controller: controller.dobController),
                                    30.verticalSpace,
                                    SignUpTextFormField(
                                      validator: (value) => validatePassword(value),
                                      onChanged: (v) {
                                        controller.createPasswordController.text =
                                            v;
                                      },
                                      controller:
                                          controller.createPasswordController,
                                      textFiledName: 'Create a Password',
                                      isPassword: true,
                                    ),
                                    30.verticalSpace,
                                    SignUpTextFormField(
                                      validator: (value) =>validateConfirmPassword(value, controller.createPasswordController.text),
                                      controller:
                                          controller.confirmPasswordController,
                                      textFiledName: 'Confirm Your Password',
                                      isPassword: true,
                                    ),
                                    30.verticalSpace,
                                    SignUpTextFormField(
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
                                  ],
                                ),
                              )),
                          20.verticalSpace,
                          TermsAndPrivacyWidget(),
                          20.verticalSpace,
                          Center(
                            child: AppButtonWidget(
                              onPressed: () async {
                                if ((controller.signUpFormKey.currentState
                                        ?.validate()??false) && controller.confirmPasswordController.text == controller.createPasswordController.text
                                    ) {
                                  print(DateTime.now().timeZoneOffset);
                                  print(controller.confirmPasswordController.text == controller.createPasswordController.text);
                                  await controller.createUserApi();
                                }else{

                                  Utility.showSnackBar("Password does not match",isError: true);
                                }
                              },
                              btnName: 'Sign Up',
                              fontSize: 18,
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
                              padding: EdgeInsets.symmetric(
                                  vertical: 10.h, horizontal: 25.w),
                              // btnColor: AppColors.primary,
                            ),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ),
        ),
        Obx(()=> Visibility(
          visible: controller.isLoading.value,
            child: AppLoder()))
      ],
    );
  }
}
