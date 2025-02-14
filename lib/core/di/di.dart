import 'package:get/get.dart';
import 'package:workshop/core/di/application_controller.dart';
import 'package:workshop/core/di/auth_controller.dart';
import 'package:workshop/core/di/cart_controller.dart';

Future<void> initGetX() async{

  // Get.lazyPut<CartController>(() => CartController(), fenix: true);
  Get.put<CartController>(CartController());
  Get.put<AuthController>(AuthController());

  // Global state
  Get.put(ApplicationController());

}