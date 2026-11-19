import 'package:flutter/material.dart';
import 'package:sideproject/models/food_item.dart';
import 'package:sideproject/models/order.dart';
import 'package:sideproject/models/restaurant.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/services/restaurant_service.dart';
import 'package:sideproject/widgets/cart/bill_details_section.dart';
import 'package:sideproject/widgets/cart/cart_header.dart';
import 'package:sideproject/widgets/cart/cart_item.dart';
import 'package:sideproject/widgets/cart/cart_items_section.dart';
import 'package:sideproject/widgets/cart/checkout_bar.dart';
import 'package:sideproject/widgets/cart/coupon_section.dart';
import 'package:sideproject/widgets/cart/delivery_address_section.dart';
import 'package:sideproject/widgets/cart/restaurant_section.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    this.onBack,
    this.onOrderPlaced,
    this.orderService,
    this.restaurantService,
    super.key,
  });

  final VoidCallback? onBack;
  final ValueChanged<Order>? onOrderPlaced;
  final OrderService? orderService;
  final RestaurantService? restaurantService;

  @override
  Widget build(BuildContext context) => Cardscreen1(
    onBack: onBack,
    onOrderPlaced: onOrderPlaced,
    orderService: orderService,
    restaurantService: restaurantService,
  );
}

class Cardscreen1 extends StatefulWidget {
  const Cardscreen1({
    this.onBack,
    this.onOrderPlaced,
    this.orderService,
    this.restaurantService,
    super.key,
  });

  final VoidCallback? onBack;
  final ValueChanged<Order>? onOrderPlaced;
  final OrderService? orderService;
  final RestaurantService? restaurantService;

  @override
  State<Cardscreen1> createState() => _Cardscreen1State();
}

class _Cardscreen1State extends State<Cardscreen1> {
  late final RestaurantService _restaurantService =
      widget.restaurantService ?? RestaurantService();
  late final OrderService _orderService = widget.orderService ?? OrderService();
  final List<CartItem> _items = [];
  late Future<List<_AvailableFood>> _availableFoodsFuture;
  bool _isSubmitting = false;

  int get _itemsTotal => _items.fold(
    0,
    (total, item) => total + (item.price * item.quantity).round(),
  );

  int get _itemCount => _items.fold(0, (total, item) => total + item.quantity);

  int get _deliveryFee => _items.isEmpty ? 0 : _items.first.deliveryFee.round();

  int get _platformFee => _items.isEmpty ? 0 : 5;

  int get _payable => _itemsTotal + _deliveryFee + _platformFee;

  @override
  void initState() {
    super.initState();
    _loadAvailableFoods();
  }

  void _loadAvailableFoods() {
    _availableFoodsFuture = _fetchAvailableFoods();
  }

  Future<List<_AvailableFood>> _fetchAvailableFoods() async {
    final restaurants = await _restaurantService.fetchRestaurants();
    final menus = await Future.wait(
      restaurants.map(
        (restaurant) => _restaurantService.fetchMenu(restaurant.id),
      ),
    );

    final availableFoods = <_AvailableFood>[];
    for (var index = 0; index < restaurants.length; index++) {
      for (final food in menus[index]) {
        if (restaurants[index].isOpen && food.isAvailable) {
          availableFoods.add(
            _AvailableFood(restaurant: restaurants[index], food: food),
          );
        }
      }
    }
    return availableFoods;
  }

  void _goBack() {
    if (widget.onBack != null) {
      widget.onBack!();
    } else {
      Navigator.maybePop(context);
    }
  }

  void _updateQuantity(int index, int change) {
    final item = _items[index];
    final quantity = item.quantity + change;
    setState(() {
      if (quantity < 1) {
        _items.removeAt(index);
      } else {
        _items[index] = item.copyWith(quantity: quantity);
      }
    });
  }

  bool _addFood(_AvailableFood availableFood) {
    if (_items.isNotEmpty &&
        _items.first.restaurantId != availableFood.restaurant.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Place an order from one restaurant at a time.'),
        ),
      );
      return false;
    }

    final existingIndex = _items.indexWhere(
      (item) =>
          item.id == availableFood.food.id &&
          item.restaurantId == availableFood.restaurant.id,
    );
    setState(() {
      if (existingIndex >= 0) {
        _items[existingIndex] = _items[existingIndex].copyWith(
          quantity: _items[existingIndex].quantity + 1,
        );
      } else {
        final food = availableFood.food;
        _items.add(
          CartItem(
            id: food.id,
            restaurantId: availableFood.restaurant.id,
            restaurantName: availableFood.restaurant.name,
            deliveryFee: availableFood.restaurant.deliveryFee,
            name: food.name,
            description: food.description.isEmpty
                ? food.category
                : food.category.isEmpty
                ? food.description
                : '${food.category} • ${food.description}',
            price: food.price,
            imageUrl: food.imageUrl,
          ),
        );
      }
    });
    return true;
  }

  Future<void> _submitOrder() async {
    if (_items.isEmpty || _isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      final order = await _orderService.createOrder(
        restaurantId: _items.first.restaurantId,
        items: _items
            .map(
              (item) => OrderItemRequest(
                foodItemId: item.id,
                quantity: item.quantity,
              ),
            )
            .toList(),
      );
      if (!mounted) return;

      setState(() {
        _items.clear();
        _isSubmitting = false;
      });
      if (widget.onOrderPlaced != null) {
        widget.onOrderPlaced!(order);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${order.orderName} placed successfully.')),
        );
      }
    } catch (error) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not place order: $error')));
    }
  }

  Future<void> _showAvailableFoods() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheetContext).height * 0.75,
          child: FutureBuilder<List<_AvailableFood>>(
            future: _availableFoodsFuture,
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
                          'Could not load menu items: ${snapshot.error}',
                          textAlign: TextAlign.center,
                        ),
                        TextButton(
                          onPressed: () {
                            setState(_loadAvailableFoods);
                          },
                          child: const Text('Try again'),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final foods = snapshot.data ?? const <_AvailableFood>[];
              if (foods.isEmpty) {
                return const Center(
                  child: Text('No available menu items were found.'),
                );
              }

              return ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Text(
                      'Choose menu items',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  for (final availableFood in foods)
                    ListTile(
                      leading: availableFood.food.imageUrl.isEmpty
                          ? const Icon(
                              Icons.restaurant_menu,
                              color: Colors.deepOrange,
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                availableFood.food.imageUrl,
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                      Icons.restaurant_menu,
                                      color: Colors.deepOrange,
                                    ),
                              ),
                            ),
                      title: Text(availableFood.food.name),
                      subtitle: Text(
                        availableFood.restaurant.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        '₹${availableFood.food.price.toStringAsFixed(0)}',
                      ),
                      onTap: () {
                        if (_addFood(availableFood)) {
                          Navigator.pop(sheetContext);
                        }
                      },
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 740),
            child: Column(
              children: [
                CartHeader(onBack: _goBack),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        RestaurantSection(items: _items),
                        const SizedBox(height: 14),
                        CartItemsSection(
                          items: _items,
                          onDecrease: (index) => _updateQuantity(index, -1),
                          onIncrease: (index) => _updateQuantity(index, 1),
                          onAddMore: _showAvailableFoods,
                        ),
                        const SizedBox(height: 14),
                        const CouponSection(),
                        const SizedBox(height: 14),
                        BillDetailsSection(
                          itemCount: _itemCount,
                          itemsTotal: _itemsTotal,
                          deliveryFee: _deliveryFee,
                          platformFee: _platformFee,
                          discount: 0,
                        ),
                        const SizedBox(height: 14),
                        const DeliveryAddressSection(),
                      ],
                    ),
                  ),
                ),
                CheckoutBar(
                  payable: _payable,
                  onCheckout: _submitOrder,
                  isLoading: _isSubmitting,
                  isEnabled: _items.isNotEmpty,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AvailableFood {
  const _AvailableFood({required this.restaurant, required this.food});

  final Restaurant restaurant;
  final FoodItem food;
}
