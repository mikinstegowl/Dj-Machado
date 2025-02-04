import 'package:newmusicappmachado/Controller/MixesController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class MixesBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => MixesController(
        homeChopperService:
            AppChopperClient().getChopperService<HomeChopperService>()));
  }
}
