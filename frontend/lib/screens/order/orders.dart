import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/order.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/screens/order/create.dart';
import 'package:stock_master/screens/order/detail.dart';
import 'package:stock_master/screens/order/update.dart';
import 'package:stock_master/services/order.dart';
import 'package:stock_master/services/product.dart';

class ShowOrders extends StatefulWidget {
  const ShowOrders({super.key});

  @override
  _ShowOrdersState createState() => _ShowOrdersState();
}

class _ShowOrdersState extends State<ShowOrders> {
  List<Order> orders = [];
  final OrderService orderService = OrderService();
  List<Product> products = [];
  final ProductService productService = ProductService();
  bool isLoding = true;

  @override
  void initState() {
    super.initState();
    // Vérifiez si le widget est déjà monté avant d'appeler _loadOrders()
    _loadOrders();
  }

  _loadProducts() async {
    try {
      final List<Product> fetchedProducts = await productService.getAll();
      if (mounted) {
        setState(() {
          products = fetchedProducts;
        });
        print('les produits chargés:');
        print(products);
      }
    } catch (e) {
      print('Erreur lors du chargement des produits : $e');
    }
  }

  _loadOrders() async {
    try {
      final List<Order> fetchedOrders = await orderService.getAll();
      await _loadProducts();
      if (mounted) {
        setState(() {
          orders = fetchedOrders;
        });
        print('les commandes chargés');
      }
    } catch (e) {
      // Gérez les erreurs liées au chargement des commandes
      print('Erreur lors du chargement des commandes : $e');
      showToast("Erreur lors du chargement des commandes. Veuillez réessayer.");
    } finally {
        setState(() {
          isLoding = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Liste des commandes"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: isLoding
          ? const Center(
              child: CircularProgressIndicator(color: Colors.green),
            )
          : orders.isEmpty
              ? const Center(
                  child: Text('Aucune commande à afficher.',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                )
              : ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];

                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.all(8.0),
                      color: index.isEven ? Colors.grey[200] : Colors.white,
                      child: ListTile(
                        title: Text(
                            "${_getProductName(order.productId)} de ${order.customerName}"),
                        subtitle: Text(
                          'Quantité: ${order.quantity} - Montant total: ${order.totalAmount} - Statut: ${order.status}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _navigateToUpdateOrder(order);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                _showDeleteConfirmationDialog(order);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          _navigateToOrderDetails(order);
                        },
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          _navigateToCreateOrder();
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToCreateOrder() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateOrder()),
    ).then((_) {
      // Rafraîchir la liste des commandes après la création
      _loadOrders();
    });
  }

  void _navigateToOrderDetails(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetails(order: order)),
    );
  }

  void _navigateToUpdateOrder(Order order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateOrder(order: order)),
    ).then((_) {
      // Rafraîchir la liste des commandes après la mise à jour
      _loadOrders();
    });
  }

  void _showDeleteConfirmationDialog(Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation de suppression"),
          content:
              const Text("Êtes-vous sûr de vouloir supprimer cette commande ?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context); // Fermer la boîte de dialogue de confirmation
                _deleteOrder(order);
              },
              child: const Text("Supprimer"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteOrder(Order order) async {
    try {
      await orderService.delete(order.orderId);
      showToast("Commande supprimée avec succès");
      // Rafraîchir la liste des commandes après la suppression
      _loadOrders();
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else {
        print('Erreur lors de la suppression de la commande : $e');
        showToast(
            "Erreur lors de la suppression de la commande. Veuillez réessayer.");
      }
    }
  }

  String _getProductName(int productId) {
    final product =
        products.firstWhere((product) => product.productId == productId);
    return products != [] ? product.productName : "Non défini";
  }
}
