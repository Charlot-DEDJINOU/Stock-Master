import 'dart:convert';

List<Product> productFromJson(String str) => List<Product>.from(json.decode(str).map((x) => Product.fromJson(x)));

String productToJson(List<Product> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Product {
  int productId;
  String productName;
  String productDescription;
  int categoryId;
  double purchasePrice;
  double sellingPrice;
  int quantityInStock;
  int quantityMin;
  int quantityMax;

  Product({
    required this.productId,
    required this.productName,
    required this.productDescription,
    required this.categoryId,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.quantityInStock,
    required this.quantityMin,
    required this.quantityMax,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productId: json['product_id'],
      productName: json['product_name'],
      productDescription: json['product_description'],
      categoryId: json['category_id'],
      purchasePrice: json['purchase_price'],
      sellingPrice: json['selling_price'],
      quantityInStock: json['quantity_in_stock'],
      quantityMin: json['quantity_min'],
      quantityMax: json['quantity_max']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_description' : productDescription,
      'category_id' : categoryId,
      'purchase_price' : purchasePrice,
      'selling_price' : sellingPrice,
      'quantity_in_stock' : quantityInStock,
      'quantity_min' : quantityMin,
      'quantity_max' : quantityMax
    };
  }

}