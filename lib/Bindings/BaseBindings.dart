import 'package:get/get.dart';

import '../Controller/BaseController.dart';

class BaseBindings implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(()=> BaseController(),fenix: true);
    // TODO: implement dependencies
  }

}