import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/screens/category/caterogies.dart';

class CustomAppDrawer extends StatefulWidget {
  const CustomAppDrawer({super.key});

  @override
  State<CustomAppDrawer> createState() => _CustomAppDrawerState();
}

class _CustomAppDrawerState extends State<CustomAppDrawer> {
  String fullname = "";

  _loadInformation() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = prefs.getString("fullname") ?? "";
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
            child: Center(
              child: Text(fullname == "" ? "User" : fullname, style: const TextStyle(color: Colors.white, fontSize: 30)),
            ),
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.group , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Clients", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.inventory , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Produits", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.category , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Categories", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const ShowCaterories(),
              ));
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.attach_money , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Ventes", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.payment , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Achats", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.shopping_cart , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Commandes", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.business_center , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Fournisseurs", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Row(
              children: [
                Icon(Icons.settings , color: Colors.white,size: 25),
                SizedBox(width: 20.0),
                Text("Paramètre", style: TextStyle(color: Colors.white, fontSize: 20))
              ],
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
