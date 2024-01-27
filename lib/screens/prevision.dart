import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class Prevision extends StatefulWidget {
  const Prevision({super.key});

  @override
  State<Prevision> createState() => _PrevisionState();
}

class _PrevisionState extends State<Prevision> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Prévisions'),
      drawer: CustomAppDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(index: 1),
      body: Center(
        child: Text('Contenu de la page des prévisions'),
      ),
    );
  }
}