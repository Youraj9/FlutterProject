import 'package:flutter/material.dart';
import 'package:sideproject/screens/Homescreen.dart';

import 'Searchscreen.dart';
import 'Orderscreen.dart';
import 'cardscreen.dart';

import 'package:sideproject/widgets/bottomna.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final List<Widget> pages = const [
    HomeScreen1(),
    SearchScreen(),
    CartScreen(),
    OrdersScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: IndexedStack(index: selectedIndex, children: pages),
      body: pages[selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: selectedIndex,
        onItemSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
    );
  }
}
