import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:workshop/core/config/routes.dart';
import 'package:workshop/core/di/cart_controller.dart';
import 'package:workshop/core/enum/available_color.dart';
import 'package:workshop/core/enum/available_size.dart';
import 'package:workshop/core/lifecycle/lifecycle_listener.dart';
import 'package:workshop/core/theme/light_color.dart';
import 'package:workshop/core/theme/theme.dart';
import 'package:workshop/core/theme/title_text.dart';
import 'package:workshop/core/widgets/extentions.dart';
import 'package:workshop/src/model/cart_item.dart';
import 'package:workshop/src/model/data.dart';
import 'package:workshop/src/pages/detail/product_detail_controller.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ProductDetailPage extends StatelessWidget with LifecycleListenerEvent{
  // ProductDetailPage({Key? key}) : super(key: key);
  final bool isLiked = true;
  static const productItemArg = "productItemArg";

  final _productDetailController = Get.put(ProductDetailController());
  final _cartController = Get.find<CartController>();

  late LifecycleListener _lifecycleListener;

  ProductDetailPage({Key? key}) : super(key: key) {
    _lifecycleListener = LifecycleListener(providerInstance: this);
  }

  @override
  void onResume() {
    print("onResume ProductDetailPage");
  }

  // @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [
              Color(0xfffbfbfb),
              Color(0xfff7f7f7),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  _appBar(context),
                  _productImage(),
                  _productImageThumbnail(),
                ],
              ),
              _detailWidget(),
              _addToCartButton(context),
            ],
          ),
        ),
      ),
      // floatingActionButton: _floatingButton(context),
    );
  }

  Widget _detailWidget() {
    return Container(
      child: DraggableScrollableSheet(
        maxChildSize: 0.8,
        initialChildSize: 0.5,
        minChildSize: 0.5,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            padding: AppTheme.padding.copyWith(bottom: 0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                )),
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowIndicator();
                return true;
              },
              child: SingleChildScrollView(
                controller: scrollController,
                // physics: const BouncingScrollPhysics(),
                child: _bottomSheetContent(scrollController, null),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _bottomSheetContent(
      ScrollController scrollController, ScrollPhysics? physics) {
    return SingleChildScrollView(
      controller: scrollController,
      physics: physics,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 50,
              height: 5,
              decoration: const BoxDecoration(
                  color: LightColor.iconColor,
                  borderRadius: BorderRadius.all(Radius.circular(10))),
            ),
          ),
          const SizedBox(height: 10),
          _productTitle(),
          const SizedBox(height: 20),
          _availableSize(),
          const SizedBox(height: 20),
          _availableColor(),
          const SizedBox(height: 20),
          _description(),
        ],
      ),
    );
  }

  Widget _productTitle() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        TitleText(
          text: _productDetailController.product.name,
          fontSize: 25,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const TitleText(
                  text: "\$ ",
                  fontSize: 20,
                  color: LightColor.orange,
                ),
                TitleText(
                  text: _productDetailController.product.price.toString(),
                  fontSize: 25,
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.yellowColor, size: 17),
                Icon(Icons.star, color: LightColor.lightGrey, size: 17),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _availableSize() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TitleText(text: "Available Sizes", fontSize: 20),
        const SizedBox(height: 10),
        GetBuilder<ProductDetailController>(
          builder: (controller) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: controller.availableSize
                  .map(
                    (e) => _sizeWidget(e,
                        isSelected: e == controller.selectedSize),
                  )
                  .toList(),
            );
          },
        ),
      ],
    );
  }

  Widget _sizeWidget(AvailableSize size, {bool isSelected = false}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: !isSelected ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color: isSelected ? Colors.orange : Colors.transparent,
      ),
      child: TitleText(
        text: size.name,
        fontSize: 16,
        color: isSelected ? LightColor.background : LightColor.titleTextColor,
      ),
    ).ripple(() {
      _productDetailController.setSelectedSize(size);
    }, borderRadius: const BorderRadius.all(Radius.circular(13)));
  }

  Widget _availableColor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const TitleText(text: "Color", fontSize: 20),
        const SizedBox(height: 10),
        GetBuilder<ProductDetailController>(
          builder: (controller) {
            return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: controller.availableColor
                    .map((e) => Padding(
                          padding: const EdgeInsets.only(right: 30),
                          child: _colorWidget(e,
                              isSelected: e == controller.selectedColor),
                        ))
                    .toList()

                // <Widget>[
                //   _colorWidget(LightColor.yellowColor, isSelected: true),
                //   const SizedBox(width: 30),
                //   _colorWidget(LightColor.lightBlue),
                //   const SizedBox(width: 30),
                //   _colorWidget(LightColor.black),
                //   const SizedBox(width: 30),
                //   _colorWidget(LightColor.red),
                //   const SizedBox(width: 30),
                //   _colorWidget(LightColor.skyBlue),
                //   const SizedBox(width: 30),
                // ],
                );
          },
        ),
      ],
    );
  }

  Widget _colorWidget(AvailableColor availableColor,
      {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        _productDetailController.setSelectedColor(availableColor);
      },
      child: CircleAvatar(
        radius: 12,
        backgroundColor: availableColor.color.withAlpha(150),
        child: isSelected
            ? Icon(
                Icons.check_circle,
                color: availableColor.color,
                size: 18,
              )
            : CircleAvatar(radius: 7, backgroundColor: availableColor.color),
      ),
    );
  }

  Widget _description() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleText(
          text: "Description",
          fontSize: 20,
        ),
        SizedBox(
          height: 20,
        ),
        TitleText(
          text: "This is product description",
          fontSize: 14,
          fontWeight: FontWeight.w400,
        )
      ],
    );
  }

  Widget _appBar(BuildContext context) {
    return Container(
      padding: AppTheme.padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _icon(
            context,
            Icons.arrow_back_ios,
            color: Colors.black54,
            size: 15,
            padding: 12,
            isOutline: true,
            onPressed: () {
              // Navigator.of(context).pop();

              Get.back(); //ใช้ได้เหมือน Navigator.of(context).pop();
            },
          ),
          _icon(context, Icons.shopping_basket,
              color: LightColor.grey.withOpacity(0.7),
              size: 15,
              padding: 4,
              isOutline: false, onPressed: () {
            // Navigator.of(context).pushNamed(Routes.shoppingCartPage);
            Get.toNamed(Routes.shoppingCartPage);
          }),
        ],
      ),
    );
  }

  Widget _icon(BuildContext context, IconData icon,
      {double padding = 10,
      Color color = LightColor.iconColor,
      double size = 20,
      bool isOutline = false,
      Function? onPressed}) {
    return Container(
      height: 40,
      width: 40,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        border: Border.all(
            color: LightColor.iconColor,
            style: isOutline ? BorderStyle.solid : BorderStyle.none),
        borderRadius: const BorderRadius.all(Radius.circular(13)),
        color:
            isOutline ? Colors.transparent : Theme.of(context).backgroundColor,
        boxShadow: const <BoxShadow>[
          BoxShadow(
              color: Color(0xFFF8F8F8),
              blurRadius: 5,
              spreadRadius: 10,
              offset: Offset(5, 5))
        ],
      ),
      child: Padding(
          padding: EdgeInsets.only(left: icon == Icons.arrow_back_ios ? 2 : 0),
          child: Stack(
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Icon(icon, color: color, size: size)),
              if (icon == Icons.shopping_basket)
                Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      width: 18,
                      height: 18,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: LightColor.orange),
                        color: LightColor.orange.withOpacity(0.9),
                      ),
                      child: GetBuilder<CartController>(
                        builder: (controller) {
                          return TitleText(
                            text: "${controller.cartTotal}",
                            color: Colors.white,
                            fontSize: 10,
                          );
                        },
                      ),
                    ))
            ],
          )),
    ).ripple(
      () {
        if (onPressed != null) {
          onPressed();
        }
      },
      borderRadius: const BorderRadius.all(Radius.circular(13)),
    );
  }

  Widget _productImage() {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        const TitleText(
          text: "AIR",
          fontSize: 160,
          color: LightColor.lightGrey,
        ),
        Image.asset("assets/show_1.png"),
      ],
    );
  }

  Widget _productImageThumbnail() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      width: double.infinity,
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: Appdata.showThumbnailList.map((e) => _thumbnail(e)).toList(),
      ),
    );
  }

  Widget _thumbnail(String src) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 40,
        width: 50,
        decoration: BoxDecoration(
          border: Border.all(color: LightColor.grey),
          borderRadius: const BorderRadius.all(Radius.circular(13)),
        ),
        child: Image.asset(src),
      ),
    );
  }

  Widget _floatingButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.of(context).pushNamed(Routes.shoppingCartPage);
      },
      backgroundColor: LightColor.orange,
      child: Icon(
        Icons.shopping_basket,
        color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
      ),
    );
  }

  Widget _addToCartButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: EdgeInsets.only(bottom: 16, left: 16, right: 16),
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: [
            const Color(0xFFFBFBFB).withOpacity(1.0),
            const Color(0xFFF7F7F7).withOpacity(0.8),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )),
        child: SizedBox(
          width: 310.5,
          height: 46,
          child: ElevatedButton(
            onPressed: () {
              _cartController.addItemToCart(
                CartItem(
                  _productDetailController.product,
                  _productDetailController.selectedSize,
                  _productDetailController.selectedColor,
                ),
              );

              showToast('Added to cart',
                context: context,
                animation: StyledToastAnimation.fade,
                reverseAnimation: StyledToastAnimation.fade,
                position: StyledToastPosition.top,
                animDuration: Duration(seconds: 1),
                duration: Duration(seconds: 4),
                curve: Curves.fastOutSlowIn,
                reverseCurve: Curves.linear,
              );

              // Fluttertoast.showToast(
              //   msg: "Added to cart",
              //   toastLength: Toast.LENGTH_SHORT,
              //   gravity: ToastGravity.TOP,
              //   timeInSecForIosWeb: 1,
              //   backgroundColor: Colors.black,
              //   textColor: Colors.white,
              //   fontSize: 16.0
              // );
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              backgroundColor:
                  MaterialStateProperty.all<Color>(LightColor.orange),
            ),
            child: Container(
              alignment: Alignment.center,
              child: const TitleText(
                text: "Add to cart",
                color: LightColor.background,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
