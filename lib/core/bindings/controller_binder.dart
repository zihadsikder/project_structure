import 'package:gat/features/home/controllers/gat_labs_controller.dart';
import 'package:gat/features/home/controllers/home_controller.dart';
import 'package:gat/features/nav_bar/controllers/nav_bar_controller.dart';
import 'package:get/get.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NavBarController>(
          () => NavBarController(),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
          () => HomeController(),
      fenix: true,
    );
    Get.lazyPut<GatLabsController>(
          () => GatLabsController(),
      fenix: true,
    );


  }
}