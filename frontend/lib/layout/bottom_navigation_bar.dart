import 'package:flutter/material.dart';
import 'package:stock_master/screens/history.dart';
import 'package:stock_master/screens/home.dart';
import 'package:stock_master/screens/prevision.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int index;

  const CustomBottomNavigationBar({Key? key, required this.index}) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.index;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      if (index == 0) {
        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const Home(),
        ));
      }
      else if (index == 1) {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const PrevisionScreen(),
        ));
      }
      else {
        Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const History(),
        ));
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Acceuil',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.timeline),
          label: 'Previsions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Historiques',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      onTap: _onItemTapped,
      backgroundColor: const Color(0xFF02BB02),
    );
  }
}