import 'package:flutter/material.dart';
import 'package:stock_master/screens/order/create.dart';

class QuantityStock extends StatefulWidget {
  final String quantity;

  const QuantityStock({Key? key, required this.quantity}) : super(key: key);

  @override
  State<QuantityStock> createState() => _QuantityStockState();
}

class _QuantityStockState extends State<QuantityStock> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Quantité insuffisante'),
      content: Text("Quantité disponible en stock : ${widget.quantity}"),
      actions: <Widget>[
        TextButton(
          child: const Text('Fermer'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Enregistrer une commande'),
          onPressed: () {
             Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CreateOrder()));
          },
        ),
      ],
    );
  }
}
