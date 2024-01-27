import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "À propos"),
      drawer: const CustomAppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                  "Stock Master",
                  style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text(
                  "À propos de l'application",
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Stock Master est une application de gestion de stock qui vous permet de gérer facilement vos produits, vos fournisseurs, vos commandes et vos mouvements de stock.",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text(
                  "Développeurs ",
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Charlot DEDJINOU (GL) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
             const Center(
                child: Text(
                  "Mathias KINNINKPO (GL) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Rafiatou GNANFON (IM) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "ALLOWANOU Blandine (IM) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Thierry TCHONKLOE (GL) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "Gabin BADJOGOUNME (GL) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Center(
                child: Text(
                  "ODJO Urbain (GL) 19665022",
                  style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Center(
                child: Text(
                  "Logo de l'entreprise :",
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                width: 150,
                height: 150,
                fit: BoxFit.contain,
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0), // Remplacez 2 par l'index de l'onglet "À propos" dans votre BottomNavigationBar
    );
  }
}
