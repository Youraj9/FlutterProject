import 'package:flutter/material.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String cuisines;
  final String rating;
  final String deliveryTime;
  final String price;
  final String offer;
  final IconData foodIcon;
  final String imageUrl;
  final bool? isOpen;
  final VoidCallback? onTap;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.cuisines,
    required this.rating,
    required this.deliveryTime,
    required this.price,
    required this.offer,
    required this.foodIcon,
    this.imageUrl = '',
    this.isOpen,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 86,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: imageUrl.isEmpty
                    ? Icon(foodIcon, size: 46, color: Colors.deepOrange)
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            foodIcon,
                            size: 46,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cuisines,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.green),
                        const SizedBox(width: 4),
                        Text(rating),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            deliveryTime,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(price),
                    const SizedBox(height: 6),
                    Text(
                      offer,
                      style: TextStyle(
                        color: isOpen == false ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
