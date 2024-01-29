import 'package:flutter/material.dart';
import 'package:stock_master/models/category.dart';
import 'package:stock_master/screens/category/caterogies.dart';
import 'package:stock_master/services/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      var response = await categoryService.update(widget.category.categoryId.toString(), data);
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
            await update({
              'category_name': updatedCategoryName
            });
          },
        ),
      ],
    );
  }
}
