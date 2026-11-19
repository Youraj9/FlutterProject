import 'package:flutter/material.dart';
import 'package:sideproject/models/order.dart';

class OrderListCard extends StatelessWidget {
  const OrderListCard({required this.order, super.key});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final itemSummary = order.items
        .map((item) => '${item.quantity} × ${item.name}')
        .join(', ');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE8D9D0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF0D8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.restaurant,
                  color: Colors.deepOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.orderName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF18243B),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      order.restaurantName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Order #${order.id}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹${order.total.toStringAsFixed(0)}',
                style: const TextStyle(
                  color: Color(0xFF18243B),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE8D9D0)),
          const SizedBox(height: 10),
          Text(
            itemSummary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            'Ordered ${_formatDateTime(order.orderedAt)}',
            style: const TextStyle(color: Colors.grey, fontSize: 12),
          ),
          if (order.isActive && order.estimatedDeliveryAt != null) ...[
            const SizedBox(height: 6),
            Text(
              'Estimated delivery ${_formatDateTime(order.estimatedDeliveryAt!)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                order.status == 'delivered'
                    ? Icons.check_circle
                    : order.status == 'cancelled'
                    ? Icons.cancel
                    : Icons.circle,
                size: 12,
                color: _statusColor,
              ),
              const SizedBox(width: 7),
              Text(
                _statusLabel,
                style: TextStyle(
                  color: _statusColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _statusColor {
    if (order.status == 'delivered') return Colors.green;
    if (order.status == 'cancelled') return Colors.red;
    return Colors.deepOrange;
  }

  String get _statusLabel => order.status
      .split('_')
      .map(
        (word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}',
      )
      .join(' ');

  static String _formatDateTime(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final local = dateTime.toLocal();
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');
    return '${local.day} ${months[local.month - 1]} ${local.year} at $hour:$minute';
  }
}
