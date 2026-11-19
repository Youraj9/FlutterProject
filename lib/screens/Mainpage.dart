import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sideproject/models/order.dart';
import 'package:sideproject/screens/Homescreen.dart';
import 'package:sideproject/models/auth_user.dart';
import 'package:sideproject/services/auth_service.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/services/restaurant_service.dart';

import 'Searchscreen.dart';
import 'Orderscreen.dart';
import 'cardscreen.dart';

import 'package:sideproject/widgets/bottomna.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({
    super.key,
    this.user,
    this.orderService,
    this.restaurantService,
  });

  final AuthUser? user;
  final OrderService? orderService;
  final RestaurantService? restaurantService;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;
  int _ordersVersion = 0;
  final List<Widget?> _pages = List<Widget?>.filled(4, null);

  final _authService = AuthService();

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (!mounted) return;
      context.go('/landing');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Could not log out: $error')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = _pageFor(selectedIndex);

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: [
          for (var index = 0; index < _pages.length; index++)
            index == selectedIndex
                ? currentPage
                : _pages[index] ?? const SizedBox.shrink(),
        ],
      ),
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

  Widget _pageFor(int index) {
    final existingPage = _pages[index];
    if (existingPage != null) return existingPage;

    final Widget page;
    switch (index) {
      case 0:
        page = HomeScreen1(
          user: widget.user,
          onLogout: _logout,
          restaurantService: widget.restaurantService,
        );
        break;
      case 1:
        page = SearchScreen(
          onBack: _showHome,
          restaurantService: widget.restaurantService,
        );
        break;
      case 2:
        page = Cardscreen1(
          onBack: _showHome,
          onOrderPlaced: _showPlacedOrder,
          orderService: widget.orderService,
          restaurantService: widget.restaurantService,
        );
        break;
      case 3:
        page = OrdersScreen(
          key: ValueKey<int>(_ordersVersion),
          onBack: _showHome,
          orderService: widget.orderService,
        );
        break;
      default:
        throw RangeError.index(index, _pages);
    }

    _pages[index] = page;
    return page;
  }

  void _showHome() {
    setState(() {
      selectedIndex = 0;
    });
  }

  void _showPlacedOrder(Order _) {
    setState(() {
      _ordersVersion++;
      _pages[3] = null;
      selectedIndex = 3;
    });
  }
}
