import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/customer.dart';
import 'package:stock_master/screens/customer/customers.dart';
import 'package:stock_master/services/customer.dart';

class UpdateCostomer extends StatefulWidget {
  final Customer customer;

  const UpdateCostomer({Key? key, required this.customer}) : super(key: key);

  @override
  State<UpdateCostomer> createState() => _UpdateCostomerState();
}

class _UpdateCostomerState extends State<UpdateCostomer> {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController emailController = TextEditingController();
  late TextEditingController phoneController = TextEditingController();
  late TextEditingController addressController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  CustomerServive customerServive = CustomerServive();

  @override
  void initState() {
    super.initState();
    var customer = widget.customer;

    nameController.text = customer.customerName;
    emailController.text = customer.email;
    phoneController.text = customer.phone;
    addressController.text = customer.address;
  }

  update(data) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await customerServive.update(
          widget.customer.customerId.toString(), data);
      print(response);
      showToast("Modification effectué avec succès");
      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const ShowCustomers()));
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        showToast("Une erreur est intervenue");
        print(e.response!.data);
      } else {
        showToast("Une erreur est intervenue");
        print(e.message);
      }
    } finally {
        setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Nouveau client"),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Image.asset(
                    "assets/images/logo.png",
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email du client',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nom du client',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: 'Adresse du client',
                          prefixIcon: Icon(Icons.location_city),
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Numéro du client',
                          prefixIcon: Icon(Icons.phone),
                          hintText: '22959105267',
                        ),
                        validator: (String? value) {
                          return value == null || value.isEmpty
                              ? 'Ce champ est obligatoire'
                              : null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await update({
                        "customer_name": nameController.text,
                        "email": emailController.text,
                        "phone": phoneController.text,
                        "address": addressController.text
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF02BB02),
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Sauvegarder',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
