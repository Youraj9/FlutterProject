import 'package:flutter/material.dart';

class Location extends StatelessWidget {
  const Location({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Row(
      children: [
        const Icon(Icons.location_on, color: Colors.deepOrange, size: 32),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Bengaluru',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.keyboard_arrow_down),
                ],
              ),
              SizedBox(height: 4),
              Text(
                'Koramangala, 1st Block',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 23,
          backgroundColor: Color(0xFFFFF0E8),
          child: Icon(Icons.person, color: Colors.deepOrange, size: 28),
        ),
      ],
    );
  }
}
