import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/models/prevision.dart';
import 'package:stock_master/screens/product/update.dart';
import 'package:stock_master/services/prevision.dart';
import 'package:stock_master/services/product.dart';

class PrevisionScreen extends StatefulWidget {
  const PrevisionScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PrevisionScreenState createState() => _PrevisionScreenState();
}

class _PrevisionScreenState extends State<PrevisionScreen> {
  List<Prevision> previsions = [];
  final PrevisionService previsionService = PrevisionService();
  final ProductService productService = ProductService();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    // Vérifiez si le widget est déjà monté avant d'appeler _loadPrevisions()
    if (mounted) {
      _loadPrevisions();
    }
  }

  Future<void> _loadPrevisions() async {
    setState(() {
      isLoading = true;
    });
    try {
      final List<Prevision> fetchedPrevisions = await previsionService.getPrevisions();
      if (mounted) {
        setState(() {
          previsions = fetchedPrevisions;
        });
      }
    } catch (e) {
      // Gérez les erreurs liées au chargement des prévisions
      print('Erreur lors du chargement des prévisions : $e');
      // Ajoutez une gestion d'erreur spécifique si nécessaire
    }
    finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Les prévisions'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 1),
      body: isLoading ?
      const Center(
        child: CircularProgressIndicator(),
      ) :
      previsions.isEmpty ?
          const Center(
              child: Text('Aucune prévision à afficher.', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          : ListView.builder(
  itemCount: previsions.length,
  itemBuilder: (context, index) {
    final prevision = previsions[index];

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(8.0),
      color: index.isEven ? Colors.grey[200] : Colors.white,
      child: ListTile(
        title: Text(prevision.productName),
        subtitle: Row(
          children: [
            Expanded(
              child: _buildStatusIcon(prevision.status),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 2,  // Adjust the flex value based on your layout
              child: Text(prevision.message, style: const TextStyle(fontSize: 18.0),),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.visibility),
          onPressed: () {
            _showProductDetails(prevision.productId);
          },
        ),
      ),
    );
  },
)

    );
  }

  void _showProductDetails(int productId) async {
    setState(() {
      isLoading = true;
    });
    try {
      final product = await productService.get(productId);
      // ignore: use_build_context_synchronously
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => UpdateProduct(product: product)),
      );
    } catch (e) {
      print('Erreur lors du chargement des détails du produit : $e');
      // Ajoutez une gestion d'erreur spécifique si nécessaire
    }
    finally{
      isLoading = false;
    }
  }

  Widget _buildStatusIcon(int status) {
    return Icon(
      status == 1 ? Icons.arrow_upward : Icons.arrow_downward,
      color: status == 1 ? Colors.orange : Colors.red,
      size: 50.0,
    );
  }
}
