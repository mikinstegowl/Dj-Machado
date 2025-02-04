import 'package:newmusicappmachado/Controller/ArtistsController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class ArtistsBinding implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => ArtistsController(
        homeChopperService:
            AppChopperClient().getChopperService<HomeChopperService>()),fenix: true);
  }
}
