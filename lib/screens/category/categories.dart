import 'package:flutter/material.dart';
import 'package:stock_master/dialogs/category/create.dart';
import 'package:stock_master/dialogs/category/delete.dart';
import 'package:stock_master/dialogs/category/update.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/models/category.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/services/category.dart';
import 'package:dio/dio.dart';

class ShowCategories extends StatefulWidget {
  const ShowCategories({super.key});

  @override
  State<ShowCategories> createState() => _ShowCategoriesState();
}

class _ShowCategoriesState extends State<ShowCategories> {
  late List<Category> categories = [];
  CategoryService categoryService = CategoryService();
  bool isLoading = true;

  allCategories() async {
    try {
      var response = await categoryService.getAll();
      setState(() {
        categories = response;
        isLoading = false;
      });
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response != null) {
        print(e.response!.data);
      } else {
        print(e.message);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    allCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Listes des Categories'),
      drawer: const CustomAppDrawer(),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      body: categories.isNotEmpty
          ? ListView.builder(
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
                            _showDeleteCategoryDialog(
                                context, category.categoryId);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          :  Center(
              child: isLoading 
                ? const CircularProgressIndicator(color: Colors.brown) 
                : const Text("Aucune catégories",style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold))
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

  Future<void> _showDeleteCategoryDialog(BuildContext context, int id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DeleteCategory(categoryId: id);
      },
    );
  }
}
