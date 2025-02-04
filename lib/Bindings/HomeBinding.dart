import 'package:newmusicappmachado/Controller/AdvanceSearchController.dart';
import 'package:newmusicappmachado/Controller/BaseController.dart';
import 'package:newmusicappmachado/Controller/HomeController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class Homebinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(BaseController(), permanent: true);
    Get.put(
        HomeController(
            homeChopperService:
                AppChopperClient().getChopperService<HomeChopperService>()),
        permanent: true);
    Get.lazyPut(
        () => (AdvanceSearchController(
            homeChopperService:
                AppChopperClient().getChopperService<HomeChopperService>())),
        fenix: true);
  }
}
