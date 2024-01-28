import 'package:flutter/material.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
 String categoryName = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une catégorie'),
      content: TextField(
        onChanged: (value) {
          categoryName = value;
        },
        decoration: const InputDecoration(
          hintText: 'Nom de la catégorie',
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Ajouter'),
          onPressed: () {
            // Ajouter la catégorie avec le nom `categoryName`
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}