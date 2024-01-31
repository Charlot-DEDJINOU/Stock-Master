import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/product.dart';
import 'package:stock_master/screens/history.dart';
import 'package:stock_master/services/product.dart';
import 'package:stock_master/services/stock_movement.dart';

class CreateBuy extends StatefulWidget {
  const CreateBuy({Key? key}) : super(key: key);

  @override
  State<CreateBuy> createState() => _CreateBuyState();
}

class _CreateBuyState extends State<CreateBuy> {
  Product? product;
  final quantityController = TextEditingController();
  final noteController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoadingProduct = true;
  late List<Product> products = [];

  ProductServive productServive = ProductServive();
  StockmovementServive stockmovementServive = StockmovementServive();

  create(data) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await stockmovementServive.create(data);
      print(response);
      showToast("Achat enregistré avec succès");
      noteController.text = "";
      quantityController.text = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const History()));
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        showToast("Une erreur est intervenue");
        print(e.response!.data);
      } else {
        showToast("Une erreur est intervenue");
        print(e.message);
      }
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  loadingProducts() async {
    try {
      var response = await productServive.getAll();
      products = response;
      setState(() {
        isLoadingProduct = false;
      });
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        showToast("Une erreur est intervenue");
        print(e.response!.data);
      } else {
        showToast("Une erreur est intervenue");
        print(e.message);
      }
    } finally {}
  }

  @override
  void initState() {
    super.initState();
    loadingProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Enregistrer un achat"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: Center(
        child: SingleChildScrollView(
          child: !isLoadingProduct
              ? Container(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 150,
                          height: 150,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Form(
                        key: formKey,
                        child: Column(
                          children: [
                            DropdownButtonFormField<Product>(
                              value: product,
                              onChanged: (Product? newValue) {
                                setState(() {
                                  product = newValue;
                                });
                              },
                              validator: (prod) => prod == null
                                  ? "Ce champ est obligatoire"
                                  : null,
                              items: products
                                  .asMap()
                                  .entries
                                  .map<DropdownMenuItem<Product>>((entry) {
                                final value = entry.value;
                                return DropdownMenuItem<Product>(
                                  value: value,
                                  child: Text(value.productName),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Produit',
                                prefixIcon: Icon(Icons.shopping_bag),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.number,
                              controller: quantityController,
                              decoration: const InputDecoration(
                                labelText: 'Quantité',
                                prefixIcon:
                                    Icon(Icons.production_quantity_limits),
                              ),
                              validator: (String? value) {
                                return value == null || value.isEmpty
                                    ? 'Ce champ est obligatoire'
                                    : null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              keyboardType: TextInputType.multiline,
                              maxLines:
                                  null, // null permet de saisir autant de lignes que nécessaire
                              controller: noteController,
                              decoration: const InputDecoration(
                                labelText: 'Notes',
                                prefixIcon: Icon(Icons.message),
                              ),
                              validator: (String? value) {
                                return value == null || value.isEmpty
                                    ? 'Ce champ est obligatoire'
                                    : null;
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await create({
                              "product_id": product!.productId,
                              "movement_type": "achat",
                              "quantity": quantityController.text,
                              "notes": noteController.text
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF02BB02),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                'Enregistrer',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                      ),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(color: Colors.brown)),
        ),
      ),
    );
  }
}
