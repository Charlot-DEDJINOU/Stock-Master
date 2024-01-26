import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/screens/home.dart';
import 'package:stock_master/screens/register.dart';
import 'package:stock_master/services/user.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscured = true;
  UserService userService = UserService();

  login(data) async {
    isLoading = true;

    try {
      var response = await userService.login(data);
      final pref = await SharedPreferences.getInstance();
      pref.setString("token", response.accessToken!);
      pref.setString("fullname", response.user!.fullname);
      Fluttertoast.showToast(msg: "Utilisateur connecté avec succès");
      emailController.text = "";
      passwordController.text = "";
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()));
    } on DioException catch (e) {
      Fluttertoast.showToast(msg: "Erreur lors de la connexion");
      if (e.response != null)
        print(e.response!.data);
      else
        print(e.message);
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
                'assets/images/login.png'), // Remplacez 'assets/background_image.jpg' par le chemin de votre image
            fit: BoxFit.cover, // Ajuste l'image pour remplir tout le conteneur
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
                          'Connectez-vous!',
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
                          await login({
                            "strategy": "local",
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
                              'Connexion',
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const Register()));
                  },
                  child: const Text(
                    'Créer un compte',
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
