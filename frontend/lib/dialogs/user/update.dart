import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/models/authenticated_user.dart';
import 'package:stock_master/screens/settings/setting.dart';
import 'package:dio/dio.dart';
import 'package:stock_master/services/user.dart';

class UpdateUser extends StatefulWidget {
  final User user;

  const UpdateUser({Key? key, required this.user}) : super(key: key);

  @override
  State<UpdateUser> createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLoading = false;
  UserService userService = UserService();

  @override
  void initState() {
    super.initState();
    emailController.text = widget.user.email;
    usernameController.text = widget.user.username;
  }

  update(data) async {
    setState(() {
      isLoading = true;
    });
    try {
      var response = await userService.update(widget.user.userId, data);

      final pref = await SharedPreferences.getInstance();
      pref.setString("username", data['username']);

      print(response);
      showToast("Profil mise à jour avec succès");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Setting()));
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
    } finally {
        setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
  title: const Text('Modifier profil'),
  content: SizedBox(
    height: MediaQuery.of(context).size.height * 0.31, // Réglez la hauteur maximale selon vos besoins
    child: SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min, // Assurez-vous que la colonne n'occupe que l'espace nécessaire
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: "Nom d'utilisateur",
              ),
              validator: (String? value) {
                return value == null || value == ''
                    ? 'Ce champ est obligatoire'
                    : null;
              },
            ),
            const SizedBox(height: 20.0),
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              validator: (String? value) {
                return value == null || value == ''
                    ? 'Ce champ est obligatoire'
                    : null;
              },
            ),
            const SizedBox(height: 20.0),
            Center(
              child: isLoading
                ? const CircularProgressIndicator(
                        color: Colors.brown,
                ) 
              :  const SizedBox(height: 0.0),
            )
          ],
        ),
      ),
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
      child: const Text('Sauvegarder'),
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          await update({
            "username": usernameController.text,
            "email": emailController.text,
            "password": widget.user.password,
            "full_name": widget.user.fullname
          });
        }
      },
    ),
  ],
);

  }
}
