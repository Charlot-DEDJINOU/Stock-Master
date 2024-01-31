import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/models/order.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/services/product.dart';

class OrderDetails extends StatefulWidget {
  final Order order;

  const OrderDetails({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetails> createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  List<Product> products = [];
  final ProductService productService = ProductService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      isLoading = true;
    });
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
    finally{
      setState(() {
        isLoading =  false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:const CustomAppBar(title: "Détails de la commande"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: isLoading ?
        const Center(
            child: CircularProgressIndicator(),
        ) :
        Center(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow("Date de la commande", widget.order.orderDate.toString().split('T')[0]),
                _buildDetailRow("Produit", _getProductName(widget.order.productId)),
                _buildDetailRow("Quantité", widget.order.quantity.toString()),
                _buildDetailRow("Montant total", widget.order.totalAmount.toString()),
                _buildDetailRow("Statut de la commande", widget.order.status),
                _buildDetailRow("Nom du client", widget.order.customerName),
                _buildDetailRow("Contact du client", widget.order.customerContact),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  String _getProductName(int productId) {
    final product = products.firstWhere((product) => product.productId == productId);
    return products != [] ? product.productName : "Non défini" ;
  }
}
