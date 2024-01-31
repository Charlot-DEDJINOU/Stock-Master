import 'package:flutter/material.dart';
import 'package:stock_master/screens/about.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title,
        style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
      ),
      backgroundColor: const Color(0xFF02BB02),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Ouvrez le menu latéral
            },
          );
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            if(Navigator.canPop(context)) {
                Navigator.pop(context);
              }
          },
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
         IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const About(),
            ));
          },
          icon: const Icon(Icons.info, color: Colors.white),
        ),
      ],
    );
  }
}
