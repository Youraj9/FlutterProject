import 'package:flutter/material.dart';
import 'package:sideproject/widgets/location.dart';
import 'package:sideproject/widgets/search.dart';
import 'package:sideproject/widgets/foodsection.dart';
import 'package:sideproject/widgets/foodcategor.dart';
// import 'package:flutter/material.dart';
import 'package:sideproject/widgets/promotional.dart';
import 'package:sideproject/widgets/restuarnt.dart';
import 'package:sideproject/widgets/bottomna.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('Food Delivery')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Location(),
              const SizedBox(height: 23),
              const Search(),
              const SizedBox(height: 23),
              const Foodsection(),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeScreen1 extends StatefulWidget {
  const HomeScreen1({super.key});

  @override
  State<HomeScreen1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  // int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Location(),

              const SizedBox(height: 22),

              const Search(),

              const SizedBox(height: 22),

              const FoodCategories(),

              const SizedBox(height: 20),

              const PromoBanner(),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Text(
                      'Top Restaurants Near You',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See all')),
                ],
              ),

              const SizedBox(height: 8),

              const RestaurantCard(
                name: 'Biryani Paradise',
                cuisines: 'Biryani • North Indian • Chinese',
                rating: '4.4',
                deliveryTime: '30–40 mins',
                price: '₹250 for two',
                offer: 'Up to 50% OFF',
                foodIcon: Icons.rice_bowl,
              ),

              const RestaurantCard(
                name: 'Burger Singh',
                cuisines: 'Burgers • Fast Food',
                rating: '4.3',
                deliveryTime: '25–35 mins',
                price: '₹300 for two',
                offer: 'Flat 40% OFF',
                foodIcon: Icons.lunch_dining,
              ),

              const RestaurantCard(
                name: 'Dosa Plaza',
                cuisines: 'South Indian • Fast Food',
                rating: '4.5',
                deliveryTime: '20–30 mins',
                price: '₹200 for two',
                offer: 'Up to 40% OFF',
                foodIcon: Icons.breakfast_dining,
              ),
              const RestaurantCard(
                name: 'CAKE AND BAKE',
                cuisines: 'CAKE',
                rating: '4.5',
                deliveryTime: '20–30 mins',
                price: '₹200 for two',
                offer: 'Up to 40% OFF',
                foodIcon: Icons.cake_rounded,
              ),
            ],
          ),
        ),
      ),
      // bottomNavigationBar: BottomNavBar(
      //   selectedIndex: selectedIndex,
      //   onItemSelected: (index) {
      //     setState(() {
      //       selectedIndex = index;
      //     });
      //   },
      // ),
    );
  }
}
