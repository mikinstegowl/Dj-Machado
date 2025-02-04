import 'package:newmusicappmachado/Controller/ProfileController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class ProfileBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> ProfileController(homeChopperService:
        AppChopperClient().getChopperService<HomeChopperService>()),fenix: true);
    // TODO: implement dependencies
  }

}