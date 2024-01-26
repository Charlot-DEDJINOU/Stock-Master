import 'package:flutter/material.dart';
import 'package:stock_master/screens/layout/drawer.dart';
import 'package:stock_master/screens/layout/bottom_navigation_bar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stock Master" , style: TextStyle(color: Colors.white)), 
        backgroundColor: const Color(0xFF02BB02),
          leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer(); // Ouvrez le menu latéral
              },
            );
          },
        ),
      ),
      drawer: const AppDrawer(),
      bottomNavigationBar: const BottomNavigationBarExample(),
      body: const Center(
        child: Text('Contenu de la page d\'accueil'),
      ),
    );
  }
}