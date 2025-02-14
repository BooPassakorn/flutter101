import 'package:get/get.dart';
import 'package:workshop/core/enum/available_color.dart';
import 'package:workshop/core/enum/available_size.dart';
import 'package:workshop/src/model/product.dart';
import 'package:workshop/src/pages/detail/product_detail_page.dart';

class ProductDetailController extends GetxController{

  // @override
  // void onInit() { //ขารับ
  //   super.onInit();
  //
  //   dynamic argument = Get.arguments;
  //
  //   print(argument[0][ProductDetailPage.productItemArg]);
  // }

  List<AvailableSize> availableSize = [];
  AvailableSize selectedSize = AvailableSize.us7;

  List<AvailableColor> availableColor = [];
  AvailableColor selectedColor = AvailableColor.yellow;

  @override
  void onInit() {
    print("ProductDetailController onInit");
    super.onInit();

    for(var value in AvailableSize.values){
      availableSize.add(value);
    }

    for(var value in AvailableColor.values){
      availableColor.add(value);
    }

    _receiveArguments();
  }

  @override
  void onReady() {
    print("ProductDetailController onReady");
    super.onReady();
  }

  @override
  void onClose() {
    print("ProductDetailController onClose");
    super.onClose();
  }

  void setSelectedSize(AvailableSize size){
    selectedSize = size;
    update();
  }

  void setSelectedColor(AvailableColor color){
    selectedColor = color;
    update();
  }

  late Product product;

  void _receiveArguments() {
    final args = Get.arguments;
    product = args[0][ProductDetailPage.productItemArg];
  }
}