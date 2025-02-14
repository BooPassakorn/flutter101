// To parse this JSON data, do
//
//     final productData = productDataFromJson(jsonString);

import 'dart:convert';

ProductData productDataFromJson(String str) => ProductData.fromJson(json.decode(str));

String productDataToJson(ProductData data) => json.encode(data.toJson());

class ProductData {
  Result? result;

  ProductData({
    this.result,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) => ProductData(
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
  };
}

class Result {
  int? id;
  String? title;
  int? price;

  Result({
    this.id,
    this.title,
    this.price,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    title: json["title"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
  };
}
