import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/screens/login.dart';

void handleUnauthorizedError(BuildContext context) async {
  final pref = await SharedPreferences.getInstance();
  pref.setString("token", "");
  
  showToast("Veuillez vous authentifier");

  Navigator.of(context).push(
    MaterialPageRoute(builder: (context) => const Login()),
  );
}
