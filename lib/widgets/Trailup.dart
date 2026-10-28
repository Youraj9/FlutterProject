import 'package:flutter/material.dart';

class Trailup extends StatelessWidget {
  const Trailup({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: 100,
          width: 400,
          child: Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
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
                    child: Icon(
                      Icons.food_bank,
                      size: 46,
                      color: Colors.deepOrange,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "something here we will be displayed",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Text(
                        "something more detail will appear here",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      Row(children: []),
                    ],
                  ),
                ],
              ),
              // const SizedBox(width: ,)
            ),
          ),
        ),
      ),
    );
  }
}

class Banners extends StatelessWidget {
  const Banners({super.key});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Container(
          height: 200,
          // width: 300,
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          // constraints: BoxConstraints(),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.deepOrangeAccent,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Food",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontSize: 13,
                        // color: const Color.fromARGB(255, 229, 230, 222),
                        letterSpacing: 1,
                        color: const Color.fromARGB(255, 229, 230, 222),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "'Cravings? We’ve got you covered!'",
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.deepOrange,
                      ),
                      child: const Text('Explore'),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.ramen_dining, size: 72, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
