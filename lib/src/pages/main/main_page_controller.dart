import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:workshop/src/model/category.dart';
import 'package:workshop/src/model/data.dart';
import 'package:workshop/src/model/product.dart';
import 'package:workshop/src/model/product_data.dart';

class MainPageController extends GetxController {
  List<Category> categoryList = [];
  List<Product> productList = [];
  List<Product> _originalProductList = [];

  TextEditingController searchController = TextEditingController();


  @override
  void onReady() {
    _fetchProductAndCategory();

    super.onReady();
  }


  @override
  void onClose() {
    searchController.dispose();

    super.onClose();
  }

  var counter = 0;

  var counter2 = 0.obs;

  increment() {
    counter++;

    print(counter);
    update();
  }

  increment2() {
    counter2++;

    print(counter2);
    // update();
  }

  void _fetchProductAndCategory() async {
    // Get.dialog(
    //   AlertDialog(
    //     content: Row(
    //       children: [
    //         const CircularProgressIndicator(),
    //         Container(
    //           margin: const EdgeInsets.only(left: 8),
    //           child: const Text("Loading..."),
    //         ),
    //       ],
    //     ),
    //   ),
    //   barrierDismissible: false,
    // );

    showDialog<void>(
        context: Get.context!,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Row(
                children: [
                  const CircularProgressIndicator(),
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    child: const Text("Loading..."),
                  ),
                ],
              ),
            ),
          );
        });

    final response = await Future.wait(
      [
        Appdata.simulateFetchingCategory(),
        Appdata.simulateFetchingProduct(),
      ],
    );

    categoryList = response[0] as List<Category>;
    _originalProductList = response[1] as List<Product>;
    productList = _originalProductList.toList();

    Navigator.of(Get.overlayContext!).pop(); //GetX

    update();
  }

  Category? getSelectedCategory() {
    try {
      return categoryList.firstWhere((element) => element.isSelected);
    } catch (e) {
      return null;
    }
  }

  void updateCategorySelected(Category category) {
    final selectedCategory = getSelectedCategory();
    selectedCategory?.isSelected = false;
    category.isSelected = true;

    final productListByCategory = searchController.text.isNotEmpty
        ? _filterBySelectedCategory(searchController.text)
        : _getProductByCategory(category);

    productList = productListByCategory.toList();

    if(productList.isNotEmpty){
      _updateProductSelected(productListByCategory[0]);
    }else{
      update();
    }

    // _getProductByCategory(category);
    // productList == productListByCategory.toList();
    // _updateProductSelected(productListByCategory[0]);

    // productList
    //     .where((element) => element.category == category.name)
    //     .toList();
    // _updateProductSelected(productListByCategory[0]);
  }

  void _updateProductSelected(Product product) {
    final selectedProduct = _getSelectedProduct();
    selectedProduct?.isSelected = false;
    product.isSelected = true;
    update();
  }

  Product? _getSelectedProduct() {
    try {
      return productList.firstWhere((element) => element.isSelected);
    } catch (e) {
      return null;
    }
  }

  List<Product> _getProductByCategory(Category category) {
    return _originalProductList
        .where((element) => element.category == category.name)
        .toList();
  }

  void search() {
    if (searchController.text.isNotEmpty) {
      final list = _filterBySelectedCategory(searchController.text);
      if (list.isNotEmpty) {
        _updateProductSelected(list[0]);
      }

      productList = list;
    } else {
      updateCategorySelected(getSelectedCategory()!);
    }

    update();
  }

  List<Product> _filterBySelectedCategory(String searchValue) {
    return _getProductByCategory(getSelectedCategory()!)
        .where((element) => element.name.contains(searchValue))
        .toList();
  }

  void getData() async {
    if(await _hasInternet()) {

      http.Response response;
      var dio = http.Dio();
      response = await dio.get("https://jsonblob.com/api/1334054917933031424");

      final data = ProductData.fromJson(response.data);

      print("id : ${data.result!.id}, title : ${data.result!.title}, price : ${data.result!.price}");
      // print(response.data.toString());
    }else{
      print("No internet connection");
    }
  }

  Future<bool> _hasInternet() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      return await InternetConnectionChecker().hasConnection;
    }

    return false;
  }
}
