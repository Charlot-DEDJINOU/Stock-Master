import 'package:flutter/material.dart';
import 'package:stock_master/layout/handle_unauthorized_error.dart';
import 'package:stock_master/layout/toast.dart';
import 'package:stock_master/screens/settings/setting.dart';
import 'package:dio/dio.dart';
import 'package:stock_master/services/user.dart';

class UpdateUserPassword extends StatefulWidget {
  final String id;

  const UpdateUserPassword({Key? key, required this.id}) : super(key: key);

  @override
  State<UpdateUserPassword> createState() => _UpdateUserPasswordState();
}

class _UpdateUserPasswordState extends State<UpdateUserPassword> {
  final formKey = GlobalKey<FormState>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool _isObscuredOldPassword = true;
  bool _isObscuredNewPassword = true;
  bool _isObscuredConfirmPassword = true;

  UserService userService = UserService();

  updatePawword(data) async {
    try {
      var response = await userService.updatePassword(data);
      print(response);
      showToast("Mot de passe changé avec succès");
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const Setting()));
    } on DioException catch (e) {
      print(e);
      if (e.response!.statusCode == 401) {
        handleUnauthorizedError(context);
      } else if (e.response!.statusCode == 203) {
        showToast("Ancien Mot de passe incorrect");
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
      content: Form(
        key: formKey,
        child: Column(
          children: [
            TextFormField(
                obscureText: _isObscuredOldPassword,
                keyboardType: TextInputType.text,
                controller: oldPasswordController,
                decoration: InputDecoration(
                    labelText: 'Ancien Mot de passe',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscuredOldPassword = !_isObscuredOldPassword;
                          });
                        },
                        icon: Icon(_isObscuredOldPassword
                            ? Icons.visibility
                            : Icons.visibility_off))),
                validator: (String? value) {
                  return value == null || value == ''
                      ? 'Ce champ est obligatoire'
                      : null;
                }),
            TextFormField(
                obscureText: _isObscuredNewPassword,
                keyboardType: TextInputType.text,
                controller: newPasswordController,
                decoration: InputDecoration(
                    labelText: 'Nouveau Mot de passe',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscuredNewPassword = !_isObscuredNewPassword;
                          });
                        },
                        icon: Icon(_isObscuredNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off))),
                validator: (String? value) {
                  return value == null || value == ''
                      ? 'Ce champ est obligatoire'
                      : null;
                }),
            TextFormField(
                obscureText: _isObscuredConfirmPassword,
                keyboardType: TextInputType.text,
                controller: confirmPasswordController,
                decoration: InputDecoration(
                    labelText: 'Confirmer Mot de passe',
                    suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _isObscuredConfirmPassword =
                                !_isObscuredConfirmPassword;
                          });
                        },
                        icon: Icon(_isObscuredConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off))),
                validator: (String? value) {
                  return value != newPasswordController.text
                      ? 'Mot de passe non conforme'
                      : null;
                }),
          ],
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
              await updatePawword({
                "user_id": widget.id,
                "old_password": oldPasswordController.text,
                "new_password": newPasswordController.text,
              });
            }
          },
        ),
      ],
    );
  }
}
