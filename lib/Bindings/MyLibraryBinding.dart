import 'package:newmusicappmachado/Controller/MyLibraryController.dart';
import 'package:newmusicappmachado/Utils/ChopperClientService/HomeChopperService.dart';
import 'package:newmusicappmachado/Utils/Network/AppChopperClient.dart';
import 'package:get/get.dart';

class MyLibraryBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> MyLibraryController(homeChopperService:
    AppChopperClient().getChopperService<HomeChopperService>()),fenix: true);
    // TODO: implement dependencies
  }

}