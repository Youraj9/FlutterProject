import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sideproject/models/restaurant_catalog.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/models/auth_user.dart';
import 'package:sideproject/screens/Resdetails.dart';
import 'package:sideproject/services/cart_store.dart';
import 'package:sideproject/services/restaurant_service.dart';
import 'package:sideproject/widgets/location.dart';
import 'package:sideproject/widgets/search.dart';
import 'package:sideproject/widgets/foodsection.dart';
import 'package:sideproject/widgets/cuisine_filter.dart';
// import 'package:flutter/material.dart';
import 'package:sideproject/widgets/promotional.dart';
import 'package:sideproject/widgets/restuarnt.dart';

// import 'package:sideproject/widgets/bottomna.dart';

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
  const HomeScreen1({
    super.key,
    this.user,
    this.onLogout,
    this.onOpenCart,
    this.cartStore,
    this.restaurantService,
  });

  final AuthUser? user;
  final Future<void> Function()? onLogout;
  final VoidCallback? onOpenCart;
  final CartStore? cartStore;
  final RestaurantService? restaurantService;

  @override
  State<HomeScreen1> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen1> {
  late final CartStore _cartStore = widget.cartStore ?? CartStore.instance;
  late final RestaurantService _restaurantService =
      widget.restaurantService ?? RestaurantService();
  late Future<RestaurantCatalog> _catalogFuture;
  String _selectedCuisine = 'All';
  String _query = '';

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  void _loadRestaurants() {
    _catalogFuture = _restaurantService.fetchCatalog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Location(user: widget.user, onLogout: widget.onLogout),

              const SizedBox(height: 22),

              Search(
                onChanged: (value) => setState(() => _query = value.trim()),
              ),

              const SizedBox(height: 22),

              FutureBuilder<RestaurantCatalog>(
                future: _catalogFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return const SizedBox(height: 92);
                  return CuisineFilter(
                    categories: snapshot.data!.categories,
                    selectedCuisine: _selectedCuisine,
                    onSelected: (cuisine) =>
                        setState(() => _selectedCuisine = cuisine),
                  );
                },
              ),

              const SizedBox(height: 20),

              const PromoBanner(),

              const SizedBox(height: 24),

              _buildRestaurantSection(),
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

  Widget _buildRestaurantSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder<RestaurantCatalog>(
          future: _catalogFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Column(
                  children: [
                    Text(
                      'Could not load restaurants: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(_loadRestaurants);
                      },
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              );
            }

            final catalog = snapshot.data!;
            final allRestaurants = catalog.restaurants;
            if (allRestaurants.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Center(child: Text('No restaurants are available yet.')),
              );
            }

            final restaurants = allRestaurants
                .where(
                  (restaurant) => restaurantMatchesCategory(
                    restaurant,
                    _selectedCuisine,
                    catalog.categories,
                  ),
                )
                .where(_matchesQuery)
                .toList();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedCuisine == 'All'
                      ? 'Top Restaurants Near You'
                      : '$_selectedCuisine Restaurants',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                if (restaurants.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text(_emptyResultsMessage)),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: restaurants.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final restaurant = restaurants[index];
                      return RestaurantCard(
                        name: restaurant.name,
                        cuisines: restaurant.cuisines.isEmpty
                            ? 'Restaurant'
                            : restaurant.cuisines.join(' • '),
                        rating: restaurant.rating.toStringAsFixed(1),
                        deliveryTime: '${restaurant.deliveryTimeMinutes} min',
                        price:
                            '₹${restaurant.minimumOrder.toStringAsFixed(0)} min order',
                        offer: restaurant.isOpen
                            ? 'Open now'
                            : 'Currently closed',
                        foodIcon: _iconForRestaurant(restaurant),
                        imageUrl: restaurant.imageUrl,
                        isOpen: restaurant.isOpen,
                        onTap: () {
                          context.push(
                            '/restaurants/${restaurant.id}',
                            extra: RestaurantDetailsNavigation(
                              restaurant: restaurant,
                              cartStore: _cartStore,
                              onOpenCart: widget.onOpenCart,
                              restaurantService: _restaurantService,
                            ),
                          );
                        },
                      );
                    },
                  ),
              ],
            );
          },
        ),
      ],
    );
  }

  bool _matchesQuery(Restaurant restaurant) {
    if (_query.isEmpty) return true;
    final searchableText = [
      restaurant.name,
      restaurant.description,
      restaurant.address,
      ...restaurant.cuisines,
    ].join(' ').toLowerCase();
    return searchableText.contains(_query.toLowerCase());
  }

  String get _emptyResultsMessage {
    if (_query.isNotEmpty) return 'No restaurants match "$_query".';
    return 'No restaurants serve $_selectedCuisine.';
  }

  IconData _iconForRestaurant(Restaurant restaurant) {
    final cuisines = restaurant.cuisines.join(' ').toLowerCase();
    if (cuisines.contains('biryani')) return Icons.rice_bowl;
    if (cuisines.contains('burger')) return Icons.lunch_dining;
    if (cuisines.contains('pizza')) return Icons.local_pizza;
    if (cuisines.contains('dessert') || cuisines.contains('cake')) {
      return Icons.cake_rounded;
    }
    return Icons.restaurant;
  }
}
