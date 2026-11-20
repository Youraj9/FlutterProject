import 'package:flutter/material.dart';
import 'package:sideproject/models/order.dart';
import 'package:sideproject/services/order_service.dart';
import 'package:sideproject/widgets/orderscreen/order_list_card.dart';
import 'package:sideproject/widgets/orderscreen/orderheader.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.onBack, this.orderService});

  final VoidCallback? onBack;
  final OrderService? orderService;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrderService _orderService = widget.orderService ?? OrderService();
  late Future<List<Order>> _ordersFuture;
  int _selectedTab = 0;
  String? _cancellingOrderId;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  void _loadOrders() {
    _ordersFuture = _orderService.fetchMyOrders();
  }

  void _refreshOrders() {
    setState(_loadOrders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8F3),
      body: SafeArea(
        child: Column(
          children: [
            Orderheader(onBack: widget.onBack, onRefresh: _refreshOrders),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _orderTab(label: 'Active', index: 0),
                  const SizedBox(width: 10),
                  _orderTab(label: 'Past Orders', index: 1),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: FutureBuilder<List<Order>>(
                future: _ordersFuture,
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
                              'Could not load your orders: ${snapshot.error}',
                              textAlign: TextAlign.center,
                            ),
                            TextButton(
                              onPressed: () => setState(_loadOrders),
                              child: const Text('Try again'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final orders = snapshot.data ?? const <Order>[];
                  final filteredOrders = orders
                      .where((order) => order.isActive == (_selectedTab == 0))
                      .toList();
                  if (filteredOrders.isEmpty) {
                    return Center(
                      child: Text(
                        _selectedTab == 0
                            ? 'No active orders yet.'
                            : 'No past orders yet.',
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: filteredOrders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final order = filteredOrders[index];
                      return OrderListCard(
                        order: order,
                        isCancelling: _cancellingOrderId == order.id,
                        onCancel: order.isCancellable
                            ? () => _confirmCancel(order)
                            : null,
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

  Future<void> _confirmCancel(Order order) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this order?'),
        content: const Text(
          'You can cancel an order only before preparation begins.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep order'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel order'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _cancellingOrderId = order.id);
    try {
      await _orderService.cancelOrder(order.id);
      if (!mounted) return;
      setState(() {
        _cancellingOrderId = null;
        _loadOrders();
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Order cancelled.')));
    } catch (error) {
      if (!mounted) return;
      setState(() => _cancellingOrderId = null);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not cancel order: $error')));
    }
  }

  Widget _orderTab({required String label, required int index}) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5A1F) : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF5A1F)
                : const Color(0xFFE8D9D0),
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF18243B),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
