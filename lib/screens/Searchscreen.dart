import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sideproject/models/restaurant_catalog.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/screens/Resdetails.dart';
import 'package:sideproject/services/cart_store.dart';
import 'package:sideproject/services/restaurant_service.dart';
import 'package:sideproject/widgets/cuisine_filter.dart';
import 'package:sideproject/widgets/restuarnt.dart';
import 'package:sideproject/widgets/search.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({
    this.onBack,
    this.onOpenCart,
    this.cartStore,
    this.restaurantService,
    super.key,
  });

  final VoidCallback? onBack;
  final VoidCallback? onOpenCart;
  final CartStore? cartStore;
  final RestaurantService? restaurantService;

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final CartStore _cartStore = widget.cartStore ?? CartStore.instance;
  late final RestaurantService _restaurantService =
      widget.restaurantService ?? RestaurantService();
  late Future<RestaurantCatalog> _catalogFuture;
  String _query = '';
  String _selectedCuisine = 'All';

  @override
  void initState() {
    super.initState();
    _loadRestaurants();
  }

  void _loadRestaurants() {
    _selectedCuisine = 'All';
    _catalogFuture = _restaurantService.fetchCatalog();
  }

  void _goBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _goBack,
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
                        'Find your favourite restaurant',
                        style: TextStyle(color: Color(0xFF71839D)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Search2(
                onChanged: (value) => setState(() => _query = value.trim()),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<RestaurantCatalog>(
                future: _catalogFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Could not load restaurants: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () => setState(_loadRestaurants),
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final catalog = snapshot.data!;
                  final allRestaurants = catalog.restaurants;
                  final restaurants = allRestaurants
                      .where(_matchesQuery)
                      .where(
                        (restaurant) => restaurantMatchesCategory(
                          restaurant,
                          _selectedCuisine,
                          catalog.categories,
                        ),
                      )
                      .toList();

                  return Column(
                    children: [
                      CuisineFilter(
                        categories: catalog.categories,
                        selectedCuisine: _selectedCuisine,
                        onSelected: (cuisine) =>
                            setState(() => _selectedCuisine = cuisine),
                      ),
                      Expanded(
                        child: restaurants.isEmpty
                            ? Center(
                                child: Text(
                                  _emptyResultsMessage(allRestaurants),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            : ListView(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  4,
                                  16,
                                  16,
                                ),
                                children: [
                                  Text(
                                    'Restaurants (${restaurants.length})',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  for (final restaurant in restaurants)
                                    RestaurantCard(
                                      name: restaurant.name,
                                      cuisines: restaurant.cuisines.isEmpty
                                          ? 'Restaurant'
                                          : restaurant.cuisines.join(' • '),
                                      rating: restaurant.rating.toStringAsFixed(
                                        1,
                                      ),
                                      deliveryTime:
                                          '${restaurant.deliveryTimeMinutes} min',
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
                                            restaurantService:
                                                _restaurantService,
                                          ),
                                        );
                                      },
                                    ),
                                ],
                              ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
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

  String _emptyResultsMessage(List<Restaurant> allRestaurants) {
    if (allRestaurants.isEmpty) return 'No restaurants are available yet.';
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
