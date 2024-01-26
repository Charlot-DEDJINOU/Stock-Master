import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:stock_master/screens/login.dart';
import 'package:stock_master/services/user.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final formKey = GlobalKey<FormState>();
  final fullnameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscured = true;
  UserService userService = UserService();

  register(data) async {
    isLoading = true;
    try {
      var response = await userService.create(data);
      print(response);
      Fluttertoast.showToast(msg: "Utilisateur créé avec succès");
      emailController.text = "";
      fullnameController.text = "";
      passwordController.text = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Login()));
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: "Erreur lors de l'inscription");
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } finally {
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                'assets/images/register.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              const Text(
                'Stock Master',
                style: TextStyle(
                  fontSize: 40,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF02BB02),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person,
                          size: 50.0,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Inscrivez-vous!',
                          style: TextStyle(
                            fontSize: 25,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30.0),
                    TextFormField(
                        keyboardType: TextInputType.text,
                        controller: fullnameController,
                        decoration: const InputDecoration(
                          labelText: "Nom d'utilisateur",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (String? value) {
                          return value == null || value == ''
                              ? 'Ce champ est obligatoire'
                              : null;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (String? value) {
                          return value == null || value == ''
                              ? 'Ce champ est obligatoire'
                              : null;
                        }),
                    const SizedBox(height: 20.0),
                    TextFormField(
                        obscureText: _isObscured,
                        keyboardType: TextInputType.text,
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                                icon: Icon(_isObscured
                                    ? Icons.visibility
                                    : Icons.visibility_off))),
                        validator: (String? value) {
                          return value == null || value == ''
                              ? 'Ce champ est obligatoire'
                              : null;
                        }),
                    const SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          await register({
                            "full_name": fullnameController.text,
                            "email": emailController.text,
                            "password": passwordController.text
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
                              'Inscription',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                  },
                  child: const Text(
                    "J'ai déjà un compte",
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
