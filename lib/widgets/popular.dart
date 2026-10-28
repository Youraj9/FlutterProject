import 'package:flutter/material.dart';

class Popularsection extends StatefulWidget {
  const Popularsection({super.key});

  @override
  State<Popularsection> createState() => _PopularsectionState();
}

class _PopularsectionState extends State<Popularsection> {
  final searches = ['Biryani', 'Pizza', 'Burger', 'Dosa', 'Sushi'];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE7ECF2)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: Colors.deepOrange,
                size: 22,
              ),
              const SizedBox(width: 6),
              const Expanded(
                child: Text(
                  'Popular Searches',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton(
                onPressed: () => setState(searches.clear),
                child: const Text('Clear All'),
              ),
            ],
          ),
          if (searches.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final search in searches)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Chip(
                        avatar: const Icon(Icons.search, size: 16),
                        label: Text(search),
                        backgroundColor: const Color(0xFFF3F6FA),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
