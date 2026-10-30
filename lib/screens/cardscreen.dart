import 'package:flutter/material.dart';
import 'package:sideproject/widgets/cart/bill_details_section.dart';
import 'package:sideproject/widgets/cart/cart_header.dart';
import 'package:sideproject/widgets/cart/cart_item.dart';
import 'package:sideproject/widgets/cart/cart_items_section.dart';
import 'package:sideproject/widgets/cart/checkout_bar.dart';
import 'package:sideproject/widgets/cart/coupon_section.dart';
import 'package:sideproject/widgets/cart/delivery_address_section.dart';
import 'package:sideproject/widgets/cart/restaurant_section.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) => const Cardscreen1();
}

class Cardscreen1 extends StatefulWidget {
  const Cardscreen1({super.key});

  @override
  State<Cardscreen1> createState() => _Cardscreen1State();
}

class _Cardscreen1State extends State<Cardscreen1> {
  final List<CartItem> _items = [
    const CartItem(
      name: 'Chicken Biryani',
      description: 'Spicy  •  Regular',
      price: 220,
      icon: Icons.rice_bowl,
    ),
    const CartItem(
      name: 'Paneer Tikka',
      description: 'Medium Spicy  •  Regular',
      price: 180,
      icon: Icons.local_dining,
    ),
  ];

  int get _itemsTotal =>
      _items.fold(0, (total, item) => total + item.price * item.quantity);

  int get _payable => _itemsTotal + 25 + 5 - 40;

  void _updateQuantity(int index, int change) {
    final item = _items[index];
    final quantity = item.quantity + change;
    if (quantity < 1) return;

    setState(() {
      _items[index] = item.copyWith(quantity: quantity);
    });
  }

  // here we are using the updatequantity for the

  //  seen this type of the function first time
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
                CartHeader(onBack: () => Navigator.maybePop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    child: Column(
                      children: [
                        const RestaurantSection(),
                        const SizedBox(height: 14),
                        CartItemsSection(
                          items: _items,
                          onDecrease: (index) => _updateQuantity(index, -1),
                          onIncrease: (index) => _updateQuantity(index, 1),
                        ),
                        const SizedBox(height: 14),
                        const CouponSection(),
                        const SizedBox(height: 14),
                        BillDetailsSection(
                          itemCount: _items.length,
                          itemsTotal: _itemsTotal,
                          deliveryFee: 25,
                          platformFee: 5,
                          discount: 40,
                        ),
                        const SizedBox(height: 14),
                        const DeliveryAddressSection(),
                      ],
                    ),
                  ),
                ),
                CheckoutBar(payable: _payable),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
