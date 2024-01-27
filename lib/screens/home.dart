import 'package:flutter/material.dart';
import 'package:stock_master/screens/category/caterogies.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Stock Master'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: GridView.count(
        crossAxisCount: 2,
        children: [
          _buildCard(Icons.inventory, 'Produits', true, () {
            // Action à effectuer lors du clic sur le premier rectangle
          }),
          _buildCard(Icons.category, 'Categories', false,  () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ShowCaterories(),
              ));
          }),
          _buildCard(Icons.person, 'Clients', false, () {
            // Action à effectuer lors du clic sur le troisième rectangle
          }),
           _buildCard(Icons.shopping_cart, 'Commandes', true, () {
            // Action à effectuer lors du clic sur le deuxième rectangle
          }),
          _buildCard(Icons.business_center, 'Fournisseurs', true, () {
            // Action à effectuer lors du clic sur le quatrième rectangle
          }),
          _buildCard(Icons.payment, 'Achats', false, () {
            // Action à effectuer lors du clic sur le quatrième rectangle
          }),
          _buildCard(Icons.attach_money, 'Ventes', false, () {
            // Action à effectuer lors du clic sur le troisième rectangle
          }),
          _buildCard(Icons.timeline, 'Previsions', true, () {
            // Action à effectuer lors du clic sur le quatrième rectangle
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