import 'package:flutter/material.dart';
import 'package:stock_master/dialogs/category/create.dart';
import 'package:stock_master/dialogs/category/delete.dart';
import 'package:stock_master/dialogs/category/update.dart';
import 'package:stock_master/models/category.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';

class ShowCaterories extends StatefulWidget {
  const ShowCaterories({super.key});

  @override
  State<ShowCaterories> createState() => _ShowCateroriesState();
}

class _ShowCateroriesState extends State<ShowCaterories> {
  final List<Category> categories = [
    Category(categoryId: 1, categoryName: 'Category 1'),
    Category(categoryId: 2, categoryName: 'Category 2'),
    Category(categoryId: 3, categoryName: 'Category 3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Categories'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final color = index.isEven ? Colors.white : Colors.green;
          return Container(
            color: color,
            padding: const EdgeInsets.all(10.0),
            child: ListTile(
              title: Text(category.categoryName),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      _showUpdateCategoryDialog(context, category);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                       _showDeleteCategoryDialog(context, category.categoryId);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.brown,
        onPressed: () {
          _showCreateCategoryDialog(context);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _showCreateCategoryDialog(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CreateCategory();
      },
    );
  }

  Future<void> _showUpdateCategoryDialog(
      BuildContext context, Category category) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateCategory(category: category);
      },
    );
  }

 Future<void> _showDeleteCategoryDialog(
      BuildContext context, int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCategory(categoryId: id);
      },
    );
  }

}