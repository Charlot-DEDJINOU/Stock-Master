import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/models/customer.dart';
import 'package:stock_master/screens/customer/create.dart';
import 'package:stock_master/screens/customer/update.dart';
import 'package:stock_master/services/customer.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowCustomers extends StatefulWidget {
  const ShowCustomers({super.key});

  @override
  State<ShowCustomers> createState() => _ShowCustomersState();
}

class _ShowCustomersState extends State<ShowCustomers> {
  late List<Customer> customers = [];
  CustomerServive customerService = CustomerServive();
  bool isLoading = true;

  allCustomers() async {
    try {
      var response = await customerService.getAll();
      setState(() {
        customers = response;
        isLoading = false;
      });
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    allCustomers();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Listes des clients"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: customers.isNotEmpty
          ? ListView.builder(
        itemCount: customers.length,
        itemBuilder: (context, index) {
          final customer = customers[index];
          return Card(
            margin: const EdgeInsetsDirectional.all(5.0),
            child: ListTile(
              onTap: () => {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => UpdateCostomer(customer: customer)))
              },
              leading: const Icon(Icons.person),
              title: Text(customer.customerName),
              subtitle: Text(customer.address),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.phone),
                    onPressed: () {
                      var phone = customer.phone;
                      _launch('tel:$phone');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.email),
                    onPressed: () {
                      var email = customer.email;
                      _launch('mailto:$email');
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.chat),
                    onPressed: () {
                      var phone = customer.phone;
                      _launch('https://wa.me/$phone');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ) :  
      Center(
            child: isLoading 
              ? const CircularProgressIndicator(color: Colors.brown) 
              : const Text("Aucun client",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const CreateCustomer(),
          ));
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _launch(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Impossible de lancer l\'application téléphone';
    }
  }
}
