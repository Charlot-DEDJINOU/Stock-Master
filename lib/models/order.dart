class Order {
  int orderId;
  DateTime orderDate;
  int productId;
  int customerId;
  int quantity;
  double totalAmount;
  String status;
  String customerName;
  String customerContact;

  Order({
    required this.orderId,
    required this.orderDate,
    required this.productId,
    required this.customerId,
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
        customerId: json['customer_id'],
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
        'customer_id' : customerId,
        'quantity' : quantity,
        'total_amount' : totalAmount,
        'status' : status,
        'customer_name' : customerName,
        'customer_contact' : customerContact
    };
  }
}
