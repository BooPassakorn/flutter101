import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workshop/main.dart';
import 'package:workshop/src/pages/cart/shopping_cart_page.dart';
import 'package:workshop/src/pages/detail/product_detail_page.dart';
import 'package:workshop/src/pages/login/login_page.dart';
import 'package:workshop/src/pages/nearby_store/nearby_store_page.dart';
import 'package:workshop/src/pages/search_by_image/search_by_image_page.dart';

class Routes {
  static const rootPage = "/";
  static const mainPage = "/main";
  static const detailPage = "/detail";
  static const shoppingCartPage = "/shopping-cart";
  static const nearbyStorePage = "/nearby-store";
  static const searchByImagePage = "/search_by_image";

  static Map<String, WidgetBuilder> getRoute(){
    return <String, WidgetBuilder>{
      rootPage : (_) => MyHomePage(),
      detailPage : (_) => ProductDetailPage(),
      shoppingCartPage : (_) => const ShoppingCartPage(),
      nearbyStorePage : (_) =>  NearbyStorePage(),
      searchByImagePage : (_) => SearchByImagePage(),
    };
  }

  static List<GetPage> getPageRoute() {
    return [
      GetPage(
        name: rootPage,
        page: () => LoginPage(),
      ),
      GetPage(
        name: mainPage,
        page: () => MyHomePage(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: detailPage,
        page: () => ProductDetailPage(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: shoppingCartPage,
        page: () => const ShoppingCartPage(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: nearbyStorePage,
        page: () =>  NearbyStorePage(),
        transition: Transition.rightToLeft,
      ),
      GetPage(
        name: searchByImagePage,
        page: () =>  SearchByImagePage(),
        transition: Transition.rightToLeft,
      ),
    ];
  }
}
