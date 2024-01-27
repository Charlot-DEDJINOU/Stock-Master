import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(title: 'Historiques'),
      drawer: CustomAppDrawer(),
      bottomNavigationBar: CustomBottomNavigationBar(index: 2),
      body: Center(
        child: Text('Contenu de la page des historiques'),
      ),
    );
  }
}