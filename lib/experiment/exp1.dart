import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: Widgets2()));
}

class Widgets2 extends StatefulWidget {
  const Widgets2({super.key});

  @override
  State<Widgets2> createState() => _Widgets2State();
}

class _Widgets2State extends State<Widgets2> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two widget methods')),
      body: Center(child: _buildCounterDisplay()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _count++;
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCounterDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Button tapped $_count times',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
