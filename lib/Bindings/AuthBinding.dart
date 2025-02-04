import 'package:newmusicappmachado/Controller/AuthController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/AuthChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class AuthBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => AppChopperClient());
    Get.lazyPut(() => AuthController(
        authChopperService:
            AppChopperClient().getChopperService<AuthChopperService>()));
  }
}
