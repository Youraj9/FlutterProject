import 'package:flutter/material.dart';
import 'package:sideproject/widgets/search.dart';
import 'package:sideproject/widgets/cusinecat.dart';
import 'package:sideproject/widgets/restuarnt.dart';
import 'package:sideproject/widgets/popular.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      minHeight: 40,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Search',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Find your favourite food',
                        style: TextStyle(color: Color(0xFF71839D)),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Search2(),
              const SizedBox(height: 18),
              const Cusinecat(),
              const SizedBox(height: 18),
              const Popularsection(),
              const SizedBox(height: 18),
              const Text(
                'Search Results (25)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                cuisines: 'Burgers • Fast Food • Beverages',
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
                name: 'La Pino’z Pizza',
                cuisines: 'Pizza • Italian • Fast Food',
                rating: '4.2',
                deliveryTime: '30–45 mins',
                price: '₹400 for two',
                offer: 'Flat 30% OFF',
                foodIcon: Icons.local_pizza,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
