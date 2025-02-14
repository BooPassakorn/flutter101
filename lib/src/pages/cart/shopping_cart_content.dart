import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workshop/core/di/cart_controller.dart';
import 'package:workshop/core/enum/shopping_cart_mode.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/theme/theme.dart';
import 'package:workshop/core/theme/title_text.dart';
import 'package:workshop/src/model/cart_item.dart';
import 'package:workshop/src/pages/cart/shopping_cart_controller.dart';

class ShoppingCartContent extends StatelessWidget {
  ShoppingCartContent({super.key});

  final _cartController = Get.find<CartController>();

  final _shoppingCartPageController = Get.find<ShoppingCartPageController>();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: SingleChildScrollView(
        child: Column(
          children: [
            _cartItems(),
            const Divider(
              thickness: 1,
              height: 70,
            ),
            _price(),
            const SizedBox(
              height: 20,
            ),
            _submitButton(context),
          ],
        ),
      ),
    );
  }

  Widget _cartItems() {
    // return Column(
    //   children: Appdata.cartList.map((e) => _cartItem(e)).toList(),
    // );

    return SizedBox(
        height: AppTheme.fullHeight(Get.context!) * 0.5,
        child: _cartController.cartTotal > 0
            ? GetBuilder<CartController>(
                builder: (controller) {
                  return ListView.builder(
                    itemCount: controller.cartTotal,
                    itemBuilder: (ctx, index) {
                      return _cartItem(controller.cartList[index]);
                    },
                  );
                },
              )
            : const Center(
                child: TitleText(
                  text: 'Cart is empty',
                  color: LightColor.grey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ));
  }

  Widget _cartItem(CartItem model) {
    return SizedBox(
      height: 80,
      child: Row(
        children: [
          if (_shoppingCartPageController.shoppingCartMode ==
              ShoppingCartMode.delete)
            Checkbox(
              value: model.isSelected,
              activeColor: LightColor.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              onChanged: (value) {
                _cartController.setSelected(model, value!);
              },
            ),
          AspectRatio(
              aspectRatio: 1.2,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: SizedBox(
                      width: 70,
                      height: 70,
                      child: Stack(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: LightColor.lightGrey,
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: Image.asset(
                      model.product.image,
                      height: 114,
                      width: 127,
                    ),
                  )
                ],
              )),
          Expanded(
            child: ListTile(
              title: TitleText(
                text: model.product.name,
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              subtitle: Row(
                children: [
                  const TitleText(
                    text: '\$',
                    fontSize: 12,
                    color: LightColor.orange,
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  TitleText(
                    text: model.product.price.toString(),
                    fontSize: 14,
                  ),
                ],
              ),
              trailing: _shoppingCartPageController.shoppingCartMode ==
                      ShoppingCartMode.normal
                  ? Container(
                      width: 35,
                      height: 35,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: LightColor.lightGrey.withAlpha(150),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TitleText(
                        text: "x${model.quantity}",
                        fontSize: 12,
                      ),
                    )
                  : const SizedBox(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _price() {
    return Visibility(
      visible: _shoppingCartPageController.shoppingCartMode ==
          ShoppingCartMode.normal,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TitleText(
            text: "${_cartController.cartTotal} Items",
            color: LightColor.grey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          TitleText(
            text: "\$ ${_cartController.getPrice()}",
            fontSize: 18,
          )
        ],
      ),
    );
  }

  Widget _submitButton(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () {
            if (_cartController.cartTotal > 0) {
              if (_shoppingCartPageController.shoppingCartMode ==
                  ShoppingCartMode.delete) {
                _cartController.deleteItemFromCart();
              } else {
                // TODO : Buy
              }
            }
          },
          style: ButtonStyle(
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            backgroundColor: MaterialStateProperty.all(
                _cartController.cartTotal > 0
                    ? LightColor.orange
                    : LightColor.grey),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 4),
            width: AppTheme.fullWidth(context) * .75,
            child: TitleText(
              text: _shoppingCartPageController.shoppingCartMode ==
                      ShoppingCartMode.normal
                  ? "Buy"
                  : "Remove selected items",
              color: LightColor.background,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        // const SizedBox(
        //   height: 8,
        // ),
        // _submitButtonWithElevatedButton(),
      ],
    );
  }

  Widget _submitButtonWithElevatedButton() {
    return SizedBox(
      width: 318,
      height: 46,
      child: ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          backgroundColor: MaterialStateProperty.all(LightColor.orange),
        ),
        child: Container(
          alignment: Alignment.center,
          child: const TitleText(
            text: "Buy",
            color: LightColor.background,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
