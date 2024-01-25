import 'package:flutter/material.dart';
import 'package:stock_master/screens/home.dart';
import 'package:stock_master/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  final pref = await SharedPreferences.getInstance();
  String token = pref.getString("token") ?? "";

  runApp(MyApp(token : token));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.token});

  final String token;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Stock Master',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: token == "" ? const Login() : const Home(),
    );
  }
}