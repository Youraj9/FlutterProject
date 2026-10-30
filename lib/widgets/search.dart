import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search for restaurants, cuisines or dishes...',
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
        prefixIcon: Icon(Icons.search, color: Colors.grey),
        filled: true,
        // filled: true,
        fillColor: const Color(0xFFF7F7F7),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 16,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

// we are defining the Search2 part also here
class Search2 extends StatelessWidget {
  const Search2({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search for restaurants, cuisines or dishes...',
              hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color(0xFFF7F7F7),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune),
          style: IconButton.styleFrom(
            backgroundColor: const Color(0xFFF3F6FA),
            foregroundColor: const Color(0xFF53657A),
            minimumSize: const Size(48, 48),
          ),
        ),
      ],
    );
  }
}
