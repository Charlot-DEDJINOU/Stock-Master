import 'dart:convert';

List<Order> orderFromJson(String str) => List<Order>.from(json.decode(str).map((x) => Order.fromJson(x)));

String orderToJson(List<Order> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Order {
  int orderId;
  String orderDate;
  int productId;
  int quantity;
  double totalAmount;
  String status;
  String customerName;
  String customerContact;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.productId,
    required this.quantity,
    required this.totalAmount,
    required this.status,
    required this.customerName,
    required this.customerContact,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
        orderId: json['order_id'],
        orderDate: json['order_date'],
        productId: json['product_id'],
        quantity: json['quantity'],
        totalAmount: json['total_amount'],
        status: json['status'],
        customerName: json['customer_name'],
        customerContact: json['customer_contact']);
  }

  Map<String, dynamic> toJson() {
    return {
        'order_id' : orderId,
        'order_date' : orderDate,
        'product_id' : productId,
        'quantity' : quantity,
        'total_amount' : totalAmount,
        'status' : status,
        'customer_name' : customerName,
        'customer_contact' : customerContact
    };
  }
}
