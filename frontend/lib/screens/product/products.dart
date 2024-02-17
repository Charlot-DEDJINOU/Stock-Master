import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/category.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/screens/product/create.dart';
import 'package:stock_master/screens/product/update.dart';
import 'package:stock_master/services/category.dart';
import 'package:stock_master/services/product.dart';

class ShowProducts extends StatefulWidget {
  const ShowProducts({Key? key}) : super(key: key);

  @override
  State<ShowProducts> createState() => _ShowProductsState();
}

class _ShowProductsState extends State<ShowProducts> {
      List<Product> products = [];
      final ProductService productService = ProductService();
      bool isLoading =  false;
      @override
      void initState() {
        super.initState();
        // Vérifier si le widget est déjà monté avant d'appeler _loadProducts()
        if (mounted) {
          _loadProducts();
        }
      }

      Future<void> _loadProducts() async {

        try {
          setState(() {
            isLoading = true;
          });
          final List<Product> fetchedProducts = await productService.getAll();
          if (mounted) {
            setState(() {
              products = fetchedProducts;
            });
          }
        } catch (e) {
          // Gérer les erreurs liées au chargement des produits
          print('Erreur lors du chargement des produits : $e');
        }
        finally {
          setState(() {
            isLoading = false;
          });
        }
      }

      @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: const CustomAppBar(title: "La liste des produits"),
        drawer: const CustomAppDrawer(),
        bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
        body: isLoading ?
          const Center(
                child: CircularProgressIndicator(),
          ) : 
          products.isEmpty
            ? const Center(
                child: Text('Aucun produit à afficher.', style: TextStyle(fontWeight: FontWeight.bold),),
              )
            : ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];

                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.all(8.0),
                    color: index.isEven ? Colors.grey[200] : Colors.white,
                    child: ListTile(
                      title: Text(product.productName),
                      subtitle: Text(
                          '${product.categoryId} - ${product.productDescription.length > 30 ? '${product.productDescription.substring(0, 30)}...' : product.productDescription }'
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _navigateToUpdateProduct(product);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteProduct(product);
                            },
                          ),
                        ],
                      ),
                      onTap: () {
                        _navigateToProductDetails(product);
                      },
                    ),
                  );
                },
              ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.brown,
          onPressed: () {
            _createProduct();
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
      );
    }

      void _createProduct() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CreateProduct()),
        ).then((_) {
          // Rafraîchir la liste des produits après la création
          _loadProducts();
        });
      }

      void _navigateToProductDetails(Product product) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProductDetails(product: product)),
        );
      }

      void _navigateToUpdateProduct(Product product) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UpdateProduct(product: product)),
        ).then((_) {
          // Rafraîchir la liste des produits après la mise à jour
          _loadProducts();
        });
      }

      void _deleteProduct(Product product) async {
      // Afficher une boîte de dialogue de confirmation
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("Voulez-vous vraiment supprimer ce produit ?"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                },
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: () async {
                  await _performProductDeletion(product);
                  Navigator.of(context).pop(); 
                },
                child: const Text("Supprimer"),
              ),
            ],
          );
        },
      );
    }

    // Fonction pour effectuer la suppression du produit
    Future<void> _performProductDeletion(Product product) async {
      try {
        await productService.delete(product.productId);
        // Rafraîchir la liste des produits après la suppression
        _loadProducts();
      } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else {
        print('Erreur lors de la suppression du produit : $e');
        showToast("Erreur lors de la suppression du produit. Veuillez réessayer.");
      }
      }
    }


}


class ProductDetails extends StatelessWidget {
  final Product product;
  final CategoryService categoryService = CategoryService();

  ProductDetails({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: product.productName),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailItem('Description', product.productDescription),
            FutureBuilder(
              future: categoryService.get(product.categoryId.toString()),
              builder: (context, AsyncSnapshot<Category> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erreur: ${snapshot.error}');
                } else {
                  final category = snapshot.data!;
                  return _buildDetailItem('Catégorie', category.categoryName);
                }
              },
            ),
            _buildDetailItem('Prix d\'achat', '${product.purchasePrice.toStringAsFixed(2)} FCFA'),
            _buildDetailItem('Prix de vente', '${product.sellingPrice.toStringAsFixed(2)} FCFA'),
            _buildDetailItem('Quantité en Stock', product.quantityInStock.toString()),
            _buildDetailItem('Quantité Min', product.quantityMin.toString()),
            _buildDetailItem('Quantité Max', product.quantityMax.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          title: Text(label),
          subtitle: Text(value),
          leading: _getIconForLabel(label),
        ),
        const Divider(),
      ],
    );
  }

  Icon _getIconForLabel(String label) {
    switch (label) {
      case 'Description':
        return const Icon(Icons.description);
      case 'Catégorie':
        return const Icon(Icons.category);
      case 'Prix d\'achat':
        return const Icon(Icons.attach_money);
      case 'Prix de vente':
        return const Icon(Icons.monetization_on);
      case 'Quantité en Stock':
        return const Icon(Icons.storage);
      case 'Quantité Min':
        return const Icon(Icons.remove_circle);
      case 'Quantité Max':
        return const Icon(Icons.add_circle);
      default:
        return const Icon(Icons.info);
    }
  }
}
