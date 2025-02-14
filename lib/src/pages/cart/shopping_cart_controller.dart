import 'package:get/get.dart';
import 'package:workshop/core/enum/shopping_cart_mode.dart';

class ShoppingCartPageController extends GetxController {
  ShoppingCartMode _shoppingCartMode = ShoppingCartMode.normal;

  ShoppingCartMode get shoppingCartMode => _shoppingCartMode;

  void toggleMode() {
    _shoppingCartMode = _shoppingCartMode.toggle();
    update();
  }
}