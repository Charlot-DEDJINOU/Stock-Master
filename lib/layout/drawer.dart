import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/screens/achat/create.dart';
import 'package:stock_master/screens/category/categories.dart';
import 'package:stock_master/screens/customer/customers.dart';
import 'package:stock_master/screens/order/orders.dart';
import 'package:stock_master/screens/product/products.dart';
import 'package:stock_master/screens/settings/setting.dart';
import 'package:stock_master/screens/supplier/suppliers.dart';
import 'package:stock_master/screens/vente/create.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  String username = "";

  _loadInformation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString("username") ?? "User";
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInformation());
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.brown,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF02BB02),
            ),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text(
                'Stock Master',
                style: TextStyle(
                  fontSize: 30,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10.0),
              Text(username,
                  style: const TextStyle(color: Colors.white, fontSize: 20)),
            ]),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.group, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Clients",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCustomers(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.inventory, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Produits",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowProducts(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.category, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Categories",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowCategories(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.attach_money, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Ventes",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateSell(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.payment, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Achats",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CreateBuy(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Commandes",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowOrders(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.business_center, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Fournisseurs",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const ShowSuppliers(),
              ));
            },
          ),
          const Divider(),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.settings, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Paramètre",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const Setting(),
              ));
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.logout, color: Colors.white, size: 25),
                SizedBox(width: 20.0),
                Text("Deconnexion",
                    style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              handleUnauthorizedError(context);
            },
          ),
        ],
      ),
    );
  }
}
