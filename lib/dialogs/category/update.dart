import 'package:flutter/material.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/category.dart';
import 'package:stock_master/screens/category/categories.dart';
import 'package:stock_master/services/category.dart';
import 'package:dio/dio.dart';

class UpdateCategory extends StatefulWidget {
  final Category category;

  const UpdateCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  late TextEditingController _textEditingController;
  CategoryService categoryService = CategoryService();

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.category.categoryName);
  }

  update(data) async {
    try {
      var response = await categoryService.update(
          widget.category.categoryId.toString(), data);
      print(response);
      showToast("Modification effectué avec succès");
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
      title: const Text('Modifier une catégorie'),
      content: TextField(
        controller: _textEditingController,
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
          child: const Text('Modifier'),
          onPressed: () async {
            String updatedCategoryName = _textEditingController.text;
            _textEditingController.text = '';
            await update({'category_name': updatedCategoryName});
          },
        ),
      ],
    );
  }
}
