import 'package:newmusicappmachado/Controller/ExplorController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class ExplorBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(ExplorController(
        homeChopperService:
            AppChopperClient().getChopperService<HomeChopperService>()));
  }
}
