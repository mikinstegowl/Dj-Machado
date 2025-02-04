import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/Constants/AppConst.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:newmusicappmachado/Utils/Styling/AppColors.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class TermsAndPrivacyWidget extends StatefulWidget {
  const  TermsAndPrivacyWidget({super.key});

  @override
  State<TermsAndPrivacyWidget> createState() => _TermsAndPrivacyWidgetState();
}

class _TermsAndPrivacyWidgetState extends State<TermsAndPrivacyWidget> {
 late TapGestureRecognizer _termsConditionRecognizer;

 late TapGestureRecognizer _privacyPolicyRecognizer;


  @override
  void dispose() {
    _privacyPolicyRecognizer.dispose();
    _termsConditionRecognizer.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _termsConditionRecognizer = TapGestureRecognizer()
      ..onTap = () {
       Get.find<AuthController>().termsAndPrivacy(value: "terms",authChopperService: AppChopperClient().getChopperService<AuthChopperService>());
      };
    _privacyPolicyRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Get.find<BaseController>().termsAndPrivacy(value: "privacy",authChopperService: AppChopperClient().getChopperService<AuthChopperService>());
      };
  }
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text:   TextSpan(
        text: 'By signing to ${AppConst.appName} App\n you agree to all',
        style: TextStyle(fontFamily: 'Century Gothic'),
        children: <TextSpan>[
          TextSpan(
              recognizer:_termsConditionRecognizer,
              text: ' Terms of Service',

              style: TextStyle(color: AppColors.primary,fontFamily: "Century Gothic")),
          TextSpan(text: ' and ',style: TextStyle(fontFamily: 'Century Gothic')),
          TextSpan(
              recognizer: _privacyPolicyRecognizer,
              text: 'Privacy Policy',
              style: TextStyle(color: AppColors.primary,fontFamily: 'Century Gothic')),
        ],
      ),
    );
  }
}
