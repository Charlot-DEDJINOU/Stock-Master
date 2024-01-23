class Customer {
  int customerId;
  String customerName;
  String email;
  String phone;
  String address;

  Customer({
    required this.customerId,
    required this.customerName,
    required this.email,
    required this.phone,
    required this.address,
  });

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        customerId: json['customer_id'],
        customerName: json['customer_name'],
        email: json['email'],
        phone: json['phone'],
        address: json['address']
      );
  }

  Map<String, dynamic> toJson() {
    return {
      'customer_id' : customerId,
      'customer_name' : customerName,
      'email' : email,
      'phone' : phone,
      'adress' : address
    };
  }
}
