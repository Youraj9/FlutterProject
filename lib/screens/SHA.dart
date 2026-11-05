import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ShaApp());
}

class ShaApp extends StatelessWidget {
  const ShaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SHA-256 example',
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange),
      home: const ShaScreen(),
    );
  }
}

class ShaScreen extends StatefulWidget {
  const ShaScreen({super.key});

  @override
  State<ShaScreen> createState() => _ShaScreenState();
}

class _ShaScreenState extends State<ShaScreen> {
  final _textController = TextEditingController();
  String? _hash;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _generateHash() {
    final bytes = utf8.encode(_textController.text);
    setState(() {
      _hash = sha256.convert(bytes).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SHA-256')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text(
            'Enter text to generate its SHA-256 hash.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _textController,
            minLines: 1,
            maxLines: 5,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Text',
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _generateHash,
            child: const Text('Generate hash'),
          ),
          if (_hash != null) ...[
            const SizedBox(height: 24),
            const Text(
              'SHA-256 hash:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SelectableText(_hash!),
          ],
        ],
      ),
    );
  }
}