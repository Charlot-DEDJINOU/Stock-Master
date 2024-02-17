import 'dart:convert';



// ignore: non_constant_identifier_names
List<Prevision> PrevisionFromJson(String str) => List<Prevision>.from(json.decode(str).map((x) => Prevision.fromJson(x)));

class Prevision {
  int productId;
  String productName;
  int status;
  String message;

  Prevision({
    required this.productId,
    required this.productName,
    required this.status,
    required this.message,
  });

  factory Prevision.fromJson(Map<String, dynamic> json) {
    return Prevision(
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      status: json['status'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}
