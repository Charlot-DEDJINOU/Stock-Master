import 'package:flutter/material.dart';
import 'package:stock_master/models/category.dart';

class UpdateCategory extends StatefulWidget {
  final Category category;

  const UpdateCategory({Key? key, required this.category}) : super(key: key);

  @override
  State<UpdateCategory> createState() => _UpdateCategoryState();
}

class _UpdateCategoryState extends State<UpdateCategory> {
  late TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController =
        TextEditingController(text: widget.category.categoryName);
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
          onPressed: () {
            String updatedCategoryName = _textEditingController.text;
            _textEditingController.text = '';
            print(updatedCategoryName);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
