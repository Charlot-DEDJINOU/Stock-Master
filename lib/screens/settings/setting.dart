import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stock_master/dialogs/user/password.dart';
import 'package:stock_master/dialogs/user/update.dart';
import 'package:stock_master/layout/appbar.dart';
import 'package:stock_master/layout/bottom_navigation_bar.dart';
import 'package:stock_master/models/authenticated_user.dart';
import 'package:stock_master/layout/drawer.dart';
import 'package:stock_master/services/user.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  late String userName;
  late String userEmail;
  late String userId;
  bool isLoading = true;

  UserService userService = UserService();
  late User user;

  loadata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    userId = pref.getString("id") ?? "";

    user = await userService.get(userId);
    userEmail = user.email;
    userName = user.username;

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: "Paramètre"),
      bottomNavigationBar: const CustomBottomNavigationBar(index: 0),
      drawer: const CustomAppDrawer(),
      body: !isLoading 
        ? ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            ListTile(
              title: const Text('Nom'),
              subtitle: Text(userName),
            ),
            const Divider(),
            ListTile(
              title: const Text('Email'),
              subtitle: Text(userEmail),
            ),
            const Divider(),
            ListTile(
                title: const Text('Changer de mot de passe'), 
                onTap: () => {
                    _showUpdateUserPasswordDialog(context, user.userId.toString())
                }
              ),
            const Divider(),
            ListTile(
              title: const Text('Modifier le profil'), 
              onTap: () => {
                  _showUpdateUserDialog(context, user)
              }
            ),
            const Divider(),
          ],
        ) 
        : const Center(
                child: CircularProgressIndicator(color: Colors.brown)
        ),
    );
  }

  Future<void> _showUpdateUserDialog(BuildContext context, User user) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateUser(user: user);
      },
    );
  }

   Future<void> _showUpdateUserPasswordDialog(BuildContext context, String id) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UpdateUserPassword(id: id);
      },
    );
  }
}
