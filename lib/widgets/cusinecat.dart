import 'package:flutter/material.dart';

class Cusinecat extends StatefulWidget {
  const Cusinecat({super.key});

  @override
  State<Cusinecat> createState() => _CusinecatState();
}

class _CusinecatState extends State<Cusinecat> {
  static const categories = [
    (name: 'All', icon: Icons.restaurant, color: Color(0xFFFFE5CC)),
    (name: 'South Indian', icon: Icons.rice_bowl, color: Color(0xFFD8F5E5)),
    (name: 'Burgers', icon: Icons.lunch_dining, color: Color(0xFFFFEBC7)),
    (name: 'Pizza', icon: Icons.local_pizza, color: Color(0xFFFFE5CC)),
    (name: 'Beverages', icon: Icons.local_drink, color: Color(0xFFDCEBFF)),
    (name: 'Desserts', icon: Icons.cake, color: Color(0xFFFFE0EF)),
  ];

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 92,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final category = categories[index];
          return Customcusine(
            name: category.name,
            iconname: category.icon,
            color: category.color,
            isSelected: selectedIndex == index,
            onTap: () => setState(() => selectedIndex = index),
          );
        },
      ),
    );
  }
}

class Customcusine extends StatelessWidget {
  final String name;
  final IconData iconname;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const Customcusine({
    super.key,
    required this.name,
    required this.iconname,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Material(
        color: Colors.transparent,
        //what does the color here means for . and here why it has given like this
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFFFF5EF) : Colors.white,
              // what does it do here what do it means
              border: Border.all(
                color: isSelected ? Colors.deepOrange : const Color(0xFFE7ECF2),
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 19,
                  backgroundColor: color,
                  child: Icon(iconname, size: 21, color: Colors.deepOrange),
                ),
                const SizedBox(height: 4),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
