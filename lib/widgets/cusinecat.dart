import 'package:flutter/material.dart';

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
      width: 112,
      child: Material(
        color: Colors.transparent,
        //what does the color here means for . and here why it has given like this
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
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
                  radius: 24,
                  backgroundColor: color,
                  child: Icon(iconname, size: 26, color: Colors.deepOrange),
                ),
                const SizedBox(height: 6),
                Text(
                  name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
