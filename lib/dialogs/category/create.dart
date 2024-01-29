import 'package:flutter/material.dart';
import 'package:stock_master/screens/category/caterogies.dart';
import 'package:stock_master/services/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';

class CreateCategory extends StatefulWidget {
  const CreateCategory({super.key});

  @override
  State<CreateCategory> createState() => _CreateCategoryState();
}

class _CreateCategoryState extends State<CreateCategory> {
  String categoryName = '';
  CategoryService categoryService = CategoryService();

  create(data) async {
    try {
      var response = await categoryService.create(data);
      print(response);
      Fluttertoast.showToast(msg: "Categorie créé avec succès");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ShowCaterories()));
    } on DioException catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Erreur lors de l'ajout");
      if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    } finally {
         Navigator.of(context).pop();
    }
  }

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
          onPressed: () async {
            await create({
              'category_name': categoryName,
            });
          },
        ),
      ],
    );
  }
}
