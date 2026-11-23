import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:sideproject/widgets/bottomna.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavBar(
        selectedIndex: navigationShell.currentIndex,
        onItemSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/search');
              break;
            case 2:
              context.go('/cart');
              break;
            case 3:
              context.go('/orders');
              break;
          }
        },
      ),
    );
  }
}
