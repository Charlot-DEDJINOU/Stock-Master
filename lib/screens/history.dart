import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/models/stock_movement.dart';
import 'package:stock_master/services/product.dart';
import 'package:stock_master/services/stock_movement.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<StockMovement> stockMovements = [];
  late List<Product> products = [];
  bool isLoading = true;

  StockmovementServive stockmovementServive = StockmovementServive();
  ProductService productServive = ProductService();

  allStockMovement() async {
    try {
      var stock = await stockmovementServive.getAll();
      var prod = await productServive.getAll();
      
      setState(() {
        stockMovements = stock.reversed.toList();
        products = prod;
        isLoading = false;
      });
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    allStockMovement();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Historiques'),
        drawer: const CustomAppDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(index: 2),
        body: stockMovements.isNotEmpty
            ? ListView.builder(
                itemCount: stockMovements.length,
                itemBuilder: (context, index) {
                  final movement = stockMovements[index];
                  var icon = movement.movementType.toLowerCase() == "vente"
                      ? Icons.arrow_downward
                      : Icons.arrow_upward;
                  var color = movement.movementType.toLowerCase() != "vente"
                      ? Colors.green
                      : Colors.brown;
                  return _buildStockMovementItem(movement, icon, color);
                },
              )
            : Center(
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.brown)
                    : const Text(
                        "Aucun achat ni vente",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ));
  }

  Widget _buildStockMovementItem(
      StockMovement movement, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsetsDirectional.all(5.0),
      child: ListTile(
        title: Text(
          movement.movementType.toUpperCase(),
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Produit: ${products.firstWhere((ele) => ele.productId == movement.productId).productName}',
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                'Date: ${movement.movementDate}',
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                'Quantité: ${movement.quantity}',
                style: const TextStyle(fontSize: 15.0),
              ),
              Text(
                'Notes: ${movement.notes}',
                style: const TextStyle(fontSize: 15.0),
              ),
            ],
          ),
        ),
        trailing: Icon(icon, color: color, size: 25.0),
      ),
    );
  }
}
