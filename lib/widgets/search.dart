import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  const Search({this.onChanged, super.key});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return TextField(
      onChanged: onChanged,
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
  const Search2({this.onChanged, super.key});

  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: 'Search restaurants or cuisines...',
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
      ],
    );
  }
}
