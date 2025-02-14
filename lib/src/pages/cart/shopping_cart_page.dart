import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workshop/core/di/cart_controller.dart';
import 'package:workshop/core/widgets/header.dart';
import 'package:workshop/src/pages/cart/shopping_cart_content.dart';
import 'package:workshop/src/pages/cart/shopping_cart_controller.dart';

class ShoppingCartPage extends StatelessWidget {
  const ShoppingCartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GetBuilder<ShoppingCartPageController>(
          init: ShoppingCartPageController(),
          builder: (controller) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Header(
                  headLine1: 'Shopping',
                  headLine2: 'Cart',
                  isShoppingCart: true,
                  shoppingCartMode: controller.shoppingCartMode,
                  onPressedIcon: (){
                    controller.toggleMode();
                    Get.find<CartController>().resetSelectedItem();
                  },
                ),
                Expanded(child: ShoppingCartContent()),
              ],
            );
          },
        ),
      ),
    );
  }
}
