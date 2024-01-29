import 'package:flutter/material.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/screens/category/categories.dart';
import 'package:stock_master/services/category.dart';
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
      showToast("Categorie créé avec succès");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ShowCategories()));
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
