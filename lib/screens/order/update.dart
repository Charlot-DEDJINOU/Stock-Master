import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/order.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/services/order.dart';
import 'package:stock_master/services/product.dart';

class UpdateOrder extends StatefulWidget {
  final Order order;

  const UpdateOrder({Key? key, required this.order}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _UpdateOrderState createState() => _UpdateOrderState();
}

class _UpdateOrderState extends State<UpdateOrder> {
  List<Product> products = [];
  final ProductService productService = ProductService();
  TextEditingController quantityController = TextEditingController();
  TextEditingController totalAmountController = TextEditingController();
  TextEditingController statusController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerContactController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  List<String> commandeStatus = ["En cours", "Livré"];
  String selectedStatus = "En cours";

  Product? selectedProduct;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    quantityController.text = widget.order.quantity.toString();
    totalAmountController.text = widget.order.totalAmount.toString();
    selectedStatus = widget.order.status;
    customerNameController.text = widget.order.customerName.toString();
    customerContactController.text =  widget.order.customerContact.toString();
  }

  Future<void> _loadProducts() async {
    try {
      final List<Product> fetchedProducts = await productService.getAll();
      if (mounted) {
        setState(() {
          products = fetchedProducts;
        });
      }
    } catch (e) {
      print('Erreur lors du chargement des produits : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(title: "Modifier une commande"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: Center(
        child: SingleChildScrollView(
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
          child: Form(
            key: formKey,
              child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Image.asset(
                      "assets/images/logo.png", 
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),

                  DropdownButtonFormField<Product?>(
                    value: selectedProduct,
                    items: products
                        .map((product) => DropdownMenuItem<Product?>(
                              value: product,
                              child: Text(product.productName),
                            ))
                        .toList(),
                    onChanged: (Product? value) {
                        setState(() {
                          selectedProduct = value;
                        });
                    },
                    decoration: const InputDecoration(labelText: 'Produit'),
                    validator: (value) {

                      if (value == null ) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Quantité'),
                    keyboardType: TextInputType.number,
                    validator: (value) {

                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;

                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: totalAmountController,
                    decoration: const InputDecoration(labelText: 'Montant total'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      if (!_isNumeric(value)) {
                        return 'Veuillez entrer une valeur numérique';
                      }
                      return null;
                    },
                    
                  ),
                  const SizedBox(height: 16.0),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    items: commandeStatus
                        .map((status) => DropdownMenuItem<String>(
                              value: status,
                              child: Text(status),
                            ))
                        .toList(),
                    onChanged: (String? value) {
                        setState(() {
                          selectedStatus = value ?? "En cours";
                        });
                    },
                    decoration: const InputDecoration(labelText: 'Status de la commande'),
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: customerNameController,
                    decoration: const InputDecoration(labelText: 'Nom du client'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: customerContactController,
                    decoration: const InputDecoration(labelText: 'Contact du client'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Ce champ est obligatoire';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        final updatedOrder = {
                          "order_id": widget.order.orderId,
                          "order_date": widget.order.orderDate,
                          "product_id": selectedProduct?.productId, 
                          "quantity": int.parse(quantityController.text),
                          "total_amount": double.parse(totalAmountController.text),
                          "status": selectedStatus,
                          "customer_name": customerNameController.text,
                          "customer_contact": customerContactController.text,
                        };
                        await _updateOrder(updatedOrder);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF02BB02),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Sauvegarder',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      )
    );
  }

  bool _isNumeric(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  Future<void> _updateOrder(updatedOrder) async {
    setState(() {
      isLoading = true;
    });

    try {
      final OrderService orderService = OrderService();

      await orderService.update(widget.order.orderId, updatedOrder);

      showToast("Commande mise à jour avec succès");

      Navigator.pop(context); 
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else {
        print('Erreur lors de la mise à jour de la commande : $e');
        showToast("Erreur lors de la mise à jour de la commande. Veuillez réessayer.");
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
