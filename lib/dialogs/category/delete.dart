import 'package:flutter/material.dart';
import 'package:stock_master/screens/category/caterogies.dart';
import 'package:stock_master/services/category.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
class DeleteCategory extends StatefulWidget {
  final int categoryId;

  const DeleteCategory({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<DeleteCategory> createState() => _DeleteCategoryState();
}

class _DeleteCategoryState extends State<DeleteCategory> {

   CategoryService categoryService = CategoryService();

  delete() async {
    try {
      await categoryService.delete(widget.categoryId.toString());
      Fluttertoast.showToast(msg: "Categorie supprimé avec succès");
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ShowCaterories()));
    } on DioException catch (e) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(msg: "Erreur lors de la supression");
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
      content: const Text(
        'Voulez-vous vraiment supprimé ?'
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: const Text('Confirmer'),
          onPressed: () async {
            await delete();
          },
        ),
      ],
    );
  }
}
