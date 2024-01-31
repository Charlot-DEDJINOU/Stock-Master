import 'package:flutter/material.dart';
import 'package:stock_master/screens/prevision.dart';
import 'package:stock_master/screens/achat/create.dart';
import 'package:stock_master/screens/category/categories.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/screens/customer/customers.dart';
import 'package:stock_master/screens/order/orders.dart';
import 'package:stock_master/screens/product/products.dart';
import 'package:stock_master/screens/supplier/suppliers.dart';
import 'package:stock_master/screens/vente/create.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: const CustomAppBar(title: 'Stock Master'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCard(Icons.inventory, 'Produits', true, () {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowProducts(),
              ));
          }),
          _buildCard(Icons.category, 'Categories', false,  () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCategories(),
              ));
          }),
          _buildCard(Icons.person, 'Clients', false, () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCustomers(),
              ));
          }),
           _buildCard(Icons.shopping_cart, 'Commandes', true, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowOrders(),
              ));
          }),
          _buildCard(Icons.business_center, 'Fournisseurs', true, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowSuppliers(),
              ));
          }),
          _buildCard(Icons.payment, 'Achats', false, () {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateBuy(),
              ));
          }),
          _buildCard(Icons.attach_money, 'Ventes', false, () {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateSell(),
              ));
          }),
          _buildCard(Icons.timeline, 'Previsions', true, () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PrevisionScreen(),
              ));
          }),
        ],
      ),
    );
  }

  Widget _buildCard(IconData icon, String text, bool position, Function() onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 8,
        color: position ? Colors.green : Colors.brown,
        margin: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 16),
            Text(
              text,
              style: const TextStyle(fontSize: 18, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}