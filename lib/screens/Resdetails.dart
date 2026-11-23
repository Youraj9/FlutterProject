import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/services/cart_store.dart';
import 'package:sideproject/services/restaurant_service.dart';

class RestaurantDetailsNavigation {
  const RestaurantDetailsNavigation({
    required this.restaurant,
    required this.cartStore,
    this.onOpenCart,
    this.restaurantService,
  });

  final Restaurant restaurant;
  final CartStore cartStore;
  final VoidCallback? onOpenCart;
  final RestaurantService? restaurantService;
}

class RestaurantDetailsRoute extends StatefulWidget {
  const RestaurantDetailsRoute({
    super.key,
    required this.restaurantId,
    this.cartStore,
    this.onOpenCart,
    this.restaurantService,
  });

  final String restaurantId;
  final CartStore? cartStore;
  final VoidCallback? onOpenCart;
  final RestaurantService? restaurantService;

  @override
  State<RestaurantDetailsRoute> createState() => _RestaurantDetailsRouteState();
}

class _RestaurantDetailsRouteState extends State<RestaurantDetailsRoute> {
  late final RestaurantService _restaurantService =
      widget.restaurantService ?? RestaurantService();
  late Future<Restaurant> _restaurantFuture;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  void _loadRestaurant() {
    _restaurantFuture = _restaurantService.fetchRestaurant(widget.restaurantId);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Restaurant>(
      future: _restaurantFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back),
              ),
              title: const Text('Restaurant'),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Could not load restaurant: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: () => setState(_loadRestaurant),
                      child: const Text('Try again'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return RestaurantDetailsScreen(
          restaurant: snapshot.data!,
          cartStore: widget.cartStore,
          onOpenCart: widget.onOpenCart,
          restaurantService: widget.restaurantService,
        );
      },
    );
  }
}

class RestaurantDetailsScreen extends StatefulWidget {
  const RestaurantDetailsScreen({
    super.key,
    required this.restaurant,
    this.cartStore,
    this.onOpenCart,
    this.restaurantService,
  });

  final Restaurant restaurant;
  final CartStore? cartStore;
  final VoidCallback? onOpenCart;
  final RestaurantService? restaurantService;

  @override
  State<RestaurantDetailsScreen> createState() =>
      _RestaurantDetailsScreenState();
}

class _RestaurantDetailsScreenState extends State<RestaurantDetailsScreen> {
  late final RestaurantService _restaurantService =
      widget.restaurantService ?? RestaurantService();
  late final CartStore _cartStore = widget.cartStore ?? CartStore.instance;
  late Future<List<FoodItem>> _menuFuture;

  @override
  void initState() {
    super.initState();
    _loadMenu();
  }

  void _loadMenu() {
    _menuFuture = _restaurantService.fetchMenu(widget.restaurant.id);
  }

  void _selectFood(FoodItem food) {
    if (!_cartStore.addFoodItem(widget.restaurant, food)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Place an order from one restaurant at a time.'),
        ),
      );
      return;
    }

    widget.onOpenCart?.call();
    if (widget.onOpenCart == null) {
      context.go('/cart');
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurant = widget.restaurant;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
              child: Row(
                children: [
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  Expanded(
                    child: Text(
                      restaurant.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF18243B),
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.description.isEmpty
                        ? restaurant.cuisines.join(' • ')
                        : restaurant.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  if (restaurant.address.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      restaurant.address,
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                  const SizedBox(height: 8),
                  Text(
                    '${restaurant.rating.toStringAsFixed(1)} ★  •  '
                    '${restaurant.deliveryTimeMinutes} min  •  '
                    '₹${restaurant.deliveryFee.toStringAsFixed(0)} delivery',
                    style: const TextStyle(
                      color: Color(0xFF18243B),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 10),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Color(0xFF18243B),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<FoodItem>>(
                future: _menuFuture,
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
                              'Could not load this menu: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () {
                                setState(_loadMenu);
                              },
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final foods = snapshot.data ?? const <FoodItem>[];
                  if (foods.isEmpty) {
                    return const Center(
                      child: Text(
                        'This restaurant has no available menu items.',
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: foods.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final food = foods[index];
                      return Card(
                        color: Colors.white,
                        child: ListTile(
                          leading: food.imageUrl.isEmpty
                              ? const Icon(
                                  Icons.restaurant_menu,
                                  color: Colors.deepOrange,
                                )
                              : ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    food.imageUrl,
                                    width: 52,
                                    height: 52,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(
                                              Icons.restaurant_menu,
                                              color: Colors.deepOrange,
                                            ),
                                  ),
                                ),
                          title: Text(food.name),
                          subtitle: Text(
                            food.description.isEmpty
                                ? food.category
                                : '${food.category} • ${food.description}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('₹${food.price.toStringAsFixed(0)}'),
                              if (food.isVegetarian)
                                const Icon(
                                  Icons.eco,
                                  color: Colors.green,
                                  size: 16,
                                ),
                            ],
                          ),
                          onTap: () => _selectFood(food),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
