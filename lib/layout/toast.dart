import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: Colors.brown,
    textColor: Colors.white,
    timeInSecForIosWeb: 50,
  );
}
