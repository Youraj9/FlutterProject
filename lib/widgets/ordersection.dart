import 'package:flutter/material.dart';

class Ordersection extends StatelessWidget {
  final String name;
  final int price;
  final String desc;
  final IconData iconame;
  const Ordersection({
    super.key,
    required this.name,
    required this.desc,
    required this.price,
    required this.iconame,
  });

  // after sometime we will implement the photo also here
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(width: 3, color: Colors.black),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(iconame, size: 45),
            Column(
              children: [
                Text(
                  name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  desc,
                  style: TextStyle(
                    fontSize: 8,
                    color: const Color.fromARGB(255, 83, 83, 83),
                  ),
                ),
                Text(" '$price"),
              ],
            ),

            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Prevents row from expanding infinitely
                children: const [
                  Icon(Icons.info), // Prefix Icon
                  SizedBox(width: 8), // Padding between icon and text
                  // Text('View Details'),
                  Text("unit will be passed here"),
                  SizedBox(width: 8), // Padding between text and icon
                  Icon(Icons.open_in_new), // Suffix Icon
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
