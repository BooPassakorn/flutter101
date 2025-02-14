import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workshop/core/di/cart_controller.dart';
import 'package:workshop/core/enum/shopping_cart_mode.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/theme/theme.dart';
import 'package:workshop/core/widgets/custom_app_bar.dart';
import 'package:workshop/core/widgets/extentions.dart';

class Header extends StatelessWidget {
  const Header({
    Key? key,
    required this.headLine1,
    required this.headLine2,
    this.isShoppingCart = false,
    this.shoppingCartMode = ShoppingCartMode.normal,
    this.onPressedIcon,
  }) : super(key: key);

  final String headLine1;
  final String headLine2;
  final bool isShoppingCart;

  final ShoppingCartMode shoppingCartMode;
  final Function? onPressedIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const CustomAppBar(
          title: 'MainPage Appbar',
        ),
        _title(),
      ],
    );
  }

  Widget _title() {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                headLine1,
                style: GoogleFonts.mulish().copyWith(
                  fontSize: 27,
                  fontWeight: FontWeight.w400,
                  color: LightColor.titleTextColor,
                ),
                // TextStyle(
                //   fontSize: 27,
                //   fontWeight: FontWeight.w400,
                //   color: LightColor.titleTextColor,
                // ),
              ),
              Text(
                headLine2,
                style: GoogleFonts.mulish().copyWith(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: LightColor.titleTextColor,
                ),
              ),
            ],
          ),
          isShoppingCart && Get.find<CartController>().cartList.isNotEmpty
              ? Container(
                  padding: const EdgeInsets.all(10),
                  child: Icon(
                    shoppingCartMode == ShoppingCartMode.normal
                        ? Icons.edit_outlined
                        : Icons.close_outlined,
                    color: LightColor.orange,
                  ),
                ).ripple(() {
                  if (onPressedIcon != null) {
                    onPressedIcon!();
                  }
                }, borderRadius: const BorderRadius.all(Radius.circular(13)))
              : const SizedBox()
        ],
      ),
    );
  }
}
