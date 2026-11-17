import 'package:flutter/material.dart';
import 'package:sideproject/screens/Homescreen.dart';
import 'package:sideproject/models/auth_user.dart';
import 'package:sideproject/services/auth_service.dart';

import 'Searchscreen.dart';
import 'Orderscreen.dart';
import 'cardscreen.dart';

import 'package:sideproject/widgets/bottomna.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.user});

  final AuthUser? user;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

  final _authService = AuthService();

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/landing', (_) => false);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not log out: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomeScreen1(user: widget.user, onLogout: _logout),
      const SearchScreen(),
      const Cardscreen1(),
      OrdersScreen(
        onBack: () {
          setState(() {
            selectedIndex = 0;
          });
        },
      ),
    ];

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
