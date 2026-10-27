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
        prefix: Icon(Icons.search, color: Colors.grey),
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
