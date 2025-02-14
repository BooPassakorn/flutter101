import 'package:workshop/core/enum/available_color.dart';
import 'package:workshop/core/enum/available_size.dart';
import 'package:workshop/src/model/product.dart';

class CartItem {
  Product product;
  AvailableSize size;
  AvailableColor color;
  int quantity;
  bool isSelected;

  CartItem(
    this.product,
    this.size,
    this.color, {
    this.quantity = 1,
    this.isSelected = false,
  });
}
