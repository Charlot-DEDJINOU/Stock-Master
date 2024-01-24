import 'dart:convert';

List<Supplier> supplierFromJson(String str) => List<Supplier>.from(json.decode(str).map((x) => Supplier.fromJson(x)));

String supplierToJson(List<Supplier> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Supplier {
  int supplierId;
  String supplierName;
  String contactPerson;
  String email;
  String phone;

  Supplier({
    required this.supplierId,
    required this.supplierName,
    required this.contactPerson,
    required this.email,
    required this.phone,
  });

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(
        supplierId: json['supplier_id'],
        supplierName: json['supplier_name'],
        contactPerson: json['contact_person'],
        email: json['email'],
        phone: json['phone']);
  }

  Map<String, dynamic> toJson() {
    return {
        'supplier_id' : supplierId,
        'supplier_name' : supplierName,
        'contact_person' : contactPerson,
        'email' : email,
        'phone' : phone
    };
  }
}