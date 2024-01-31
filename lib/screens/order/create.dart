import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class CreateOrder extends StatefulWidget {
  const CreateOrder({super.key});

  @override
  State<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends State<CreateOrder> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Enregistrer une commande'),
      drawer: CustomAppDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(index: 0),
      body: Center(
        child: Text('Contenu de la page des prévisions'),
      ),
    );
  }
}